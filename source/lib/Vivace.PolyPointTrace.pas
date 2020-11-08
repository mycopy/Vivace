{==============================================================================
         _       ve'va'CHe
  __   _(_)_   ____ _  ___ ___ ™
  \ \ / / \ \ / / _` |/ __/ _ \
   \ V /| |\ V / (_| | (_|  __/
    \_/ |_| \_/ \__,_|\___\___|
                   game toolkit

 Copyright © 2020 tinyBigGAMES™ LLC
 All rights reserved.

 website: https://tinybiggames.com
 email  : support@tinybiggames.com

 LICENSE: zlib/libpng

 Vivace Game Toolkit is licensed under an unmodified zlib/libpng license,
 which is an OSI-certified, BSD-like license that allows static linking
 with closed source software:

 This software is provided "as-is", without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software in
     a product, an acknowledgment in the product documentation would be
     appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.

============================================================================== }

unit Vivace.PolyPointTrace;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Bitmap,
  Vivace.PolyPoint,
  Vivace.Math;

procedure TR_Init(aMju: Extended = 6; aMaxStepBack: Integer = 10;
  aAlphaThreshold: Byte = 70);

procedure TR_Done;

function TR_GetPointCount: Integer;

procedure TR_PrimaryTrace(Tex: TViBitmap; W, H: Single);

procedure TR_SimplifyPoly;

procedure TR_ApplyPolyPoint(aPolyPoint: TViPolyPoint; aNum: Integer;
  aOrigin: PViVector);

implementation

uses
  Vivace.Color,
  Vivace.Entity;

type
  TR_Point = record
    X, Y: Integer;
  end;

var
  PolyArr: array of TR_Point;
  PntCount: Integer;
  Mju: Extended = 6;
  MaxStepBack: Integer = 10;
  AlphaThreshold: Byte = 70; // alpha channel threshhold

procedure TR_ApplyPolyPoint(aPolyPoint: TViPolyPoint; aNum: Integer;
  aOrigin: PViVector);
var
  I: Integer;
begin
  for I := 0 to PntCount - 1 do
  begin
    aPolyPoint.AddPoint(aNum, PolyArr[I].X, PolyArr[I].Y, aOrigin);
  end;
end;

procedure TR_Init(aMju: Extended = 6; aMaxStepBack: Integer = 10;
  aAlphaThreshold: Byte = 70);
begin
  TR_Done;
  Mju := aMju;
  MaxStepBack := aMaxStepBack;
  AlphaThreshold := aAlphaThreshold;
end;

procedure TR_Done;
begin
  PntCount := 0;
  PolyArr := nil;
end;

function TR_GetPointCount: Integer;
begin
  Result := PntCount;
end;

function IsNeighbour(X1, Y1, X2, Y2: Integer): Boolean;
begin
  Result := (Abs(X2 - X1) <= 1) and (Abs(Y2 - Y1) <= 1);
end;

function IsPixEmpty(Tex: TViBitmap; X, Y: Integer; W, H: Single): Boolean;
var
  Color: TViColor;
begin
  if (X < 0) or (Y < 0) or (X > W - 1) or (Y > H - 1) then
    Result := true
  else
  begin
    Color := Tex.GetPixel(X, Y);
    Result := Boolean(Color.alpha * 255 < AlphaThreshold);
  end;
end;

// some point list functions
procedure TR_AddPoint(X, Y: Integer);
var
  L: Integer;
begin
  Inc(PntCount);
  // L := Length(PolyArr);
  L := High(PolyArr) + 1;
  if L < PntCount then
    SetLength(PolyArr, L + MaxStepBack);
  PolyArr[PntCount - 1].X := X;
  PolyArr[PntCount - 1].Y := Y;
end;

procedure TR_DelPoint(Index: Integer);
var
  I: Integer;
begin
  if PntCount > 1 then
    for I := Index to PntCount - 2 do
      PolyArr[I] := PolyArr[I + 1];
  Dec(PntCount);
end;

function IsInList(X, Y: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to PntCount - 1 do
  begin
    Result := (PolyArr[I].X = X) and (PolyArr[I].Y = Y);
    if Result then
      Break;
  end;
end;

procedure FindStartingPoint(Tex: TViBitmap; var X, Y: Integer; W, H: Single);
var
  I, J: Integer;
begin
  X := 1000000; // init X and Y with huge values
  Y := 1000000;
  // and simply find the non-zero point with lowest Y
  I := 0;
  J := 0;
  while (X = 1000000) and (I <= H) do
  begin
    if not IsPixEmpty(Tex, I, J, W, H) then
    begin
      X := I;
      Y := J;
    end;
    Inc(I);
    if I = W then
    begin
      I := 0;
      Inc(J);
    end;
  end;
  if X = 1000000 then
  begin
    // do something awful - texture is empty!
    // ShowMessage('do something awful - texture is empty!', [], SHOWMESSAGE_ERROR);
  end;
end;

const
  // this is an order of looking for neighbour. Order is quite important
  Neighbours: array [1 .. 8, 1 .. 2] of Integer = ((0, -1), (-1, 0), (0, 1),
    (1, 0), (-1, -1), (-1, 1), (1, 1), (1, -1));

function CountEmptyAround(Tex: TViBitmap; X, Y: Integer; W, H: Single): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to 8 do
    if IsPixEmpty(Tex, X + Neighbours[I, 1], Y + Neighbours[I, 2], W, H) then
      Inc(Result);
end;

// finds nearest non-empty pixel with maximum empty neighbours which is NOT neighbour of some other pixel
// Returns true if found and XF,YF - coordinates
// This function may look odd but I need it for finding primary circumscribed poly which later will be
// simplified
function FindNearestButNotNeighbourOfOther(Tex: TViBitmap;
  Xs, Ys, XOther, YOther: Integer; var XF, YF: Integer; W, H: Single): Boolean;
var
  I, MaxEmpty, E: Integer;
  Xt, Yt: Integer;
begin
  MaxEmpty := 0;
  Result := False;
  for I := 1 to 8 do
  begin
    Xt := Xs + Neighbours[I, 1];
    Yt := Ys + Neighbours[I, 2];
    // is it non-empty and not-a-neighbour point?
    if (not IsInList(Xt, Yt)) and (not IsNeighbour(Xt, Yt, XOther, YOther)) and
      (not IsPixEmpty(Tex, Xt, Yt, W, H)) then
    begin
      E := CountEmptyAround(Tex, Xt, Yt, W, H); // ok. count empties around
      if E > MaxEmpty then // the best choice point has max empty neighbours
      begin
        XF := Xt;
        YF := Yt;
        MaxEmpty := E;
        Result := true;
      end;
    end;
  end;
end;

// primarily tracer procedure (gives too precise polyline - need to simplify later)
procedure TR_PrimaryTrace(Tex: TViBitmap; W, H: Single);
var
  I: Integer;
  Xn, Yn, Xnn, Ynn: Integer;
  NextPointFound: Boolean;
  Back: Integer;
  StepBack: Integer;
begin
  FindStartingPoint(Tex, Xn, Yn, W, H);
  NextPointFound := Xn <> 1000000;
  StepBack := 0;
  while NextPointFound do
  begin
    NextPointFound := False;
    // checking if we got back to starting point...
    if not((PntCount > 3) and IsNeighbour(Xn, Yn, PolyArr[0].X, PolyArr[0].Y))
    then
    begin
      if PntCount > 7 then
        Back := 7
      else
        Back := PntCount;
      if Back = 0 then // no points in list - take any near point
        NextPointFound := FindNearestButNotNeighbourOfOther(Tex, Xn, Yn, -100,
          -100, Xnn, Ynn, W, H)
      else
        // checking near but not going back
        for I := 1 to Back do
        begin
          NextPointFound := FindNearestButNotNeighbourOfOther(Tex, Xn, Yn,
            PolyArr[PntCount - I].X, PolyArr[PntCount - I].Y, Xnn, Ynn, W, H);
          NextPointFound := NextPointFound and (not IsInList(Xnn, Ynn));
          if NextPointFound then
            Break;
        end;
      TR_AddPoint(Xn, Yn);
      if NextPointFound then
      begin
        Xn := Xnn;
        Yn := Ynn;
        StepBack := 0;
      end
      else if StepBack < MaxStepBack then
      begin
        Xn := PolyArr[PntCount - StepBack * 2 - 2].X;
        Yn := PolyArr[PntCount - StepBack * 2 - 2].Y;
        Inc(StepBack);
        NextPointFound := true;
      end;
    end;
  end;
  // close the poly
  if PntCount > 0 then
    TR_AddPoint(PolyArr[0].X, PolyArr[0].Y);
end;

// simplifying procedures
function LineLength(X1, Y1, X2, Y2: Integer): Extended;
var
  A, B: Integer;
begin
  A := Abs(X2 - X1);
  B := Abs(Y2 - Y1);
  Result := Sqrt(A * A + B * B);
end;

function TriangleSquare(X1, Y1, X2, Y2, X3, Y3: Integer): Extended;
var
  P: Extended;
  A, B, C: Extended;
begin
  A := LineLength(X1, Y1, X2, Y2);
  B := LineLength(X2, Y2, X3, Y3);
  C := LineLength(X3, Y3, X1, Y1);
  P := A + B + C;
  Result := Sqrt(P * (P - A) * (P - B) * (P - C)); // using Heron's formula
end;

// for alternate method simplifying I decided to use "thinness" of triangles
// the idea is that if square of triangle is small but his perimeter is big it means that
// triangle is "thin" - so it can be approximated to line
function TriangleThinness(X1, Y1, X2, Y2, X3, Y3: Integer): Extended;
var
  P: Extended;
  A, B, C, S: Extended;
begin
  A := LineLength(X1, Y1, X2, Y2);
  B := LineLength(X2, Y2, X3, Y3);
  C := LineLength(X3, Y3, X1, Y1);
  P := A + B + C;
  S := Sqrt(P * (P - A) * (P - B) * (P - C));
  // using Heron's formula to find triangle's square
  Result := S / P;
  // so if this result less than some Mju then we can approximate particular triangle
end;

procedure TR_SimplifyPoly;
var
  I: Integer;
  Finished: Boolean;
  Thinness: Extended;
begin
  Finished := False;
  while not Finished do
  begin
    I := 0;
    Finished := true;
    while I <= PntCount - 3 do
    begin
      Thinness := TriangleThinness(PolyArr[I].X, PolyArr[I].Y, PolyArr[I + 1].X,
        PolyArr[I + 1].Y, PolyArr[I + 2].X, PolyArr[I + 2].Y);
      if Thinness < Mju then
      // the square of triangle is too thin - we can approximate it!
      begin
        TR_DelPoint(I + 1); // so delete middle point
        Finished := False;
      end;
      Inc(I);
    end;
  end;
end;

end.

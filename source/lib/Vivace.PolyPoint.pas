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

unit Vivace.PolyPoint;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Polygon,
  Vivace.Bitmap,
  Vivace.Sprite,
  Vivace.Math,
  Vivace.Color;

type

  { TViPolyPoint }
  TViPolyPoint = class
  protected
    FPolygon: array of TViPolygon;
    FCount: Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save(aFilename: string);
    procedure Load(aFilename: string);
    procedure CopyFrom(aPolyPoint: TViPolyPoint);
    procedure AddPoint(aNum: Integer; aX: Single; aY: Single; aOrigin: PViVector);
    function TraceFromBitmap(aBitmap: TViBitmap; aMju: Single;
      aMaxStepBack: Integer; aAlphaThreshold: Integer;
      aOrigin: PViVector): Integer;
    procedure TraceFromSprite(aSprite: TViSprite; aGroup: Integer; aMju: Single;
      aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PViVector);
    function Count: Integer;
    procedure Render(aNum: Integer; aX: Single; aY: Single; aScale: Single;
      aAngle: Single; aColor: TViColor; aOrigin: PViVector; aHFlip: Boolean;
      aVFlip: Boolean);
    function Collide(aNum1: Integer; aGroup1: Integer; aX1: Single; aY1: Single;
      aScale1: Single; aAngle1: Single; aOrigin1: PViVector; aHFlip1: Boolean;
      aVFlip1: Boolean; aPolyPoint2: TViPolyPoint; aNum2: Integer;
      aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single;
      aAngle2: Single; aOrigin2: PViVector; aHFlip2: Boolean; aVFlip2: Boolean;
      var aHitPos: TViVector): Boolean;
    function CollidePoint(aNum: Integer; aGroup: Integer; aX: Single;
      aY: Single; aScale: Single; aAngle: Single; aOrigin: PViVector;
      aHFlip: Boolean; aVFlip: Boolean; var aPoint: TViVector): Boolean;
    function Polygon(aNum: Integer): TViPolygon;
    function Valid(aNum: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils,
  Vivace.PolyPointTrace,
  Vivace.Collision,
  Vivace.Engine;

{ --- TPolyPoint ------------------------------------------------------------- }
procedure TViPolyPoint.Clear;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Assigned(FPolygon[I]) then
    begin
      FreeAndNil(FPolygon[I]);
    end;
  end;
  FPolygon := nil;
  FCount := 0;
end;

constructor TViPolyPoint.Create;
begin
  inherited;
  FPolygon := nil;
  FCount := 0;
end;

destructor TViPolyPoint.Destroy;
begin
  Clear;
  inherited;
end;

procedure TViPolyPoint.Save(aFilename: string);
begin
end;

procedure TViPolyPoint.Load(aFilename: string);
begin
end;

procedure TViPolyPoint.CopyFrom(aPolyPoint: TViPolyPoint);
begin
end;

procedure TViPolyPoint.AddPoint(aNum: Integer; aX: Single; aY: Single;
  aOrigin: PViVector);
var
  X, Y: Single;
begin
  X := aX;
  Y := aY;

  if aOrigin <> nil then
  begin
    X := X - aOrigin.X;
    Y := Y - aOrigin.Y;
  end;

  FPolygon[aNum].AddLocalPoint(X, Y, True);
end;

function TViPolyPoint.TraceFromBitmap(aBitmap: TViBitmap; aMju: Single;
  aMaxStepBack: Integer; aAlphaThreshold: Integer; aOrigin: PViVector): Integer;
var
  I: Integer;
  W, H: Single;
begin
  Inc(FCount);
  SetLength(FPolygon, FCount);
  I := FCount - 1;
  FPolygon[I] := TViPolygon.Create;
  aBitmap.GetSize(@W, @H);
  aBitmap.Lock(nil);
  TR_Init(aMju, aMaxStepBack, aAlphaThreshold);
  TR_PrimaryTrace(aBitmap, W, H);
  TR_SimplifyPoly;
  TR_ApplyPolyPoint(Self, I, aOrigin);
  TR_Done;
  aBitmap.Unlock;

  Result := I;
end;

procedure TViPolyPoint.TraceFromSprite(aSprite: TViSprite; aGroup: Integer;
  aMju: Single; aMaxStepBack: Integer; aAlphaThreshold: Integer;
  aOrigin: PViVector);
var
  I: Integer;
  Rect: TViRectangle;
  Tex: TViBitmap;
  W, H: Integer;
begin
  Clear;
  FCount := aSprite.GetImageCount(aGroup);
  SetLength(FPolygon, Count);
  for I := 0 to Count - 1 do
  begin
    FPolygon[I] := TViPolygon.Create;
    Tex := aSprite.GetImageTexture(I, aGroup);
    Rect := aSprite.GetImageRect(I, aGroup);
    W := Round(Rect.width);
    H := Round(Rect.height);
    Tex.Lock(@Rect);
    TR_Init(aMju, aMaxStepBack, aAlphaThreshold);
    TR_PrimaryTrace(Tex, W, H);
    TR_SimplifyPoly;
    TR_ApplyPolyPoint(Self, I, aOrigin);
    TR_Done;
    Tex.Unlock;
  end;
end;

function TViPolyPoint.Count: Integer;
begin
  Result := FCount;
end;

procedure TViPolyPoint.Render(aNum: Integer; aX: Single; aY: Single;
  aScale: Single; aAngle: Single; aColor: TViColor; aOrigin: PViVector;
  aHFlip: Boolean; aVFlip: Boolean);
begin
  if aNum >= FCount then
    Exit;
  FPolygon[aNum].Render(aX, aY, aScale, aAngle, 1, aColor, aOrigin,
    aHFlip, aVFlip);
end;

function TViPolyPoint.Collide(aNum1: Integer; aGroup1: Integer; aX1: Single;
  aY1: Single; aScale1: Single; aAngle1: Single; aOrigin1: PViVector;
  aHFlip1: Boolean; aVFlip1: Boolean; aPolyPoint2: TViPolyPoint; aNum2: Integer;
  aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single; aAngle2: Single;
  aOrigin2: PViVector; aHFlip2: Boolean; aVFlip2: Boolean;
  var aHitPos: TViVector): Boolean;
var
  L1, L2, IX, IY: Integer;
  Cnt1, Cnt2: Integer;
  Pos: array [0 .. 3] of PViVector;
  Poly1, Poly2: TViPolygon;
begin
  Result := False;

  if (aPolyPoint2 = nil) then
    Exit;

  Poly1 := FPolygon[aNum1];
  Poly2 := aPolyPoint2.Polygon(aNum2);

  // transform to world points
  Poly1.Transform(aX1, aY1, aScale1, aAngle1, aOrigin1, aHFlip1, aVFlip1);
  Poly2.Transform(aX2, aY2, aScale2, aAngle2, aOrigin2, aHFlip2, aVFlip2);

  Cnt1 := Poly1.GetPointCount;
  Cnt2 := Poly2.GetPointCount;

  if Cnt1 < 2 then
    Exit;
  if Cnt2 < 2 then
    Exit;

  for L1 := 0 to Cnt1 - 2 do
  begin
    Pos[0] := Poly1.GetWorldPoint(L1);
    Pos[1] := Poly1.GetWorldPoint(L1 + 1);

    for L2 := 0 to Cnt2 - 2 do
    begin

      Pos[2] := Poly2.GetWorldPoint(L2);
      Pos[3] := Poly2.GetWorldPoint(L2 + 1);
      if ViLineIntersection(Round(Pos[0].X), Round(Pos[0].Y), Round(Pos[1].X),
        Round(Pos[1].Y), Round(Pos[2].X), Round(Pos[2].Y), Round(Pos[3].X),
        Round(Pos[3].Y), IX, IY) = liTRUE then
      begin
        aHitPos.X := IX;
        aHitPos.Y := IY;
        Result := True;
        Exit;
      end;
    end;
  end;

end;

function TViPolyPoint.CollidePoint(aNum: Integer; aGroup: Integer; aX: Single;
  aY: Single; aScale: Single; aAngle: Single; aOrigin: PViVector; aHFlip: Boolean;
  aVFlip: Boolean; var aPoint: TViVector): Boolean;
var
  L1, IX, IY: Integer;
  Cnt1: Integer;
  Pos: array [0 .. 3] of PViVector;
  Point2: TViVector;
  Poly1: TViPolygon;
begin
  Result := False;

  Poly1 := FPolygon[aNum];

  // transform to world points
  Poly1.Transform(aX, aY, aScale, aAngle, aOrigin, aHFlip, aVFlip);

  Cnt1 := Poly1.GetPointCount;

  if Cnt1 < 2 then
    Exit;

  Point2.X := aPoint.X + 1;
  Point2.Y := aPoint.Y + 1;
  Pos[2] := @aPoint;
  Pos[3] := @Point2;

  for L1 := 0 to Cnt1 - 2 do
  begin
    Pos[0] := Poly1.GetWorldPoint(L1);
    Pos[1] := Poly1.GetWorldPoint(L1 + 1);

    if ViLineIntersection(Round(Pos[0].X), Round(Pos[0].Y), Round(Pos[1].X),
      Round(Pos[1].Y), Round(Pos[2].X), Round(Pos[2].Y), Round(Pos[3].X),
      Round(Pos[3].Y), IX, IY) = liTrue then
    begin
      aPoint.X := IX;
      aPoint.Y := IY;
      Result := True;
      Exit;
    end;
  end;

end;

function TViPolyPoint.Polygon(aNum: Integer): TViPolygon;
begin
  Result := FPolygon[aNum];
end;

function TViPolyPoint.Valid(aNum: Integer): Boolean;
begin
  Result := False;
  if aNum >= FCount then
    Exit;
  Result := Boolean(FPolygon[aNum].GetPointCount >= 2);
end;

end.

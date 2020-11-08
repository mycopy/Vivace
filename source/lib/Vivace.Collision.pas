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

unit Vivace.Collision;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Math;

type

  { TViLineIntersection }
  TViLineIntersection = (liNone, liTrue, liParallel);

function ViPointInRectangle(aPoint: TViVector; aRect: TViRectangle): Boolean;

function ViPointInCircle(aPoint, aCenter: TViVector; aRadius: Single): Boolean;

function ViPointInTriangle(aPoint, aP1, aP2, aP3: TViVector): Boolean;

function ViCirclesOverlap(aCenter1: TViVector; aRadius1: Single;
  aCenter2: TViVector; aRadius2: Single): Boolean;

function ViCircleInRectangle(aCenter: TViVector; aRadius: Single;
  aRect: TViRectangle): Boolean;

function ViRectanglesOverlap(aRect1, aRect2: TViRectangle): Boolean;

function ViRectangleIntersection(aRect1, aRect2: TViRectangle): TViRectangle;

function ViLineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer;
  var aX: Integer; var aY: Integer): TViLineIntersection;

function ViRadiusOverlap(aRadius1, aX1, aY1, aRadius2, aX2, aY2,
  aShrinkFactor: Single): Boolean;

implementation

uses
  System.Math;

function ViPointInRectangle(aPoint: TViVector; aRect: TViRectangle): Boolean;
begin
  if ((aPoint.x >= aRect.x) and (aPoint.x <= (aRect.x + aRect.width)) and
    (aPoint.y >= aRect.y) and (aPoint.y <= (aRect.y + aRect.height))) then
    Result := True
  else
    Result := False;
end;

function ViPointInCircle(aPoint: TViVector; aCenter: TViVector;
  aRadius: Single): Boolean;
begin
  Result := ViCirclesOverlap(aPoint, 0, aCenter, aRadius);
end;

function ViPointInTriangle(aPoint: TViVector; aP1: TViVector; aP2: TViVector;
  aP3: TViVector): Boolean;
var
  alpha, beta, gamma: Single;
begin
  alpha := ((aP2.y - aP3.y) * (aPoint.x - aP3.x) + (aP3.x - aP2.x) *
    (aPoint.y - aP3.y)) / ((aP2.y - aP3.y) * (aP1.x - aP3.x) + (aP3.x - aP2.x) *
    (aP1.y - aP3.y));

  beta := ((aP3.y - aP1.y) * (aPoint.x - aP3.x) + (aP1.x - aP3.x) *
    (aPoint.y - aP3.y)) / ((aP2.y - aP3.y) * (aP1.x - aP3.x) + (aP3.x - aP2.x) *
    (aP1.y - aP3.y));

  gamma := 1.0 - alpha - beta;

  if ((alpha > 0) and (beta > 0) and (gamma > 0)) then
    Result := True
  else
    Result := False;
end;

function ViCirclesOverlap(aCenter1: TViVector; aRadius1: Single;
  aCenter2: TViVector; aRadius2: Single): Boolean;
var
  dx, dy, distance: Single;
begin
  dx := aCenter2.x - aCenter1.x; // X distance between centers
  dy := aCenter2.y - aCenter1.y; // Y distance between centers

  distance := sqrt(dx * dx + dy * dy); // Distance between centers

  if (distance <= (aRadius1 + aRadius2)) then
    Result := True
  else
    Result := False;
end;

function ViCircleInRectangle(aCenter: TViVector; aRadius: Single;
  aRect: TViRectangle): Boolean;
var
  dx, dy: Single;
  cornerDistanceSq: Single;
  recCenterX: Integer;
  recCenterY: Integer;
begin
  recCenterX := Round(aRect.x + aRect.width / 2);
  recCenterY := Round(aRect.y + aRect.height / 2);

  dx := abs(aCenter.x - recCenterX);
  dy := abs(aCenter.y - recCenterY);

  if (dx > (aRect.width / 2.0 + aRadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (dy > (aRect.height / 2.0 + aRadius)) then
  begin
    Result := False;
    Exit;
  end;

  if (dx <= (aRect.width / 2.0)) then
  begin
    Result := True;
    Exit;
  end;
  if (dy <= (aRect.height / 2.0)) then
  begin
    Result := True;
    Exit;
  end;

  cornerDistanceSq := (dx - aRect.width / 2.0) * (dx - aRect.width / 2.0) +
    (dy - aRect.height / 2.0) * (dy - aRect.height / 2.0);

  Result := Boolean(cornerDistanceSq <= (aRadius * aRadius));
end;

function ViRectanglesOverlap(aRect1: TViRectangle;
  aRect2: TViRectangle): Boolean;
var
  dx, dy: Single;
begin
  dx := abs((aRect1.x + aRect1.width / 2) - (aRect2.x + aRect2.width / 2));
  dy := abs((aRect1.y + aRect1.height / 2) - (aRect2.y + aRect2.height / 2));

  if ((dx <= (aRect1.width / 2 + aRect2.width / 2)) and
    ((dy <= (aRect1.height / 2 + aRect2.height / 2)))) then
    Result := True
  else
    Result := False;
end;

function ViRectangleIntersection(aRect1, aRect2: TViRectangle): TViRectangle;
var
  dxx, dyy: Single;
begin
  Result.Assign(0, 0, 0, 0);

  if ViRectanglesOverlap(aRect1, aRect2) then
  begin
    dxx := abs(aRect1.x - aRect2.x);
    dyy := abs(aRect1.y - aRect2.y);

    if (aRect1.x <= aRect2.x) then
    begin
      if (aRect1.y <= aRect2.y) then
      begin
        Result.x := aRect2.x;
        Result.y := aRect2.y;
        Result.width := aRect1.width - dxx;
        Result.height := aRect1.height - dyy;
      end
      else
      begin
        Result.x := aRect2.x;
        Result.y := aRect1.y;
        Result.width := aRect1.width - dxx;
        Result.height := aRect2.height - dyy;
      end
    end
    else
    begin
      if (aRect1.y <= aRect2.y) then
      begin
        Result.x := aRect1.x;
        Result.y := aRect2.y;
        Result.width := aRect2.width - dxx;
        Result.height := aRect1.height - dyy;
      end
      else
      begin
        Result.x := aRect1.x;
        Result.y := aRect1.y;
        Result.width := aRect2.width - dxx;
        Result.height := aRect2.height - dyy;
      end
    end;

    if (aRect1.width > aRect2.width) then
    begin
      if (Result.width >= aRect2.width) then
        Result.width := aRect2.width;
    end
    else
    begin
      if (Result.width >= aRect1.width) then
        Result.width := aRect1.width;
    end;

    if (aRect1.height > aRect2.height) then
    begin
      if (Result.height >= aRect2.height) then
        Result.height := aRect2.height;
    end
    else
    begin
      if (Result.height >= aRect1.height) then
        Result.height := aRect1.height;
    end
  end;
end;

function ViLineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer;
  var aX: Integer; var aY: Integer): TViLineIntersection;

var
  _Ax, Bx, Cx, _Ay, By, Cy, d, e, f, num: Integer;
  offset: Integer;
  x1lo, x1hi, y1lo, y1hi: Integer;
begin
  Result := liNone;

  _Ax := aX2 - aX1;
  Bx := aX3 - aX4;

  if (_Ax < 0) then // X bound box test
  begin
    x1lo := aX2;
    x1hi := aX1;
  end
  else
  begin
    x1hi := aX2;
    x1lo := aX1;
  end;

  if (Bx > 0) then
  begin
    if (x1hi < aX4) or (aX3 < x1lo) then
      Exit;
  end
  else
  begin
    if (x1hi < aX3) or (aX4 < x1lo) then
      Exit;
  end;

  _Ay := aY2 - aY1;
  By := aY3 - aY4;

  if (_Ay < 0) then // Y bound box test
  begin
    y1lo := aY2;
    y1hi := aY1;
  end
  else
  begin
    y1hi := aY2;
    y1lo := aY1;
  end;

  if (By > 0) then
  begin
    if (y1hi < aY4) or (aY3 < y1lo) then
      Exit;
  end
  else
  begin
    if (y1hi < aY3) or (aY4 < y1lo) then
      Exit;
  end;

  Cx := aX1 - aX3;
  Cy := aY1 - aY3;
  d := By * Cx - Bx * Cy; // alpha numerator
  f := _Ay * Bx - _Ax * By; // both denominator

  if (f > 0) then // alpha tests
  begin
    if (d < 0) or (d > f) then
      Exit;
  end
  else
  begin
    if (d > 0) or (d < f) then
      Exit
  end;

  e := _Ax * Cy - _Ay * Cx; // beta numerator
  if (f > 0) then // beta tests
  begin
    if (e < 0) or (e > f) then
      Exit;
  end
  else
  begin
    if (e > 0) or (e < f) then
      Exit;
  end;

  // compute intersection coordinates

  if (f = 0) then
  begin
    Result := liParallel;
    Exit;
  end;

  num := d * _Ax; // numerator
  // if SameSigni(num, f) then
  if Sign(num) = Sign(f) then

    offset := f div 2
  else
    offset := -f div 2;
  aX := aX1 + (num + offset) div f; // intersection x

  num := d * _Ay;
  // if SameSigni(num, f) then
  if Sign(num) = Sign(f) then
    offset := f div 2
  else
    offset := -f div 2;

  aY := aY1 + (num + offset) div f; // intersection y

  Result := liTrue;
end;

function ViRadiusOverlap(aRadius1: Single; aX1: Single; aY1: Single;
  aRadius2: Single; aX2: Single; aY2: Single; aShrinkFactor: Single): Boolean;

var
  Dist: Single;
  R1, R2: Single;
  V1, V2: TViVector;
begin
  R1 := aRadius1 * aShrinkFactor;
  R2 := aRadius2 * aShrinkFactor;

  V1.x := aX1;
  V1.y := aY1;
  V2.x := aX2;
  V2.y := aY2;

  // Dist := Vector_Dist(@V1, @V2);
  Dist := V1.distance(V2);
  // Dist := Vector_Distance(V1, V2);

  if (Dist < R1) or (Dist < R2) then
    Result := True
  else
    Result := False;
end;

end.

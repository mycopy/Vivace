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

unit Vivace.Starfield;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Math,
  Vivace.Common;

type
  { TViStarfieldItem }
  TViStarfieldItem = record
    X, Y, Z: Single;
    Speed: Single;
  end;

  { TViStarfield }
  TViStarfield = class(TViBaseObject)
  protected
    FCenter: TViVector;
    FMin: TViVector;
    FMax: TViVector;
    FViewScaleRatio: Single;
    FViewScale: Single;
    FStarCount: Cardinal;
    FStar: array of TViStarfieldItem;
    FSpeed: TViVector;
    FVirtualPos: TViVector;
  protected
    procedure TransformDrawPoint(aX, aY, aZ: Single;
      aVPX, aVPY, aVPW, aVPH: Integer);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Done;

    procedure Init(aStarCount: Cardinal; aMinX, aMinY, aMinZ, aMaxX, aMaxY,
      aMaxZ, aViewScale: Single);
    procedure SetVirtualPos(aX, aY: Single);
    procedure GetVirtualPos(var aX: Single; var aY: Single);
    procedure SetXSpeed(aSpeed: Single);
    procedure SetYSpeed(aSpeed: Single);
    procedure SetZSpeed(aSpeed: Single);
    procedure Update(aDeltaTime: Single);
    procedure Render;
  end;

implementation

uses
  Vivace.Color,
  Vivace.Engine;

{ --- TViStarfield ---------------------------------------------------------- }
procedure TViStarfield.TransformDrawPoint(aX, aY, aZ: Single;
  aVPX, aVPY, aVPW, aVPH: Integer);
var
  X, Y: Single;
  sw, sh: Single;
  ooz: Single;
  cv: byte;
  color: TViColor;

  function IsVisible(vx, vy, vw, vh: Single): Boolean;
  begin
    Result := False;
    if ((vx - vw) < 0) then
      Exit;
    if (vx > (aVPW - 1)) then
      Exit;
    if ((vy - vh) < 0) then
      Exit;
    if (vy > (aVPH - 1)) then
      Exit;
    Result := True;
  end;

begin
  FViewScaleRatio := aVPW / aVPH;
  FCenter.X := (aVPW / 2) + aVPX;
  FCenter.Y := (aVPH / 2) + aVPY;

  ooz := ((1.0 / aZ) * FViewScale);
  X := (FCenter.X - aVPX) - (aX * ooz) * FViewScaleRatio;
  Y := (FCenter.Y - aVPY) + (aY * ooz) * FViewScaleRatio;
  sw := (1.0 * ooz);
  if sw < 1 then
    sw := 1;
  sh := (1.0 * ooz);
  if sh < 1 then
    sh := 1;
  if not IsVisible(X, Y, sw, sh) then
    Exit;
  cv := round(255.0 - (((1.0 / FMax.Z) / (1.0 / aZ)) * 255.0));

  color := ViColorMake(cv, cv, cv, cv);

  X := X - FVirtualPos.X;
  Y := Y - FVirtualPos.Y;

  ViEngine.Display.DrawFilledRectangle(X, Y, sw, sh, color);
end;

constructor TViStarfield.Create;
begin
  inherited;
  Init(250, -1000, -1000, 10, 1000, 1000, 1000, 90);
end;

destructor TViStarfield.Destroy;
begin
  Done;
  inherited;
end;

procedure TViStarfield.Init(aStarCount: Cardinal;
  aMinX, aMinY, aMinZ, aMaxX, aMaxY, aMaxZ, aViewScale: Single);
var
  vpx, vpy: Integer;
  vpw, vph: Integer;
  I: Integer;
begin
  Done;

  FStarCount := aStarCount;
  SetLength(FStar, FStarCount);

  ViEngine.Display.GetViewportSize(@vpx, @vpy, @vpw, @vph);

  FViewScale := aViewScale;
  FViewScaleRatio := vpw / vph;
  FCenter.X := (vpw / 2) + vpx;
  FCenter.Y := (vph / 2) + vpy;
  FCenter.Z := 0;

  FMin.X := aMinX;
  FMin.Y := aMinY;
  FMin.Z := aMinZ;
  FMax.X := aMaxX;
  FMax.Y := aMaxY;
  FMax.Z := aMaxZ;

  for I := 0 to FStarCount - 1 do
  begin
    FStar[I].X := ViEngine.Math.RandomRange(FMin.X, FMax.X);
    FStar[I].Y := ViEngine.Math.RandomRange(FMin.Y, FMax.Y);
    FStar[I].Z := ViEngine.Math.RandomRange(FMin.Z, FMax.Z);
  end;

  SetXSpeed(0.0);
  SetYSpeed(0.0);
  SetZSpeed(-120);
  SetVirtualPos(0, 0);
end;

procedure TViStarfield.Done;
begin
  FStar := nil;
end;

procedure TViStarfield.SetVirtualPos(aX, aY: Single);
begin
  FVirtualPos.X := aX;
  FVirtualPos.Y := aY;
  FVirtualPos.Z := 0;
end;

procedure TViStarfield.GetVirtualPos(var aX: Single; var aY: Single);
begin
  aX := FVirtualPos.X;
  aY := FVirtualPos.Y;
end;

procedure TViStarfield.SetXSpeed(aSpeed: Single);
begin
  FSpeed.X := aSpeed;
end;

procedure TViStarfield.SetYSpeed(aSpeed: Single);
begin
  FSpeed.Y := aSpeed;
end;

procedure TViStarfield.SetZSpeed(aSpeed: Single);
begin

  FSpeed.Z := aSpeed;
end;

procedure TViStarfield.Update(aDeltaTime: Single);
var
  I: Integer;

  procedure SetRandomPos(aIndex: Integer);
  begin
    FStar[aIndex].X := ViEngine.Math.RandomRange(FMin.X, FMax.X);
    FStar[aIndex].Y := ViEngine.Math.RandomRange(FMin.Y, FMax.Y);
    FStar[aIndex].Z := ViEngine.Math.RandomRange(FMin.Z, FMax.Z);
  end;

begin

  for I := 0 to FStarCount - 1 do
  begin
    FStar[I].X := FStar[I].X + (FSpeed.X * aDeltaTime);
    FStar[I].Y := FStar[I].Y + (FSpeed.Y * aDeltaTime);
    FStar[I].Z := FStar[I].Z + (FSpeed.Z * aDeltaTime);

    if FStar[I].X < FMin.X then
    begin
      SetRandomPos(I);
      FStar[I].X := FMax.X;
    end;

    if FStar[I].X > FMax.X then
    begin
      SetRandomPos(I);
      FStar[I].X := FMin.X;
    end;

    if FStar[I].Y < FMin.Y then
    begin
      SetRandomPos(I);
      FStar[I].Y := FMax.Y;
    end;

    if FStar[I].Y > FMax.Y then
    begin
      SetRandomPos(I);
      FStar[I].Y := FMin.Y;
    end;

    if FStar[I].Z < FMin.Z then
    begin
      SetRandomPos(I);
      FStar[I].Z := FMax.Z;
    end;

    if FStar[I].Z > FMax.Z then
    begin
      SetRandomPos(I);
      FStar[I].Z := FMin.Z;
    end;

  end;
end;

procedure TViStarfield.Render;
var
  I: Integer;
  vpx, vpy, vpw, vph: Integer;
begin
  ViEngine.Display.GetViewportSize(@vpx, @vpy, @vpw, @vph);
  for I := 0 to FStarCount - 1 do
  begin
    TransformDrawPoint(FStar[I].X, FStar[I].Y, FStar[I].Z, vpx, vpy, vpw, vph);
  end;
end;

end.

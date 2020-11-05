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

unit Vivace.Bitmap;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Common,
  Vivace.Color,
  Vivace.Math;

type
  { TViBitmap }
  TViBitmap = class(TViBaseObject)
  protected
    FHandle: PALLEGRO_BITMAP;
    FWidth: Single;
    FHeight: Single;
    FLocked: Boolean;
    FLockedRegion: TViRectangle;
    FFilename: string;
  public
    property Handle: PALLEGRO_BITMAP read FHandle;

    constructor Create; override;

    destructor Destroy; override;

    procedure Allocate(aWidth: Integer; aHeight: Integer);

    procedure Load(aFilename: string; aColorKey: PViColor);

    procedure Unload;

    procedure GetSize(aWidth: PSingle; aHeight: PSingle);

    procedure Lock(aRegion: PViRectangle);

    procedure Unlock;

    function GetPixel(aX: Integer; aY: Integer): TViColor;

    procedure Draw(aX: Single; aY: Single; aRegion: PViRectangle;
      aCenter: PViVector; aScale: PViVector; aAngle: Single; aColor: TViColor;
      aHFlip: Boolean; aVFlip: Boolean);

    procedure DrawTiled(aDeltaX: Single; aDeltaY: Single);
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  Vivace.Engine;

{ --- TViBitmap ------------------------------------------------------------- }
procedure TViBitmap.Allocate(aWidth, aHeight: Integer);
begin
  Unload;
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or
    ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
  FHandle := al_create_bitmap(aWidth, aHeight);
  if FHandle <> nil then
  begin
    FWidth := al_get_bitmap_width(FHandle);
    FHeight := al_get_bitmap_height(FHandle);
    FFilename := '';
  end;
end;

procedure TViBitmap.Unload;
begin
  if FHandle <> nil then
  begin
    al_destroy_bitmap(FHandle);
    FHandle := nil;
  end;
  FWidth := 0;
  FHeight := 0;
  FLocked := False;
  FLockedRegion.Assign(0, 0, 0, 0);
end;

constructor TViBitmap.Create;
begin
  FHandle := nil;
  Unload;
end;

destructor TViBitmap.Destroy;
begin
  Unload;
  inherited;
end;

procedure TViBitmap.Draw(aX: Single; aY: Single; aRegion: PViRectangle;
  aCenter: PViVector; aScale: PViVector; aAngle: Single; aColor: TViColor;
  aHFlip: Boolean; aVFlip: Boolean);
var
  a: Single;
  rg: TViRectangle;
  cp: TViVector;
  sc: TViVector;
  c: ALLEGRO_COLOR absolute aColor;
  flags: Integer;
begin
  if FHandle = nil then
    Exit;

  // angle
  a := aAngle * VIDEG2RAD;

  // region
  if Assigned(aRegion) then
    rg.Assign(aRegion.X, aRegion.Y, aRegion.Width, aRegion.Height)
  else
    rg.Assign(0, 0, FWidth, FHeight);

  if rg.X < 0 then
    rg.X := 0;
  if rg.X > FWidth - 1 then
    rg.X := FWidth - 1;

  if rg.Y < 0 then
    rg.Y := 0;
  if rg.Y > FHeight - 1 then
    rg.Y := FHeight - 1;

  if rg.Width < 0 then
    rg.Width := 0;
  if rg.Width > FWidth then
    rg.Width := rg.Width;

  if rg.Height < 0 then
    rg.Height := 0;
  if rg.Height > FHeight then
    rg.Height := rg.Height;

  // center
  if Assigned(aCenter) then
  begin
    cp.X := (rg.Width * aCenter.X);
    cp.Y := (rg.Height * aCenter.Y);
  end
  else
  begin
    cp.X := 0;
    cp.Y := 0;
  end;

  // scale
  if Assigned(aScale) then
  begin
    sc.X := aScale.X;
    sc.Y := aScale.Y;
  end
  else
  begin
    sc.X := 1;
    sc.Y := 1;
  end;

  // flags
  flags := 0;
  if aHFlip then
    flags := flags or ALLEGRO_FLIP_HORIZONTAL;
  if aVFlip then
    flags := flags or ALLEGRO_FLIP_VERTICAL;

  // render
  al_draw_tinted_scaled_rotated_bitmap_region(FHandle, rg.X, rg.Y, rg.Width,
    rg.Height, c, cp.X, cp.Y, aX, aY, sc.X, sc.Y, a, flags);
end;

procedure TViBitmap.DrawTiled(aDeltaX: Single; aDeltaY: Single);
var
  w, h: Integer;
  ox, oy: Integer;
  px, py: Single;
  fx, fy: Single;
  tx, ty: Integer;
  vpw, vph: Integer;
  vr, vb: Integer;
  ix, iy: Integer;
begin

  ViEngine.Display.GetViewportSize(nil, nil, @vpw, @vph);

  w := Round(FWidth);
  h := Round(FHeight);

  ox := -w + 1;
  oy := -h + 1;

  px := aDeltaX;
  py := aDeltaY;

  fx := px - floor(px);
  fy := py - floor(py);

  tx := floor(px) - ox;
  ty := floor(py) - oy;

  if (tx >= 0) then
    tx := tx mod w + ox
  else
    tx := w - -tx mod w + ox;
  if (ty >= 0) then
    ty := ty mod h + oy
  else
    ty := h - -ty mod h + oy;

  vr := vpw;
  vb := vph;
  iy := ty;

  while iy < vb do
  begin
    ix := tx;
    while ix < vr do
    begin
      // Render(nil, Round(ix+fx), Round(iy+fy), 1, 0, FLIP_NONE, nil);
      al_draw_bitmap(FHandle, ix + fx, iy + fy, 0);
      ix := ix + w;
    end;
    iy := iy + h;
  end;
end;

procedure TViBitmap.GetSize(aWidth: PSingle; aHeight: PSingle);
begin
  if aWidth <> nil then
    aWidth^ := FWidth;
  if aHeight <> nil then
    aHeight^ := FHeight;
end;

procedure TViBitmap.Load(aFilename: string; aColorKey: PViColor);
var
  fn: string;
  ColorKey: PALLEGRO_COLOR absolute aColorKey;
begin
  Unload;
  fn := aFilename;

  // al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR);
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or
    ALLEGRO_VIDEO_BITMAP);

  FHandle := al_load_bitmap(PAnsiChar(AnsiString(fn)));
  if FHandle <> nil then
  begin

    FWidth := al_get_bitmap_width(FHandle);
    FHeight := al_get_bitmap_height(FHandle);

    // apply colorkey
    if aColorKey <> nil then
    begin
      al_convert_mask_to_alpha(FHandle, ColorKey^)
    end;
    FFilename := aFilename;
  end;
end;

procedure TViBitmap.Lock(aRegion: PViRectangle);
begin
  if FHandle = nil then
    Exit;

  if not FLocked then
  begin
    if aRegion <> nil then
    begin
      al_lock_bitmap_region(FHandle, Round(aRegion.X), Round(aRegion.Y),
        Round(aRegion.Width), Round(aRegion.Height), ALLEGRO_PIXEL_FORMAT_ANY,
        ALLEGRO_LOCK_READWRITE);
      FLockedRegion.Assign(aRegion.X, aRegion.Y, aRegion.Width, aRegion.Height);
    end
    else
    begin
      al_lock_bitmap(FHandle, ALLEGRO_PIXEL_FORMAT_ANY, ALLEGRO_LOCK_READWRITE);
      FLockedRegion.Assign(0, 0, FWidth, FHeight);
    end;
    FLocked := True;
  end;
end;

procedure TViBitmap.Unlock;
begin
  if FHandle = nil then
    Exit;
  if FLocked then
  begin
    al_unlock_bitmap(FHandle);
    FLocked := False;
    FLockedRegion.Assign(0, 0, 0, 0);
  end;
end;

function TViBitmap.GetPixel(aX: Integer; aY: Integer): TViColor;
var
  X, Y: Integer;
  aResult: ALLEGRO_COLOR absolute Result;
begin
  if FHandle = nil then
    Exit;

  X := Round(aX + FLockedRegion.X);
  Y := Round(aY + FLockedRegion.Y);
  aResult := al_get_pixel(FHandle, X, Y);
end;

end.

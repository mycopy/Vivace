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

unit uTiledBitmap;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Input,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Engine,
  Vivace.Bitmap,
  Vivace.Display,
  uCommon;

const
  cDisplayTitle = 'Vivace: Tiled Bitmap Demo';

type

  { TTiledBitmapDemo }
  TTiledBitmapDemo = class(TCustomDemo)
  protected
    FTexture: array[0..3] of TViBitmap;
    FSpeed: array[0..3] of Single;
    FPos: array[0..3] of TViVector;
  public
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double); override;
    procedure OnClearDisplay; override;
    procedure OnShowDisplay; override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
  end;

implementation

uses
  System.SysUtils;

{ --- TTiledBitmapDemo ------------------------------------------------------ }
procedure TTiledBitmapDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TTiledBitmapDemo.OnExit;
begin
  inherited;
end;

procedure TTiledBitmapDemo.OnStartup;
var
  I: Integer;
begin
  inherited;

  // Get bitmap interfaces
  for I := 0 to 3 do
    FTexture[I] := TViBitmap.Create;

  // Load bitmap images
  FTexture[0].Load('arc/bitmaps/backgrounds/space.png', nil);
  FTexture[1].Load('arc/bitmaps/backgrounds/nebula.png', @BLACK);
  FTexture[2].Load('arc/bitmaps/backgrounds/spacelayer1.png', @BLACK);
  FTexture[3].Load('arc/bitmaps/backgrounds/spacelayer2.png', @BLACK);

  // Set bitmap speeds
  FSpeed[0] := 0.3 * 30;
  FSpeed[1] := 0.5 * 30;
  FSpeed[2] := 1.0 * 30;
  FSpeed[3] := 2.0 * 30;

  // Clear pos
  FPos[0].Clear;
  FPos[1].Clear;
  FPos[2].Clear;
  FPos[3].Clear;
end;

procedure TTiledBitmapDemo.OnShutdown;
var
  I: Integer;
begin
  // Release bitmap interfaces
  for I := 0 to 3 do
    FreeAndNil(FTexture[I]);

  inherited;
end;

procedure TTiledBitmapDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
var
  I: Integer;
begin
  inherited;

  // update bitmap position
  for I := 0 to 3 do
  begin
    FPos[I].Y := FPos[I].Y + (FSpeed[I] * aDeltaTime);
  end;
end;

procedure TTiledBitmapDemo.OnClearDisplay;
begin
  // clear display
  ViEngine.Display.Clear(BLACK);
end;

procedure TTiledBitmapDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TTiledBitmapDemo.OnRender;
var
  I: Integer;
begin
  inherited;

  // render bitmaps
  for i := 0 to 3 do
  begin
    if i = 1 then ViEngine.Display.SetBlendMode(bmAdditiveAlpha);
    FTexture[i].DrawTiled(FPos[i].X, FPos[i].Y);
    if i = 1 then ViEngine.Display.RestoreDefaultBlendMode;
  end;
end;

procedure TTiledBitmapDemo.OnRenderGUI;
begin
  inherited;
end;

end.

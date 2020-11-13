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

unit uBitmap;

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
  uCommon;

const
  cDisplayTitle = 'Vivace: Bitmap Demo';

type

  { TBitmapDemo }
  TBitmapDemo = class(TCustomDemo)
  var
    FBitmap: array[1..2] of TViBitmap;
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

{ --- TBitmapDemo ----------------------------------------------------------- }
procedure TBitmapDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TBitmapDemo.OnExit;
begin
  inherited;
end;

procedure TBitmapDemo.OnStartup;
begin
  inherited;
  FBitmap[1] := TViBitmap.Create;
  FBitmap[2] := TViBitmap.Create;

  // load a bitmap that has true transparancy
  FBitmap[1].Load('arc/bitmaps/sprites/vivace.png', nil);

  // load a bitmap and use colorkey transparancy
  FBitmap[2].Load('arc/bitmaps/sprites/circle00.png', @COLORKEY);
end;

procedure TBitmapDemo.OnShutdown;
begin
  FreeAndNil(FBitmap[1]);
  FreeAndNil(FBitmap[2]);
  inherited;
end;

procedure TBitmapDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;
end;

procedure TBitmapDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TBitmapDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TBitmapDemo.OnRender;
begin
  inherited;

  // draw transparancy bitmap
  FBitmap[1].DrawCentered(cDisplayWidth/2, 150, 0.5, 0, WHITE);

  // draw colorkey transparancy bitmap
  FBitmap[2].DrawCentered(cDisplayWidth/2, 300, 1, 0, WHITE);
end;

procedure TBitmapDemo.OnRenderGUI;
begin
  inherited;
end;

end.

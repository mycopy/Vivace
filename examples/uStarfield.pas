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

unit uStarfield;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Input,
  Vivace.Starfield,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Engine,
  uCommon;

const
  cDisplayTitle = 'Vivace: Starfield Demo';

type

  { TStarfieldDemo }
  TStarfieldDemo = class(TCustomDemo)
  protected
    FStarfield: TViStarfield;
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

{ --- TStarfieldDemo -------------------------------------------------------- }
procedure TStarfieldDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TStarfieldDemo.OnExit;
begin
  inherited;
end;

procedure TStarfieldDemo.OnStartup;
begin
  inherited;

  // create starfield
  FStarfield := TViStarfield.Create;
end;

procedure TStarfieldDemo.OnShutdown;
begin
  // free starfield
  FreeAndNil(FStarfield);

  inherited;
end;

procedure TStarfieldDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  // starfield #1
  if ViEngine.Input.KeyboardPressed(KEY_1) then
  begin
    FStarfield.SetXSpeed(25*7);
    FStarfield.SetYSpeed(0);
    FStarfield.SetZSpeed(-(5*25));
    FStarfield.SetVirtualPos(0, 0);
  end;

  // starfield #2
  if ViEngine.Input.KeyboardPressed(KEY_2) then
  begin
    FStarfield.SetXSpeed(0);
    FStarfield.SetYSpeed(-(25*5));
    FStarfield.SetZSpeed(-(5*25));
    FStarfield.SetVirtualPos(0, 0);
  end;

  // starfield #3
  if ViEngine.Input.KeyboardPressed(KEY_3) then
  begin
    FStarfield.SetXSpeed(-(25*5));
    FStarfield.SetYSpeed(0);
    FStarfield.SetZSpeed(-(5*25));
    FStarfield.SetVirtualPos(0, 0);
  end;

  // starfield #4
  if ViEngine.Input.KeyboardPressed(KEY_4) then
  begin
    FStarfield.SetXSpeed(0);
    FStarfield.SetYSpeed(25*5);
    FStarfield.SetZSpeed(-(5*25));
    FStarfield.SetVirtualPos(0, 0);
  end;

  // starfield #5
  if ViEngine.Input.KeyboardPressed(KEY_5) then
  begin
    FStarfield.SetXSpeed(0);
    FStarfield.SetYSpeed(0);
    FStarfield.SetZSpeed(5*25);
    FStarfield.SetVirtualPos(0, 0);
  end;

  // starfield #6
  if ViEngine.Input.KeyboardPressed(KEY_6) then
  begin
    FStarfield.SetZSpeed(0);
    FStarfield.SetYSpeed(15*10);
  end;

  // starfield #7
  if ViEngine.Input.KeyboardPressed(KEY_7) then
  begin
    FStarfield.SetXSpeed(0);
    FStarfield.SetYSpeed(0);
    FStarfield.SetZSpeed(-(5*25));
    FStarfield.SetVirtualPos(0, 0);
  end;

  // update starfield
  FStarfield.Update(aDeltaTime);
end;

procedure TStarfieldDemo.OnClearDisplay;
begin
  // clear display
  ViEngine.Display.Clear(BLACK);
end;

procedure TStarfieldDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TStarfieldDemo.OnRender;
begin
  // render starfield
  FStarfield.Render;
end;

procedure TStarfieldDemo.OnRenderGUI;
begin
  inherited;

  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    '1-6 - Change starfield', [ViEngine.FrameRate]);
end;

end.

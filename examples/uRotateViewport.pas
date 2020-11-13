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

unit uRotateViewport;

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
  Vivace.Viewport,
  Vivace.Bitmap,
  uCommon;

const
  cDisplayTitle = 'Vivace: Rotate Viewport Demo';

type

  { TRotateViewportDemo }
  TRotateViewportDemo = class(TCustomDemo)
  protected
    FViewport: TViViewport;
    FBackground: TViBitmap;
    FSpeed: Single;
    FAngle: Single;
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

{ --- TRotateViewportDemo --------------------------------------------------- }
procedure TRotateViewportDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TRotateViewportDemo.OnExit;
begin
  inherited;
end;

procedure TRotateViewportDemo.OnStartup;
begin
  inherited;

  FViewport := TViViewport.Create;
  FViewport.Init((cDisplayWidth - 380) div 2, (cDisplayHeight - 280) div 2,
    380, 280);

  FBackground := TViBitmap.Create;
  FBackground.Load('arc/bitmaps/backgrounds/bluestone.png', nil);
end;

procedure TRotateViewportDemo.OnShutdown;
begin
  FreeAndNil(FBackground);
  FreeAndNil(FViewport);
  inherited;
end;

procedure TRotateViewportDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  FSpeed := FSpeed + (60 * aDeltaTime);

  FAngle := FAngle + (7 * aDeltaTime);
  ViEngine.Math.ClipValue(FAngle, 0, 359, True);
  FViewport.SetAngle(FAngle);
end;

procedure TRotateViewportDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TRotateViewportDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TRotateViewportDemo.OnRender;
var
  W: Integer;
begin
  inherited;

  ViEngine.Display.SetViewport(FViewport);
  ViEngine.Display.GetViewportSize(nil, nil, @W, nil);

  ViEngine.Display.Clear(SKYBLUE);
  FBackground.DrawTiled(0, FSpeed);
  ConsoleFont.Print(W div 2, 3, WHITE, alCenter, 'Viewport', []);

  ViEngine.Display.SetViewport(nil);
end;

procedure TRotateViewportDemo.OnRenderGUI;
begin
  inherited;
end;

end.

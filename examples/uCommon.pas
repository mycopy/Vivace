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

unit uCommon;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Display,
  Vivace.Input,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Sprite,
  Vivace.Actor,
  Vivace.Engine;

const
  cArchiveFilename = 'Data.arc';

  cDisplayWidth      = 800;
  cDisplayHeight     = 480;
  cDisplayFullscreen = False;
  cDisplayAntiAlias  = True;
  cDisplayVSync      = True;
  cDisplayRenderAPI  = raDirect3D;

type

  { TCustomDemo }
  TCustomDemo = class(TViGame)
  protected
    FTitle: string;
    FConsoleFont: TViFont;
    FDefaultFont: TViFont;
    FSprite: TViSprite;
    FScene: TViActorScene;
  public
    HudPos: TViVector;
    MousePos: TViVector;
    property Title: string read FTitle write FTitle;
    property ConsoleFont: TViFont read FConsoleFont write FConsoleFont;
    property DefaultFont: TViFont read FDefaultFont write FDefaultFont;
    property Sprite: TViSprite read FSprite;
    property Scene: TViActorScene read FScene;
    constructor Create; override;
    destructor Destroy; override;
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

{ --- TCustomDemo ----------------------------------------------------------- }
constructor TCustomDemo.Create;
begin
  inherited;
  FTitle := 'Vivace: Custom Demo';
end;

destructor TCustomDemo.Destroy;
begin
  inherited;
end;

procedure TCustomDemo.OnLoad;
begin
  // mount archive file
  ViEngine.Mount(cArchiveFilename);
end;

procedure TCustomDemo.OnExit;
begin
  // unmount archive file
  ViEngine.Unmount(cArchiveFilename);
end;

procedure TCustomDemo.OnStartup;
begin
  // open display
  ViEngine.Display.Open(-1, -1, cDisplayWidth, cDisplayHeight,
    cDisplayFullscreen, cDisplayVSync, cDisplayAntiAlias, cDisplayRenderAPI,
    FTitle);

  // create console font
  FConsoleFont := ViFontLoadConsole(12);

  // create sprite
  FSprite := TViSprite.Create;

  // create actor list
  FScene := TViActorScene.Create;
end;

procedure TCustomDemo.OnShutdown;
begin
  // free actor list
  FreeAndNil(FScene);

  // free sprite
  FreeAndNil(FSprite);

  // free fonts
  FreeAndNil(FDefaultFont);
  FreeAndNil(FConsoleFont);

  // close display
  ViEngine.Display.Close;
end;

procedure TCustomDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  // get mouse input
  ViEngine.Input.MouseGetInfo(MousePos);

  // ESC: quit
  if ViEngine.Input.KeyboardPressed(KEY_ESCAPE) then
    ViEngine.Terminate := True;

  // F11: toggle fullscreen
  if ViEngine.Input.KeyboardPressed(KEY_F11) then
    ViEngine.Display.ToggleFullscreen;

  // F12: screenshot
  if ViEngine.Input.KeyboardPressed(KEY_F12) then
    ViEngine.Screenshot.Take;
end;

procedure TCustomDemo.OnClearDisplay;
begin
  // clear display
  ViEngine.Display.Clear(DARKGRAY);
end;

procedure TCustomDemo.OnShowDisplay;
begin
  // show display
  ViEngine.Display.Show;
end;

procedure TCustomDemo.OnRender;
begin
end;

procedure TCustomDemo.OnRenderGUI;
var
  LSize: TViRectangle;
  LColor: TViColor;
begin
  // assign hud start pos
  HudPos.Assign(3,3);

  // display hud text
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, WHITE, alLeft,
    'fps %d', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'Esc - Quit', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'F11 - Toggle fullscreen', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'F12 - Screenshot', [ViEngine.FrameRate]);

  // display hut footer
  LColor := ViColorMake(64,64,64,64);
  ViEngine.Display.GetViewportSize(LSize);
  LSize.X := LSize.Width / 2;
  LSize.Y := (LSize.Height - FConsoleFont.GetLineHeight) - 3;
  FConsoleFont.Print(LSize.X,  LSize.Y, LColor, alCenter, 'Vivace™ Game Toolkit', []);
end;

end.

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

unit uTemplate;

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
  uCommon;

const
  cDisplayTitle = 'Vivace: Template';

type

  { TTemplate }
  TTemplate = class(TViGame)
  protected
    FConsoleFont: TViFont;
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

{ --- TTemplate ------------------------------------------------------------- }
procedure TTemplate.OnLoad;
begin
  // mount archive file
  ViEngine.Mount(cArchiveFilename);
end;

procedure TTemplate.OnExit;
begin
  // unmount archive file
  ViEngine.Unmount(cArchiveFilename);
end;

procedure TTemplate.OnStartup;
begin
  // open display
  ViEngine.Display.Open(-1, -1, cDisplayWidth, cDisplayHeight,
    cDisplayFullscreen, cDisplayVSync, cDisplayAntiAlias, cDisplayRenderAPI,
    cDisplayTitle);

  // create console font
  FConsoleFont := ViFontLoadConsole(12);
end;

procedure TTemplate.OnShutdown;
begin
  // free console font
  FreeAndNil(FConsoleFont);

  // close display
  ViEngine.Display.Close;
end;

procedure TTemplate.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  // process input
  if ViEngine.Input.KeyboardPressed(KEY_ESCAPE) then
    ViEngine.Terminate := True;
end;

procedure TTemplate.OnClearDisplay;
begin
  // clear display
  ViEngine.Display.Clear(BLACK);
end;

procedure TTemplate.OnShowDisplay;
begin
  // show display
  ViEngine.Display.Show;
end;

procedure TTemplate.OnRender;
begin
end;

procedure TTemplate.OnRenderGUI;
var
  Pos: TViVector;
begin
  // assign hud start pos
  Pos.Assign(3,3);

  // display hud text
  FConsoleFont.Print(Pos.X, Pos.Y, 0, WHITE, alLeft,
    'fps %d', [ViEngine.FrameRate]);
  FConsoleFont.Print(Pos.X, Pos.Y, 0, GREEN, alLeft,
    'Esc - Quit', [ViEngine.FrameRate]);
end;

end.

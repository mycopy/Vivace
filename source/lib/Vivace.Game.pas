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

unit Vivace.Game;

interface

uses
  Vivace.Common,
  Vivace.Speech,
  Vivace.Timer;

type

  { TViGame }
  TViGame = class(TViBaseObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnStartupDialogShow; virtual;
    procedure OnStartupDialogMore; virtual;
    procedure OnStartupDialogRun; virtual;
    procedure OnLoad; virtual;
    procedure OnExit; virtual;
    procedure OnStartup; virtual;
    procedure OnShutdown; virtual;
    procedure OnDisplayReady(aReady: Boolean); virtual;
    procedure OnToggleFullscreen(aFullscreen: Boolean); virtual;
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double); virtual;
    procedure OnFixedUpdate(aTimer: TViTimer); virtual;
    procedure OnProcessIMGUI; virtual;
    procedure OnClearDisplay; virtual;
    procedure OnShowDisplay; virtual;
    procedure OnOpenDisplay; virtual;
    procedure OnCloseDisplay; virtual;
    procedure OnRender; virtual;
    procedure OnBeforeRenderScene(aSceneNum: Integer); virtual;
    procedure OnAfterRenderScene(aSceneNum: Integer); virtual;
    procedure OnRenderGUI; virtual;
    procedure OnSpeechWord(aSpeech: TViSpeech; aWord: string; aText: string); virtual;
  end;

  { TViGameClass }
  TViGameClass = class of TViGame;

procedure ViRunGame(aGame: TViGameClass);

implementation

uses
  System.SysUtils,
  Vivace.Engine;

procedure ViRunGame(aGame: TViGameClass);
var
  Game: TViGame;
begin
  Game := aGame.Create;
  try
    ViEngine.Run(Game);
  finally
    FreeAndNil(Game);
    ViEngine.Run(nil);
  end;
end;

{ --- TViGame --------------------------------------------------------------- }
constructor TViGame.Create;
begin
  inherited;
end;

destructor TViGame.Destroy;
begin
  inherited;
end;

procedure TViGame.OnAfterRenderScene(aSceneNum: Integer);
begin
end;

procedure TViGame.OnBeforeRenderScene(aSceneNum: Integer);
begin
end;

procedure TViGame.OnClearDisplay;
begin
end;

procedure TViGame.OnCloseDisplay;
begin
end;

procedure TViGame.OnDisplayReady(aReady: Boolean);
begin
end;

procedure TViGame.OnExit;
begin
end;

procedure TViGame.OnFixedUpdate(aTimer: TViTimer);
begin
end;

procedure TViGame.OnLoad;
begin
end;

procedure TViGame.OnOpenDisplay;
begin
end;

procedure TViGame.OnProcessIMGUI;
begin
end;

procedure TViGame.OnRender;
begin
end;

procedure TViGame.OnRenderGUI;
begin
end;

procedure TViGame.OnShowDisplay;
begin
end;

procedure TViGame.OnShutdown;
begin
end;

procedure TViGame.OnSpeechWord(aSpeech: TViSpeech; aWord, aText: string);
begin
end;

procedure TViGame.OnStartup;
begin
end;

procedure TViGame.OnStartupDialogMore;
begin
end;

procedure TViGame.OnStartupDialogRun;
begin
end;

procedure TViGame.OnStartupDialogShow;
begin
end;

procedure TViGame.OnToggleFullscreen(aFullscreen: Boolean);
begin
end;

procedure TViGame.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
end;

end.

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

unit uAudioStream;

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
  Vivace.Audio,
  uCommon;

const
  cDisplayTitle = 'Vivace: Audio Stream Demo';

type

  { TAudioStreamDemo }
  TAudioStreamDemo = class(TCustomDemo)
  var
    FFilename: string;
    FNum: Integer;
    FMusic: TViAudioStream;
    procedure Play(aNum: Integer; aVol: Single);
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
  System.SysUtils,
  System.IOUtils;

{ --- TAudioStreamDemo ------------------------------------------------------ }
procedure TAudioStreamDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TAudioStreamDemo.OnExit;
begin
  inherited;
end;

procedure TAudioStreamDemo.OnStartup;
begin
  inherited;
  FNum := 1;
  FFilename := '';
  FMusic := TViAudioStream.Create;
  Play(1, 1.0);
end;

procedure TAudioStreamDemo.OnShutdown;
begin
  FreeAndNil(FMusic);
  inherited;
end;

procedure TAudioStreamDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  if ViEngine.Input.KeyboardPressed(KEY_PGDN) then
  begin
    Inc(FNum);
    if FNum > 13 then
      FNum := 1;
    Play(FNum, 1.0);
  end
  else
  if ViEngine.Input.KeyboardPressed(KEY_PGUP) then
  begin
    Dec(FNum);
    if FNum < 1 then
      FNum := 13;
    Play(FNum, 1.0);
  end

end;

procedure TAudioStreamDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TAudioStreamDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TAudioStreamDemo.OnRender;
begin
  inherited;
end;

procedure TAudioStreamDemo.OnRenderGUI;
begin
  inherited;
  ConsoleFont.Print(HudPos.x, HudPos.y, 0, GREEN, alLeft,
    'PgUp/PgDn   - Play sample', []);
  ConsoleFont.Print(HudPos.x, HudPos.y, 0, YELLOW, alLeft,
    'Song:         %s', [TPath.GetFileName(FFilename)]);

end;

procedure TAudioStreamDemo.Play(aNum: Integer; aVol: Single);
begin
  FFilename := Format('arc/audio/music/song%.*d.ogg', [2,aNum]);
  FMusic.Load(FFilename);
  FMusic.Play(True, aVol);
end;


end.

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

unit uAudioSample;

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
  cDisplayTitle = 'Vivace: Audio Sample Demo';

type

  { TAudioSampleDemo }
  TAudioSampleDemo = class(TCustomDemo)
  protected
    FSamples: array[ 0..8 ] of TViAudioSample;
    FLoopSampleId: TViAudioSampleId;
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

{ --- TAudioSampleDemo ------------------------------------------------------ }
procedure TAudioSampleDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TAudioSampleDemo.OnExit;
begin
  inherited;
end;

procedure TAudioSampleDemo.OnStartup;
var
  I: Integer;
begin
  inherited;

  for I := 0 to 5 do
  begin
    FSamples[I] := TViAudioSample.Create;
    FSamples[I].Load(Format('arc/audio/sfx/samp%d.ogg', [I]));
  end;
  FSamples[6] := TViAudioSample.Create;
  FSamples[6].Load('arc/audio/sfx/weapon_player.ogg');
  FSamples[7] := TViAudioSample.Create;
  FSamples[7].Load('arc/audio/sfx/thunder.ogg');
  FSamples[8] := TViAudioSample.Create;
  FSamples[8].Load('arc/audio/sfx/digthis.ogg');
end;

procedure TAudioSampleDemo.OnShutdown;
var
  I: Integer;
begin
  ViEngine.Audio.SampleStopAll;
  for I := 0 to 8 do
    FreeAndNil(FSamples[I]);
  inherited;
end;

procedure TAudioSampleDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  if ViEngine.Input.KeyboardPressed(KEY_0) then
    FSamples[0].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_1) then
    FSamples[1].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_2) then
    FSamples[2].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_3) then
    FSamples[3].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_4) then
    FSamples[4].Play(1.0, 0, 1, True, @FLoopSampleId);
  if ViEngine.Input.KeyboardPressed(KEY_5) then
    FSamples[5].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_6) then
    FSamples[6].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_7) then
    FSamples[7].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_8) then
    FSamples[8].Play(1.0, 0, 1, False, nil);
  if ViEngine.Input.KeyboardPressed(KEY_9) then
    ViEngine.Audio.SampleStop(FLoopSampleId);
end;

procedure TAudioSampleDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TAudioSampleDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TAudioSampleDemo.OnRender;
begin
  inherited;
end;

procedure TAudioSampleDemo.OnRenderGUI;
begin
  inherited;

  ConsoleFont.Print(HudPos.x, HudPos.y, 0, GREEN, alLeft,
    '1-8         - Play sample', []);
  ConsoleFont.Print(HudPos.x, HudPos.y, 0, GREEN, alLeft,
    '9           - Stop looping sample', []);

end;

end.

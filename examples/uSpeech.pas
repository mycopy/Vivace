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

unit uSpeech;

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
  Vivace.Starfield,
  Vivace.Speech,
  uCommon;

const
  cDisplayTitle = 'Vivace: Speech Demo';

const
  SpeechTextCount = 2;
  SpeechText: array[0 .. SpeechTextCount-1] of string =(

    // speech text #1
    'You are Cadet John Blake. Reports are ' +
    'showing some activity in the newly ' +
    'established "free zones" bordering the ' +
    'outer regions of the Earth Alliance ' +
    'Defense Grid.' +
    ' ' +
    'These areas were established to promote ' +
    'free commerce and attract new members to ' +
    'the Alliance. A new resistance group has ' +
    'formed and they are stirring up trouble;' +
    'Known as the New Space Resistance  or (NSR),' +
    'they are considered extremely hostile and ' +
    'you are authorized to neutralize this ' +
    'threat by any means necessary.' +
    ' ' +
    'You''ve been assigned to patrol zones one ' +
    'through seven; Your mission is called ' +
    'Operation freestrike; and you will pilot ' +
    'the LRTD-50X; This is an experimental ' +
    'long-range tactical defense ship. It is ' +
    'equipped with new advanced weaponry and ' +
    'shield technology as well as an enhanced ' +
    'quantum pulse engine.' +
    ' ' +
    'This is a top-priority mission cadet; and ' +
    'confidence is high; I repeat, confidence is high!',

    // speech text #2
    'Vivace game toolkit, is an advanced 2D game development system for desktop PC''s ' +
    'and can use Direct3D or OpenGL for hardware accelerated rendering. ' +
    'You access the features from a minimal exposed interface, to allow ' +
    'you to rapidly and efficiently develop your graphics simulations. ' +
    'It''s robust, designed for easy use and suitable for making all types ' +
    'of 2D games and other graphic simulations. There is support ' +
    'for buffers, bitmaps, audio samples, streaming music, video playback, ' +
    'loading resources directly from a standard zip archive, and much more. ' +
    'Vivace, easy, fast, fun.'
  );

type

  { TSpeechDemo }
  TSpeechDemo = class(TCustomDemo)
  protected
    FStarfield: TViStarfield;
    FVoiceNum: Integer;
    FOldVoiceNum: Integer;
    FSpeechTextNum: Integer;
    FSpeechWord: string;
    FVoiceCount: Integer;
    FVoiceDesc: string;
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
    procedure OnSpeechWord(aSpeech: TViSpeech; aWord: string;
      aText: string); override;
  end;

implementation

uses
  System.SysUtils;

{ --- TSpeechDemo ----------------------------------------------------------- }
procedure TSpeechDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TSpeechDemo.OnExit;
begin
  inherited;
end;

procedure TSpeechDemo.OnStartup;
begin
  inherited;

  DefaultFont := ViFontLoadDefault(18);

  FSpeechTextNum := 0;

  FVoiceNum := 0;
  FOldVoiceNum := 0;
  FVoiceCount := ViEngine.Speech.GetVoiceCount;
  FVoiceDesc  := ViEngine.Speech.GetVoiceAttribute(0, vaDescription);

  FStarfield := TViStarfield.Create;
  FStarfield.Init(250, -1000, -1000, 10, 1000, 1000, 1000, 260);
  FStarfield.SetZSpeed(0);
  FStarfield.SetYSpeed(600);
end;

procedure TSpeechDemo.OnShutdown;
begin
  FreeAndNil(FStarfield);
  FreeAndNil(DefaultFont);
  inherited;
end;

procedure TSpeechDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);

  procedure ChangeVoice;
  begin
    if FOldVoiceNum <> FVoiceNum then
    begin
      FVoiceDesc  := ViEngine.Speech.GetVoiceAttribute(FVoiceNum,
        vaDescription);
      ViEngine.Speech.ChangeVoice(FVoiceNum);
      FOldVoiceNum := FVoiceNum;
    end;
  end;

begin
  inherited;

  if ViEngine.Input.KeyboardPressed(KEY_DOWN) then
    begin
      Dec(FSpeechTextNum);
      ViEngine.Math.ClipValue(FSpeechTextNum, 0, SpeechTextCount-1, False);
    end
  else
  if ViEngine.Input.KeyboardPressed(KEY_UP) then
    begin
      Inc(FSpeechTextNum);
      ViEngine.Math.ClipValue(FSpeechTextNum, 0, SpeechTextCount-1, False);
    end;

  if ViEngine.Input.KeyboardPressed(KEY_PGDN) then
    begin
      Dec(FVoiceNum);
      ViEngine.Math.ClipValue(FVoiceNum, 0, FVoiceCount-1, False);
      ChangeVoice;
    end
  else
  if ViEngine.Input.KeyboardPressed(KEY_PGUP) then
    begin
      Inc(FVoiceNum);
      ViEngine.Math.ClipValue(FVoiceNum, 0, FVoiceCount-1, False);
      ChangeVoice;
    end;

  if ViEngine.Input.KeyboardPressed(KEY_S) then
  begin
    ViEngine.Speech.Speak(SpeechText[FSpeechTextNum], True);
  end;

  FStarfield.Update(aDeltaTime);
end;

procedure TSpeechDemo.OnClearDisplay;
begin
  ViEngine.Display.Clear(BLACK);
end;

procedure TSpeechDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TSpeechDemo.OnRender;
begin
  inherited;

  FStarfield.Render;
end;

procedure TSpeechDemo.OnRenderGUI;
begin
  inherited;

  ConsoleFont.Print(HudPos.x, HudPos.y, 0, GREEN, alLeft,
    'S           - Speek', []);
  ConsoleFont.Print(HudPos.x, HudPos.y, 0, GREEN, alLeft,
    'Up/Down     - Speech text (%d/%d)', [FSpeechTextNum+1,
    SpeechTextCount]);
  ConsoleFont.Print(HudPos.x, HudPos.y, 0, GREEN, alLeft,
    'PgUp/PgDn   - Speech voice (%d/%d)', [FVoiceNum+1, FVoiceCount]);
  ConsoleFont.Print(HudPos.x, HudPos.y, 0, YELLOW, alLeft,
    'Voice       - %s', [FVoiceDesc]);
  DefaultFont.Print(15, 160, YELLOW, alLeft,
    'Speech:     %s', [FSpeechWord]);
end;

procedure TSpeechDemo.OnSpeechWord(aSpeech: TViSpeech; aWord: string;
  aText: string);
begin
  FSpeechWord := aWord;
end;


end.

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

unit Vivace.Speech;

{$I Vivace.Defines.inc}

interface

uses
  System.Classes,
  Vivace.Speechlib.TLB,
  Vivace.Common;

type

  { TViSpeech }
  TViSpeech = class;

  { TViSpeechVoiceAttribute }
  TViSpeechVoiceAttribute = (vaDescription, vaName, vaVendor, vaAge, vaGender,
    vaLanguage, vaId);

  { TViSpeechWordEvent }
  TViSpeechWordEvent = procedure(aSpeech: TViSpeech; aWord: string; aText: string)
    of object;

  { TViSpeech }
  TViSpeech = class(TViBaseObject)
  protected
    FSpVoice: TSpVoice;
    FVoiceList: TInterfaceList;
    FVoiceDescList: TStringList;
    FPaused: Boolean;
    FText: string;
    FWord: string;
    FOnWord: TViSpeechWordEvent;
    procedure OnWord(aSender: TObject; aStreamNumber: Integer;
      aStreamPosition: OleVariant; aCharacterPosition, aLength: Integer);
    procedure OnStartStream(aSender: TObject; StreamNumber: Integer;
      StreamPosition: OleVariant);
    procedure DoSpeak(aText: string; aFlags: Integer);
    procedure EnumVoices;
    procedure FreeVoices;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure SetWordEventHandler(aHandler: TViSpeechWordEvent);

    function GetVoiceCount: Integer;
    function GetVoiceAttribute(aIndex: Integer;
      aAttribute: TViSpeechVoiceAttribute): string;
    procedure ChangeVoice(aIndex: Integer);

    procedure SetVolume(aVolume: Single);
    function GetVolume: Single;

    procedure SetRate(aRate: Single);
    function GetRate: Single;

    procedure Clear;
    procedure Speak(aText: string; aPurge: Boolean);
    procedure SpeakXML(aText: string; aPurge: Boolean);

    function Active: Boolean;
    procedure Pause;
    procedure Resume;
    procedure Reset;
  end;

implementation

uses
  System.SysUtils;

{ --- TViSpeech ------------------------------------------------------------- }
procedure TViSpeech.OnWord(aSender: TObject; aStreamNumber: Integer;
  aStreamPosition: OleVariant; aCharacterPosition, aLength: Integer);
begin
  if FText.IsEmpty then
    Exit;
  if not Assigned(FOnWord) then
    Exit;
  FWord := FText.Substring(aCharacterPosition, aLength);
  FOnWord(Self, PChar(FWord), PChar(FText));
end;

procedure TViSpeech.OnStartStream(aSender: TObject; StreamNumber: Integer;
  StreamPosition: OleVariant);
begin
end;

procedure TViSpeech.DoSpeak(aText: string; aFlags: Integer);
begin
  if FSpVoice = nil then
    Exit;
  if aText.IsEmpty then
    Exit;
  if FPaused then
    Resume;
  FSpVoice.Speak(aText, aFlags);
  FText := aText;
end;

procedure TViSpeech.EnumVoices;
var
  I: Integer;
  SOToken: ISpeechObjectToken;
  SOTokens: ISpeechObjectTokens;
begin
  FVoiceList := TInterfaceList.Create;
  FVoiceDescList := TStringList.Create;
  SOTokens := FSpVoice.GetVoices('', '');
  for I := 0 to SOTokens.Count - 1 do
  begin
    SOToken := SOTokens.Item(I);
    FVoiceDescList.Add(SOToken.GetDescription(0));
    FVoiceList.Add(SOToken);
  end;
end;

procedure TViSpeech.FreeVoices;
begin
  FreeAndNil(FVoiceDescList);
  FreeAndNil(FVoiceList);
end;

constructor TViSpeech.Create;
begin
  inherited;
  FPaused := False;
  FText := '';
  FWord := '';
  FOnWord := nil;
  FSpVoice := TSpVoice.Create(nil);
  FSpVoice.EventInterests := SVEAllEvents;
  EnumVoices;
  // SpVoice.OnStartStream := TSpeechUtils.OnStartStream;
  FSpVoice.OnWord := OnWord;
end;

destructor TViSpeech.Destroy;
begin
  FreeVoices;
  FSpVoice.OnWord := nil;
  FSpVoice.Free;
  inherited;
end;

procedure TViSpeech.SetWordEventHandler(aHandler: TViSpeechWordEvent);
begin
  FOnWord := aHandler;
end;

function TViSpeech.GetVoiceCount: Integer;
begin
  Result := FVoiceList.Count;
end;

function TViSpeech.GetVoiceAttribute(aIndex: Integer;
  aAttribute: TViSpeechVoiceAttribute): string;
var
  SOToken: ISpeechObjectToken;

  function GetAttr(aItem: string): string;
  begin
    if aItem = 'Id' then
      Result := SOToken.Id
    else
      Result := SOToken.GetAttribute(aItem);
  end;

begin
  Result := '';
  if (aIndex < 0) or (aIndex > FVoiceList.Count - 1) then
    Exit;
  SOToken := ISpeechObjectToken(FVoiceList.Items[aIndex]);
  case aAttribute of
    vaDescription:
      Result := FVoiceDescList[aIndex];
    vaName:
      Result := GetAttr('Name');
    vaVendor:
      Result := GetAttr('Vendor');
    vaAge:
      Result := GetAttr('Age');
    vaGender:
      Result := GetAttr('Gender');
    vaLanguage:
      Result := GetAttr('Language');
    vaId:
      Result := GetAttr('Id');
  end;
end;

procedure TViSpeech.ChangeVoice(aIndex: Integer);
var
  SOToken: ISpeechObjectToken;
begin
  if (aIndex < 0) or (aIndex > FVoiceList.Count - 1) then
    Exit;
  SOToken := ISpeechObjectToken(FVoiceList.Items[aIndex]);
  FSpVoice.Voice := SOToken;
end;

procedure TViSpeech.SetVolume(aVolume: Single);
var
  V: Integer;
begin
  if aVolume < 0 then
    aVolume := 0
  else if aVolume > 1 then
    aVolume := 1;

  V := Round(100.0 * aVolume);

  if FSpVoice = nil then
    Exit;
  FSpVoice.Volume := V;
end;

function TViSpeech.GetVolume: Single;
begin
  Result := 0;
  if FSpVoice = nil then
    Exit;
  Result := FSpVoice.Volume / 100.0;
end;

procedure TViSpeech.SetRate(aRate: Single);
var
  V: Integer;
begin
  if aRate < 0 then
    aRate := 0
  else if aRate > 1 then
    aRate := 1;

  V := Round(20.0 * aRate) - 10;

  if V < -10 then
    V := -10
  else if V > 10 then
    V := 10;

  if FSpVoice = nil then
    Exit;
  FSpVoice.Rate := V;
end;

function TViSpeech.GetRate: Single;
begin
  Result := 0;
  if FSpVoice = nil then
    Exit;
  Result := (FSpVoice.Rate + 10.0) / 20.0;
end;

procedure TViSpeech.Speak(aText: string; aPurge: Boolean);
var
  flag: Integer;
  Text: string;
begin
  flag := SVSFlagsAsync;
  Text := aText;
  if aPurge then
    flag := flag or SVSFPurgeBeforeSpeak;
  DoSpeak(Text, flag);
end;

procedure TViSpeech.SpeakXML(aText: string; aPurge: Boolean);
var
  flag: Integer;
  Text: string;
begin
  flag := SVSFlagsAsync or SVSFIsXML;
  if aPurge then
    flag := flag or SVSFPurgeBeforeSpeak;
  Text := aText;
  DoSpeak(aText, flag);
end;

procedure TViSpeech.Clear;
begin
  if FSpVoice = nil then
    Exit;
  if Active then
  begin
    FSpVoice.Skip('Sentence', MaxInt);
    Speak(' ', True);
  end;
  FText := '';
end;

function TViSpeech.Active: Boolean;
begin
  Result := False;
  if FSpVoice = nil then
    Exit;
  Result := Boolean(FSpVoice.Status.RunningState <> SRSEDone);
end;

procedure TViSpeech.Pause;
begin
  if FSpVoice = nil then
    Exit;
  FSpVoice.Pause;
  FPaused := True;
end;

procedure TViSpeech.Resume;
begin
  if FSpVoice = nil then
    Exit;
  FSpVoice.Resume;
  FPaused := False;
end;

procedure TViSpeech.Reset;
begin
  Clear;
  FreeAndNil(FSpVoice);
  FPaused := False;
  FText := '';
  FWord := '';
  FOnWord := nil;
  FSpVoice := TSpVoice.Create(nil);
  FSpVoice.OnWord := OnWord;
end;

end.

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

unit Vivace.Audio;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Common;

const
  MAX_AUDIO_CHANNELS = 16;

type

  { TViAudio }
  TViAudio = class(TViBaseObject)
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TViAudioSample }
  TViAudioSample = class(TViBaseObject)
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TViAudioStream }
  TViAudioStream = class(TViBaseObject)
  protected
    FHandle: PALLEGRO_AUDIO_STREAM;
    function  GetLooping: Boolean;
    procedure SetLooping(aLooping: Boolean);
    function  GetPlaying: Boolean;
    procedure SetPlaying(aPlaying: Boolean);
    procedure SetGain(aGain: Single);
    function GetGain: Single;
  public
    property Looping: Boolean read GetLooping write SetLooping;
    property Playing: Boolean read GetPlaying write SetPlaying;
    property Gain: Single read GetGain write SetGain;
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(aFilename: string);
    procedure Unload;
    procedure Play(aLoop: Boolean; aGain: Single);
    procedure Stop;
  end;


implementation

uses
  System.SysUtils,
  Vivace.Engine;

{ --- TViAudio -------------------------------------------------------------- }
constructor TViAudio.Create;
begin
  inherited;
end;

destructor TViAudio.Destroy;
begin
  inherited;
end;

{ ---- TViAudioSample ------------------------------------------------------- }
constructor TViAudioSample.Create;
begin
  inherited;
end;

destructor TViAudioSample.Destroy;
begin
  inherited;
end;

{ --- TViAudioStream -------------------------------------------------------- }
function  TViAudioStream.GetLooping: Boolean;
var
  Mode: ALLEGRO_PLAYMODE;
begin
  Result := False;
  if FHandle = nil then Exit;

  Mode := al_get_audio_stream_playmode(FHandle);

  if (Mode = ALLEGRO_PLAYMODE_LOOP) or
     (Mode = _ALLEGRO_PLAYMODE_STREAM_ONEDIR) then
    Result := True;
end;

procedure TViAudioStream.SetLooping(aLooping: Boolean);
var
  Mode: ALLEGRO_PLAYMODE;
begin
  if FHandle = nil then Exit;

  Stop;

  if aLooping then
    Mode := ALLEGRO_PLAYMODE_LOOP
  else
    Mode := ALLEGRO_PLAYMODE_ONCE;

  al_set_audio_stream_playmode(FHandle, Mode);
end;

function  TViAudioStream.GetPlaying: Boolean;
begin
  if FHandle = nil then
    Result := False
  else
    Result := al_get_audio_stream_playing(FHandle);
end;

procedure TViAudioStream.SetPlaying(aPlaying: Boolean);
begin
  if FHandle = nil then Exit;
  al_set_audio_stream_playing(FHandle, aPlaying);
end;

procedure TViAudioStream.SetGain(aGain: Single);
begin
  if FHandle = nil then Exit;
  al_set_audio_stream_gain(FHandle, aGain);
end;

function TViAudioStream.GetGain: Single;
begin
  if FHandle = nil then
    Result := 0
  else
    Result := al_get_audio_stream_gain(FHandle);
end;


constructor TViAudioStream.Create;
begin
  inherited;
  FHandle := nil;
end;

destructor TViAudioStream.Destroy;
begin
  Unload;
  inherited;
end;

procedure TViAudioStream.Load(aFilename: string);
var
  fn: string;
begin
  if aFilename.IsEmpty then
    Exit;

  Unload;

  FHandle := al_load_audio_stream(PAnsiChar(AnsiString(aFilename)), 4, 2048);

  if FHandle <> nil then
  begin
    al_set_audio_stream_playmode(FHandle, ALLEGRO_PLAYMODE_ONCE);
    al_attach_audio_stream_to_mixer(FHandle, ViEngine.Mixer);
    al_set_audio_stream_playing(FHandle, False);
  end;
end;

procedure TViAudioStream.Unload;
begin
  if FHandle <> nil then
  begin
    al_set_audio_stream_playing(FHandle, False);
    al_drain_audio_stream(FHandle);
    al_detach_audio_stream(FHandle);
    al_destroy_audio_stream(FHandle);
    FHandle := nil;
  end;
end;

procedure TViAudioStream.Play(aLoop: Boolean; aGain: Single);
var
  Mode: ALLEGRO_PLAYMODE;
begin
  if FHandle = nil then Exit;

  Stop;

  if aLoop then
    Mode := ALLEGRO_PLAYMODE_LOOP
  else
    Mode := ALLEGRO_PLAYMODE_ONCE;

  al_set_audio_stream_playmode(FHandle, Mode);
  al_set_audio_stream_gain(FHandle, aGain);
  al_rewind_audio_stream(FHandle);
  al_set_audio_stream_playing(FHandle, True);
end;

procedure TViAudioStream.Stop;
begin
  if FHandle = nil then Exit;
  al_set_audio_stream_playing(FHandle, False);
  al_rewind_audio_stream(FHandle);
end;

end.

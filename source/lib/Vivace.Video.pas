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

unit Vivace.Video;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Common;

type

  { TViVideo }
  TViVideo = class(TViBaseObject)
  protected
    FVoice: PALLEGRO_VOICE;
    FMixer: PALLEGRO_MIXER;
    FHandle: PALLEGRO_VIDEO;
    FLoop: Boolean;
    FPlaying: Boolean;
    FPaused: Boolean;
    FFilename: string;
    procedure InitAudio;
    procedure ShutdownAudio;
    function GetPause: Boolean;
    procedure SetPause(aPause: Boolean);
    function GetLooping: Boolean;
    procedure SetLooping(aLoop: Boolean);
    function GetPlaying: Boolean;
    procedure SetPlaying(aPlaying: Boolean);
  public
    property Handle: PALLEGRO_VIDEO read FHandle;
    property Pause: Boolean read GetPause write SetPause;
    property Looping: Boolean read GetLooping write SetLooping;
    property Playing: Boolean read GetPlaying write SetPlaying;

    constructor Create; override;

    destructor Destroy; override;

    procedure Load(aFilename: string);

    procedure Unload;

    procedure Play(aLoop: Boolean; aGain: Single);

    procedure Draw(aX: Single; aY: Single);

    procedure GetSize(aWidth: PSingle; aHeight: PSingle);

    procedure Seek(aPos: Single);

    procedure Rewind;

    class procedure PauseAll(aPause: Boolean);
    class procedure FreeAll;
    class procedure FinishedEvent(aHandle: PALLEGRO_VIDEO);
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  System.IOUtils,
  Vivace.Engine;

var
  VideoList: TList<TViVideo> = nil;

{ --- TViVideo -------------------------------------------------------------- }
procedure TViVideo.Unload;
begin

  if FHandle <> nil then
  begin
    al_set_video_playing(FHandle, False);
    al_unregister_event_source(ViEngine.Queue,
      al_get_video_event_source(FHandle));
    al_close_video(FHandle);
    ShutdownAudio;

    FHandle := nil;
    FLoop := False;
    FPlaying := False;
    FPaused := False;
  end;
end;

procedure TViVideo.InitAudio;
begin
  if al_is_audio_installed then
  begin
    if FVoice = nil then
    begin
      FVoice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16,
        ALLEGRO_CHANNEL_CONF_2);
      FMixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32,
        ALLEGRO_CHANNEL_CONF_2);
      al_attach_mixer_to_voice(FMixer, FVoice);
    end;
  end;
end;

procedure TViVideo.ShutdownAudio;
begin
  if al_is_audio_installed then
  begin
    al_detach_mixer(FMixer);
    al_destroy_mixer(FMixer);
    al_destroy_voice(FVoice);
    FMixer := nil;
    FVoice := nil;
  end;
end;

constructor TViVideo.Create;
begin
  inherited;
  FHandle := nil;
  FLoop := False;
  FPlaying := False;
  FPaused := False;
  FVoice := nil;
  FMixer := nil;
  VideoList.Add(Self);
end;

destructor TViVideo.Destroy;
begin
  VideoList.Remove(Self);
  Unload;
  inherited;
end;

procedure TViVideo.Draw(aX, aY: Single);
var
  frame: PALLEGRO_BITMAP;
begin
  if FHandle = nil then
    Exit;

  if not GetPlaying then
  begin
    Exit;
  end;

  frame := al_get_video_frame(FHandle);
  if frame <> nil then
  begin
    al_draw_scaled_bitmap(frame, 0, 0, al_get_bitmap_width(frame),
      al_get_bitmap_height(frame), aX, aY, al_get_video_scaled_width(FHandle),
      al_get_video_scaled_height(FHandle), 0);
  end;

end;

function TViVideo.GetLooping: Boolean;
begin
  Result := FLoop;
end;

function TViVideo.GetPlaying: Boolean;
begin
  if FHandle = nil then
    Result := False
  else
    Result := al_is_video_playing(FHandle);
end;

procedure TViVideo.Load(aFilename: string);
begin
  if aFilename.IsEmpty then
    Exit;

  Unload;
  if TFile.Exists(aFilename) then
  begin
    InitAudio;
    FHandle := al_open_video(PAnsiChar(AnsiString(aFilename)));
    if FHandle <> nil then
    begin
      al_register_event_source(ViEngine.Queue,
        al_get_video_event_source(FHandle));
      al_set_video_playing(FHandle, False);
      FFilename := aFilename;
    end;
  end;
end;

procedure TViVideo.Play(aLoop: Boolean; aGain: Single);
begin
  if FHandle = nil then
    Exit;
  al_start_video(FHandle, FMixer);
  al_set_mixer_gain(FMixer, aGain);
  al_set_video_playing(FHandle, True);
  FLoop := aLoop;
  FPlaying := True;
  FPaused := False;
end;

procedure TViVideo.SetLooping(aLoop: Boolean);
begin
  FLoop := aLoop;
end;

procedure TViVideo.SetPlaying(aPlaying: Boolean);
begin
  if FHandle = nil then
    Exit;
  if FPaused then
    Exit;
  al_set_video_playing(FHandle, aPlaying);
  FPlaying := aPlaying;
  FPaused := False;
end;

procedure TViVideo.GetSize(aWidth: PSingle; aHeight: PSingle);
begin
  if FHandle = nil then
  begin
    if aWidth <> nil then
      aWidth^ := 0;
    if aHeight <> nil then
      aHeight^ := 0;
    Exit;
  end;
  if aWidth <> nil then
    aWidth^ := al_get_video_scaled_width(FHandle);
  if aHeight <> nil then
    aHeight^ := al_get_video_scaled_height(FHandle);
end;

procedure TViVideo.Seek(aPos: Single);
begin
  if FHandle = nil then
    Exit;
  al_seek_video(FHandle, aPos);
end;

procedure TViVideo.SetPause(aPause: Boolean);
begin
  // if not FPlaying then Exit;
  if FHandle = nil then
    Exit;

  // if trying to pause and video is not playing, just exit
  if (aPause = True) then
  begin
    if not al_is_video_playing(FHandle) then
    Exit;
  end;

  // if trying to unpause without first being paused, just exit
  if (aPause = False) then
  begin
    if FPaused = False then
      Exit;
  end;

  al_set_video_playing(FHandle, not aPause);
  FPaused := aPause;
end;

function TViVideo.GetPause: Boolean;
begin
  Result := FPaused;
end;

procedure TViVideo.Rewind;
begin
  if FHandle = nil then
    Exit;
  al_seek_video(FHandle, 0);
end;

class procedure TViVideo.PauseAll(aPause: Boolean);
var
  V: TViVideo;
begin
  for V in VideoList do
  begin
    V.Pause := aPause;
  end;
end;

class procedure TViVideo.FreeAll;
var
  V: TViVideo;
begin
  for V in VideoList do
  begin
    FreeAndNil(V);
  end;
  VideoList.Clear;
end;

class procedure TViVideo.FinishedEvent(aHandle: PALLEGRO_VIDEO);
var
  V: TViVideo;
begin
  for V in VideoList do
  begin
    if V.Handle <> aHandle then
      continue;

    if V.Looping then
    begin
      V.Rewind;
      if not V.Pause then
        V.Playing := True;
    end;

  end;
end;

initialization
begin
  // init video list
  VideoList := TList<TViVideo>.Create;
end;

finalization
begin
  // free any unfreed videos
  TViVideo.FreeAll;

  // free video list
  FreeAndNil(VideoList);
end;

end.

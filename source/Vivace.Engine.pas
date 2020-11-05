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

unit Vivace.Engine;

interface

uses
  Vivace.Allegro.API,
  Vivace.Timer,
  Vivace.Common,
  Vivace.Math;

type

  { TViEngine }
  TViEngine = class(TViBaseObject)
  protected
    FQueue: PALLEGRO_EVENT_QUEUE;
    FEvent: ALLEGRO_EVENT;
    FVoice: PALLEGRO_VOICE;
    FMixer: PALLEGRO_MIXER;
    FMouseState: ALLEGRO_MOUSE_STATE;
    FKeyboardState: ALLEGRO_KEYBOARD_STATE;
    FTerminate: Boolean;
    FKeyCode: Integer;
    FDefaultWindowPos: TViPointi;
    FTimer: TViTimer;
    procedure StartupAllegro;
    procedure ShutdownAllegro;
    procedure SetTerminate(aTerminate: Boolean);
    function GetTerminate: Boolean;
    procedure SetUpdateSpeed(aSpeed: Single);
    function GetUpdateSpeed: Single;
    procedure SetFixedUpdateSpeed(aSpeed: Single);
    function GetFixedUpdateSpeed: Single;
    function GetFrameRate: Cardinal;
    function GetDeltaTime: Double;
  public
    property Queue: PALLEGRO_EVENT_QUEUE read FQueue;

    property Event: ALLEGRO_EVENT read FEvent;

    property Mixer: PALLEGRO_MIXER read FMixer;

    property MouseState: ALLEGRO_MOUSE_STATE read FMouseState;

    property KeyboardState: ALLEGRO_KEYBOARD_STATE read FKeyboardState;

    property KeyCode: Integer read FKeyCode write FKeyCode;

    property DefaultWindowPos: TViPointi read FDefaultWindowPos
      write FDefaultWindowPos;

    property Terminate: Boolean read GEtTerminate write SetTerminate;

    property UpdateSpeed: Single read GetUpdateSpeed write SetUpdateSpeed;

    property FixedUpdateSpeed: Single read GetFixedUpdateSpeed
      write SetFixedUpdateSpeed;

    property FrameRate: Cardinal read GetFrameRate;

    property DeltaTime: Double read GetDeltaTime;

    constructor Create; override;

    destructor Destroy; override;

    procedure ResetTiming;

    function FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;

    function FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;

    function Mount(aPath: string): Boolean;
    function Unmount(aPath: string): Boolean;

  end;

var
  Vivace: TViEngine = nil;

implementation

uses
  System.SysUtils;

{ --- TViEngine ------------------------------------------------------------- }
procedure TViEngine.StartupAllegro;
begin
  // check if allegro already installed
  if al_is_system_installed then
    Exit;

  // init allegro
  al_init;

  // init addons
  al_init_video_addon;
  al_init_font_addon;
  al_init_ttf_addon;
  al_init_primitives_addon;
  al_init_native_dialog_addon;
  al_init_image_addon;

  // install devices
  al_install_keyboard;
  al_install_mouse;
  al_install_joystick;

  // init event queues
  FQueue := al_create_event_queue;
  al_register_event_source(FQueue, al_get_keyboard_event_source);
  al_register_event_source(FQueue, al_get_mouse_event_source);
  al_register_event_source(FQueue, al_get_joystick_event_source);
  //Joystick.Setup(0);

  // init misc
  al_get_new_window_position(@DefaultWindowPos.X, @DefaultWindowPos.Y);

  // init audio
  if not al_is_audio_installed then
  begin
    // install audio
    al_install_audio;
    al_init_acodec_addon;
    FVoice := al_create_voice(44100, ALLEGRO_AUDIO_DEPTH_INT16,
      ALLEGRO_CHANNEL_CONF_2);
    FMixer := al_create_mixer(44100, ALLEGRO_AUDIO_DEPTH_FLOAT32,
      ALLEGRO_CHANNEL_CONF_2);
    al_set_default_mixer(FMixer);
    al_attach_mixer_to_voice(FMixer, FVoice);
    al_reserve_samples(ALLEGRO_MAX_CHANNELS);
  end;

  // init physfs
  if PHYSFS_init(nil) then
  begin
    al_set_physfs_file_interface;
  end;
end;

procedure TViEngine.ShutdownAllegro;
begin
  // check if allegro is not installed
  if not al_is_system_installed then
    Exit;

  // shutdown physfs
  if PHYSFS_isInit then
  begin
    PHYSFS_deinit;
  end;

  // shutdown audio
  if al_is_audio_installed then
  begin
    al_stop_samples;
    al_detach_mixer(FMixer);
    al_destroy_mixer(FMixer);
    al_destroy_voice(FVoice);
    al_uninstall_audio;
  end;

  // shutdown event queues
  al_unregister_event_source(FQueue, al_get_keyboard_event_source);
  al_unregister_event_source(FQueue, al_get_mouse_event_source);
  al_unregister_event_source(FQueue, al_get_joystick_event_source);
  al_destroy_event_queue(FQueue);

  // uninstall allegro
  al_uninstall_system;
end;

procedure TViEngine.SetTerminate(aTerminate: Boolean);
begin
  FTerminate := aTerminate;
end;

function TViEngine.GetTerminate: Boolean;
begin
  Result := FTerminate;
end;


procedure TViEngine.SetUpdateSpeed(aSpeed: Single);
begin
  FTimer.SetUpdateSpeed(aSpeed);
  //FScreenshake.Timer.SetUpdateSpeed(aSpeed);
end;

function TViEngine.GetUpdateSpeed: Single;
begin
  Result := FTimer.GetUpdateSpeed;
end;

procedure TViEngine.SetFixedUpdateSpeed(aSpeed: Single);
begin
  FTimer.SetFixedUpdateSpeed(aSpeed);
  //FScreenshake.Timer.SetFixedUpdateSpeed(aSpeed);
end;

function TViEngine.GetFixedUpdateSpeed: Single;
begin
  Result := FTimer.GetFixedUpdateSpeed;
end;

function TViEngine.GetFrameRate: Cardinal;
begin
  Result := FTimer.GetFrameRate;
end;

function TViEngine.GetDeltaTime: Double;
begin
  Result := FTimer.GetDeltaTime;
end;


constructor TViEngine.Create;
begin
  inherited;
  StartupAllegro;
  FTimer := TViTimer.Create;
end;

destructor TViEngine.Destroy;
begin
  FreeAndNil(FTimer);
  ShutdownAllegro;
  inherited;
end;

procedure TViEngine.ResetTiming;
begin
  FTimer.Reset;
end;

function TViEngine.FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
begin
  Result := FTimer.FrameSpeed(aTimer, aSpeed);
end;

function TViEngine.FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;
begin
  Result := FTimer.FrameElapsed(aTimer, aFrames);
end;

function TViEngine.Mount(aPath: string): Boolean;
begin
  Result := PHYSFS_mount(PAnsiChar(AnsiString(aPath)), nil, True);
end;

function TViEngine.Unmount(aPath: string): Boolean;
begin
  Result := PHYSFS_unmount(PAnsiChar(AnsiString(aPath)));
end;


initialization
begin
  // create global engine instance
  Vivace := TViEngine.Create;
end;

finalization
begin
  // free global engine instance
  FreeAndNil(Vivace);
end;


end.

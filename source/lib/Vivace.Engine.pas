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
  Vivace.Math,
  Vivace.Display,
  Vivace.Input,
  Vivace.Speech,
  Vivace.Audio,
  Vivace.OS,
  Vivace.Screenshake,
  Vivace.Screenshot,
  Vivace.Game;

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
    FFIState: array[False..True] of ALLEGRO_STATE;
    FTimer: TViTimer;
    FMath: TViMath;
    FInput: TViInput;
    FDisplay: TViDisplay;
    FSpeech: TViSpeech;
    FAudio: TViAudio;
    FScreenshake: TViScreenshakes;
    FScreenshot: TViScreenshot;
    FOS: TViOS;
    //FIMGUI: TViIMGUI;
    FGame: TViGame;
    procedure StartupAllegro;
    procedure ShutdownAllegro;
    procedure InitCommonColors;
    procedure SetTerminate(aTerminate: Boolean);
    function GetTerminate: Boolean;
    procedure SetUpdateSpeed(aSpeed: Single);
    function GetUpdateSpeed: Single;
    procedure SetFixedUpdateSpeed(aSpeed: Single);
    function GetFixedUpdateSpeed: Single;
    function GetFrameRate: Cardinal;
    function GetDeltaTime: Double;
    procedure GameLoop;
  public
    Joystick: TViJoystick;

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

    property Timer: TViTimer read FTimer;

    property Math: TViMath read FMath;

    property Input: TViInput read FInput;

    property Display: TViDisplay read FDisplay;

    property Speech: TViSpeech read FSpeech;

    property Audio: TViAudio read FAudio;

    property OS: TViOS read FOS;

    property Screenshake: TViScreenshakes read FScreenshake;

    property Screenshot: TViScreenshot read FScreenshot;

    //property IMGUI: TViIMGUI read FIMGUI;

    constructor Create; override;

    destructor Destroy; override;

    procedure ResetTiming;

    function FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;

    function FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;

    procedure EnablePhysFS(aEnable: Boolean);
    function Mount(aPath: string): Boolean;
    function Unmount(aPath: string): Boolean;

    procedure OnStartupDialogShow;
    procedure OnStartupDialogMore;
    procedure OnStartupDialogRun;
    procedure OnLoad;
    procedure OnExit;
    procedure OnStartup;
    procedure OnShutdown;
    procedure OnDisplayReady(aReady: Boolean);
    procedure OnToggleFullscreen(aFullscreen: Boolean);
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
    procedure OnFixedUpdate(aTimer: TViTimer);
    procedure OnProcessIMGUI;
    procedure OnClearDisplay;
    procedure OnShowDisplay;
    procedure OnOpenDisplay;
    procedure OnCloseDisplay;
    procedure OnRender;
    procedure OnBeforeRenderScene(aSceneNum: Integer);
    procedure OnAfterRenderScene(aSceneNum: Integer);
    procedure OnRenderGUI;
    procedure OnSpeechWord(aSpeech: TViSpeech; aWord: string; aText: string);

    procedure Run(aGame: TViGame = nil);
  end;

var
  ViEngine: TViEngine = nil;

implementation

uses
  System.SysUtils,
  VCL.Forms,
  WinApi.MMSystem,
  Vivace.Color,
  Vivace.Video;

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
  Joystick.Setup(0);

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
    al_reserve_samples(MAX_AUDIO_CHANNELS);
  end;


  // init physfs
  al_store_state(@FFIState[False], ALLEGRO_STATE_NEW_FILE_INTERFACE);
  al_store_state(@FFIState[True], ALLEGRO_STATE_NEW_FILE_INTERFACE);
  if PHYSFS_init(nil) then
  begin
    al_set_physfs_file_interface;
    al_store_state(@FFIState[True], ALLEGRO_STATE_NEW_FILE_INTERFACE);
  end;

  InitCommonColors;
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

procedure TViEngine.InitCommonColors;
begin
  // Common Colors
  VILIGHTGRAY := ViColorMake(200, 200, 200, 255);
  VIGRAY := ViColorMake(130, 130, 130, 255);
  VIDARKGRAY := ViColorMake(80, 80, 80, 255);
  VIYELLOW := ViColorMake(253, 249, 0, 255);
  VIGOLD := ViColorMake(255, 203, 0, 255);
  VIORANGE := ViColorMake(255, 161, 0, 255);
  VIPINK := ViColorMake(255, 109, 194, 255);
  VIRED := ViColorMake(230, 41, 55, 255);
  VIMAROON := ViColorMake(190, 33, 55, 255);
  VIGREEN := ViColorMake(0, 228, 48, 255);
  VILIME := ViColorMake(0, 158, 47, 255);
  VIDARKGREEN := ViColorMake(0, 117, 44, 255);
  VISKYBLUE := ViColorMake(102, 191, 255, 255);
  VIBLUE := ViColorMake(0, 121, 241, 255);
  VIDARKBLUE := ViColorMake(0, 82, 172, 255);
  VIPURPLE := ViColorMake(200, 122, 255, 255);
  VIVIOLET := ViColorMake(135, 60, 190, 255);
  VIDARKPURPLE := ViColorMake(112, 31, 126, 255);
  VIBEIGE := ViColorMake(211, 176, 131, 255);
  VIBROWN := ViColorMake(127, 106, 79, 255);
  VIDARKBROWN := ViColorMake(76, 63, 47, 255);
  VIWHITE := ViColorMake(255, 255, 255, 255);
  VIBLACK := ViColorMake(0, 0, 0, 255);
  VIBLANK := ViColorMake(0, 0, 0, 0);
  VIMEGENTA := ViColorMake(255, 0, 255, 255);
  VIWHITE2 := ViColorMake(245, 245, 245, 255);
  VIRED2 := ViColorMake(126, 50, 63, 255);
  VICOLORKEY := ViColorMake(255, 000, 255, 255);
  VIOVERLAY1 := ViColorMake(000, 032, 041, 180);
  VIOVERLAY2 := ViColorMake(001, 027, 001, 255);
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
  FScreenshake.Timer.SetUpdateSpeed(aSpeed);
end;

function TViEngine.GetUpdateSpeed: Single;
begin
  Result := FTimer.GetUpdateSpeed;
end;

procedure TViEngine.SetFixedUpdateSpeed(aSpeed: Single);
begin
  FTimer.SetFixedUpdateSpeed(aSpeed);
  FScreenshake.Timer.SetFixedUpdateSpeed(aSpeed);
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
  FGame := nil;
  FTimer := TViTimer.Create;
  FMath := TViMath.Create;
  FOS := TViOS.Create;
  FDisplay := TViDisplay.Create;
  FInput := TViInput.Create;
  //FIMGUI := TViIMGUI.Create;
  FSpeech := TViSpeech.Create;
  FAudio := TViAudio.Create;
  FScreenshake := TViScreenshakes.Create;
  FScreenshot := TViScreenshot.Create;
end;

destructor TViEngine.Destroy;
begin
  FreeAndNil(FScreenshot);
  FreeAndNil(FScreenshake);
  FreeAndNil(FAudio);
  FreeAndNil(FSpeech);
  //FreeAndNil(FIMGUI);
  FreeAndNil(FInput);
  FreeAndNil(FDisplay);
  FreeAndNil(FOS);
  FreeAndNil(FMath);
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

procedure TViEngine.EnablePhysFS(aEnable: Boolean);
begin
  al_restore_state(@FFIState[aEnable]);
end;

function TViEngine.Mount(aPath: string): Boolean;
begin
  Result := PHYSFS_mount(PAnsiChar(AnsiString(aPath)), nil, True);
end;

function TViEngine.Unmount(aPath: string): Boolean;
begin
  Result := PHYSFS_unmount(PAnsiChar(AnsiString(aPath)));
end;

procedure TViEngine.OnStartupDialogShow;
begin
  if Assigned(FGame) then
    FGame.OnStartupDialogShow;
end;

procedure TViEngine.OnStartupDialogMore;
begin
  if Assigned(FGame) then
    FGame.OnStartupDialogMore;
end;

procedure TViEngine.OnStartupDialogRun;
begin
  if Assigned(FGame) then
    FGame.OnStartupDialogRun;
end;

procedure TViEngine.OnLoad;
begin
  if Assigned(FGame) then
    FGame.OnLoad;
end;

procedure TViEngine.OnExit;
begin
  if Assigned(FGame) then
    FGame.OnExit;
end;

procedure TViEngine.OnStartup;
begin
  if Assigned(FGame) then
    FGame.OnStartup;
end;

procedure TViEngine.OnShutdown;
begin
  if Assigned(FGame) then
    FGame.OnShutdown;
end;

procedure TViEngine.OnDisplayReady(aReady: Boolean);
begin
  if Assigned(FGame) then
    FGame.OnDisplayReady(aReady);
end;

procedure TViEngine.OnToggleFullscreen(aFullscreen: Boolean);
begin
  if Assigned(FGame) then
    FGame.OnToggleFullscreen(aFullscreen);
end;

procedure TViEngine.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  if Assigned(FGame) then
    FGame.OnUpdate(aTimer, aDeltaTime);
end;

procedure TViEngine.OnFixedUpdate(aTimer: TViTimer);
begin
  if Assigned(FGame) then
    FGame.OnFixedUpdate(aTimer);
end;

procedure TViEngine.OnProcessIMGUI;
begin
  if Assigned(FGame) then
    FGame.OnProcessIMGUI;
end;

procedure TViEngine.OnClearDisplay;
begin
  if Assigned(FGame) then
    FGame.OnClearDisplay;
end;

procedure TViEngine.OnShowDisplay;
begin
  if Assigned(FGame) then
    FGame.OnShowDisplay;
end;

procedure TViEngine.OnOpenDisplay;
begin
  if Assigned(FGame) then
    FGame.OnOpenDisplay;
end;

procedure TViEngine.OnCloseDisplay;
begin
  if Assigned(FGame) then
    FGame.OnCloseDisplay;
end;

procedure TViEngine.OnRender;
begin
  if Assigned(FGame) then
    FGame.OnRender;
end;

procedure TViEngine.OnBeforeRenderScene(aSceneNum: Integer);
begin
  if Assigned(FGame) then
    FGame.OnBeforeRenderScene(aSceneNum);
end;

procedure TViEngine.OnAfterRenderScene(aSceneNum: Integer);
begin
  if Assigned(FGame) then
    FGame.OnAfterRenderScene(aSceneNum);
end;

procedure TViEngine.OnRenderGUI;
begin
  if Assigned(FGame) then
    FGame.OnRenderGUI;
end;

procedure TViEngine.OnSpeechWord(aSpeech: TViSpeech; aWord: string; aText: string);
begin
  if Assigned(FGame) then
    FGame.OnSpeechWord(aSpeech, aWord, aText);
end;

procedure TViEngine.Run(aGame: TViGame);
begin
  FGame := aGame;
  if FGame <> nil then
  begin
    FGame.OnLoad;
    GameLoop;
    FGame.OnExit;
  end;
end;

procedure TViEngine.GameLoop;
var
  DisplayReady: Boolean;
  trans: ALLEGRO_TRANSFORM;

  function BIT_CHECK(a, b: Integer): Boolean; inline;
  begin
    Result := (a and (1 shl b)) <> 0;
  end;

begin

  FSpeech.SetWordEventHandler(OnSpeechWord);
  // FNet.SetReceiveEvent(FGame.OnNetReceive);
  // FNet.SetStatusEvent(FGame.OnNetStatus);

  FTerminate := False;
  DisplayReady := True;

  //FAudio.Open;
  try
    OnStartup;

    FTimer.Reset;

    while not FTerminate do
    begin
      // process OS messages
      Application.ProcessMessages;

      timeBeginPeriod(1);

      if not DisplayReady then
      begin
        // allow background tasks to runn
        Sleep(1);
      end
      else if not FDisplay.VSync then
      begin
        // vsync is not active so try to minimize CPU usage
        Sleep(1);
      end;

      timeEndPeriod(1);

      // input
      FKeyCode := 0;
      al_get_keyboard_state(@FKeyboardState);
      al_get_mouse_state(@FMouseState);

      // start imgui input processing
      //FIMGUI.InputBegin;

      repeat
        //FLua.CollectGarbage;

        if al_get_next_event(FQueue, @FEvent) then
        begin

          // process imgui events
          //FIMGUI.HandleEvent(FEvent);

          case FEvent.&type of
            ALLEGRO_EVENT_DISPLAY_CLOSE:
              begin
                FTerminate := True;
              end;

            ALLEGRO_EVENT_DISPLAY_DISCONNECTED,
              ALLEGRO_EVENT_DISPLAY_HALT_DRAWING, ALLEGRO_EVENT_DISPLAY_LOST,
              ALLEGRO_EVENT_DISPLAY_SWITCH_OUT:
              begin
                // display switch out
                if FEvent.&type = ALLEGRO_EVENT_DISPLAY_SWITCH_OUT then
                begin
                  FInput.Clear;
                end;

                // pause speech engine
                if FSpeech <> nil then
                begin
                  if FSpeech.Active then
                  begin
                    FSpeech.Pause;
                  end;
                end;

                // pause audio
                if al_is_audio_installed then
                begin
                  al_set_mixer_playing(FMixer, False);
                end;

                // pause video
                TViVideo.PauseAll(True);

                // set display not ready
                DisplayReady := False;
                OnDisplayReady(DisplayReady);
              end;

            ALLEGRO_EVENT_DISPLAY_CONNECTED,
              ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING, ALLEGRO_EVENT_DISPLAY_FOUND,
              ALLEGRO_EVENT_DISPLAY_SWITCH_IN:
              begin
                // resume speech engine
                if FSpeech <> nil then
                begin
                  if FSpeech.Active then
                  begin
                    FSpeech.Resume;
                  end;
                end;

                // resume audio
                if al_is_audio_installed then
                begin
                  al_set_mixer_playing(FMixer, True);
                end;

                // resume video
                TViVideo.PauseAll(False);

                // set display ready
                DisplayReady := True;
                OnDisplayReady(DisplayReady);
              end;

            ALLEGRO_EVENT_KEY_CHAR:
              begin
                FKeyCode := FEvent.keyboard.unichar;
              end;

            ALLEGRO_EVENT_VIDEO_FINISHED:
              begin
                TViVideo.FinishedEvent(PALLEGRO_VIDEO(FEvent.user.data1));
              end;

            ALLEGRO_EVENT_JOYSTICK_AXIS:
              begin
                if (FEvent.Joystick.stick < MAX_STICKS) and
                  (FEvent.Joystick.axis < MAX_AXES) then
                begin
                  Joystick.Pos[FEvent.Joystick.stick][FEvent.Joystick.axis] :=
                    FEvent.Joystick.Pos;
                end;
              end;

            ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN:
              begin
                Joystick.Button[FEvent.Joystick.Button] := True;
              end;

            ALLEGRO_EVENT_JOYSTICK_BUTTON_UP:
              begin
                Joystick.Button[FEvent.Joystick.Button] := False;
              end;

            ALLEGRO_EVENT_JOYSTICK_CONFIGURATION:
              begin
                al_reconfigure_joysticks;
                Joystick.Setup(0);
              end;

          end;
        end;

      until al_is_event_queue_empty(FQueue);

      // end imgui input processing
      //FIMGUI.InputEnd;


      if DisplayReady then
      begin
        // process IMGUI
        OnProcessIMGUI;

        // process update and fixed update
        FTimer.Update(OnUpdate, OnFixedUpdate);

        // clear frame
        OnClearDisplay;

        // render
        OnRender;

        // process screen shakes
        FScreenshake.Update;

        // save the current transform
        trans := al_get_current_transform^;

        // reset transform
        FDisplay.ResetTransform;

        // render imgui
        //FIMGUI.Render;

        // clear imgui resources
        //FIMGUI.Clear;

        // render normal gui
        OnRenderGUI;

        // got back to current transform
        al_use_transform(@trans);

        // process screen shots
        FScreenshot.Process;

        // show display
        OnShowDisplay;


        // process deferred callbacks here
        //FHighscores.Poll;
      end;
      // call deferred callback here

    end;

  finally
    OnShutdown;
  end;

  FSpeech.Clear;
  //FAudio.Music.Unload;
  //FAudio.Close;
  //FPhysics.Close;
  // FNet.Close;
end;

initialization
begin
  // create global engine instance
  ViEngine := TViEngine.Create;
end;

finalization
begin
  // free global engine instance
  FreeAndNil(ViEngine);
end;


end.

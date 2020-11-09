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

unit uTest02;

{$I Vivace.Defines.inc}

interface

procedure RunTest02;

implementation

uses
  System.SysUtils,
  System.Math,
  Vivace.Engine,
  Vivace.Timer,
  Vivace.Speech,
  Vivace.Color,
  Vivace.Display,
  Vivace.Game,
  Vivace.Font,
  Vivace.Math,
  Vivace.Input,
  Vivace.Text,
  Vivace.Video,
  Vivace.Audio,
  Vivace.Bitmap,
  Vivace.Starfield,
  Vivace.IMGUI,
  Vivace.Nuklear.API;

type
  { TMyGame }
  TMyGame = class(TViGame)
  protected
    FConsoleFont: TViFont;
    FDefaultFont: TViFont;
    FText: TViTextCache;
    FVideo1: TViVideo;
    FVideo2: TViVideo;
    FMusic1: TViAudioStream;
    FMusic2: TViAudioStream;
    FLogo: TViBitmap;
    FLogoAngle: Single;
    FCenter: TViVector;
    FSamples: array[ 0..8 ] of TViAudioSample;
    FLoopSampleId: TViAudioSampleId;
    FStarfield: TViStarfield;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnStartupDialogShow; override;
    procedure OnStartupDialogMore; override;
    procedure OnStartupDialogRun; override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnDisplayReady(aReady: Boolean); override;
    procedure OnToggleFullscreen(aFullscreen: Boolean); override;
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double); override;
    procedure OnFixedUpdate(aTimer: TViTimer); override;
    procedure OnProcessIMGUI; override;
    procedure OnClearDisplay; override;
    procedure OnShowDisplay; override;
    procedure OnOpenDisplay; override;
    procedure OnCloseDisplay; override;
    procedure OnRender; override;
    procedure OnBeforeRenderScene(aSceneNum: Integer); override;
    procedure OnAfterRenderScene(aSceneNum: Integer); override;
    procedure OnRenderGUI; override;
    procedure OnSpeechWord(aSpeech: TViSpeech; aWord: string; aText: string); override;
  end;

procedure RunTest02;
begin
  ViRunGame(TMyGame);
end;


{ --- TMyGame --------------------------------------------------------------- }
constructor TMyGame.Create;
begin
  inherited;
  FCenter.Assign(0.5, 0.5);
  FLogoAngle := 0;
end;

destructor TMyGame.Destroy;
begin

  inherited;
end;

procedure TMyGame.OnAfterRenderScene(aSceneNum: Integer);
begin
  inherited;

end;

procedure TMyGame.OnBeforeRenderScene(aSceneNum: Integer);
begin
  inherited;

end;

procedure TMyGame.OnClearDisplay;
begin
  inherited;
  ViEngine.Display.Clear(VIBLACK);
end;

procedure TMyGame.OnCloseDisplay;
begin
  inherited;

end;

procedure TMyGame.OnDisplayReady(aReady: Boolean);
begin
  inherited;
  if aReady then
    WriteLn('Display ready...')
  else
    WriteLn('Display not ready...');
end;

procedure TMyGame.OnExit;
begin
  inherited;

end;

procedure TMyGame.OnFixedUpdate(aTimer: TViTimer);
begin
  inherited;

end;

procedure TMyGame.OnLoad;
begin
  inherited;

end;

procedure TMyGame.OnOpenDisplay;
begin
  inherited;

end;

type
  tmenu_state = (MENU_NONE,MENU_FILE, MENU_EDIT,MENU_VIEW,MENU_CHART);

var
  show_menu: integer = nk_true;
  show_app_about: integer = nk_false;
  menu_state: tmenu_state = MENU_FILE;
  state: nk_collapse_states;
  values: array[0..11] of single = (26.0,13.0,30.0,15.0,25.0,10.0,20.0,40.0,12.0,8.0,22.0,28.0);
  prog: nk_size = 40;
  slider: integer = 10;
  check: integer = nk_true;
  mprog: nk_size = 60;
  mslider: integer = 10;
  mcheck: integer = nk_true;

procedure TMyGame.OnProcessIMGUI;
var
  ctx: pnk_context;
begin
  inherited;

  ctx := ViEngine.IMGUI.Context;

  ViEngine.IMGUI.WindowBegin('Test', 'Test Window', 50, 50, 200, 200,
    [IMGUI_WINDOW_BORDER, IMGUI_WINDOW_MOVABLE, IMGUI_WINDOW_SCALABLE,
    IMGUI_WINDOW_TITLE,IMGUI_WINDOW_CLOSABLE]);

    if (show_menu = 1) then
    begin

      nk_menubar_begin(ctx);

      // menu #1
      nk_layout_row_begin(ctx, NK_STATIC, 25, 5);
      nk_layout_row_push(ctx, 45);
      if nk_menu_begin_label(ctx, 'MENU', NK_TEXT_LEFT, nk_vec2_(120, 200)) = nk_true then
      begin
          nk_layout_row_dynamic(ctx, 25, 1);
          if (nk_menu_item_label(ctx, 'Hide', NK_TEXT_LEFT)) = nk_true then
              show_menu := nk_false;
          if (nk_menu_item_label(ctx, 'About', NK_TEXT_LEFT)) = nk_true then
              show_app_about := nk_true;
          nk_progress(ctx, @prog, 100, NK_MODIFIABLE);
          nk_slider_int(ctx, 0, @slider, 16, 1);
          nk_checkbox_label(ctx, 'check', @check);
          nk_menu_end(ctx);
      end;


      // menu #2
      nk_layout_row_push(ctx, 60);
      if nk_menu_begin_label(ctx, 'ADVANCED', NK_TEXT_LEFT, nk_vec2_(200, 600)) = nk_true then
      begin
          state := ifThen(menu_state = MENU_FILE, NK_MAXIMIZED, NK_MINIMIZED);
          if nk_tree_state_push(ctx, NK_TREE_TAB, 'FILE', @state) = nk_true then
          begin
            menu_state := MENU_FILE;
            nk_menu_item_label(ctx, 'New', NK_TEXT_LEFT);
            nk_menu_item_label(ctx, 'Open', NK_TEXT_LEFT);
            nk_menu_item_label(ctx, 'Save', NK_TEXT_LEFT);
            nk_menu_item_label(ctx, 'Close', NK_TEXT_LEFT);
            nk_menu_item_label(ctx, 'Exit', NK_TEXT_LEFT);
            nk_tree_pop(ctx);
          end
          else menu_state := tmenu_state(ifthen(menu_state = MENU_FILE, Ord(MENU_NONE), Ord(menu_state)));

          state := ifthen(menu_state = MENU_EDIT, NK_MAXIMIZED, NK_MINIMIZED);
          if nk_tree_state_push(ctx, NK_TREE_TAB, 'EDIT', @state) = nk_true then
          begin
              menu_state := MENU_EDIT;
              nk_menu_item_label(ctx, 'Copy', NK_TEXT_LEFT);
              nk_menu_item_label(ctx, 'Delete', NK_TEXT_LEFT);
              nk_menu_item_label(ctx, 'Cut', NK_TEXT_LEFT);
              nk_menu_item_label(ctx, 'Paste', NK_TEXT_LEFT);
              nk_tree_pop(ctx);
          end
          //else menu_state := ifthen(menu_state = MENU_EDIT, MENU_NONE, menu_state);
          else menu_state := tmenu_state(ifthen(menu_state = MENU_EDIT, Ord(MENU_NONE), Ord(menu_state)));

          state := ifthen(menu_state = MENU_VIEW, NK_MAXIMIZED, NK_MINIMIZED);
          if nk_tree_state_push(ctx, NK_TREE_TAB, 'VIEW', @state) = nk_true then
          begin
              menu_state := MENU_VIEW;
              nk_menu_item_label(ctx, 'About', NK_TEXT_LEFT);
              nk_menu_item_label(ctx, 'Options', NK_TEXT_LEFT);
              nk_menu_item_label(ctx, 'Customize', NK_TEXT_LEFT);
              nk_tree_pop(ctx);
          end
          //else menu_state := ifthen(menu_state = MENU_VIEW, MENU_NONE, menu_state);
          else menu_state := tmenu_state(ifthen(menu_state = MENU_VIEW, Ord(MENU_NONE), Ord(menu_state)));


          state := ifthen(menu_state = MENU_CHART, NK_MAXIMIZED, NK_MINIMIZED);
          if nk_tree_state_push(ctx, NK_TREE_TAB, 'CHART', @state) = nk_true then
          begin
              var i: nk_size := 0;
              menu_state := MENU_CHART;
              nk_layout_row_dynamic(ctx, 150, 1);
              nk_chart_begin(ctx, NK_CHART_COLUMN, Length(values), 0, 50);
              //for (i = 0; i < Length(values); ++i)
              for i := 0 to Length(values) do
                  nk_chart_push(ctx, values[i]);
              nk_chart_end(ctx);
              nk_tree_pop(ctx);
          end
          else menu_state := tmenu_state(ifthen(menu_state = MENU_CHART, Ord(MENU_NONE), Ord(menu_state)));
          nk_menu_end(ctx);
      end;

      // menu widgets
      nk_layout_row_push(ctx, 70);
      nk_progress(ctx, @mprog, 100, NK_MODIFIABLE);
      nk_slider_int(ctx, 0, @mslider, 16, 1);
      nk_checkbox_label(ctx, 'check', @mcheck);

      nk_menubar_end(ctx);

    end;

  ViEngine.IMGUI.WindowEnd;

end;

procedure TMyGame.OnRender;
begin
  inherited;

  FStarfield.Render;

  FLogo.Draw(240, 300, nil, @FCenter, nil, FLogoAngle, VIWHITE, FAlse, False);

  FVideo1.Draw(50, 50);
  FVideo2.Draw(60, 60);
end;

procedure TMyGame.OnRenderGUI;
var
  Pos: TViVector;
begin
  inherited;
  Pos.Assign(3,3);
  FConsoleFont.Print(Pos.x, Pos.y, 0, VIWHITE, alLeft, 'fps %d',
    [ViEngine.FrameRate]);
  FConsoleFont.Print(Pos.x, Pos.y, 0, VIGREEN, alLeft, 'ESC Quit',
    [ViEngine.FrameRate]);

  FText.Render;
end;

procedure TMyGame.OnShowDisplay;
begin
  inherited;
  ViEngine.Display.Show;
end;

procedure TMyGame.OnShutdown;
var
  I: Integer;
begin
  ViEngine.IMGUI.Close;

  FreeAndNil(FVideo2);
  FreeAndNil(FVideo1);
  FreeAndNil(FMusic1);
  ViEngine.Audio.SampleStopAll;
  for I := 0 to 8 do
    FreeAndNil(FSamples[I]);
  FreeAndNil(FLogo);
  FreeAndNil(FText);
  FreeAndNil(FDefaultFont);
  FreeAndNil(FConsoleFont);
  FreeAndNil(FStarfield);
  ViEngine.Display.Close;
  inherited;
end;

procedure TMyGame.OnSpeechWord(aSpeech: TViSpeech; aWord, aText: string);
begin
  inherited;
  WriteLn(aWord);
end;

procedure TMyGame.OnStartup;
var
  I: Integer;
begin
  inherited;
  ViEngine.Display.Open(-1, -1, 480, 600, False, True, True, raDirect3D, 'MyGame');

  FStarfield := TViStarfield.Create;

  //ViEngine.Mount('./');
  ViEngine.Mount('data.arc');
  FConsoleFont := TViFont.Create;
  FConsoleFont.Load(12, 'arc/fonts/console.ttf');

  FDefaultFont := TViFont.Create;
  FDefaultFont.Load(18, 'arc/fonts/default.ttf');

  FText := TViTextCache.Create;
  FText.Print(FDefaultFont, 50, 50, alLeft, 1.0, 0.0, [VIWHITE, VIRED, VIBLUE,
    VIYELLOW], 'My name is ^c3^%s^c0^', ['Jarrod Davis']);

  FText.Print(FDefaultFont, 50, 50, alLeft, 1.0, 21.0, [VIWHITE, VIRED, VIBLUE,
    VIYELLOW], 'My ^c1^name^c0^ is %s', ['Jarrod Davis']);

  FLogo := TViBitmap.Create;
  FLogo.Load('arc/bitmaps/sprites/vivace.png', nil);

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

  FMusic1 := TViAudioStream.Create;
  FMusic1.Load('arc/audio/music/song06.ogg');
  FMusic1.Play(True, 1.0);

  FVideo1 := TViVideo.Create;
  FVideo1.Load('arc/videos/small.ogv');
  //FVideo1.Play(True, 1.0);

  FVideo2 := TViVideo.Create;
  FVideo2.Load('arc/videos/test.ogv');
  //FVideo2.Play(True, 1.0);

  ViEngine.Speech.Speak('Vivace Game Toolkit', True);


  ViEngine.IMGUI.Open(12, 'arc/fonts/gui.ttf');
  ViEngine.IMGUI.SetStyle(IMGUI_THEME_DARK);
end;

procedure TMyGame.OnStartupDialogMore;
begin
  inherited;

end;

procedure TMyGame.OnStartupDialogRun;
begin
  inherited;

end;

procedure TMyGame.OnStartupDialogShow;
begin
  inherited;

end;

procedure TMyGame.OnToggleFullscreen(aFullscreen: Boolean);
begin
  inherited;

end;

procedure TMyGame.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  if ViEngine.Input.KeyboardPressed(KEY_ESCAPE) then
    ViEngine.Terminate := True;


  if ViEngine.Input.KeyboardPressed(KEY_F11) then
    ViEngine.Display.ToggleFullscreen;

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

  if ViEngine.Input.KeyboardPressed(KEY_S) then
    ViEngine.Screenshake.Start(30,7);

  if ViEngine.Input.KeyboardPressed(KEY_F12) then
    ViEngine.Screenshot.Take;

  FLogoAngle := FLogoAngle + (30.0 * aDeltaTime);
  ViEngine.Math.ClipValue(FLogoAngle, 0, 359, True);

  FStarfield.Update(aDeltaTime);
end;

end.

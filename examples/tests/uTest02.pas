﻿unit uTest02;

interface

procedure RunTest02;

implementation

uses
  Vivace.Engine,
  Vivace.Timer,
  Vivace.Speech,
  Vivace.Color,
  Vivace.Display,
  Vivace.Game;

type
  { TMyGame }
  TMyGame = class(TViGame)
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
  ViEngine.Display.Clear(VISKYBLUE);
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

procedure TMyGame.OnProcessIMGUI;
begin
  inherited;

end;

procedure TMyGame.OnRender;
begin
  inherited;

end;

procedure TMyGame.OnRenderGUI;
begin
  inherited;

end;

procedure TMyGame.OnShowDisplay;
begin
  inherited;
  ViEngine.Display.Show;
end;

procedure TMyGame.OnShutdown;
begin
  inherited;
  ViEngine.Display.Close;
end;

procedure TMyGame.OnSpeechWord(aSpeech: TViSpeech; aWord, aText: string);
begin
  inherited;

end;

procedure TMyGame.OnStartup;
begin
  inherited;
  ViEngine.Display.Open(-1, -1, 480, 600, False, True, True, raDirect3D, 'MyGame');
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

end;

end.

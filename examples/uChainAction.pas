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

unit uChainAction;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Input,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Engine,
  Vivace.Actor,
  Vivace.Starfield,
  Vivace.Display,
  Vivace.Audio,
  uCommon;

const
  cDisplayTitle = 'Vivace: ChainAction Demo';

  // scene
  SCN_COUNT  = 2;
  SCN_CIRCLE = 0;
  SCN_EXPLO  = 1;

  // circle
  SHRINK_FACTOR = 0.65;

  CIRCLE_SCALE = 0.125;
  CIRCLE_SCALE_SPEED   = 0.95;

  CIRCLE_EXP_SCALE_MIN = 0.05;
  CIRCLE_EXP_SCALE_MAX = 0.49;

  CIRCLE_MIN_COLOR = 64;
  CIRCLE_MAX_COLOR = 255;

  CIRCLE_COUNT = 80;

type

  { TCommonEntity }
  TCommonEntity = class(TViActorEntity)
  public
    constructor Create; override;
    procedure OnCollide(aActor: TViActor; aHitPos: TViVector); override;
    function  Collide(aActor: TViActor; var aHitPos: TViVector): Boolean; override;
  end;

  { TCircle }
  TCircle = class(TCommonEntity)
  protected
    FColor: TViColor;
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TViActor; aHitPos: TViVector); override;
    property Speed: Single read FSpeed;
  end;

  { TCircleExplosion }
  TCircleExplosion = class(TCommonEntity)
  protected
    FColor: array[0..1] of TViColor;
    FState: Integer;
    FFade: Single;
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(aX, aY: Single; aColor: TViColor); overload;
    procedure Setup(aCircle: TCircle); overload;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TViActor; aHitPos: TViVector); override;
  end;


  { TChainActionDemo }
  TChainActionDemo = class(TCustomDemo)
  protected
    FExplosions: Integer;
    FChainActive: Boolean;
    FStarfield: TViStarfield;
    FMusic: TViAudioStream;
  public
    property Explosions: Integer read FExplosions write FExplosions;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double); override;
    procedure OnClearDisplay; override;
    procedure OnShowDisplay; override;
    procedure OnRender; override;
    procedure OnBeforeRenderScene(aSceneNum: Integer); override;
    procedure OnAfterRenderScene(aSceneNum: Integer); override;
    procedure OnRenderGUI; override;
    procedure SpawnCircle(aNum: Integer); overload;
    procedure SpawnCircle; overload;
    procedure SpawnExplosion(aX, aY: Single; aColor: TViColor); overload;
    procedure SpawnExplosion(aCircle: TCircle); overload;
    procedure CheckCollision(aEntity: TViActorEntity);
    procedure StartChain;
    procedure PlayLevel;
    function  ChainEnded: Boolean;
    function  LevelClear: Boolean;
  end;

var
  Game: TChainActionDemo = nil;

implementation

uses
  System.SysUtils;

{ --- TCommonEntity --------------------------------------------------------- }
constructor TCommonEntity.Create;
begin
  inherited;
  CanCollide := True;
end;

procedure TCommonEntity.OnCollide(aActor: TViActor; aHitPos: TViVector);
begin
  inherited;
end;

function  TCommonEntity.Collide(aActor: TViActor; var aHitPos: TViVector): Boolean;
begin
  Result := False;

  if Overlap(aActor) then
  begin
    aHitPos.X := Entity.GetPos.X;
    aHitPos.Y := Entity.GetPos.Y;
    Result := True;
  end;
end;


{ --- TCircle --------------------------------------------------------------- }
constructor TCircle.Create;
var
  ok: Boolean;
  VP: TViRectangle;
  A: Single;
begin
  inherited;

  ViEngine.Display.GetViewportSize(VP);

  Entity.Init(Game.Sprite, 0);
  Entity.SetShrinkFactor(SHRINK_FACTOR);
  Entity.SetScaleAbs(CIRCLE_SCALE);
  Entity.SetPosAbs(ViEngine.Math.RandomRange(32, (VP.Width-1)-32),
    ViEngine.Math.RandomRange(32, (VP.Width-1)-32));

  ok := False;
  repeat
    Sleep(1);
    FColor := ViColorMake(
      ViEngine.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      ViEngine.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      ViEngine.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      ViEngine.Math.RandomRange(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR)
    );

    if ViColorEqual(FColor, BLACK) or
       ViColorEqual(FColor, WHITE) then
      continue;

    ok := True;
  until ok;

  ok := False;
  repeat
    Sleep(1);
    A := ViEngine.Math.RandomRange(0, 359);
    if (Abs(A) >=90-10) and (Abs(A) <= 90+10) then continue;
    if (Abs(A) >=270-10) and (Abs(A) <= 270+10) then continue;

    ok := True;
  until ok;

  Entity.RotateAbs(A);
  Entity.SetColor(FColor);
  FSpeed := ViEngine.Math.RandomRange(3*35, 7*35);
end;

destructor TCircle.Destroy;
begin
  inherited;
end;

procedure TCircle.OnUpdate(aDelta: Single);
var
  V: TViVector;
  VP: TViRectangle;
  R: Single;
begin
  ViEngine.Display.GetViewportSize(VP);

  Entity.Thrust(FSpeed * aDelta);

  V := Entity.GetPos;

  R := Entity.GetRadius / 2;

  if V.x < -R then
    V.x := VP.Width-1
  else if V.x > (VP.Width-1)+R then
    V.x := -R;

  if V.y < -R then
    V.y := (VP.Height-1)
  else if V.y > (VP.Height-1)+R then
    V.y := -R;

  Entity.SetPosAbs(V.X, V.Y);
end;

procedure TCircle.OnRender;
begin
  inherited;
end;

procedure TCircle.OnCollide(aActor: TViActor; aHitPos: TViVector);
begin
  Terminated := True;
  Game.SpawnExplosion(Entity.GetPos.X, Entity.GetPos.Y, FColor);
  Game.Explosions := Game.Explosions + 1;
end;


{ --- TCircleExplosion ------------------------------------------------------ }
constructor TCircleExplosion.Create;
begin
  inherited;
  Entity.Init(Game.Sprite, 0);
  Entity.SetShrinkFactor(SHRINK_FACTOR);
  Entity.SetScaleAbs(CIRCLE_SCALE);
  FState := 0;
  FFade := 0;
  FSpeed := 0;
end;

destructor TCircleExplosion.Destroy;
begin
  inherited;
end;

procedure TCircleExplosion.Setup(aX, aY: Single; aColor: TViColor);
begin
  FColor[0] := aColor;
  FColor[1] := aColor;
  Entity.SetPosAbs(aX, aY);
end;
procedure TCircleExplosion.Setup(aCircle: TCircle);
begin
  Setup(aCircle.Entity.GetPos.X, aCircle.Entity.GetPos.Y, aCircle.Entity.GetColor);
  Entity.RotateAbs(aCircle.Entity.GetAngle);
  FSpeed := aCircle.Speed;
end;

procedure TCircleExplosion.OnUpdate(aDelta: Single);
begin
  Entity.Thrust(FSpeed*aDelta);

  case FState of
    0: // expand
    begin
      Entity.SetScaleRel(CIRCLE_SCALE_SPEED*aDelta);
      if Entity.GetScale > CIRCLE_EXP_SCALE_MAX then
      begin
        FState := 1;
      end;
      Entity.SetColor(FColor[0]);
    end;

    1: // contract
    begin
      Entity.SetScaleRel(-CIRCLE_SCALE_SPEED*aDelta);
      FFade := CIRCLE_SCALE_SPEED*aDelta / Entity.GetScale;
      if Entity.GetScale < CIRCLE_EXP_SCALE_MIN then
      begin
        FState := 2;
        FFade := 1.0;
        Terminated := True;
      end;
      //C := Engine.Color.Fade(FColor[0], FColor[1], FFade);
      //Entity.SetColor(C);
    end;

    2: // kill
    begin
      Terminated := True;
    end;

  end;

  Game.CheckCollision(Self);
end;

procedure TCircleExplosion.OnRender;
begin
  //Engine.Display.SetBlendMode(bmAdditiveAlpha);
  //Entity.Render(0, 0);
  //Engine.Display.RestoreDefaultBlendMode;
  inherited;
end;

procedure TCircleExplosion.OnCollide(aActor: TViActor; aHitPos: TViVector);
begin
end;

{ --- TChainActionDemo ------------------------------------------------------ }
constructor TChainActionDemo.Create;
begin
  inherited;
  Game := Self;
end;

destructor TChainActionDemo.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TChainActionDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TChainActionDemo.OnExit;
begin
  inherited;
end;

procedure TChainActionDemo.OnStartup;
var
  Page: Integer;
  Group: Integer;
begin
  inherited;

  DefaultFont := ViFontLoadDefault(18);

  // init circle sprite
  Page := Sprite.LoadPage('arc/bitmaps/sprites/light.png', @COLORKEY);
  Group := Sprite.AddGroup;
  Sprite.AddImageFromGrid(Page, Group, 0, 0, 256, 256);

  // init starfield
  FStarfield := TViStarfield.Create;

  // init music
  FMusic := TViAudioStream.Create;
  FMusic.Load('arc/audio/music/song06.ogg');
  FMusic.Play(True, 1.0);

  Scene.Alloc(SCN_COUNT);
  PlayLevel;
end;

procedure TChainActionDemo.OnShutdown;
begin
  FreeAndNil(FMusic);
  FreeAndNil(FStarfield);
  inherited;
end;

procedure TChainActionDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  // start  new level
  if ViEngine.Input.KeyboardPressed(KEY_SPACE) then
  begin
    if LevelClear then
      PlayLevel;
  end;

  // start chain reaction
  if ViEngine.Input.MousePressed(MOUSE_BUTTON_LEFT) then
  begin
    if ChainEnded then
      StartChain;
  end;

  FStarfield.Update(aDeltaTime);

  // update scene
  FScene.Update([], aDeltaTime);
end;

procedure TChainActionDemo.OnClearDisplay;
begin
  ViEngine.Display.Clear(BLACK);
end;

procedure TChainActionDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TChainActionDemo.OnRender;
begin
  FStarfield.Render;
  FScene.Render([], OnBeforeRenderScene, OnAfterRenderScene);
  inherited;
end;

procedure TChainActionDemo.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      ViEngine.Display.SetBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
      ViEngine.Display.SetBlendMode(bmAdditiveAlpha);
    end;
  end;
end;

procedure TChainActionDemo.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      ViEngine.Display.RestoreDefaultBlendMode;
    end;
  end;
end;

procedure TChainActionDemo.OnRenderGUI;
var
  VP: TViRectangle;
  x: Single;
  C: TViColor;
begin
  inherited;

  ConsoleFont.Print(HudPos.X, HudPos.y, 0, YELLOW, alLeft, 'Circles: %d',
    [Scene[SCN_CIRCLE].Count]);


  ViEngine.Display.GetViewportSize(vp);
  x := vp.Width / 2;

  if ChainEnded and (not LevelClear) then
    C := WHITE
  else
    C := DARKGRAY;

  DefaultFont.Print(x, 120, C, alCenter,
    'Click mouse to start chain reaction', []);

  if LevelClear then
  begin
    DefaultFont.Print(x, 120+21, YELLOW, alCenter,
      'Press SPACE to start new level', []);
  end;
end;

procedure TChainActionDemo.SpawnCircle(aNum: Integer);
var
  I: Integer;
begin
  for I := 0 to aNum - 1 do
    Scene[SCN_CIRCLE].Add(TCircle.Create);
end;

procedure TChainActionDemo.SpawnCircle;
begin
  SpawnCircle(ViEngine.Math.RandomRange(10, 40));
end;

procedure TChainActionDemo.SpawnExplosion(aX, aY: Single; aColor: TViColor);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aX, aY, aColor);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainActionDemo.SpawnExplosion(aCircle: TCircle);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aCircle);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainActionDemo.CheckCollision(aEntity: TViActorEntity);
begin
  Scene[SCN_CIRCLE].CheckCollision([], aEntity);
end;

procedure TChainActionDemo.StartChain;
begin
  if not FChainActive then
  begin
    SpawnExplosion(MousePos.X, MousePos.Y, WHITE);
    FChainActive := True;
  end;
end;

procedure TChainActionDemo.PlayLevel;
begin
  Scene.ClearAll;
  SpawnCircle(CIRCLE_COUNT);
  FChainActive := False;
  FExplosions := 0;
end;

function  TChainActionDemo.ChainEnded: Boolean;
begin
  Result := True;
  if FChainActive then
  begin
    Result := Boolean(Scene[SCN_EXPLO].Count = 0);
    if Result  then
      FChainActive := False;
  end;
end;

function  TChainActionDemo.LevelClear: Boolean;
begin
  Result := Boolean(Scene[SCN_CIRCLE].Count = 0);
end;

end.

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

unit uAstroBlaster;

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
  Vivace.Audio,
  Vivace.Bitmap,
  Vivace.Display,
  Vivace.Actor,
  Vivace.Misc,
  uCommon;

const
  cDisplayTitle = 'Vivace: AstroBlaster Demo';

  cMultiplier = 60;
  cPlayerMultiplier = 600;

  // player
  cPlayerTurnRate      = 2.7 * cPlayerMultiplier;
  //cPlayerFriction      = 1.005;
  cPlayerFriction      = 0.005* cPlayerMultiplier;
  cPlayerAccel         = 0.1* cPlayerMultiplier;
  cPlayerMagnitude     = 10 * 14;
  cPlayerHalfSize      = 32.0;
  cPlayerFrameFPS      = 12;
  cPlayerNeutralFrame  = 0;
  cPlayerFirstFrame    = 1;
  cPlayerLastFrame     = 3;
  cPlayerTurnAccel     = 300;
  //cPlayerTurnAccel     = 1.0;
  cPlayerMaxTurn       = 150;
  cPlayerTurnDrag      = 150;

  // scene
  cSceneBkgrnd         = 0;
  cSceneRocks          = 1;
  cSceneRockExp        = 2;
  cSceneEnemyWeapon    = 3;
  cSceneEnemy          = 4;
  cSceneEnemyExp       = 5;
  cScenePlayerWeapon   = 6;
  cScenePlayer         = 7;
  cScenePlayerExp      = 8;
  cSceneCount          = 9;

  // sound effects
  cSfxRockExp          = 0;
  cSfxPlayerExp        = 1;
  cSfxEnemyExp         = 2;
  cSfxPlayerEngine     = 3;
  cSfxPlayerWeapon     = 4;

  // volume
  cVolPlayerEngine     = 0.40;
  cVolPlayerWeapon     = 0.30;
  cVolRockExp          = 0.25;
  cVolSong             = 0.55;

  // rocks
  cRocksMin            = 7;
  cRocksMax            = 21;

type

  { TSpriteID }
  TSpriteID = record
    Page : Integer;
    Group: Integer;
  end;
  PSpriteID = ^TSpriteID;

  { TRockSize }
  TRockSize = (
    rsLarge, rsMedium, rsSmall
  );

  { TEntity }
  TBaseEntity = class(TViActorEntity)
  protected
    FTest: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure WrapPosAtEdge(var aPos: TViVector);
  end;

  { TWeapon }
  TWeapon = class(TBaseEntity)
  protected
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnCollide(aActor: TViActor; aHitPos: TViVector); override;
    procedure Spawn(aId: Integer; aPos: TViVector; aAngle, aSpeed: Single);
  end;

  { TExplosion }
  TExplosion = class(TBaseEntity)
  protected
    FSpeed: Single;
    FCurDir: TViVector;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aElapsedTime: Single); override;
    procedure Spawn(aPos: TViVector; aDir: TViVector; aSpeed, aScale: Single);
  end;

  { TParticle }
  TParticle = class(TBaseEntity)
  protected
    FSpeed: Single;
    FFadeSpeed: Single;
    FAlpha: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure Spawn(aId: Integer; aPos: TViVector; aAngle, aSpeed,
      aScale, aFadeSpeed: Single; aScene: Integer);
  end;

  { TRock }
  TRock = class(TBaseEntity)
  protected
    FCurDir: TViVector;
    FSpeed: Single;
    FRotSpeed: Single;
    FSize: TRockSize;
    function CalcScale(aSize: TRockSize): Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnCollide(aActor: TViActor; aHitPos: TViVector); override;
    procedure Spawn(aId: Integer; aSize: TRockSize; aPos: TViVector; aAngle: Single);
    procedure Split(aHitPos: TViVector);
  end;

  { TPlayer }
  TPlayer = class(TBaseEntity)
  protected
    FTimer    : Single;
    FCurFrame : Integer;
    FThrusting: Boolean;
    FCurAngle : Single;
    FTurnSpeed: Single;
  public
    DirVec    : TViVector;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure Spawn(aX, aY: Single);
    procedure FireWeapon(aSpeed: Single);
  end;


  { TAstroBlasterDemo }
  TAstroBlasterDemo = class(TCustomDemo)
  protected
    FBkPos: TViVector;
    FBkColor: TViColor;
    FMusic: TViAudioStream;
  public
    Sfx: array[0..7] of TViAudioSample;
    Background : array[0..3] of TViBitmap;
    PlayerSprID: TSpriteID;
    EnemySprID: TSpriteID;
    RocksSprID: TSpriteID;
    ShieldsSprID: TSpriteID;
    WeaponSprID: TSpriteID;
    ExplosionSprID: TSpriteID;
    ParticlesSprID: TSpriteID;
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
    procedure OnRenderGUI; override;
    procedure OnBeforeRenderScene(aSceneNum: Integer); override;
    procedure OnAfterRenderScene(aSceneNum: Integer); override;
    procedure SpawnRocks;
    procedure SpawnPlayer;
    procedure SpawnLevel;
    function  LevelCleared: Boolean;
  end;

implementation

uses
  System.SysUtils;

var
  Player: TPlayer;
  Game: TAstroBlasterDemo;

  // channel
  cChanPlayerEngine: TViAudioSampleId;
  cChanPlayerWeapon: TViAudioSampleId;

{ --- Routines -------------------------------------------------------------- }
function RandomRangedslNP(aMin, aMax: Single): Single;
begin
  Result := ViEngine.Math.RandomRange(aMin, aMax);
  if ViEngine.Math.RandomBool then Result := -Result;
end;

function RangeRangeIntNP(aMin, aMax: Integer): Integer;
begin
  Result := ViEngine.Math.RandomRange(aMin, aMax);
  if ViEngine.Math.RandomBool then Result := -Result;
end;

{ --- TBaseEntity ----------------------------------------------------------- }
constructor TBaseEntity.Create;
begin
  inherited;
  CanCollide := True;
end;

destructor TBaseEntity.Destroy;
begin
  inherited;
end;

procedure  TBaseEntity.WrapPosAtEdge(var aPos: TViVector);
var
  hh,hw: Single;
begin
  hw := Entity.GetWidth / 2;
  hh := Entity.GetHeight /2 ;

  if (aPos.X > (cDisplayWidth-1)+hw) then
    aPos.X := -hw
  else if (aPos.X < -hw) then
    aPos.X := (cDisplayWidth-1)+hw;

  if (aPos.Y > (cDisplayHeight-1)+hh) then
    aPos.Y := -hh
  else if (aPos.Y < -hw) then
    aPos.Y := (cDisplayHeight-1)+hh;
end;

{ --- TWeapon ---------------------------------------------------------------- }
constructor TWeapon.Create;
begin
  inherited;
  Entity.Init(Game.Sprite, Game.WeaponSprId.Group);
  Entity.TracePolyPoint(6, 12, 70);
end;

destructor TWeapon.Destroy;
begin
  inherited;
end;

procedure TWeapon.OnRender;
begin
  inherited;
end;

procedure TWeapon.OnUpdate(aDelta: Single);
begin
  inherited;
  if Entity.IsVisible(0,0) then
    begin
      Entity.Thrust(FSpeed*aDelta);
      Game.Scene[cSceneRocks].CheckCollision([], Self);
    end
  else
    Terminated := True;
end;

procedure TWeapon.OnCollide(aActor: TViActor; aHitPos: TViVector);
begin
  CanCollide := False;
  Terminated := True;
end;

procedure  TWeapon.Spawn(aId: Integer; aPos: TViVector; aAngle, aSpeed: Single);
begin
  FSpeed := aSpeed;
  Entity.SetFrame(aId);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Entity.RotateAbs(aAngle);
end;

{ --- TExplosion ------------------------------------------------------------ }
constructor TExplosion.Create;
begin
  inherited;
  FSpeed := 0;
  FCurDir.X := 0;
  FCurDir.Y := 0;
end;

destructor TExplosion.Destroy;
begin
  inherited;
end;

procedure TExplosion.OnRender;
begin
  inherited;
end;

procedure TExplosion.OnUpdate(aElapsedTime: Single);
var
  P,V: TViVector;
begin
  if Entity.NextFrame then
  begin
    Terminated := True;
  end;

  V.X := (FCurDir.X + FSpeed) * aElapsedTime;
  V.Y := (FCurDir.Y + FSpeed) * aElapsedTime;

  P.X := Entity.GetPos.X + V.X;
  P.Y := Entity.GetPos.Y + V.Y;

  Entity.SetPosAbs(P.X, P.Y);
end;

procedure TExplosion.Spawn(aPos: TViVector; aDir: TViVector; aSpeed, aScale: Single);
begin
  FSpeed := aSpeed;
  FCurDir := aDir;
  Entity.Init(Game.Sprite, Game.ExplosionSprID.Group);
  Entity.SetFrameFPS(14);
  Entity.SetScaleAbs(aScale);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Game.Scene[cSceneRockExp].Add(Self);
end;

{ --- TParticle ------------------------------------------------------------ }
constructor TParticle.Create;
begin
  inherited;
end;

destructor TParticle.Destroy;
begin
  inherited;
end;

procedure TParticle.OnRender;
begin
  inherited;
end;

procedure TParticle.OnUpdate(aDelta: Single);
var
  C,C2: TViColor;
  A: Single;
begin
  Entity.Thrust(FSpeed*aDelta);

  if Entity.IsVisible(0, 0) then
    begin
      FAlpha := FAlpha - (FFadeSpeed * aDelta);
      if FAlpha <= 0 then
      begin
        FAlpha := 0;
        Terminated := True;
      end;
      A := FAlpha / 255.0;
      //C := Engine.Color.Fade(WHITE, BLACK, A);
      c2.Red := 1*a; c2.Green := 1*a; c2.Blue := 1*a; c2.Alpha := a;
      C := ViColorMake(c2.Red, c2.Green, c2.Blue, c2.Alpha);
      Entity.SetColor(C);
    end
  else
    Terminated := True;
end;

procedure TParticle.Spawn(aId: Integer; aPos: TViVector; aAngle, aSpeed,
  aScale, aFadeSpeed: Single; aScene: Integer);
begin
  FSpeed := aSpeed;
  FFadeSpeed := aFadeSpeed;
  FAlpha := 255;
  Entity.Init(Game.Sprite, Game.ParticlesSprID.Group);
  Entity.SetFrame(aId);
  Entity.SetScaleAbs(aScale);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Entity.RotateAbs(aAngle);
  Game.Scene[aScene].Add(Self);
end;

{ --- TRock ----------------------------------------------------------------- }
function TRock.CalcScale(aSize: TRockSize): Single;
begin
  case aSize of
    rsLarge: Result := 1.0;
    rsMedium: Result := 0.65;
    rsSmall: Result := 0.45;
  else
    Result := 1.0;
  end;
end;

constructor TRock.Create;
begin
  inherited;
  FSpeed := 0;
  FRotSpeed := 0;
  FSize := rsLarge;
  Entity.Init(Game.Sprite, Game.RocksSprId.Group);
  Entity.TracePolyPoint(6, 12, 70);
end;

destructor TRock.Destroy;
begin
  inherited;
end;

procedure TRock.OnRender;
begin
  inherited;
end;

procedure TRock.OnUpdate(aDelta: Single);
var
  P: TViVector;
  V: TViVector;
begin
  inherited;
  Entity.RotateRel(FRotSpeed*aDelta);
  V.X := (FCurDir.X + FSpeed);
  V.Y := (FCurDir.Y + FSpeed);
  P.X := Entity.GetPos.X + V.X*aDelta;
  P.Y := Entity.GetPos.Y + V.Y*aDelta;
  WrapPosAtEdge(P);
  Entity.SetPosAbs(P.X, P.Y);
end;

procedure TRock.OnCollide(aActor: TViActor; aHitPos: TViVector);
begin
  CanCollide := False;
  Split(aHitPos);
end;


procedure TRock.Spawn(aId: Integer; aSize: TRockSize; aPos: TViVector; aAngle: Single);
begin
  FSpeed := RandomRangedslNP(0.2*cMultiplier, 2*cMultiplier);
  FRotSpeed := RandomRangedslNP(0.2*cMultiplier, 2*cMultiplier);

  FSize := aSize;
  Entity.SetFrame(aId);
  Entity.SetPosAbs(aPos.X, aPos.Y);
  Entity.RotateAbs(ViEngine.Math.RandomRange(0, 259));
  Entity.Thrust(1);
  FCurDir.X := Entity.GetDir.X;
  FCurDir.Y := Entity.GetDir.Y;
  FCurDir.Normalize;
  Entity.SetScaleAbs(CalcScale(FSize));
end;

procedure TRock.Split(aHitPos: TViVector);

  procedure DoSplit(aId: Integer; aSize: TRockSize; aPos: TViVector);
  var
    r: TRock;
  begin
    r := TRock.Create;
    r.Spawn(aId, aSize, aPos, 0);
    Game.Scene[cSceneRocks].Add(r);
  end;

  procedure DoExplosion(aScale: Single);
  var
    p: TViVector;
    e: TExplosion;
  begin
    p := Entity.GetPos;
    e := TExplosion.Create;
    e.Spawn(p, FCurDir, FSpeed, aScale);
  end;

  procedure DoParticles;
  var
    c,i: Integer;
    p: TParticle;
    angle,speed,fade: Single;
  begin
    c := 0;
    case FSize of
      rsLarge : c := 50;
      rsMedium: c := 25;
      rsSmall : c := 15;
    end;

    for i := 1 to c do
    begin
      p := TParticle.Create;
      angle := ViEngine.Math.RandomRange(0, 255);
      speed := ViEngine.Math.RandomRange(1*cMultiplier, 7*cMultiplier);
      fade := ViEngine.Math.RandomRange(3*cMultiplier, 7*cMultiplier);

      p.Spawn(0, aHitPos, angle, speed, 0.10, fade, cSceneRockExp);
    end;
  end;

begin
  case FSize of
    rsLarge:
      begin
        DoSplit(Entity.GetFrame, rsMedium, Entity.GetPos);
        DoSplit(Entity.GetFrame, rsMedium, Entity.GetPos);
        DoExplosion(3.0);
        DoParticles;
        Game.Sfx[cSfxRockExp].Play(cVolRockExp, AUDIO_PAN_NONE, 1, False, nil);
      end;

    rsMedium:
      begin
        DoSplit(Entity.GetFrame, rsSmall, Entity.GetPos);
        DoSplit(Entity.GetFrame, rsSmall, Entity.GetPos);
        DoExplosion(2.5);
        DoParticles;
        Game.Sfx[cSfxRockExp].Play(cVolRockExp, AUDIO_PAN_NONE, 1, False, nil);
      end;

    rsSmall:
      begin
        DoExplosion(1.5);
        DoParticles;
        Game.Sfx[cSfxRockExp].Play(cVolRockExp, AUDIO_PAN_NONE, 1, False, nil);
      end;
  end;
  Terminated := True;
end;

{ --- TPlayer ---------------------------------------------------------------- }
constructor TPlayer.Create;
begin
  Player := Self;
  inherited;

  FTimer    := 0;
  FCurFrame := 0;
  FThrusting:= False;
  FCurAngle := 0;
  DirVec.Clear;
  FTurnSpeed := 0;

  Entity.Init(Game.Sprite, Game.PlayerSprID.Group);

  Entity.TracePolyPoint(6, 12, 70);

  Entity.SetPosAbs(cDisplayWidth /2, cDisplayHeight /2);
end;

destructor TPlayer.Destroy;
begin
  inherited;
  Player := nil;
end;

procedure TPlayer.OnRender;
begin
  inherited;
end;

procedure TPlayer.OnUpdate(aDelta: Single);
var
  P: TViVector;
  Fire: Boolean;
  Turn: Integer;
  Accel: Boolean;
begin
  if ViEngine.Input.KeyboardPressed(KEY_LCTRL) or
     ViEngine.Input.KeyboardPressed(KEY_RCTRL) or
     ViEngine.Input.JoystickPressed(JOY_BTN_RB) then
    Fire := True
  else
    Fire := False;

  if ViEngine.Input.KeyboardDown(KEY_RIGHT) or
     ViEngine.Input.JoystickDown(JOY_BTN_RDPAD) then
    Turn := 1
  else
  if ViEngine.Input.KeyboardDown(KEY_LEFT) or
     ViEngine.Input.JoystickDown(JOY_BTN_LDPAD) then
    Turn := -1
  else
    Turn := 0;

  if (ViEngine.Input.KeyboardDown(KEY_UP)) or
     ViEngine.Input.JoystickDown(JOY_BTN_UDPAD) then
    Accel := true
  else
    Accel := False;


  // update keys
  if Fire then
  begin
    FireWeapon(10*cMultiplier);
  end;

  if Turn = 1 then
  begin
    ViSmoothMove(FTurnSpeed, cPlayerTurnAccel*aDelta, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
  end
  else if Turn = -1 then
    begin
      ViSmoothMove(FTurnSpeed, -cPlayerTurnAccel*aDelta, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
    end
  else
    begin
      ViSmoothMove(FTurnSpeed, 0, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
    end;

  FCurAngle := FCurAngle + FTurnSpeed*aDelta;
  if FCurAngle > 360 then
    FCurAngle := FCurAngle - 360
  else if FCurAngle < 0 then
    FCurAngle := FCurAngle + 360;

  FThrusting := False;
  if (Accel) then
  begin
    FThrusting := True;

    if (DirVec.Magnitude < cPlayerMagnitude) then
    begin
      DirVec.Trust(FCurAngle, cPlayerAccel*aDelta);
    end;

    if not ViEngine.Audio.SamplePlaying(cChanPlayerEngine) then
    begin
      Game.Sfx[cSfxPlayerEngine].Play(cVolPlayerEngine, AUDIO_PAN_NONE, 1,
        True, @cChanPlayerEngine);
    end;

  end;

  ViSmoothMove(DirVec.X, 0, cPlayerMagnitude, cPlayerFriction*aDelta);
  ViSmoothMove(DirVec.Y, 0, cPlayerMagnitude, cPlayerFriction*aDelta);

  P.X := Entity.GetPos.X + DirVec.X*aDelta;
  P.Y := Entity.GetPos.Y + DirVec.Y*aDelta;

  WrapPosAtEdge(P);

  if (FThrusting) then
    begin
      if (ViEngine.FrameSpeed(FTimer, cPlayerFrameFPS)) then
      begin
        FCurFrame := FCurFrame + 1;
        if (FCurFrame > cPlayerLastFrame) then
        begin
          FCurFrame := cPlayerFirstFrame;
        end
      end;

    end
  else
    begin
      FCurFrame := cPlayerNeutralFrame;

      if ViEngine.Audio.SamplePlaying(cChanPlayerEngine) then
      begin
        ViEngine.Audio.SampleStop(cChanPlayerEngine);
      end;
    end;

  Entity.RotateAbs(FCurAngle);
  Entity.SetFrame(FCurFrame);
  Entity.SetPosAbs(P.X, P.Y);
end;

procedure TPlayer.Spawn(aX, aY: Single);
begin
end;

procedure TPlayer.FireWeapon(aSpeed: Single);
var
  P: TViVector;
  W: TWeapon;
begin
  P.X := Entity.GetPos.X;
  P.Y := Entity.GetPos.Y;
  P.Trust(Entity.GetAngle, 16);
  W := TWeapon.Create;
  W.Spawn(0, P, Entity.GetAngle, aSpeed);
  Game.Scene[cScenePlayerWeapon].Add(W);
  Game.Sfx[cSfxPlayerWeapon].Play(cVolPlayerWeapon, AUDIO_PAN_NONE, 1, False,
    @cChanPlayerWeapon);
end;

{ --- TAstroBlasterDemo ----------------------------------------------------- }
constructor TAstroBlasterDemo.Create;
begin
  inherited;
  Game := Self;
end;

destructor TAstroBlasterDemo.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TAstroBlasterDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TAstroBlasterDemo.OnExit;
begin
  inherited;
end;

procedure TAstroBlasterDemo.OnStartup;
begin
  inherited;

  // init background
  FBkColor := ViColorMake(255,255,255,128);

  Background[0] := TViBitmap.Create;
  Background[1] := TViBitmap.Create;
  Background[2] := TViBitmap.Create;
  Background[3] := TViBitmap.Create;

  Background[0].Load('arc/bitmaps/backgrounds/space.png',  @BLACK);
  Background[1].Load('arc/bitmaps/backgrounds/nebula.png', @BLACK);
  Background[2].Load('arc/bitmaps/backgrounds/spacelayer1.png', @BLACK);
  Background[3].Load('arc/bitmaps/backgrounds/spacelayer2.png', @BLACK);

    // init player sprites
  PlayerSprID.Page := Game.Sprite.LoadPage('arc/bitmaps/sprites/ship.png', nil);
  PlayerSprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 0, 0, 64, 64);
  Game.Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 1, 0, 64, 64);
  Game.Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 2, 0, 64, 64);
  Game.Sprite.AddImageFromGrid(PlayerSprID.Page, PlayerSprID.Group, 3, 0, 64, 64);


  // init enemy sprites
  EnemySprID.Page := PlayerSprID.Page;
  EnemySprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(EnemySprID.Page, EnemySprID.Group, 0, 1, 64, 64);
  Game.Sprite.AddImageFromGrid(EnemySprID.Page, EnemySprID.Group, 1, 1, 64, 64);
  Game.Sprite.AddImageFromGrid(EnemySprID.Page, EnemySprID.Group, 2, 1, 64, 64);

  // init shield sprites
  ShieldsSprID.Page := PlayerSprID.Page;
  ShieldsSprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(ShieldsSprID.Page, ShieldsSprID.Group, 0, 4, 32, 32);
  Game.Sprite.AddImageFromGrid(ShieldsSprID.Page, ShieldsSprID.Group, 1, 4, 32, 32);
  Game.Sprite.AddImageFromGrid(ShieldsSprID.Page, ShieldsSprID.Group, 2, 4, 32, 32);

  // init wepason sprites
  WeaponSprID.Page := PlayerSprID.Page;
  WeaponSprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(WeaponSprID.Page, WeaponSprID.Group, 3, 4, 32, 32);
  Game.Sprite.AddImageFromGrid(WeaponSprID.Page, WeaponSprID.Group, 4, 4, 32, 32);
  Game.Sprite.AddImageFromGrid(WeaponSprID.Page, WeaponSprID.Group, 5, 4, 32, 32);

  // init rock sprites
  RocksSprID.Page := Game.Sprite.LoadPage('arc/bitmaps/sprites/rocks.png', nil);
  RocksSprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(RocksSprID.Page, RocksSprID.Group, 0, 0, 128, 128);
  Game.Sprite.AddImageFromGrid(RocksSprID.Page, RocksSprID.Group, 1, 0, 128, 128);
  Game.Sprite.AddImageFromGrid(RocksSprID.Page, RocksSprID.Group, 0, 1, 128, 128);


  // init explosion sprites
  ExplosionSprID.Page := Game.Sprite.LoadPage('arc/bitmaps/sprites/explosion.png', nil);
  ExplosionSprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 0, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 0, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 0, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 0, 64, 64);

  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 1, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 1, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 1, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 1, 64, 64);

  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 2, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 2, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 2, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 2, 64, 64);

  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 0, 3, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 1, 3, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 2, 3, 64, 64);
  Game.Sprite.AddImageFromGrid(ExplosionSprID.Page, ExplosionSprID.Group, 3, 3, 64, 64);

  // init particles
  ParticlesSprID.Page := Game.Sprite.LoadPage('arc/bitmaps/sprites/particles.png', nil);
  ParticlesSprID.Group := Game.Sprite.AddGroup;
  Game.Sprite.AddImageFromGrid(ParticlesSprID.Page, ParticlesSprID.Group, 0, 0, 64, 64);

  //Engine.Audio.ChannelSetReserved(0, True);
  //Engine.Audio.ChannelSetReserved(1, True);

  // init sfx
  Sfx[cSfxRockExp] := TViAudioSample.Create;
  Sfx[cSfxPlayerExp] := TViAudioSample.Create;
  Sfx[cSfxEnemyExp] := TViAudioSample.Create;
  Sfx[cSfxPlayerEngine] := TViAudioSample.Create;
  Sfx[cSfxPlayerWeapon] := TViAudioSample.Create;


  Sfx[cSfxRockExp].Load('arc/audio/sfx/explo_rock.ogg');
  Sfx[cSfxPlayerExp].Load('arc/audio/sfx//explo_player.ogg');
  Sfx[cSfxEnemyExp].Load('arc/audio/sfx//explo_enemy.ogg');
  Sfx[cSfxPlayerEngine].Load('arc/audio/sfx//engine_player.ogg');
  Sfx[cSfxPlayerWeapon].Load('arc/audio/sfx//weapon_player.ogg');

  FMusic := TViAudioStream.Create;
  FMusic.Load('arc/audio/music/song13.ogg');
  FMusic.Play(True, 1.0);

  // init scene
  Scene.Alloc(cSceneCount);

  SpawnLevel;
end;

procedure TAstroBlasterDemo.OnShutdown;
begin
  Scene.ClearAll;

  FreeAndNil(FMusic);

  FreeAndNil(Sfx[cSfxRockExp]);
  FreeAndNil(Sfx[cSfxPlayerExp]);
  FreeAndNil(Sfx[cSfxEnemyExp]);
  FreeAndNil(Sfx[cSfxPlayerEngine]);
  FreeAndNil(Sfx[cSfxPlayerWeapon]);

  FreeAndNil(Background[3]);
  FreeAndNil(Background[2]);
  FreeAndNil(Background[1]);
  FreeAndNil(Background[0]);

  inherited;
end;

procedure TAstroBlasterDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
var
  P: TViVector;
begin
  inherited;

  if Assigned(Player) then
  begin
    P := Player.DirVec;
    FBkPos.X := FBkPos.X + (P.X * aDeltaTime);
    FBkPos.Y := FBkPos.Y + (P.Y * aDeltaTime);
  end;

  if LevelCleared then
  begin
    SpawnLevel;
  end;

  Scene.Update([], aDeltaTime);

end;

procedure TAstroBlasterDemo.OnClearDisplay;
begin
  ViEngine.Display.Clear(BLACK);
end;

procedure TAstroBlasterDemo.OnShowDisplay;
begin
  inherited;
end;

const
  bm = 3;

procedure TAstroBlasterDemo.OnRender;
begin
  // render background
  Background[0].DrawTiled(-(FBkPos.X/1.9*bm), -(FBkPos.Y/1.9*bm));
  Background[1].DrawTiled(-(FBkPos.X/1.9*bm), -(FBkPos.Y/1.9*bm));
  Background[2].DrawTiled(-(FBkPos.X/1.6*bm), -(FBkPos.Y/1.6*bm));
  Background[3].DrawTiled(-(FBkPos.X/1.3*bm), -(FBkPos.Y/1.3*bm));

  FScene.Render([], OnBeforeRenderScene, OnAfterRenderScene);

  inherited;
end;

procedure TAstroBlasterDemo.OnRenderGUI;
begin
  inherited;

  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'Left        - Rotate Left', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'Right       - Rotate Right', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'Up          - Trust', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'Ctrl        - Fire', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'Count: %d', [Scene[cSceneRocks].Count]);

end;

procedure TAstroBlasterDemo.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    cSceneRockExp:
    begin
      ViEngine.Display.SetBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
      ViEngine.Display.SetBlendMode(bmAdditiveAlpha);
    end;
  end;
end;

procedure TAstroBlasterDemo.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    cSceneRockExp:
    begin
      ViEngine.Display.RestoreDefaultBlendMode;
    end;
  end;
end;

procedure TAstroBlasterDemo.SpawnRocks;
var
  i,c: Integer;
  id: Integer;
  size: TRockSize;
  angle: Single;
  rock: TRock;
  radius : Single;
  pos: TViVector;
begin

  c := ViEngine.Math.RandomRange(cRocksMin, cRocksMax);

  for i := 1 to c do
  begin
    id := ViEngine.Math.RandomRange(0, 2);
    size := TRockSize(ViEngine.Math.RandomRange(0, 2));
    pos.x := cDisplayWidth / 2;
    pos.y := cDisplayHeight /2;
    radius := (pos.x + pos.y) / 2;
    angle := ViEngine.Math.RandomRange(0, 359);
    pos.Trust(angle, radius);
    rock := TRock.Create;
    rock.Spawn(id, size, pos, angle);
    Game.Scene[cSceneRocks].Add(rock);
  end;
end;

procedure TAstroBlasterDemo.SpawnPlayer;
begin
  Scene.Lists[cScenePlayer].Add(TPlayer.Create);
end;

procedure TAstroBlasterDemo.SpawnLevel;
begin
  Scene.ClearAll;
  SpawnRocks;
  SpawnPlayer;
end;

function TAstroBlasterDemo.LevelCleared: Boolean;
begin
  if (Scene[cSceneRocks].Count        > 0) or
     (Scene[cSceneRockExp].Count      > 0) or
     (Scene[cScenePlayerWeapon].Count > 0) then
    Result := False
  else
    Result := True;
end;

end.

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

unit uViewports;

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
  Vivace.Viewport,
  Vivace.Polygon,
  Vivace.Bitmap,
  Vivace.Starfield,
  Vivace.Audio,
  Vivace.Sprite,
  uCommon;

const
  cDisplayTitle  = 'Vivace: Viewports Demo';

  GRAVITY        = 0.4;
  XDECAY         = 0.97;
  YDECAY         = 0.97;
  ELASTICITY     = 0.77;
  WALLDECAY      = 1.0;
  BALL_SIZE      = 30;
  BALL_SIZE_HALF = BALL_SIZE div 2;

type

{ TViewportWindow }
  TViewportWindow = record
    w,h: Integer;
    x,y,sx,sy: Single;
    minx,maxx: Single;
    miny,maxy: Single;
    color: TViColor;
  end;

  { TViewport }
  TViewport = class(TViActor)
  protected
    FHandle: TViViewport;
    FSize : TViVector;
    FPos  : TViVector;
    FSpeed: TViVector;
    FRange: TViRange;
    FColor: TViColor;
    FCaption: string;
  public
    property Caption: string read FCaption write FCaption;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
    procedure PrintCaption(aColor: TViColor);
  end;

  { TViewport1 }
  TViewport1 = class(TViewport)
  protected
    FPolygon: TViPolygon;
    FOrigin : TViVector;
    FAngle  : Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
  end;

  { TViewport2 }
  TViewport2 = class(TViewport)
  protected
    FBallPos: TViVector;
    FBallSpeed: TViVector;
    FTimer: Single;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
  end;

  { TViewport3 }
  TViewport3 = class(TViewport)
  protected
    FTileTexture: TViBitmap;
    FTilePos: TViVector;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
  end;

  { TViewport4 }
  TViewport4 = class(TViewport)
  protected
    FStarfield: TViStarfield;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure OnUpdate(aDelta: Single); override;
    procedure OnRender; override;
  end;

  { TViewportsDemo }
  TViewportsDemo = class(TCustomDemo)
  protected
    FMusic: TViAudioStream;
  public
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
  end;

implementation

uses
  System.SysUtils;

var
  Game: TViewportsDemo = nil;

{ --- TViewport ------------------------------------------------------------- }
constructor TViewport.Create;
begin
  inherited;
  FPos.X := 10;
  FPos.Y := 10;
  FSize.X := 50;
  FSize.Y := 50;
  FRange.miny := 0;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;
  FSpeed.x := ViEngine.Math.RandomRange(0.1*60,0.3*60);
  FSpeed.y := ViEngine.Math.RandomRange(0.1*60,0.3*60);

  FColor := WHITE;
  FCaption := 'A Viewport';

  FHandle := TViViewport.Create;
end;

destructor TViewport.Destroy;
begin
  FreeAndNil(FHandle);
  inherited;
end;

procedure TViewport.OnUpdate(aDelta: Single);
begin
  // update horizontal movement
  FPos.x := FPos.x + (FSpeed.x * aDelta);
  if (FPos.x < FRange.MinX) then
    begin
      FPos.x  := FRange.Minx;
      FSpeed.x := -FSpeed.x;
    end
  else if (FPos.x > FRange.Maxx) then
    begin
      FPos.x  := FRange.Maxx;
      FSpeed.x := -FSpeed.x;
    end;

  // update horizontal movement
  FPos.y := FPos.y + (FSpeed.y * aDelta);
  if (FPos.y < FRange.Miny) then
    begin
      FPos.y  := FRange.Miny;
      FSpeed.y := -FSpeed.y;
    end
  else if (FPos.y > FRange.Maxy) then
    begin
      FPos.y  := FRange.Maxy;
      FSpeed.y := -FSpeed.y;
    end;

  FHandle.SetPosition(Round(FPos.X), Round(FPos.y));
end;

procedure TViewport.OnRender;
begin
  ViEngine.Display.SetViewport(FHandle);
  ViEngine.Display.Clear(FColor);
end;

procedure TViewport.PrintCaption(aColor: TViColor);
begin
  Game.ConsoleFont.Print(3, 3, aColor, alLeft, FCaption, []);
end;


{ --- TViewport1 ------------------------------------------------------------ }
constructor TViewport1.Create;
begin
  inherited;

  Caption := 'Viewport #1';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 10;
  FPos.y := 10;

  FRange.miny := 0;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := LIGHTGRAY;

  FHandle.Init(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  // init polygon
  FPolygon := TViPolygon.Create;
  FPolygon.AddLocalPoint(0, 0, True);
  FPolygon.AddLocalPoint(128, 0, True);
  FPolygon.AddLocalPoint(128, 128, True);
  FPolygon.AddLocalPoint(0, 128, True);
  FPolygon.AddLocalPoint(0, 0, True);

  // you can either use local coords such as -64, -64, 64, 64 etc and when
  // transformed it will be center or easier just use specify an origin. In this
  // case this polygon span is 128 so set the origin xy to 64 to center it on
  // screen.
  FOrigin.X := 64;
  FOrigin.Y := 64;
end;

destructor TViewport1.Destroy;
begin
  FreeAndNil(FPolygon);
  inherited;
end;

procedure TViewport1.OnUpdate(aDelta: Single);
begin
  inherited;
  // update angle by DeltaTime to keep it constant. In this case the default
  // fps is 30 so we are in effect adding on degree every second.
  FAngle := FAngle + (30.0 * aDelta);

  // just clip between 0 and 360 with wrapping. if greater than max value, it
  // will set min to value-max.
  ViEngine.Math.ClipValue(FAngle, 0, 360, True);
end;

procedure TViewport1.OnRender;
begin
  inherited;
  // render polygon in center of screen
  //Polygon_Render(FPolygon, Round(FSize.X / 2), Round(FSize.Y / 2), 1, FAngle, 1, YELLOW, FLIP_NONE, @FOrigin);
  FPolygon.Render(FSize.X / 2, FSize.Y / 2, 1, FAngle, 1, YELLOW, @FOrigin, False, False);
  PrintCaption(BLACK);

  //FHandle.SetActive(False);
  ViEngine.Display.SetViewport(nil);
end;

{ --- TViewport2 ------------------------------------------------------------ }
constructor TViewport2.Create;
begin
  inherited;

  Caption := 'Viewport #2';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 410;
  FPos.y := 10;

  FRange.miny := 0;
  FRange.minx := 400-10;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := ViColorMake(77, 157, 251, 255);

  FHandle.Init(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  FBallPos.x := ViEngine.Math.RandomRange(BALL_SIZE_HALF, FSize.x-BALL_SIZE_HALF);
  FBallPos.y := BALL_SIZE_HALF;

  FBallSpeed.x := ViEngine.Math.RandomRange(-50,50);
  FBallSpeed.y := ViEngine.Math.RandomRange(3,7);
  FTimer := 0;
end;

destructor TViewport2.Destroy;
begin
  inherited;
end;

procedure TViewport2.OnUpdate(aDelta: Single);
begin
  inherited;

  if not ViEngine.FrameSpeed(FTimer, 60) then
    Exit;

  if ViEngine.Math.SameValue(FBallSpeed.x, 0, 0.001) then
  begin
    FBallPos.x := ViEngine.Math.RandomRange(BALL_SIZE_HALF, FSize.x-BALL_SIZE_HALF);
    FBallPos.y := BALL_SIZE_HALF;
    FBallSpeed.x := ViEngine.Math.RandomRange(-50,50);
    FBallSpeed.y := ViEngine.Math.RandomRange(3,7);
  end;

  // decay
  FBallSpeed.x := FBallSpeed.x * XDECAY;
  FBallSpeed.y := FBallSpeed.y * XDECAY;

  // gravity
  FBallSpeed.y := FBallSpeed.y + GRAVITY;

  // move
  FBallPos.x := FBallPos.x + FBallSpeed.x;
  FBallPos.y := FBallPos.y + FBallSpeed.y;

  if (FBallPos.x < BALL_SIZE) then
    begin
      FBallPos.x  := BALL_SIZE;
      FBallSpeed.x := -FBallSpeed.x * WALLDECAY;
    end;
  //else
  if (FBallPos.x > FSize.x-BALL_SIZE) then
    begin
      FBallPos.x  := FSize.x-BALL_SIZE;
      FBallSpeed.x := -FBallSpeed.x * WALLDECAY;
    end;

  // update horizontal movement

  if (FBallPos.y < BALL_SIZE) then
    begin
      FBallPos.y  := BALL_SIZE;
      FBallSpeed.y := -FBallSpeed.y * WALLDECAY;
    end;
  //else
  if (FBallPos.y > FSize.y-BALL_SIZE) then
    begin
      FBallPos.y  := FSize.y-BALL_SIZE;
      FBallSpeed.y := -FBallSpeed.y * WALLDECAY;
    end;
end;

procedure TViewport2.OnRender;
var
  s: string;
begin
  inherited;

  ViEngine.Display.DrawFilledCircle(FBallPos.X, FBallPos.Y, BALL_SIZE, RED);

  PrintCaption(YELLOW);

  s := Format('x,y: %f,%f',[Abs(FBallSpeed.x),Abs(FBallSpeed.y)]);
  Game.ConsoleFont.Print(1, 15, WHITE, alLeft, s, []);

  //FHandle.SetActive(False);
  ViEngine.Display.SetViewport(nil);
end;

{ --- TViewport3 ------------------------------------------------------------ }
constructor TViewport3.Create;
begin
  inherited;

  Caption := 'Viewport #3';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 10;
  FPos.y := 310;

  FRange.miny := 300-10;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := BLACK;

  FHandle.Init(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  FTilePos.x := 0;
  FTilePos.y := 0;

  FTileTexture := TViBitmap.Create;
  FTileTexture.Load('arc/bitmaps/backgrounds/bluestone.png', nil);
end;

destructor TViewport3.Destroy;
begin
  FreeAndNil(FTileTexture);
  inherited;
end;

procedure TViewport3.OnUpdate(aDelta: Single);
begin
  inherited;
  FTilePos.y := FTilePos.y + ((7.0*60) * aDelta);
end;

procedure TViewport3.OnRender;
begin
  inherited;

  // tile texture across viewport
  FTileTexture.DrawTiled(FTilePos.x,FTilePos.y);

  // display the viewport caption
  PrintCaption(WHITE);

  ViEngine.Display.SetViewport(nil);
end;



{ --- TViewport4 ------------------------------------------------------------ }
constructor TViewport4.Create;
begin
  inherited;

  Caption := 'Viewport #4';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 410;
  FPos.y := 310;


  FRange.miny := 300-10;
  FRange.minx := 400-10;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := BLACK;

  FHandle.Init(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  FStarfield := TViStarfield.Create;
  FStarField.SetZSpeed(-(60*3));
end;

destructor TViewport4.Destroy;
begin
  FreeAndNil(FStarField);
  inherited;
end;

procedure TViewport4.OnUpdate(aDelta: Single);
begin
  inherited;
  FStarfield.Update(aDelta);
end;

procedure TViewport4.OnRender;
begin
  inherited;
  FStarfield.Render;
  PrintCaption(WHITE);
  ViEngine.Display.SetViewport(nil);
end;

{ --- TViewportsDemo -------------------------------------------------------- }
constructor TViewportsDemo.Create;
begin
  inherited;
  Game := Self;
end;

destructor TViewportsDemo.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TViewportsDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TViewportsDemo.OnExit;
begin
  inherited;
end;

procedure TViewportsDemo.OnStartup;
begin
  // open display
  ViEngine.Display.Open(-1, -1, cDisplayWidth, 600,
    cDisplayFullscreen, cDisplayVSync, cDisplayAntiAlias, cDisplayRenderAPI,
    FTitle);

  // create console font
  FConsoleFont := ViFontLoadConsole(12);

  // create sprite
  FSprite := TViSprite.Create;

  // create actor list
  FScene := TViActorScene.Create;

  Scene.Alloc(1);

  Scene[0].Add(TViewport1.Create);
  Scene[0].Add(TViewport2.Create);
  Scene[0].Add(TViewport3.Create);
  Scene[0].Add(TViewport4.Create);


  FMusic := TViAudioStream.Create;
  FMusic.Load('arc/audio/music/song01.ogg');
  FMusic.Play(True, 1.0)
end;

procedure TViewportsDemo.OnShutdown;
begin
  FreeAndNil(FMusic);
  inherited;
end;

procedure TViewportsDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  Scene.Update([], aDeltaTime);
end;

procedure TViewportsDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TViewportsDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TViewportsDemo.OnRender;
begin
  inherited;

  Scene.Render([], nil, nil);
end;

procedure TViewportsDemo.OnRenderGUI;
begin
  inherited;
end;

end.

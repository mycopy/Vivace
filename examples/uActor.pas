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

unit uActor;

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
  uCommon;

const
  cDisplayTitle = 'Vivace: Actor Demo';

  cActorWidth  = 100;
  cActorHeight = 100;

type

  { TActor }
  TActor = class(TViActor)
  protected
    FPos: TViVector;
    FRange: TViRange;
    FSpeed: TViVector;
    FColor: TViColor;
    FSize: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Single); override;
    procedure OnRender; override;
  end;

  { TActorDemo }
  TActorDemo = class(TCustomDemo)
  public
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double); override;
    procedure OnClearDisplay; override;
    procedure OnShowDisplay; override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure Spawn;
  end;

implementation

uses
  System.SysUtils;

{ --- TActor ---------------------------------------------------------------- }
constructor TActor.Create;
var
  Size: Integer;
  R,G,B: Byte;
begin
  inherited;
  FPos.Assign(ViEngine.Math.RandomRange(0, cDisplayWidth-1),
   ViEngine.Math.RandomRange(0, cDisplayHeight-1));
  FRange.MinX := 0;
  FRange.MinY := 0;
  FSize := ViEngine.Math.RandomRange(25, 100);
  FRange.MaxX := (cDisplayWidth-1) - FSize;
  FRange.MaxY := (cDisplayHeight-1) - FSize;
  FSpeed.x := ViEngine.Math.RandomRange(120, 120*3);
  FSpeed.y := ViEngine.Math.RandomRange(120, 120*3);
  R := ViEngine.Math.RandomRange(1, 255);
  G := ViEngine.Math.RandomRange(1, 255);
  B := ViEngine.Math.RandomRange(1, 255);
  FColor := ViColorMake(R,G,B,255);
end;

destructor TActor.Destroy;
begin
  inherited;
end;

procedure TActor.OnUpdate(aDeltaTime: Single);
begin
  // update horizontal movement
  FPos.x := FPos.x + (FSpeed.x * aDeltaTime);
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
  FPos.y := FPos.y + (FSpeed.y * aDeltaTime);
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
end;

procedure TActor.OnRender;
begin
  ViEngine.Display.DrawFilledRectangle(FPos.X, FPos.Y, FSize, FSize, FColor);
end;

{ --- TActorDemo ------------------------------------------------------------ }
procedure TActorDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TActorDemo.OnExit;
begin
  inherited;
end;

procedure TActorDemo.OnStartup;
begin
  inherited;

  // allocate actor scenes
  FScene.Alloc(1);

  // add actor to scene
  Spawn;
end;

procedure TActorDemo.OnShutdown;
begin
  // free actor scene
  FScene.ClearAll;

  inherited;
end;

procedure TActorDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  // spawn new actors
  if ViEngine.Input.KeyboardPressed(KEY_S) then
    Spawn;

  // update scene
  FScene.Update([], aDeltaTime);
end;

procedure TActorDemo.OnClearDisplay;
begin
  // clear display
  ViEngine.Display.Clear(BLACK);
end;

procedure TActorDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TActorDemo.OnRender;
begin
  // render scene
  FScene.Render([], nil, nil);
end;

procedure TActorDemo.OnRenderGUI;
begin
  inherited;

  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    'S   - Spawn actors', [ViEngine.FrameRate]);
  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, YELLOW, alLeft,
    'Count: %d', [FScene.Lists[0].Count]);
end;

procedure TActorDemo.Spawn;
var
  I,C: Integer;
begin
  FScene.ClearAll;
  C := ViEngine.Math.RandomRange(3, 25);
  for I := 1 to C do
    FScene.Lists[0].Add(TActor.Create);
end;

end.

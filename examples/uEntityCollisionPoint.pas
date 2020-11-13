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

unit uEntityCollisionPoint;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Input,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Engine,
  Vivace.Entity,
  uCommon;

const
  cDisplayTitle = 'Vivace: Entity Collision Point Demo';

type

  { TEntityCollisionPointDemo }
  TEntityCollisionPointDemo = class(TCustomDemo)
  protected
    FFigure: TviEntity;
    FFigureAngle: Single;
    FCollide: Boolean;
    FHitPos: TViVector;
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
  end;

implementation

uses
  System.SysUtils;

{ --- TEntityCollisionPointDemo --------------------------------------------- }
procedure TEntityCollisionPointDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TEntityCollisionPointDemo.OnExit;
begin
  inherited;
end;

procedure TEntityCollisionPointDemo.OnStartup;
begin
  inherited;

  Sprite.LoadPage('arc/bitmaps/sprites/figure.png', @COLORKEY);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 128, 128);

  FFigure := TViEntity.Create;
  FFigure.Init(Sprite, 0);
  FFigure.SetPosAbs(cDisplayWidth/2, cDisplayHeight/2);
  FFigure.TracePolyPoint(6,12,70);
  FFigure.SetRenderPolyPoint(True);
end;

procedure TEntityCollisionPointDemo.OnShutdown;
begin
  FreeAndNil(FFigure);
  inherited;
end;

procedure TEntityCollisionPointDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  FHitPos.Assign(MousePos);
  if FFigure.CollidePolyPointPoint(FHitPos) then
    FCollide := true
  else
    FCollide := False;


  FFigureAngle := FFigureAngle + (30.0 * aDeltaTime);
  ViEngine.Math.ClipValue(FFigureAngle, 0, 359, True);
  FFigure.RotateAbs(FFigureAngle);
end;

procedure TEntityCollisionPointDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TEntityCollisionPointDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TEntityCollisionPointDemo.OnRender;
var
  Pos: TViVector;
begin
  inherited;

  FFigure.Render(0,0);

  // if entities collide show hit position
  if FCollide then
  begin
    Pos := FFigure.GetPos;
    ConsoleFont.Print(Pos.X-64, Pos.Y-64, WHITE, alLeft, '(%3f,%3f)', [FHitPos.X, FHitPos.Y]);
    ViEngine.Display.DrawFilledRectangle(FHitPos.X, FHitPos.Y, 10, 10, RED);
  end;
end;

procedure TEntityCollisionPointDemo.OnRenderGUI;
begin
  inherited;
end;

end.

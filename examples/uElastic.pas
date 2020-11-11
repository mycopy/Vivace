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

unit uElastic;

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
  Vivace.Audio,
  uCommon;

const
  cDisplayTitle = 'Vivace: Elastic Demo';

  // beads
  cGravity          = 0.04;
  cXDecay           = 0.97;
  cYDecay           = 0.97;
  cBeadCount        = 10;
  cXElasticity      = 0.02;
  cYElasticity      = 0.02;
  cWallDecay        = 0.9;
  cSlackness        = 1;
  cBeadSize         = 12;
  cBedHalfSize      = cBeadSize / 2;
  cBeadFilled       = True;

type

  { TBead }
  TBead = record
    X    : Single;
    Y    : Single;
    XMove: Single;
    YMove: Single;
  end;

  { TElasticDemo }
  TElasticDemo = class(TCustomDemo)
  protected
    FViewWidth: Single;
    FViewHeight: Single;
    FBead : array[0..cBeadCount] of TBead;
    FTimer: Single;
    FMusic: TViAudioStream;
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

{ --- TElasticDemo ---------------------------------------------------------- }
procedure TElasticDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TElasticDemo.OnExit;
begin
  inherited;
end;

procedure TElasticDemo.OnStartup;
var
  vp: TViRectangle;
begin
  inherited;

  FillChar(FBead, SizeOf(FBead), 0);

  ViEngine.Display.GetViewportSize(vp);
  FViewWidth := vp.Width;
  FViewHeight := vp.Height;

  FMusic := TViAudioStream.Create;
  FMusic.Load('arc/audio/music/song04.ogg');
  FMusic.Play(True, 1.0);

end;

procedure TElasticDemo.OnShutdown;
begin
  FreeAndNil(FMusic);
  inherited;
end;

procedure TElasticDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
var
  i: Integer;
  Dist, DistX, DistY: Single;
begin
  inherited;

  if not aTimer.FrameSpeed(FTimer, ViEngine.UpdateSpeed) then
    Exit;

  FBead[0].X := MousePos.X;
  FBead[0].Y := MousePos.Y;

  if FBead[0].X - (cBeadSize+10)/2<0 then
  begin
   FBead[0].X := (cBeadSize+10)/2;
  end;

  if FBead[0].X + ((cBeadSize+10)/2) >FViewWidth then
  begin
   FBead[0].X := FViewWidth - (cBeadSize+10)/2;
  end;

  if FBead[0].Y - ((cBeadSize+10)/2) < 0 then
  begin
   FBead[0].Y := (cBeadSize+10)/2;
  end;

  if FBead[0].Y + ((cBeadSize+10)/2) > FViewHeight then
  begin
   FBead[0].Y := FViewHeight - (cBeadSize+10)/2;
  end;

  // loop though other beads
  for i := 1 to cBeadCount do
  begin
    // calc X and Y distance between the bead and the one before it
    DistX := FBead[i].X - FBead[i-1].X;
    DistY := FBead[i].Y - FBead[i-1].Y;

    // calc total distance
    Dist := sqrt(DistX*DistX + DistY * DistY);

    // if the beads are far enough apart, decrease the movement to create elasticity
    if Dist > cSlackness then
    begin
       FBead[i].XMove := FBead[i].XMove - (cXElasticity * DistX);
       FBead[i].YMove := FBead[i].YMove - (cYElasticity * DistY);
    end;

    // if bead is not last bead
    if i <> cBeadCount then
    begin
       // calc distances between the bead and the one after it
       DistX := FBead[i].X - FBead[i+1].X;
       DistY := FBead[i].Y - FBead[i+1].Y;
       Dist  := sqrt(DistX*DistX + DistY*DistY);

       // if beads are far enough apart, decrease the movement to create elasticity
       if Dist > 1 then
       begin
          FBead[i].XMove := FBead[i].XMove - (cXElasticity * DistX);
          FBead[i].YMove := FBead[i].YMove - (cYElasticity * DistY);
       end;
    end;

    // decay the movement of the beads to simulate loss of energy
    FBead[i].XMove := FBead[i].XMove * cXDecay;
    FBead[i].YMove := FBead[i].YMove * cYDecay;

    // apply cGravity to bead movement
    FBead[i].YMove := FBead[i].YMove + cGravity;

    // move beads
    FBead[i].X := FBead[i].X + FBead[i].XMove;
    FBead[i].Y := FBead[i].Y + FBead[i].YMove;

    // ff the beads hit a wall, make them bounce off of it
    if FBead[i].X - ((cBeadSize + 10 ) / 2) < 0 then
    begin
       FBead[i].X     :=  FBead[i].X     + (cBeadSize+10)/2;
       FBead[i].XMove := -FBead[i].XMove * cWallDecay;
    end;

    if FBead[i].X + ((cBeadSize+10)/2) > FViewWidth then
    begin
       FBead[i].X     := FViewWidth - (cBeadSize+10)/2;
       FBead[i].xMove := -FBead[i].XMove * cWallDecay;
    end;

    if FBead[i].Y - ((cBeadSize+10)/2) < 0 then
    begin
       FBead[i].YMove := -FBead[i].YMove * cWallDecay;
       FBead[i].Y     :=(cBeadSize+10)/2;
    end;

    if FBead[i].Y + ((cBeadSize+10)/2) > FViewHeight then
    begin
       FBead[i].YMove := -FBead[i].YMove * cWallDecay;
       FBead[i].Y     := FViewHeight - (cBeadSize+10)/2;
    end;
  end;
end;

procedure TElasticDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TElasticDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TElasticDemo.OnRender;
var
  I: Integer;
begin
  inherited;

  // draw last bead
  ViEngine.Display.DrawFilledRectangle(FBead[0].X, FBead[0].Y, cBeadSize,
    cBeadSize, GREEN);

  // loop though other beads
  for I := 1 to cBeadCount do
  begin
    // draw bead and string from it to the one before it
    ViEngine.Display.DrawLine(FBead[i].x+cBedHalfSize,
      FBead[i].y+cBedHalfSize, FBead[i-1].x+cBedHalfSize,
      FBead[i-1].y+cBedHalfSize, YELLOW, 1);
    ViEngine.Display.DrawFilledRectangle(FBead[i].X, FBead[i].Y, cBeadSize,
     cBeadSize, GREEN);
  end;
end;

procedure TElasticDemo.OnRenderGUI;
begin
  inherited;
end;

end.

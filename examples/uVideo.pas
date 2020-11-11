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

unit uVideo;

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
  Vivace.Video,
  uCommon;

const
  cDisplayTitle = 'Vivace: Video Demo';

type

  { TVideoDemo }
  TVideoDemo = class(TCustomDemo)
  protected
    FVideo: array[0..3] of TViVideo;
    FFilename: array[0..3] of string;
    FNum: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Play(aNum: Integer; aVol: Single);
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

{ --- TTemplate ------------------------------------------------------------- }
constructor TVideoDemo.Create;
begin
  inherited;
  FNum := -1;
end;

destructor TVideoDemo.Destroy;
begin
  inherited;
end;

procedure TVideoDemo.Play(aNum: Integer; aVol: Single);
begin
  if (aNum < 0) or (aNum > 3) then Exit;
  if  (aNum = FNum) then Exit;
  if (FNum >=0) and (FNum <=3) then
    FVideo[FNum].Playing := False;
  FNum := aNum;
  FVideo[FNum].Play(True, 1.0);
end;
procedure TVideoDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TVideoDemo.OnExit;
begin
  inherited;
end;

procedure TVideoDemo.OnStartup;
begin
  inherited;

  FFilename[0] := 'tbgintro.ogv';
  FFilename[1] := 'test.ogv';
  FFilename[2] := 'wildlife.ogv';
  FFilename[3] := 'small.ogv';


  FVideo[0] := TViVideo.Create;
  FVideo[1] := TViVideo.Create;
  FVideo[2] := TViVideo.Create;
  FVideo[3] := TViVideo.Create;

  FVideo[0].Load('arc/videos/'+FFilename[0]);
  FVideo[1].Load('arc/videos/'+FFilename[1]);
  FVideo[2].Load('arc/videos/'+FFilename[2]);
  FVideo[3].Load('arc/videos/'+FFilename[3]);

  Play(0, 1.0);
end;

procedure TVideoDemo.OnShutdown;
begin
  FreeAndNil(FVideo[2]);
  FreeAndNil(FVideo[1]);
  FreeAndNil(FVideo[0]);
  inherited;
end;

procedure TVideoDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  if ViEngine.Input.KeyboardPressed(KEY_1) then
    Play(0, 1.0);

  if ViEngine.Input.KeyboardPressed(KEY_2) then
    Play(1, 1.0);

  if ViEngine.Input.KeyboardPressed(KEY_3) then
    Play(2, 1.0);

  if ViEngine.Input.KeyboardPressed(KEY_4) then
    Play(3, 1.0);

end;

procedure TVideoDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TVideoDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TVideoDemo.OnRender;
var
  x,y,w,h: Single;
  vp: TViRectangle;
begin
  inherited;
  ViEngine.Display.GetViewportSize(vp);
  FVideo[FNum].GetSize(@w, @h);
  x := (vp.Width  - w) / 2;
  y := (vp.Height - h) / 2;
  FVideo[FNum].Draw(x, y);
end;

procedure TVideoDemo.OnRenderGUI;
begin
  inherited;

  FConsoleFont.Print(HudPos.X, HudPos.Y, 0, GREEN, alLeft,
    '1-4 - Video (%s)', [FFilename[FNum]]);

end;

end.

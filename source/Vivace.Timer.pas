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

unit Vivace.Timer;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Common;

type

  TViTimer = class;

  TViTimerUpdateEvent = procedure(aTimer: TViTimer; aDeltaTime: Double) of object;
  TViTimerFixedUpdateEvent = procedure(aTimer: TViTimer) of object;

  { TViTimer }
  TViTimer = class(TViBaseObject)
  protected
    FNow: Double;
    FPassed: Double;
    FLast: Double;

    FAccumulator: Double;
    FFrameAccumulator: Double;
    FFixedAccumulator: Double;

    FDeltaTime: Double;
    FFixedDeltaTime: Double;

    FFrameCount: Cardinal;
    FFrameRate: Cardinal;

    FUpdateSpeed: Single;
    FFixedUpdateSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Reset;

    procedure SetUpdateSpeed(aSpeed: Single);
    function GetUpdateSpeed: Single;

    procedure SetFixedUpdateSpeed(aSpeed: Single);
    function GetFixedUpdateSpeed: Single;

    function GetDeltaTime: Double;
    function GetFrameRate: Cardinal;

    procedure Update(aUpdate: TViTimerUpdateEvent;
      aFixedUpdate: TViTimerFixedUpdateEvent);

    function FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
    function FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;

  end;

implementation

uses
  Vivace.Allegro.API;

{ --- TViTimer -------------------------------------------------------------- }
constructor TViTimer.Create;
begin
  inherited;

  FNow := 0;
  FPassed := 0;
  FLast := 0;

  FAccumulator := 0;
  FFrameAccumulator := 0;
  FFixedAccumulator := 0;

  FDeltaTime := 0;
  FFixedDeltaTime := 0;

  FFrameCount := 0;
  FFrameRate := 0;

  FUpdateSpeed := 0;
  FFixedUpdateSpeed := 0;

  SetUpdateSpeed(60);
  SetFixedUpdateSpeed(60);

  FLast := al_get_time;
end;

destructor TViTimer.Destroy;
begin
  inherited;
end;

procedure TViTimer.Reset;
begin
  FNow := 0;
  FPassed := 0;
  FLast := 0;

  FAccumulator := 0;
  FFrameAccumulator := 0;
  FFixedAccumulator := 0;

  FDeltaTime := 0;
  FFixedDeltaTime := 0;

  FFrameCount := 0;
  FFrameRate := 0;

  SetUpdateSpeed(FUpdateSpeed);
  SetFixedUpdateSpeed(FFixedUpdateSpeed);

  FLast := al_get_time;
end;

procedure TViTimer.SetUpdateSpeed(aSpeed: Single);
begin
  FUpdateSpeed := aSpeed;
  FDeltaTime := 1.0 / FUpdateSpeed;
end;

function TViTimer.GetUpdateSpeed: Single;
begin
  Result := FUpdateSpeed;
end;

procedure TViTimer.SetFixedUpdateSpeed(aSpeed: Single);
begin
  FFixedUpdateSpeed := aSpeed;
  FFixedDeltaTime := 1.0 / FFixedUpdateSpeed;
end;

function TViTimer.GetFixedUpdateSpeed: Single;
begin
  Result := FFixedUpdateSpeed;
end;

function TViTimer.GetDeltaTime: Double;
begin
  Result := FDeltaTime;
end;

function TViTimer.GetFrameRate: Cardinal;
begin
  Result := FFrameRate;
end;

const
  EPSILON = 0.00001;

procedure TViTimer.Update(aUpdate: TViTimerUpdateEvent;
  aFixedUpdate: TViTimerFixedUpdateEvent);
begin
  FNow := al_get_time;
  FPassed := FNow - FLast;
  FLast := FNow;

  // process framerate
  Inc(FFrameCount);
  FFrameAccumulator := FFrameAccumulator + FPassed + EPSILON;
  if FFrameAccumulator >= 1 then
  begin
    FFrameAccumulator := 0;
    FFrameRate := FFrameCount;
    FFrameCount := 0;
  end;

  // process fixed update
  FFixedAccumulator := FFixedAccumulator + FPassed;
  if FFixedAccumulator >= FFixedDeltaTime then
  begin
    FFixedAccumulator := 0;
    if Assigned(aFixedUpdate) then
    begin
      aFixedUpdate(Self);
    end;
  end;

  // process variable update
  FAccumulator := FAccumulator + FPassed;
  while (FAccumulator >= FDeltaTime) do
  begin
    if Assigned(aUpdate) then
    begin
      aUpdate(Self, FDeltaTime);
    end;
    FAccumulator := FAccumulator - FDeltaTime;
  end;
end;

function TViTimer.FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + (aSpeed / FUpdateSpeed);
  if aTimer >= 1.0 then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

function TViTimer.FrameElapsed(var aTimer: Single; aFrames: Single): Boolean;
begin
  Result := False;
  aTimer := aTimer + FUpdateSpeed;
  if aTimer > aFrames then
  begin
    aTimer := 0;
    Result := True;
  end;
end;

end.

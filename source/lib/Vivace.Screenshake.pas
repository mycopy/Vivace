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

unit Vivace.Screenshake;

{$I Vivace.Defines.inc}

interface

uses
  Generics.Collections,
  Vivace.Allegro.API,
  Vivace.Timer,
  Vivace.Math,
  Vivace.Common;

type

  { TViScreenshake }
  TViScreenshake = class
  protected
    FActive: Boolean;
    FDuration: Single;
    FMagnitude: Single;
    FTimer: Single;
    FPos: TViPointi;
  public
    constructor Create(aDuration: Single; aMagnitude: Single);
    destructor Destroy; override;
    procedure Process(aSpeed: Single; aDeltaTime: Double);
    property Active: Boolean read FActive;
  end;

  { TScreenShakes }
  TViScreenshakes = class(TViBaseObject)
  protected
    FTrans: ALLEGRO_TRANSFORM;
    FList: TObjectList<TViScreenshake>;
    FTimer: TViTimer;
  public
    property Timer: TViTimer read FTimer;
    constructor Create; override;
    destructor Destroy; override;
    procedure Process(aTimer: TViTimer; aDeltaTime: Double);
    procedure Update;

    procedure Start(aDuration: Single; aMagnitude: Single);
    procedure Clear;
    function Active: Boolean;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Engine;

{ --- TViScreenshake -------------------------------------------------------- }
constructor TViScreenshake.Create(aDuration: Single; aMagnitude: Single);
begin
  inherited Create;
  FActive := True;
  FDuration := aDuration;
  FMagnitude := aMagnitude;
  FTimer := 0;
  FPos.x := 0;
  FPos.y := 0;
end;

destructor TViScreenshake.Destroy;
begin
  inherited;
end;

function lerp(t: Single; a: Single; b: Single): Single; inline;
begin
  Result := (1 - t) * a + t * b;
end;

procedure TViScreenshake.Process(aSpeed: Single; aDeltaTime: Double);
begin
  if not FActive then
    Exit;

  FDuration := FDuration - (aSpeed * aDeltaTime);
  if FDuration <= 0 then
  begin
    ViEngine.Display.SetTransformPosition(-FPos.x, -FPos.y);
    FActive := False;
    Exit;
  end;

  if Round(FDuration) <> Round(FTimer) then
  begin

    ViEngine.Display.SetTransformPosition(-FPos.x, -FPos.y);

    FPos.x := Round(ViEngine.Math.RandomRange(-FMagnitude, FMagnitude));
    FPos.y := Round(ViEngine.Math.RandomRange(-FMagnitude, FMagnitude));

    ViEngine.Display.SetTransformPosition(FPos.x, FPos.y);

    FTimer := FDuration;
  end;
end;

{ --- TViScreenshakes ------------------------------------------------------- }
constructor TViScreenshakes.Create;
begin
  inherited;
  FList := TObjectList<TViScreenshake>.Create(True);
  FTimer := TViTimer.Create;
  al_identity_transform(@FTrans);
end;

destructor TViScreenshakes.Destroy;
begin
  FreeAndNil(FTimer);
  FreeAndNil(FList);
  inherited;
end;

procedure TViScreenshakes.Start(aDuration: Single; aMagnitude: Single);
var
  Shake: TViScreenshake;
begin
  Shake := TViScreenshake.Create(aDuration, aMagnitude);
  FList.Add(Shake);
end;

procedure TViScreenshakes.Clear;
begin
  FList.Clear;
end;

function TViScreenshakes.Active: Boolean;
begin
  Result := Boolean(FList.Count > 0);
end;

procedure TViScreenshakes.Process(aTimer: TViTimer; aDeltaTime: Double);
var
  Shake: TViScreenshake;
  Flag: Boolean;
begin
  // process shakes
  Flag := Active;
  for Shake in FList do
  begin
    if Shake.Active then
    begin
      Shake.Process(FTimer.GetUpdateSpeed, aDeltaTime);
    end
    else
    begin
      FList.Remove(Shake);
    end;
  end;

  if Flag then
  begin
    if not Active then
    begin
      // Lib.Display.ResetTransform;
    end;
  end;

end;

procedure TViScreenshakes.Update;
begin
  FTimer.Update(Process, nil);
end;

end.

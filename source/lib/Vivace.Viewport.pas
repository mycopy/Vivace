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

unit Vivace.Viewport;

{$I Vivace.Defines.inc}

interface

uses
  System.SysUtils,
  Vivace.Common,
  Vivace.Bitmap,
  Vivace.Math;

type

  { TViViewport }
  TViViewport = class(TViBaseObject)
  protected
    FBitmap: TViBitmap;
    FActive: Boolean;
    FPos: TViRectangle;
    FHalf: TViVector;
    FAngle: Single;
    FCenter: TViVector;
    procedure Clean;
  public
    constructor Create; override;

    destructor Destroy; override;

    procedure Init(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer);

    procedure SetActive(aActive: Boolean);

    function GetActive: Boolean;

    procedure SetPosition(aX: Integer; aY: Integer);

    procedure GetSize(aX: PInteger; aY: PInteger; aWidth: PInteger;
      aHeight: PInteger);

    procedure SetAngle(aAngle: Single);

    function GetAngle: Single;
  end;

implementation

uses
  Vivace.Engine,
  Vivace.Color;


{ --- TViViewport ----------------------------------------------------------- }

procedure TViViewport.Clean;
begin
  if FBitmap <> nil then
  begin
    if FActive then
    begin
      // this fixes the is issue where if the active viewport is destroyed
      // while active, then just pass nil to Display.SetViewport to restore
      // the fullscreen viewport instead
      ViEngine.Display.SetViewport(nil);
    end;
    SetActive(False);
    FreeAndNil(FBitmap);
    FActive := False;
    FBitmap := nil;
    FPos.Assign(0, 0, 0, 0);
    FAngle := 0;
  end;
end;

constructor TViViewport.Create;
begin
  inherited;
  FBitmap := nil;
  FActive := False;
  FPos.Assign(0, 0, 0, 0);
  FAngle := 0;
  FCenter.Assign(0.5, 0.5);
end;

destructor TViViewport.Destroy;
begin
  Clean;
  inherited;
end;

procedure TViViewport.Init(aX: Integer; aY: Integer; aWidth: Integer;
  aHeight: Integer);
begin
  Clean;
  FActive := False;
  FBitmap := TViBitmap.Create;
  if FBitmap <> nil then
  begin
    FBitmap.Allocate(aWidth, aHeight);
    FPos.Assign(aX, aY, aWidth, aHeight);
    FHalf.Assign(aWidth / 2, aHeight / 2);
  end;
end;

procedure TViViewport.SetActive(aActive: Boolean);
begin
  if FBitmap = nil then
    Exit;

  if aActive then
  begin
    if FActive then
      Exit;
    ViEngine.Display.SetTarget(FBitmap);
  end
  else
  begin
    if not FActive then
      Exit;
    ViEngine.Display.ResetTarget;
    FBitmap.Draw(FPos.X + FHalf.X, FPos.Y + FHalf.Y, nil, @FCenter, nil, FAngle,
      WHITE, False, False);
  end;

  FActive := aActive;
end;

function TViViewport.GetActive: Boolean;
begin
  Result := FActive;
end;

procedure TViViewport.SetPosition(aX: Integer; aY: Integer);
begin
  if FBitmap = nil then
    Exit;
  FPos.X := aX;
  FPos.Y := aY;
end;

procedure TViViewport.GetSize(aX: PInteger; aY: PInteger; aWidth: PInteger;
  aHeight: PInteger);
begin
  if FBitmap = nil then
    Exit;

  if aX <> nil then
    aX^ := Round(FPos.X);
  if aY <> nil then
    aY^ := Round(FPos.Y);
  if aWidth <> nil then
    aWidth^ := Round(FPos.Width);
  if aHeight <> nil then
    aHeight^ := Round(FPos.Height);
end;

procedure TViViewport.SetAngle(aAngle: Single);
begin
  FAngle := aAngle;
  ViEngine.Math.ClipValue(FAngle, 0, 359, True);
end;

function TViViewport.GetAngle: Single;
begin
  Result := FAngle;
end;

end.

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

unit Vivace.Polygon;

{$I Vivace.Defines.inc}

interface

uses
  System.SysUtils,
  Vivace.Color,
  Vivace.Math,
  Vivace.Common;

type

  { TViPolygonSegment }
  TViPolygonSegment = record
    Point: TViVector;
    Visible: Boolean;
  end;

  { TViPolygon }
  TViPolygon = class(TViBaseObject)
  protected
    FSegment: array of TViPolygonSegment;
    FWorldPoint: array of TViVector;
    FItemCount: Integer;
    procedure Clear;
  public
    constructor Create; override;

    destructor Destroy; override;

    procedure Save(aFilename: string);

    procedure Load(aFilename: string);

    procedure CopyFrom(aPolygon: TViPolygon);

    procedure AddLocalPoint(aX: Single; aY: Single; aVisible: Boolean);

    function Transform(aX: Single; aY: Single; aScale: Single; aAngle: Single;
      aOrigin: PViVector; aHFlip: Boolean; aVFlip: Boolean): Boolean;

    procedure Render(aX: Single; aY: Single; aScale: Single; aAngle: Single;
      aThickness: Integer; aColor: TViColor; aOrigin: PViVector; aHFlip: Boolean;
      aVFlip: Boolean);

    procedure SetSegmentVisible(aIndex: Integer; aVisible: Boolean);

    function GetSegmentVisible(aIndex: Integer): Boolean;

    function GetPointCount: Integer;

    function GetWorldPoint(aIndex: Integer): PViVector;

    function GetLocalPoint(aIndex: Integer): PViVector;
  end;

implementation

uses
  System.Classes,
  Vivace.Allegro.API,
  Vivace.Engine;

{ --- TViPolygon ------------------------------------------------------------ }
procedure TViPolygon.Clear;
begin
  FSegment := nil;
  FWorldPoint := nil;
  FItemCount := 0;
end;

constructor TViPolygon.Create;
begin
  inherited;
  Clear;
end;

destructor TViPolygon.Destroy;
begin
  inherited;
end;

procedure TViPolygon.Save(aFilename: string);
var
  Size: Integer;
  fs: PALLEGRO_FILE;
  Filename: string;
begin
  Filename := aFilename;
  if Filename.IsEmpty then
    Exit;

  ViEngine.EnablePhysFS(False);

  fs := al_fopen(PAnsiChar(AnsiString(Filename)), 'wb');

  try
    // FItemCount
    al_fwrite(fs, @FItemCount, SizeOf(FItemCount));

    // FItem
    Size := SizeOf(FSegment[0]) * FItemCount;

    // fs.WriteData(FSegment, Size);
    al_fwrite(fs, FSegment, Size);

    // FWorldPoint
    Size := SizeOf(FWorldPoint[0]) * FItemCount;

    // fs.WriteData(FWorldPoint, Size);
    al_fwrite(fs, FWorldPoint, Size);

  finally
    al_fclose(fs);
  end;

  ViEngine.EnablePhysFS(True);

end;

procedure TViPolygon.Load(aFilename: string);
var
  Size: Integer;
  FStream: PALLEGRO_FILE;
  Filename: string;
  FName: AnsiString;
begin
  Filename := aFilename;
  if Filename.IsEmpty then
    Exit;

  FName := AnsiString(Filename);

  if not al_filename_exists(PAnsiChar(FName)) then
    Exit;

  FStream := al_fopen(PAnsiChar(FName), 'rb');

  try
    Clear;

    // FItemCount
    al_fread(FStream, @FItemCount, SizeOf(FItemCount));

    // FItem
    SetLength(FSegment, FItemCount);
    Size := SizeOf(FSegment[0]) * FItemCount;
    al_fread(FStream, FSegment, Size);

    // FWorldPoint
    SetLength(FWorldPoint, FItemCount);
    Size := SizeOf(FWorldPoint[0]) * FItemCount;
    al_fread(FStream, FWorldPoint, Size);

  finally
    al_fclose(FStream);
  end;

end;

procedure TViPolygon.CopyFrom(aPolygon: TViPolygon);
var
  i: Integer;
begin
  Clear;
  with aPolygon do
  begin
    for i := 0 to FItemCount - 1 do
    begin
      with FSegment[i] do
      begin
        Self.AddLocalPoint(Round(Point.X), Round(Point.Y), Visible);
      end;
    end;
  end;
end;

procedure TViPolygon.AddLocalPoint(aX: Single; aY: Single; aVisible: Boolean);
begin
  Inc(FItemCount);
  SetLength(FSegment, FItemCount);
  SetLength(FWorldPoint, FItemCount);
  FSegment[FItemCount - 1].Point.X := aX;
  FSegment[FItemCount - 1].Point.Y := aY;
  FSegment[FItemCount - 1].Visible := aVisible;
  FWorldPoint[FItemCount - 1].X := 0;
  FWorldPoint[FItemCount - 1].Y := 0;
end;

function TViPolygon.Transform(aX: Single; aY: Single; aScale: Single;
  aAngle: Single; aOrigin: PViVector; aHFlip: Boolean; aVFlip: Boolean): Boolean;
var
  i: Integer;
  P: TViVector;
begin
  Result := False;

  if FItemCount < 2 then
    Exit;

  for i := 0 to FItemCount - 1 do
  begin
    // get local coord
    P.X := FSegment[i].Point.X;
    P.Y := FSegment[i].Point.Y;

    // move point to origin
    if aOrigin <> nil then
    begin
      P.X := P.X - aOrigin.X;
      P.Y := P.Y - aOrigin.Y;
    end;

    // horizontal flip
    if aHFlip then
    begin
      P.X := -P.X;
    end;

    // virtical flip
    if aVFlip then
    begin
      P.Y := -P.Y;
    end;

    // scale
    P.X := P.X * aScale;
    P.Y := P.Y * aScale;

    // rotate
    ViEngine.Math.AngleRotatePos(aAngle, P.X, P.Y);

    // convert to world
    P.X := P.X + aX;
    P.Y := P.Y + aY;

    // set world point
    FWorldPoint[i].X := P.X;
    FWorldPoint[i].Y := P.Y;
  end;

  Result := True;
end;

procedure TViPolygon.Render(aX: Single; aY: Single; aScale: Single;
  aAngle: Single; aThickness: Integer; aColor: TViColor; aOrigin: PViVector;
  aHFlip: Boolean; aVFlip: Boolean);
var
  i: Integer;
begin
  if not Transform(aX, aY, aScale, aAngle, aOrigin, aHFlip, aVFlip) then
    Exit;

  // draw line segments
  for i := 0 to FItemCount - 2 do
  begin
    if FSegment[i].Visible then
    begin
      ViEngine.Display.DrawLine(FWorldPoint[i].X, FWorldPoint[i].Y,
        FWorldPoint[i + 1].X, FWorldPoint[i + 1].Y, aColor, aThickness);
    end;
  end;
end;

procedure TViPolygon.SetSegmentVisible(aIndex: Integer; aVisible: Boolean);
begin
  FSegment[aIndex].Visible := True;
end;

function TViPolygon.GetSegmentVisible(aIndex: Integer): Boolean;
begin
  Result := FSegment[aIndex].Visible;
end;

function TViPolygon.GetPointCount: Integer;
begin
  Result := FItemCount;
end;

function TViPolygon.GetWorldPoint(aIndex: Integer): PViVector;
begin
  Result := @FWorldPoint[aIndex];
end;

function TViPolygon.GetLocalPoint(aIndex: Integer): PViVector;
begin
  Result := @FSegment[aIndex].Point;
end;

end.

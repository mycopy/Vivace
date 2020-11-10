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

unit Vivace.Sprite;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Bitmap,
  Vivace.Math,
  Vivace.Color,
  Vivace.Common;

type

  { TViSpriteImageRegion }
  PViSpriteImageRegion = ^TViSpriteImageRegion;
  TViSpriteImageRegion = record
    Rect: TViRectangle;
    Page: Integer;
  end;

  { PViSpriteGroup }
  PViSpriteGroup = ^TViSpriteGroup;
  TViSpriteGroup = record
    Image: array of TViSpriteImageRegion;
    Count: Integer;
    PolyPoint: Pointer;
  end;

  { TViSprite }
  TViSprite = class(TViBaseObject)
  protected
    FBitmap: array of TViBitmap;
    FGroup: array of TViSpriteGroup;
    FPageCount: Integer;
    FGroupCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;
    function LoadPage(aFilename: string; aColorKey: PViColor): Integer;

    function AddGroup: Integer;
    function GetGroupCount: Integer;

    function AddImageFromRect(aPage: Integer; aGroup: Integer;
      aRect: TViRectangle): Integer;
    function AddImageFromGrid(aPage: Integer; aGroup: Integer; aGridX: Integer;
      aGridY: Integer; aGridWidth: Integer; aGridHeight: Integer): Integer;
    function GetImageCount(aGroup: Integer): Integer;
    function GetImageWidth(aNum: Integer; aGroup: Integer): Single;
    function GetImageHeight(aNum: Integer; aGroup: Integer): Single;
    function GetImageTexture(aNum: Integer; aGroup: Integer): TViBitmap;
    function GetImageRect(aNum: Integer; aGroup: Integer): TViRectangle;
    procedure DrawImage(aNum: Integer; aGroup: Integer; aX: Single; aY: Single;
      aOrigin: PViVector; aScale: PViVector; aAngle: Single; aColor: TViColor;
      aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean);

    function GroupPolyPoint(aGroup: Integer): Pointer;
    procedure GroupPolyPointTrace(aGroup: Integer; aMju: Single = 6;
      aMaxStepBack: Integer = 12; aAlphaThreshold: Integer = 70;
      aOrigin: PViVector = nil);
    function GroupPolyPointCollide(aNum1: Integer; aGroup1: Integer;
      aX1: Single; aY1: Single; aScale1: Single; aAngle1: Single;
      aOrigin1: PViVector; aHFlip1: Boolean; aVFlip1: Boolean; aSprite2: TViSprite;
      aNum2: Integer; aGroup2: Integer; aX2: Single; aY2: Single;
      aScale2: Single; aAngle2: Single; aOrigin2: PViVector; aHFlip2: Boolean;
      aVFlip2: Boolean; aShrinkFactor: Single; var aHitPos: TViVector): Boolean;
    function GroupPolyPointCollidePoint(aNum: Integer; aGroup: Integer;
      aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PViVector;
      aHFlip: Boolean; aVFlip: Boolean; aShrinkFactor: Single;
      var aPoint: TViVector): Boolean;
  end;

implementation

uses
  System.SysUtils,
  Vivace.PolyPoint,
  Vivace.Collision,
  Vivace.Engine;

{ --- TViSprite ------------------------------------------------------------- }
procedure TViSprite.Clear;
var
  I: Integer;
begin
  if FBitmap <> nil then
  begin
    // free group data
    for I := 0 to FGroupCount - 1 do
    begin
      // free image array
      FGroup[I].Image := nil;

      // free polypoint
      FreeAndNil(FGroup[I].PolyPoint);
    end;

    // free page
    for I := 0 to FPageCount - 1 do
    begin
      if Assigned(FBitmap[I]) then
      begin
        FreeAndNil(FBitmap[I]);
      end;
    end;

    FBitmap := nil;
    FGroup := nil;
    FPageCount := 0;
    FGroupCount := 0;
  end;
end;

constructor TViSprite.Create;
begin
  inherited;
  FBitmap := nil;
  FGroup := nil;
  FPageCount := 0;
  FGroupCount := 0;
end;

destructor TViSprite.Destroy;
begin
  Clear;
  inherited;
end;

function TViSprite.LoadPage(aFilename: string; aColorKey: PViColor): Integer;
begin
  Result := FPageCount;
  Inc(FPageCount);
  SetLength(FBitmap, FPageCount);
  FBitmap[Result] := TViBitmap.Create;
  FBitmap[Result].Load(aFilename, aColorKey);
end;

function TViSprite.AddGroup: Integer;
begin
  Result := FGroupCount;
  Inc(FGroupCount);
  SetLength(FGroup, FGroupCount);
  FGroup[Result].PolyPoint := TViPolyPoint.Create;
end;

function TViSprite.GetGroupCount: Integer;
begin
  Result := FGroupCount;
end;

function TViSprite.AddImageFromRect(aPage: Integer; aGroup: Integer;
  aRect: TViRectangle): Integer;
begin
  Result := FGroup[aGroup].Count;
  Inc(FGroup[aGroup].Count);
  SetLength(FGroup[aGroup].Image, FGroup[aGroup].Count);

  FGroup[aGroup].Image[Result].Rect.X := aRect.X;
  FGroup[aGroup].Image[Result].Rect.Y := aRect.Y;
  FGroup[aGroup].Image[Result].Rect.Width := aRect.Width;
  FGroup[aGroup].Image[Result].Rect.Height := aRect.Height;
  FGroup[aGroup].Image[Result].Page := aPage;
end;

function TViSprite.AddImageFromGrid(aPage: Integer; aGroup: Integer;
  aGridX: Integer; aGridY: Integer; aGridWidth: Integer;
  aGridHeight: Integer): Integer;
begin
  Result := FGroup[aGroup].Count;
  Inc(FGroup[aGroup].Count);
  SetLength(FGroup[aGroup].Image, FGroup[aGroup].Count);

  FGroup[aGroup].Image[Result].Rect.X := aGridWidth * aGridX;
  FGroup[aGroup].Image[Result].Rect.Y := aGridHeight * aGridY;
  FGroup[aGroup].Image[Result].Rect.Width := aGridWidth;
  FGroup[aGroup].Image[Result].Rect.Height := aGridHeight;
  FGroup[aGroup].Image[Result].Page := aPage;
end;

function TViSprite.GetImageCount(aGroup: Integer): Integer;
begin
  Result := FGroup[aGroup].Count;
end;

function TViSprite.GetImageWidth(aNum: Integer; aGroup: Integer): Single;
begin
  Result := FGroup[aGroup].Image[aNum].Rect.Width;
end;

function TViSprite.GetImageHeight(aNum: Integer; aGroup: Integer): Single;
begin
  Result := FGroup[aGroup].Image[aNum].Rect.Height;
end;

function TViSprite.GetImageTexture(aNum: Integer; aGroup: Integer): TViBitmap;
begin
  Result := FBitmap[FGroup[aGroup].Image[aNum].Page];
end;

procedure TViSprite.DrawImage(aNum: Integer; aGroup: Integer; aX: Single;
  aY: Single; aOrigin: PViVector; aScale: PViVector; aAngle: Single; aColor: TViColor;
  aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean);
var
  PageNum: Integer;
  RectP: PViRectangle;
  oxy: TViVector;
begin
  RectP := @FGroup[aGroup].Image[aNum].Rect;
  PageNum := FGroup[aGroup].Image[aNum].Page;
  FBitmap[PageNum].Draw(aX, aY, RectP, aOrigin, aScale, aAngle, aColor,
    aHFlip, aVFlip);

  if aDrawPolyPoint then
  begin
    oxy.X := 0;
    oxy.Y := 0;
    if aOrigin <> nil then
    begin
      oxy.X := FGroup[aGroup].Image[aNum].Rect.Width;
      oxy.Y := FGroup[aGroup].Image[aNum].Rect.Height;

      oxy.X := Round(oxy.X * aOrigin.X);
      oxy.Y := Round(oxy.Y * aOrigin.Y);
    end;
    TViPolyPoint(FGroup[aGroup].PolyPoint).Render(aNum, aX, aY, aScale.X, aAngle,
      YELLOW, @oxy, aHFlip, aVFlip);
  end;
end;

function TViSprite.GetImageRect(aNum: Integer; aGroup: Integer): TViRectangle;
begin
  Result := FGroup[aGroup].Image[aNum].Rect;
end;

function TViSprite.GroupPolyPoint(aGroup: Integer): Pointer;
begin
  Result := FGroup[aGroup].PolyPoint;
end;

procedure TViSprite.GroupPolyPointTrace(aGroup: Integer; aMju: Single = 6;
  aMaxStepBack: Integer = 12; aAlphaThreshold: Integer = 70;
  aOrigin: PViVector = nil);
begin
  TViPolyPoint(FGroup[aGroup].PolyPoint).TraceFromSprite(Self, aGroup, aMju,
    aMaxStepBack, aAlphaThreshold, aOrigin);
end;

function TViSprite.GroupPolyPointCollide(aNum1: Integer; aGroup1: Integer;
  aX1: Single; aY1: Single; aScale1: Single; aAngle1: Single; aOrigin1: PViVector;
  aHFlip1: Boolean; aVFlip1: Boolean; aSprite2: TViSprite; aNum2: Integer;
  aGroup2: Integer; aX2: Single; aY2: Single; aScale2: Single; aAngle2: Single;
  aOrigin2: PViVector; aHFlip2: Boolean; aVFlip2: Boolean; aShrinkFactor: Single;
  var aHitPos: TViVector): Boolean;
var
  PP1, PP2: TViPolyPoint;
  Radius1: Integer;
  Radius2: Integer;
  Origini1, Origini2: TViVector;
  Origini1P, Origini2P: PViVector;
begin
  Result := False;

  if (aSprite2 = nil) then
    Exit;

  PP1 := FGroup[aGroup1].PolyPoint;
  PP2 := aSprite2.FGroup[aGroup2].PolyPoint;

  if not PP1.Valid(aNum1) then
    Exit;
  if not PP2.Valid(aNum2) then
    Exit;

  Radius1 := Round(FGroup[aGroup1].Image[aNum1].Rect.Height + FGroup[aGroup1]
    .Image[aNum1].Rect.Width) div 2;

  Radius2 := Round(aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Height +
    aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Width) div 2;

  if not ViRadiusOverlap(Radius1, aX1, aY1, Radius2, aX2, aY2, aShrinkFactor) then
    Exit;

  Origini2.X := aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Width;
  Origini2.Y := aSprite2.FGroup[aGroup2].Image[aNum2].Rect.Height;

  Origini1P := nil;
  if aOrigin1 <> nil then
  begin
    Origini1.X := Round(FGroup[aGroup1].Image[aNum1].Rect.Width * aOrigin1.X);
    Origini1.Y := Round(FGroup[aGroup1].Image[aNum1].Rect.Height * aOrigin1.Y);
    Origini1P := @Origini1;
  end;

  Origini2P := nil;
  if aOrigin2 <> nil then
  begin
    Origini2.X := Round(aSprite2.FGroup[aGroup2].Image[aNum2]
      .Rect.Width * aOrigin2.X);
    Origini2.Y := Round(aSprite2.FGroup[aGroup2].Image[aNum2]
      .Rect.Height * aOrigin2.Y);
    Origini2P := @Origini2;
  end;

  Result := PP1.Collide(aNum1, aGroup1, aX1, aY1, aScale1, aAngle1, Origini1P,
    aHFlip1, aVFlip1, PP2, aNum2, aGroup2, aX2, aY2, aScale2, aAngle2,
    Origini2P, aHFlip2, aVFlip2, aHitPos);
end;

function TViSprite.GroupPolyPointCollidePoint(aNum: Integer; aGroup: Integer;
  aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PViVector;
  aHFlip: Boolean; aVFlip: Boolean; aShrinkFactor: Single;
  var aPoint: TViVector): Boolean;
var
  PP1: TViPolyPoint;
  Radius1: Integer;
  Radius2: Integer;
  Origini1: TViVector;
  Origini1P: PViVector;

begin
  Result := False;

  PP1 := FGroup[aGroup].PolyPoint;

  if not PP1.Valid(aNum) then
    Exit;

  Radius1 := Round(FGroup[aGroup].Image[aNum].Rect.Height + FGroup[aGroup].Image
    [aNum].Rect.Width) div 2;

  Radius2 := 2;

  if not ViRadiusOverlap(Radius1, aX, aY, Radius2, aPoint.X, aPoint.Y,
    aShrinkFactor) then
    Exit;

  Origini1P := nil;
  if aOrigin <> nil then
  begin
    Origini1.X := FGroup[aGroup].Image[aNum].Rect.Width * aOrigin.X;
    Origini1.Y := FGroup[aGroup].Image[aNum].Rect.Height * aOrigin.Y;
    Origini1P := @Origini1;
  end;

  Result := PP1.CollidePoint(aNum, aGroup, aX, aY, aScale, aAngle, Origini1P,
    aHFlip, aVFlip, aPoint);
end;

end.

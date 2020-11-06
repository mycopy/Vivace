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

unit Vivace.Text;

{$I Vivace.Defines.inc}

interface

uses
  System.Generics.Collections,
  Vivace.Bitmap,
  Vivace.Common,
  Vivace.Color,
  Vivace.Math,
  Vivace.Font;

type

  { TViText }
  TViText = class(TViBaseObject)
  protected
    FBitmap: TViBitmap;
    FText: string;
    FFont: TViFont;
    procedure Clear;
  public
    property Text: string read FText;
    property Font: TViFont read FFont;

    constructor Create; override;
    destructor Destroy; override;

    procedure Print(aFont: TViFont; aColors: array of TViColor;
      const aMsg: string; const aArgs: array of const);
    procedure Render(aX: Single; aY: Single; aAlign: TViAlign; aScale: Single;
      aAngle: Single);
  end;

  { TViTextCacheItem }
  TViTextCacheItem = class(TViBaseObject)
  protected
    FText: TViText;
    FX: Single;
    FY: Single;
    FAlign: TViAlign;
    FScale: Single;
    FAngle: Single;
  public
    property Text: TViText read FText;
    property X: Single read FX;
    property Y: Single read FY;
    property Align: TViAlign read FAlign;
    property Scale: Single read FScale;
    property Angle: Single read FAngle;

    constructor Create; override;
    destructor Destroy; override;

    procedure Print(aFont: TViFont; aX: Single; aY: Single; aAlign: TViAlign;
      aScale: Single; aAngle: Single; aColors: array of TViColor;
      const aMsg: string; const aArgs: array of const);

    procedure Render;
  end;

  { TViTextCache }
  TViTextCache = class(TViBaseObject)
  protected
    FPos: TViVector;
    FCache: TObjectList<TViTextCacheItem>;
    function Cached(aFont: TViFont; aX: Single; aY: Single; aAlign: TViAlign;
      aScale: Single; aAngle: Single; const aMsg: string;
      const aArgs: array of const): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;

    procedure Print(aFont: TViFont; aX: Single; aY: Single; aAlign: TViAlign;
      aScale: Single; aAngle: Single; aColors: array of TViColor;
      const aMsg: string; const aArgs: array of const); overload;

    procedure Print(aFont: TViFont; aX: Single; var aY: Single;
      aLineSpace: Single; aAlign: TViAlign; aColors: array of TViColor;
      const aMsg: string; const aArgs: array of const); overload;

    procedure Render;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Engine;

{ --- TViText --------------------------------------------------------------- }
procedure TViText.Clear;
begin
  FBitmap.Unload;
  FText := '';
  FFont := nil;
end;

constructor TViText.Create;
begin
  inherited;
  FBitmap := TViBitmap.Create;
  FText := '';
  FFont := nil;
end;

destructor TViText.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TViText.Print(aFont: TViFont; aColors: array of TViColor;
  const aMsg: string; const aArgs: array of const);
var
  X: Single;
  C: string;
  Text: string;
  TempText: string;
  TextWidth: Single;
  TextHeight: Single;
  Color: TViColor;
  Mode: Integer;
  ColorCount: Integer;
  ColorIndex: Integer;
begin
  Text := Format(aMsg, aArgs);
  if (Text = FText) and (aFont = FFont) then
    Exit;
  ColorCount := Length(aColors);
  Color := aColors[0];
  TempText := '';
  Mode := -1;
  for C in Text do
  begin
    if C = '^' then
    begin
      if Mode = -1 then
        Mode := 0
      else if Mode = 0 then
      begin
        Mode := -1;
        continue;
      end;
    end;

    if Mode <> -1 then
      continue;
    TempText := TempText + C;
  end;

  TextWidth := aFont.GetTextWidth(TempText, []);
  TextHeight := aFont.GetLineHeight;

  Clear;
  FBitmap.Allocate(Round(TextWidth), Round(TextHeight));
  ViEngine.Display.SetTarget(FBitmap);

  X := 0;
  Mode := -1;
  for C in Text do
  begin
    if Mode = 2 then
    begin
      if C = '^' then
      begin
        Mode := -1;
      end;
      continue;
    end;
    // do change color
    if Mode = 1 then
    begin
      ColorIndex := C.ToInteger;
      if (ColorIndex < 0) or (ColorIndex > ColorCount - 1) then
      begin
        Mode := -1;
        continue;
      end;
      Color := aColors[ColorIndex];
      Mode := 2;
      continue;
    end;
    // check change color
    if Mode = 0 then
    begin
      if (C = 'c') or (C = 'C') then
      begin
        Mode := 1;
        continue;
      end;
    end;

    // set change color
    if C = '^' then
    begin
      Mode := 0;
      continue;
    end;
    aFont.Print(X, 0, Color, alLeft, C, []);
    X := X + aFont.GetTextWidth(C, []);
  end;

  ViEngine.Display.ResetTarget;

  FText := Text;
  FFont := aFont;
end;

procedure TViText.Render(aX: Single; aY: Single; aAlign: TViAlign; aScale: Single;
  aAngle: Single);
var
  Center: TViVector;
  Scale: TViVector;
begin
  case aAlign of
    alLeft:
      Center.Assign(0, 0);
    alCenter:
      Center.Assign(0.5, 0);
    alRight:
      Center.Assign(1, 0);
  end;

  Scale.Assign(aScale, aScale);

  FBitmap.Draw(aX, aY, nil, @Center, @Scale, aAngle, VIWHITE, False, False);
end;

{ --- TViTextCacheItem ------------------------------------------------------ }
constructor TViTextCacheItem.Create;
begin
  inherited;
  FText := TViText.Create;
  FX := 0;
  FY := 0;
  FAlign := alLeft;
  FScale := 0;
  FAngle := 0;
end;

destructor TViTextCacheItem.Destroy;
begin
  FreeAndNil(FText);
  inherited;
end;

procedure TViTextCacheItem.Print(aFont: TViFont; aX: Single; aY: Single;
  aAlign: TViAlign; aScale: Single; aAngle: Single; aColors: array of TViColor;
  const aMsg: string; const aArgs: array of const);
begin
  FText.Print(aFont, aColors, aMsg, aArgs);
  FX := aX;
  FY := aY;
  FAlign := aAlign;
  FScale := aScale;
  FAngle := aAngle;
end;

procedure TViTextCacheItem.Render;
begin
  FText.Render(FX, FY, FAlign, FScale, FAngle);
end;

{ --- TViTextCache ---------------------------------------------------------- }
function TViTextCache.Cached(aFont: TViFont; aX: Single; aY: Single;
  aAlign: TViAlign; aScale: Single; aAngle: Single; const aMsg: string;
  const aArgs: array of const): Boolean;
var
  Item: TViTextCacheItem;
  Text: string;
begin
  Result := False;
  Text := Format(aMsg, aArgs);
  for Item in FCache do
  begin
    if (Item.Text.Text = Text) and (Item.Text.Font = aFont) and (Item.X = aX)
      and (Item.Y = aY) and (Item.Align = aAlign) and (Item.Scale = aScale) and
      (Item.Angle = aAngle) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

constructor TViTextCache.Create;
begin
  inherited;
  FCache := TObjectList<TViTextCacheItem>.Create;
end;

destructor TViTextCache.Destroy;
begin
  Clear;
  FreeAndNil(FCache);
  inherited;
end;

procedure TViTextCache.Clear;
begin
  FCache.Clear;
end;

procedure TViTextCache.Print(aFont: TViFont; aX: Single; aY: Single;
  aAlign: TViAlign; aScale: Single; aAngle: Single;
  aColors: array of TViColor; const aMsg: string; const aArgs: array of const);
var
  Item: TViTextCacheItem;
begin
  if Cached(aFont, aX, aY, aAlign, aScale, aAngle, aMsg, aArgs) then
    Exit;
  Item := TViTextCacheItem.Create;
  Item.Print(aFont, aX, aY, aAlign, aScale, aAngle, aColors, aMsg, aArgs);
  FCache.Add(Item);
end;

procedure TViTextCache.Print(aFont: TViFont; aX: Single; var aY: Single;
  aLineSpace: Single; aAlign: TViAlign;
  aColors: array of TViColor; const aMsg: string; const aArgs: array of const);
begin
  Print(aFont, aX, aY, aAlign, 1, 0, aColors, aMsg, aArgs);
  aY := aY + aFont.GetLineHeight + aLineSpace;
end;

procedure TViTextCache.Render;
var
  Item: TViTextCacheItem;
begin
  for Item in FCache do
  begin
    Item.Render;
  end;
end;

end.

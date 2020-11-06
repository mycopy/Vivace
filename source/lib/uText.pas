{ =============================================================================
  Vivace™ Game Toolkit
  Copyright © tinyBigGAMES™ LLC
  All rights reserved.

  website: https://tinybiggames.com
  email  : support@tinybiggames.com
  ============================================================================ }

unit uText;

{$I defines.inc}

interface

uses
  System.Generics.Collections,
  uBitmap,
  uCommon,
  uColor,
  uMath,
  uFont;

type

  { TText }
  TText = class(TBaseObject)
  protected
    FBitmap: TBitmap;
    FText: string;
    FFont: TFont;
    procedure Clear;
  public
    property Text: string read FText;
    property Font: TFont read FFont;

    constructor Create; override;
    destructor Destroy; override;

    procedure Print(aFont: TFont; aColors: array of TColor; aText: string);
    procedure Render(aX: Single; aY: Single; aAlign: TAlign; aScale: Single;
      aAngle: Single);
  end;

  { TTextCacheItem }
  TTextCacheItem = class(TBaseObject)
  protected
    FText: TText;
    FX: Single;
    FY: Single;
    FAlign: TAlign;
    FScale: Single;
    FAngle: Single;
  public
    property Text: TText read FText;
    property X: Single read FX;
    property Y: Single read FY;
    property Align: TAlign read FAlign;
    property Scale: Single read FScale;
    property Angle: Single read FAngle;

    constructor Create; override;
    destructor Destroy; override;

    procedure Print(aFont: TFont; aX: Single; aY: Single; aAlign: TAlign;
      aScale: Single; aAngle: Single; aColors: array of TColor; aText: string);

    procedure Render;
  end;

  { TTextCache }
  TTextCache = class(TBaseObject)
  protected
    FPos: TVector;
    FCache: TObjectList<TTextCacheItem>;
    function Cached(aFont: TFont; aX: Single; aY: Single; aAlign: TAlign;
      aScale: Single; aAngle: Single; aText: string): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;

    procedure Print(aFont: TFont; aX: Single; aY: Single; aAlign: TAlign;
      aScale: Single; aAngle: Single; aColors: array of TColor;
      aText: string); overload;

    procedure Print(aFont: TFont; aX: Single; var aY: Single;
      aLineSpace: Single; aAlign: TAlign; aColors: array of TColor;
      aText: string); overload;

    procedure Render;
  end;

implementation

uses
  System.SysUtils,
  uEngine;

{ --- TText ----------------------------------------------------------------- }
procedure TText.Clear;
begin
  FBitmap.Unload;
  FText := '';
  FFont := nil;
end;

constructor TText.Create;
begin
  inherited;
  FBitmap := TBitmap.Create;
  FText := '';
  FFont := nil;
end;

destructor TText.Destroy;
begin
  FreeAndNil(FBitmap);
  inherited;
end;

procedure TText.Print(aFont: TFont; aColors: array of TColor; aText: string);
var
  X: Single;
  C: string;
  Text: string;
  TempText: string;
  TextWidth: Single;
  TextHeight: Single;
  Color: TColor;
  Mode: Integer;
  ColorCount: Integer;
  ColorIndex: Integer;
begin
  Text := aText;
  if (aText = FText) and (aFont = FFont) then
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

  TextWidth := aFont.GetTextWidth(TempText);
  TextHeight := aFont.GetLineHeight;

  Clear;
  FBitmap.Allocate(Round(TextWidth), Round(TextHeight));
  gEngine.Display.SetTarget(FBitmap);

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
    aFont.Print(X, 0, Color, alLeft, PChar(C));
    X := X + aFont.GetTextWidth(PChar(C));
  end;

  gEngine.Display.ResetTarget;

  FText := Text;
  FFont := aFont;
end;

procedure TText.Render(aX: Single; aY: Single; aAlign: TAlign; aScale: Single;
  aAngle: Single);
var
  Center: TVector;
  Scale: TVector;
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

  FBitmap.Draw(aX, aY, nil, @Center, @Scale, aAngle, WHITE, False, False);
end;

{ --- TTextCacheItem -------------------------------------------------------- }
constructor TTextCacheItem.Create;
begin
  inherited;
  FText := TText.Create;
  FX := 0;
  FY := 0;
  FAlign := alLeft;
  FScale := 0;
  FAngle := 0;
end;

destructor TTextCacheItem.Destroy;
begin
  FreeAndNil(FText);
  inherited;
end;

procedure TTextCacheItem.Print(aFont: TFont; aX: Single; aY: Single;
  aAlign: TAlign; aScale: Single; aAngle: Single; aColors: array of TColor;
  aText: string);
begin
  FText.Print(aFont, aColors, aText);
  FX := aX;
  FY := aY;
  FAlign := aAlign;
  FScale := aScale;
  FAngle := aAngle;
end;

procedure TTextCacheItem.Render;
begin
  FText.Render(FX, FY, FAlign, FScale, FAngle);
end;

{ --- TTextCache ------------------------------------------------------------ }
function TTextCache.Cached(aFont: TFont; aX: Single; aY: Single; aAlign: TAlign;
  aScale: Single; aAngle: Single; aText: string): Boolean;
var
  Item: TTextCacheItem;
begin
  Result := False;
  for Item in FCache do
  begin
    if (Item.Text.Text = aText) and (Item.Text.Font = aFont) and (Item.X = aX)
      and (Item.Y = aY) and (Item.Align = aAlign) and (Item.Scale = aScale) and
      (Item.Angle = aAngle) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

constructor TTextCache.Create;
begin
  inherited;
  FCache := TObjectList<TTextCacheItem>.Create;
end;

destructor TTextCache.Destroy;
begin
  Clear;
  FreeAndNil(FCache);
  inherited;
end;

procedure TTextCache.Clear;
begin
  FCache.Clear;
end;

procedure TTextCache.Print(aFont: TFont; aX: Single; aY: Single; aAlign: TAlign;
  aScale: Single; aAngle: Single; aColors: array of TColor; aText: string);
var
  Item: TTextCacheItem;
begin
  if Cached(aFont, aX, aY, aAlign, aScale, aAngle, aText) then
    Exit;
  Item := TTextCacheItem.Create;
  Item.Print(aFont, aX, aY, aAlign, aScale, aAngle, aColors, aText);
  FCache.Add(Item);
end;

procedure TTextCache.Print(aFont: TFont; aX: Single; var aY: Single;
  aLineSpace: Single; aAlign: TAlign; aColors: array of TColor; aText: string);
begin
  Print(aFont, aX, aY, aAlign, 1, 0, aColors, aText);
  aY := aY + aFont.GetLineHeight + aLineSpace;
end;

procedure TTextCache.Render;
var
  Item: TTextCacheItem;
begin
  for Item in FCache do
  begin
    Item.Render;
  end;
end;

end.

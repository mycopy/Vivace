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

unit Vivace.Font;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Color,
  Vivace.Common;

type

  { TViAlign }
  TViAlign = (alLeft = 0, alCenter = 1, alRight = 2);

  { TViFont }
  TViFont = class(TViBaseObject)
  protected
    FHandle: PALLEGRO_FONT;
    FFilename: string;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Load(aSize: Cardinal; aFilename: string); overload;
    procedure Load(aSize: Cardinal; aMemory: Pointer; aLength: Int64); overload;
    procedure Unload;
    procedure Print(aX: Single; aY: Single; aColor: TViColor; aAlign: TViAlign;
      const aMsg: string; const aArgs: array of const); overload;
    procedure Print(aX: Single; var aY: Single; aLineSpace: Single;
      aColor: TViColor; aAlign: TViAlign; const aMsg: string;
      const aArgs: array of const); overload;
    procedure Print(aX: Single; aY: Single; aColor: TViColor; aAngle: Single;
      const aMsg: string; const aArgs: array of const); overload;
    function GetTextWidth(const aMsg: string;
      const aArgs: array of const): Single;
    function GetLineHeight: Single;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Math,
  Vivace.Display,
  Vivace.Engine;

{ --- TViFont --------------------------------------------------------------- }
procedure TViFont.Unload;
begin
  if FHandle <> nil then
  begin
    al_destroy_font(FHandle);
    FHandle := nil;
    FFilename := '';
  end;
end;

constructor TViFont.Create;
begin
  inherited;
  FHandle := nil;
  Unload;
end;

destructor TViFont.Destroy;
begin
  Unload;
  inherited;
end;

procedure TViFont.Load(aSize: Cardinal; aFilename: string);
var
  FName: string;
  Size: Integer;
begin
  if aFilename.IsEmpty then
    Exit;
  FName := aFilename;
  Size := -aSize;
  if ViEngine.OS.FileExists(FName) then
  begin
    Unload;
    al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or
      ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
    FHandle := al_load_font(PAnsiChar(AnsiString(FName)), Size, 0);
    if FHandle <> nil then
    begin
      FFilename := FName;
    end
  end;
end;

procedure TViFont.Load(aSize: Cardinal; aMemory: Pointer; aLength: Int64);
var
  mf: PALLEGRO_FILE;
  Size: Integer;
begin
  mf := al_open_memfile(aMemory, aLength, 'rb');
  Size := -aSize;
  if mf <> nil then
  begin
    Unload;
    al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR or
      ALLEGRO_MIPMAP or ALLEGRO_VIDEO_BITMAP);
    FHandle := al_load_ttf_font_f(mf, '', aSize, 0);
    if FHandle <> nil then
    begin
      FFilename := 'MEMORYFILE';
    end

  end;

end;

procedure TViFont.Print(aX: Single; aY: Single; aColor: TViColor; aAlign: TViAlign;
  const aMsg: string; const aArgs: array of const);
var
  ustr: PALLEGRO_USTR;
  Text: string;
  Color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  Text := Format(aMsg, aArgs);
  if Text.IsEmpty then
    Exit;
  ustr := al_ustr_new_from_utf16(PUInt16(PChar(Text)));
  al_draw_ustr(FHandle, Color, aX, aY, Ord(aAlign) or
    ALLEGRO_ALIGN_INTEGER, ustr);
  al_ustr_free(ustr);
end;

procedure TViFont.Print(aX: Single; var aY: Single; aLineSpace: Single;
  aColor: TViColor; aAlign: TViAlign; const aMsg: string;
  const aArgs: array of const);
begin
  Print(aX, aY, aColor, aAlign, aMsg, aArgs);
  aY := aY + GetLineHeight + aLineSpace;
end;

function TViFont.GetTextWidth(const aMsg: string;
  const aArgs: array of const): Single;
var
  ustr: PALLEGRO_USTR;
  Text: string;
begin
  Result := 0;
  if FHandle = nil then
    Exit;
  Text := Format(aMsg, aArgs);
  if Text.IsEmpty then
    Exit;
  ustr := al_ustr_new_from_utf16(PUInt16(PChar(Text)));
  Result := al_get_ustr_width(FHandle, ustr);
  al_ustr_free(ustr);
end;

function TViFont.GetLineHeight: Single;
begin
  if FHandle = nil then
    Result := 0
  else
  begin
    Result := al_get_font_line_height(FHandle);
  end;
end;

procedure TViFont.Print(aX: Single; aY: Single; aColor: TViColor; aAngle: Single;
  const aMsg: string; const aArgs: array of const);
var
  ustr: PALLEGRO_USTR;
  Text: string;
  fx, fy: Single;
  tr: ALLEGRO_TRANSFORM;
  Color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  Text := Format(aMsg, aArgs);
  if Text.IsEmpty then
    Exit;
  fx := GetTextWidth(Text, []) / 2;
  fy := GetLineHeight / 2;
  al_identity_transform(@tr);
  al_translate_transform(@tr, -fx, -fy);
  al_rotate_transform(@tr, aAngle * VIDEG2RAD);
  ViEngine.Math.AngleRotatePos(aAngle, fx, fy);
  al_translate_transform(@tr, aX + fx, aY + fy);
  al_compose_transform(@tr, @ViEngine.Display.Trans);
  al_use_transform(@tr);
  ustr := al_ustr_new_from_utf16(PUInt16(PChar(Text)));
  al_draw_ustr(FHandle, Color, 0, 0, ALLEGRO_ALIGN_LEFT or
    ALLEGRO_ALIGN_INTEGER, ustr);
  al_ustr_free(ustr);
  al_use_transform(@ViEngine.Display.Trans);
end;

end.

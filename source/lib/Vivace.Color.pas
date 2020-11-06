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

unit Vivace.Color;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Common;

type

  { TViColor }
  PViColor = ^TViColor;
  TViColor = record
    Red: Single;
    Green: Single;
    Blue: Single;
    Alpha: Single;
  end;

function ViMakeColor(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte)
  : TViColor; overload; inline;

function ViMakeColor(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single)
  : TViColor; overload; inline;

function ViFadeColor(aTo: TViColor; aFrom: TViColor; aPos: Single): TViColor; inline;

function ViColorEqual(aColor1: TViColor; aColor2: TViColor): Boolean; inline;

function ViToAlColor(aColor: TViColor): ALLEGRO_COLOR; inline;

function ViFromAlColor(aColor: ALLEGRO_COLOR): TViColor; inline;

{$REGION 'Common Colors'}

var
  VILIGHTGRAY: TViColor;
  VIGRAY: TViColor;
  VIDARKGRAY: TViColor;
  VIYELLOW: TViColor;
  VIGOLD: TViColor;
  VIORANGE: TViColor;
  VIPINK: TViColor;
  VIRED: TViColor;
  VIMAROON: TViColor;
  VIGREEN: TViColor;
  VILIME: TViColor;
  VIDARKGREEN: TViColor;
  VISKYBLUE: TViColor;
  VIBLUE: TViColor;
  VIDARKBLUE: TViColor;
  VIPURPLE: TViColor;
  VIVIOLET: TViColor;
  VIDARKPURPLE: TViColor;
  VIBEIGE: TViColor;
  VIBROWN: TViColor;
  VIDARKBROWN: TViColor;
  VIWHITE: TViColor;
  VIBLACK: TViColor;
  VIBLANK: TViColor;
  VIMEGENTA: TViColor;
  VIWHITE2: TViColor;
  VIRED2: TViColor;
  VICOLORKEY: TViColor;
  VIOVERLAY1: TViColor;
  VIOVERLAY2: TViColor;
{$ENDREGION}

implementation

function ViToAlColor(aColor: TViColor): ALLEGRO_COLOR;
begin
  Result.r := aColor.Red;
  Result.g := aColor.Green;
  Result.b := aColor.Blue;
  Result.a := aColor.Alpha;
end;

function ViFromAlColor(aColor: ALLEGRO_COLOR): TViColor;
begin
  Result.Red := aColor.r;
  Result.Green := aColor.g;
  Result.Blue := aColor.b;
  Result.Alpha := aColor.a;
end;

function ViMakeColor(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TViColor;
begin
  Result := ViFromAlColor(al_map_rgba(aRed, aGreen, aBlue, aAlpha));
end;

function ViMakeColor(aRed: Single; aGreen: Single; aBlue: Single;
  aAlpha: Single): TViColor;
begin
  Result := ViFromAlColor(al_map_rgba_f(aRed, aGreen, aBlue, aAlpha));
end;

function ViFadeColor(aTo: TViColor; aFrom: TViColor; aPos: Single): TViColor;
var
  C: TViColor;
begin
  // clip to ranage 0.0 - 1.0
  if aPos < 0 then
    aPos := 0
  else if aPos > 1.0 then
    aPos := 1.0;

  // fade colors
  C.Alpha := aFrom.Alpha + ((aTo.Alpha - aFrom.Alpha) * aPos);
  C.Blue := aFrom.Blue + ((aTo.Blue - aFrom.Blue) * aPos);
  C.Green := aFrom.Green + ((aTo.Green - aFrom.Green) * aPos);
  C.Red := aFrom.Red + ((aTo.Red - aFrom.Red) * aPos);
  Result := ViMakeColor(C.Red, C.Green, C.Blue, C.Alpha);
end;

function ViColorEqual(aColor1: TViColor; aColor2: TViColor): Boolean;
begin
  if (aColor1.Red = aColor2.Red) and (aColor1.Green = aColor2.Green) and
    (aColor1.Blue = aColor2.Blue) and (aColor1.Alpha = aColor2.Alpha) then
    Result := True
  else
    Result := False;
end;

end.

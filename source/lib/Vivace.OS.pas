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

unit Vivace.OS;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Common;

type

  { TViOS }
  TViOS = class(TViBaseObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    function FileExists(aFilename: string): Boolean;
    function FileCount(aPath: string; aSearchMask: string): Integer;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Vivace.Allegro.API;


{ --- TViOS ----------------------------------------------------------------- }
constructor TViOS.Create;
begin
  inherited;
end;

destructor TViOS.Destroy;
begin
  inherited;
end;

function TViOS.FileExists(aFilename: string): Boolean;
begin
  Result := al_filename_exists(PAnsiChar(AnsiString(aFilename)));
end;

function TViOS.FileCount(aPath: string; aSearchMask: string): Integer;
var
  SearchRec: TSearchRec;
begin
  Result := 0;
  aPath := TPath.Combine(aPath, aSearchMask);
  if FindFirst(aPath, faAnyFile, SearchRec) = 0 then
    repeat
      if SearchRec.Attr <> faDirectory then
        Inc(Result);
    until FindNext(SearchRec) <> 0;
end;

end.

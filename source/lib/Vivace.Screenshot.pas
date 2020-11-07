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

unit Vivace.Screenshot;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Common;

type

  { TScreenshot }
  TViScreenshot = class(TViBaseObject)
  protected
    FFlag: Boolean;
    FDir: string;
    FBaseFilename: string;
    FFilename: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Process;

    procedure Init(aDir: string; aBaseFilename: string);
    procedure Take;
  end;

implementation

uses
  System.SysUtils,
  Vivace.Engine;

{ --- TdeScreenshot ---------------------------------------------------------- }
constructor TViScreenshot.Create;
begin
  inherited;
  FFlag := False;
  FFilename := '';
  FDir := 'Screenshots';
  FBaseFilename := 'Screen';
  Init('', '');
end;

destructor TViScreenshot.Destroy;
begin
  inherited;
end;

procedure TViScreenshot.Init(aDir: string; aBaseFilename: string);
var
  Dir: string;
  BaseFilename: string;
begin
  FFilename := '';
  FFlag := False;

  Dir := aDir;
  BaseFilename := aBaseFilename;

  if Dir.IsEmpty then
    Dir := 'Screenshots';
  FDir := Dir;

  if BaseFilename.IsEmpty then
    BaseFilename := 'Screen';
  FBaseFilename := BaseFilename;

  ChangeFileExt(FBaseFilename, '');
end;

procedure TViScreenshot.Take;
begin
  FFlag := True;
end;

procedure TViScreenshot.Process;
var
  c: Integer;
  f, d, b: string;
begin
  if ViEngine.Screenshake.Active then
    Exit;
  if not FFlag then
    Exit;
  FFlag := False;

  // director
  d := ExpandFilename(FDir);
  ForceDirectories(d);

  // base name
  b := FBaseFilename;

  // search file maks
  f := b + '*.png';

  // file count
  c := ViEngine.OS.FileCount(d, f);

  // screenshot file mask
  f := Format('%s\%s (%.3d).png', [d, b, c]);
  FFilename := f;

  // save screenshot
  ViEngine.Display.Save(f);
end;

end.

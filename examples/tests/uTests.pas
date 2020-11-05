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

unit uTests;

interface

procedure RunTests;

implementation

uses
  System.SysUtils,
  Vivace.Allegro.API,
  Vivace.Nuklear.API,
  Vivace.ENet.API,
  Vivace.Common,
  Vivace.Lua,
  Vivace.Speech;

procedure WaitForEnter;
begin
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
end;

procedure Test01;
begin
  WriteLn('Vivace ', cVivaceVersion);
  WaitForEnter;
end;

procedure Test02;
begin
  if al_init then
  begin
    WriteLn('Succesfully initialized Allegro');
    al_uninstall_system;
  end;
  WaitForEnter;
end;

procedure Test03;
var
  Ctx: nk_context;
begin
  if nk_init_default(@Ctx, nil) = 1 then
  begin
    WriteLn('Succesfully initialized Nuklear');
    nk_free(@Ctx);
  end;
  WaitForEnter;
end;

procedure Test04;
begin
  if enet_initialize = 0 then
  begin
    WriteLn('Succesfully initialized ENet');
    enet_deinitialize;
  end;
  WaitForEnter;
end;

procedure Test05;
var
  Lua: TViLua;
begin
  Lua := TViLua.Create;
  Lua.LoadString('print("Succesfully initialized " .. vivace.luaversion)');
  FreeAndNil(Lua);
  WaitForEnter;
end;

procedure Test06;
var
  Spk: TViSpeech;
  I: Integer;
  S: string;
  Say: string;
begin
  Say := 'Vivace Game Toolkit';
  Spk := TViSpeech.Create;
  WriteLn(Format('Found %d speech voices: ', [Spk.GetVoiceCount]));
  for I := 0 to  Spk.GetVoiceCount-1 do
  begin
    Spk.ChangeVoice(I);
    S := Spk.GetVoiceAttribute(I, vaDescription);
    WriteLn;
    WriteLn(Format('Voice #%d: %s', [I+1, S]));
    Spk.Speak('Vivace Game Toolkit', True);
    WaitForEnter;
  end;
  FreeAndNil(Spk);
end;

procedure RunTests;
begin
  Test01;  // Vivace version
  Test02;  // Init Allegro
  Test03;  // Init Nuklear
  Test04;  // Init ENet
  Test05;  // Init Lua
  Test06;  // Speech;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.

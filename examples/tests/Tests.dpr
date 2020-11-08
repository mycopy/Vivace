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

program Tests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uTests in 'uTests.pas',
  uTest02 in 'uTest02.pas',
  uTest01 in 'uTest01.pas',
  Vivace.Allegro.API in '..\..\source\lib\Vivace.Allegro.API.pas',
  Vivace.Bitmap in '..\..\source\lib\Vivace.Bitmap.pas',
  Vivace.Color in '..\..\source\lib\Vivace.Color.pas',
  Vivace.Common in '..\..\source\lib\Vivace.Common.pas',
  Vivace.Display in '..\..\source\lib\Vivace.Display.pas',
  Vivace.ENet.API in '..\..\source\lib\Vivace.ENet.API.pas',
  Vivace.Engine in '..\..\source\lib\Vivace.Engine.pas',
  Vivace.Game in '..\..\source\lib\Vivace.Game.pas',
  Vivace.Input in '..\..\source\lib\Vivace.Input.pas',
  Vivace.Lua.API in '..\..\source\lib\Vivace.Lua.API.pas',
  Vivace.Lua in '..\..\source\lib\Vivace.Lua.pas',
  Vivace.Math in '..\..\source\lib\Vivace.Math.pas',
  Vivace.Nuklear.API in '..\..\source\lib\Vivace.Nuklear.API.pas',
  Vivace.Speech in '..\..\source\lib\Vivace.Speech.pas',
  Vivace.SpeechLib.TLB in '..\..\source\lib\Vivace.SpeechLib.TLB.pas',
  Vivace.Timer in '..\..\source\lib\Vivace.Timer.pas',
  Vivace.Viewport in '..\..\source\lib\Vivace.Viewport.pas',
  Vivace.Text in '..\..\source\lib\Vivace.Text.pas',
  Vivace.Font in '..\..\source\lib\Vivace.Font.pas',
  Vivace.Video in '..\..\source\lib\Vivace.Video.pas',
  Vivace.Audio in '..\..\source\lib\Vivace.Audio.pas',
  Vivace.OS in '..\..\source\lib\Vivace.OS.pas',
  Vivace.Screenshake in '..\..\source\lib\Vivace.Screenshake.pas',
  Vivace.Screenshot in '..\..\source\lib\Vivace.Screenshot.pas',
  Vivace.Utils in '..\..\source\lib\Vivace.Utils.pas',
  Vivace.Starfield in '..\..\source\lib\Vivace.Starfield.pas',
  Vivace.Collision in '..\..\source\lib\Vivace.Collision.pas',
  Vivace.Polygon in '..\..\source\lib\Vivace.Polygon.pas',
  Vivace.PolyPointTrace in '..\..\source\lib\Vivace.PolyPointTrace.pas',
  Vivace.PolyPoint in '..\..\source\lib\Vivace.PolyPoint.pas',
  Vivace.Sprite in '..\..\source\lib\Vivace.Sprite.pas',
  Vivace.Entity in '..\..\source\lib\Vivace.Entity.pas',
  Vivace.IMGUI in '..\..\source\lib\Vivace.IMGUI.pas';

begin
  try
    RunTests;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

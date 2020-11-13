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

unit uEntity;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Input,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Engine,
  Vivace.Entity,
  Vivace.Display,
  uCommon;

const
  cDisplayTitle = 'Vivace: Entity Demo';

type

  { TEntityDemo }
  TEntityDemo = class(TCustomDemo)
  protected
    FExplo: TViEntity;
    FShip: TViEntity;
  public
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aTimer: TViTimer; aDeltaTime: Double); override;
    procedure OnClearDisplay; override;
    procedure OnShowDisplay; override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
  end;

implementation

uses
  System.SysUtils;

{ --- TEntityDemo ----------------------------------------------------------- }
procedure TEntityDemo.OnLoad;
begin
  inherited;
  Title := cDisplayTitle;
end;

procedure TEntityDemo.OnExit;
begin
  inherited;
end;

procedure TEntityDemo.OnStartup;
begin
  inherited;

  // init explosion sprite
  Sprite.LoadPage('arc/bitmaps/sprites/explosion.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 0, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 1, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 1, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 2, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 2, 64, 64);

  Sprite.AddImageFromGrid(0, 0, 0, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 1, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 2, 3, 64, 64);
  Sprite.AddImageFromGrid(0, 0, 3, 3, 64, 64);

  // init ship sprite
  Sprite.LoadPage('arc/bitmaps/sprites/ship.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(1, 1, 0, 0, 64, 64);
  Sprite.AddImageFromGrid(1, 1, 1, 0, 64, 64);
  Sprite.AddImageFromGrid(1, 1, 2, 0, 64, 64);
  Sprite.AddImageFromGrid(1, 1, 3, 0, 64, 64);



  // init explosion entity
  FExplo := TViEntity.Create;
  FExplo.Init(Sprite, 0);
  FExplo.SetFrameFPS(14);
  FExplo.SetScaleAbs(1);
  FExplo.SetPosAbs(cDisplayWidth/2, (cDisplayHeight/2)-64);

  // init ship entity
  FShip := TViEntity.Create;
  FShip.Init(Sprite, 1);
  FShip.SetFrameFPS(17);
  FShip.SetScaleAbs(1);
  FShip.SetPosAbs(cDisplayWidth/2, (cDisplayHeight/2)+64);

end;

procedure TEntityDemo.OnShutdown;
begin
  FreeAndNil(FExplo);
  FreeAndNil(FShip);
  inherited;
end;

procedure TEntityDemo.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  inherited;

  FExplo.NextFrame;
  FShip.NextFrame;
end;

procedure TEntityDemo.OnClearDisplay;
begin
  inherited;
end;

procedure TEntityDemo.OnShowDisplay;
begin
  inherited;
end;

procedure TEntityDemo.OnRender;
begin
  inherited;

  ViEngine.Display.SetBlendMode(bmAdditiveAlpha);
  FExplo.Render(0,0);
  ViEngine.Display.RestoreDefaultBlendMode;

  FShip.Render(0,0);

end;

procedure TEntityDemo.OnRenderGUI;
begin
  inherited;
end;

end.

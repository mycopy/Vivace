![](/images/logo.png)

![GitHub last commit](https://img.shields.io/github/last-commit/tinyBigGAMES/Vivace) ![GitHub contributors](https://img.shields.io/github/contributors/tinyBigGAMES/Vivace) ![GitHub stars](https://img.shields.io/github/stars/tinyBigGAMES/Vivace?style=social) ![GitHub forks](https://img.shields.io/github/forks/tinyBigGAMES/Vivace?style=social)

![Twitter Follow](https://img.shields.io/twitter/follow/tinyBigGAMES?style=social) 

# Welcome to Vivace
Vivace&trade; (ve'va'CHe) Game Toolkit is an SDK to allow easy, fast & fun 2D game development in [Delphi](https://www.embarcadero.com/products/delphi) on desktop PC's running Microsoft Windows® and uses Direct3D® or OpenGL for hardware accelerated rendering.

It's robust, designed for easy, fast & fun use an suitable for making all types of 2D games and other graphic simulations, You access the features from a simple and intuitive API, to allow you to rapidly and efficiently develop your graphics simulations. There is support for bitmaps, audio samples, streaming music, video playback, loading resources directly from a standard ZIP archive and much more.

## Features
- You interact with the toolkit via class objects and a thin OOP framework
- Archive (standard zip, mount/unmount)
- Display ( Direct3D/OpenGL, antialiasing, vsync, viewports, primitives, blending)
- Input (keyboard, mouse and joystick)
- Bitmap (color key transparency, scaling, rotation, flipped, titled)
- Video (ogv format, play, pause, rewind)
- Sprite (pages, groups, animation, polypoint collision)
- Entity (defined from a sprite, position, scale, rotation, collision)
- Actor (list, scene, statemachine)
- Audio (samples, streams)
- Speech (multiple voices, play, pause)
- Font (true type, scale, rotate, 3 builtin)
- Timing (time-based, frame elapsed, frame speed)
- Misc (screenshake, screenshot, starfied, colors)

## Minimum System Requirements
- Delphi 2010 or higher
- Microsoft Windows 10
- DirectX 9/OpenGL 3.3

## Installation
- Unzip the archive to a desired location.
- Add `installdir\bin` to your windows search path so the `vivace.dll` can be found or place them in same location as your project.
- Add `installdir\source\libs` to Delphi's library path so the toolkit source files can be found for any project or for a specific project add to projects search path.
- See examples in the `installdir\examples` for more information about usage. You can load all examples using the project group file located in the `installdir\source` folder.

## Deployment
In addition to your own project files, you will need to include `vivace.dll` in your distro.

## Known Issues
- This project is in active development so changes will be frequent 
- Documentation is WIP. They will continue to evolve
- More examples will continually be added

## A Tour of Vivace
### Game Object
You just have to derive a new class from the `TviGame` base class and override a few callback methods. You access the toolkit functionality from the classes in the various `Vivace.XXX` units.
```pascal
uses
  Vivace.Color,
  Vivace.Math,
  Vivace.Timer,
  Vivace.Input,
  Vivace.Font,
  Vivace.Font.Builtin,
  Vivace.Game,
  Vivace.Engine,
  uCommon;

const
  cArchiveFilename   = 'Data.arc';

  cDisplayTitle      = 'MyGame';
  cDisplayWidth      = 800;
  cDisplayHeight     = 480;
  cDisplayFullscreen = False;
  cDisplayAntiAlias  = True;
  cDisplayVSync      = True;
  cDisplayRenderAPI  = raDirect3D;  

type
  { TMyGame }
  TMyGame = class(TViGame)
  protected
    FConsoleFont: TViFont;
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
```
### How to use
A minimal implementation example:
```pascal
uses
  System.SysUtils;

{ TMyGame }
procedure TMyGame.OnLoad;
begin
  // mount archive file
  ViEngine.Mount(cArchiveFilename);
end;

procedure TMyGame.OnExit;
begin
  // unmount archive file
  ViEngine.Unmount(cArchiveFilename);
end;

procedure TMyGame.OnStartup;
begin
  // open display
  ViEngine.Display.Open(-1, -1, cDisplayWidth, cDisplayHeight,
    cDisplayFullscreen, cDisplayVSync, cDisplayAntiAlias, cDisplayRenderAPI,
    cDisplayTitle);

  // create console font
  FConsoleFont := ViFontLoadConsole(12);
end;

procedure TMyGame.OnShutdown;
begin
  // free console font
  FreeAndNil(FConsoleFont);

  // close display
  ViEngine.Display.Close;
end;

procedure TMyGame.OnUpdate(aTimer: TViTimer; aDeltaTime: Double);
begin
  // process input
  if ViEngine.Input.KeyboardPressed(KEY_ESCAPE) then
    ViEngine.Terminate := True;
end;

procedure TMyGame.OnClearDisplay;
begin
  // clear display
  ViEngine.Display.Clear(BLACK);
end;

procedure TMyGame.OnShowDisplay;
begin
  // show display
  ViEngine.Display.Show;
end;

procedure TMyGame.OnRender;
begin
end;

procedure TMyGame.OnRenderGUI;
var
  Pos: TViVector;
begin
  // assign hud start pos
  Pos.Assign(3,3);

  // display hud text
  FConsoleFont.Print(Pos.X, Pos.Y, 0, WHITE, alLeft,
    'fps %d', [ViEngine.FrameRate]);
  FConsoleFont.Print(Pos.X, Pos.Y, 0, GREEN, alLeft,
    'Esc - Quit', [ViEngine.FrameRate]);
end;
```
To run your game, call
```pascal
  ViRunGame(TMyGame);
```
See the examples for more information on usage.

## Download
You can download the source code of the current development version from the [git repository](https://github.com/tinyBigGAMES/Vivace/archive/main.zip).

## Support

Website: https://tinybiggames.com

E-mail : support@tinybiggames.com

[![Discord](https://img.shields.io/badge/chat-on_discord-7389D8.svg?logo=discord&logoColor=ffffff&labelColor=6A7EC2)](https://discord.gg/tPWjMwK)


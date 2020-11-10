![](/images/logo.png)

![GitHub last commit](https://img.shields.io/github/last-commit/tinyBigGAMES/Vivace) ![GitHub contributors](https://img.shields.io/github/contributors/tinyBigGAMES/Vivace) ![GitHub stars](https://img.shields.io/github/stars/tinyBigGAMES/Vivace?style=social) ![GitHub forks](https://img.shields.io/github/forks/tinyBigGAMES/Vivace?style=social)

![Twitter Follow](https://img.shields.io/twitter/follow/tinyBigGAMES?style=social) 

# Welcome to Vivace
Vivace&trade; (ve'va'CHe) Game Toolkit is an advanced 2D game development system for PC's running Microsoft Windows® and uses Direct3D® or OpenGL for hardware accelerated rendering.

It's robust, designed for easy, fast & fun use an suitable for making all types of 2D games and other graphic simulations, You access the features from a simple and intuitive API, to allow you to rapidly and efficiently develop your graphics simulations. There is support for buffers, bitmaps, audio samples, streaming music, video playback, loading resources directly from a standard ZIP archive and much more.

## Features
- Requires Delphi 2010 or higher
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

## A Tour of Vivace
### Game Object
You just have to derive a new class from `TviGame` class and override a few callback methods.
```pascal
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
The example of usage.
```pascal
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
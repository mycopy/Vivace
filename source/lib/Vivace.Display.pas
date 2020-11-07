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

unit Vivace.Display;

{$I Vivace.Defines.inc}

interface

uses
  System.SysUtils,
  System.Math,
  WinApi.Messages,
  VCL.Graphics,
  WinApi.Windows,
  Vivace.Allegro.API,
  Vivace.Common,
  Vivace.Math,
  Vivace.Viewport,
  Vivace.Color,
  Vivace.Bitmap;

const
  BLEND_ZERO = 0;
  BLEND_ONE = 1;
  BLEND_ALPHA = 2;
  BLEND_INVERSE_ALPHA = 3;
  BLEND_SRC_COLOR = 4;
  BLEND_DEST_COLOR = 5;
  BLEND_INVERSE_SRC_COLOR = 6;
  BLEND_INVERSE_DEST_COLOR = 7;
  BLEND_CONST_COLOR = 8;
  BLEND_INVERSE_CONST_COLOR = 9;
  BLEND_ADD = 0;
  BLEND_SRC_MINUS_DEST = 1;
  BLEND_DEST_MINUS_SRC = 2;

type

  { TBlendMode }
  TBlendMode = (bmPreMultipliedAlpha, bmNonPreMultipliedAlpha, bmAdditiveAlpha,
    bmCopySrcToDest, bmMultiplySrcAndDest);

  { TBlendModeColor }
  TBlendModeColor = (bcColorNormal, bcColorAvgSrcDest);

  { TRenderAPI }
  TRenderAPI = (raDirect3D, raOpenGL);

type
  { TViDisplay }
  TViDisplay = class(TViBaseObject)
  protected
    FHandle: PALLEGRO_DISPLAY;
    FLockRegion: PALLEGRO_LOCKED_REGION;
    FTrans: ALLEGRO_TRANSFORM;
    FTitle: string;
    FSize: TViRectangle;
    FTransSize: TViRectangle;
    FTransScale: Single;
    FIsFullscreen: Boolean;
    FViewport: TViViewport;
    FVSync: Boolean;
    FAntialias: Boolean;
    FRenderAPI: TRenderAPI;
    function TransformScale(aFullscreen: Boolean): Single;
    procedure LoadDefaultIcon;
    procedure OnClose;
  public
    property Handle: PALLEGRO_DISPLAY read FHandle;
    property Trans: ALLEGRO_TRANSFORM read FTrans;
    property Size: TViRectangle read FSize;
    property TransSize: TViRectangle read FTransSize;
    property TransScale: Single read FTransScale;
    property VSync: Boolean read FVSync;
    property Antialias: Boolean read FAntialias;
    property RenderAPI: TRenderAPI read FRenderAPI;

    constructor Create; override;
    destructor Destroy; override;

    procedure AlignToViewport(var aX: Single; var aY: Single);

    procedure Open(aPosX: Integer; aPosY: Integer; aWidth: Integer;
      aHeight: Integer; aFullscreen: Boolean; aVSync: Boolean;
      aAntiAlias: Boolean; aRenderAPI: TRenderAPI; aTitle: string);
    function Opened: Boolean;
    procedure Close;

    procedure SetIcon(aFilename: string; aColorKey: PViColor);

    function GetTitle: string;
    procedure SetTitle(aTitle: string);

    procedure SetPos(aX: Integer; aY: Integer);
    procedure GetPos(aX: PInteger; aY: PInteger);

    procedure GetSize(aWidth: PInteger; aHeight: PInteger);

    procedure ResetTransform;
    procedure SetTransformPosition(aX: Integer; aY: Integer);
    procedure SetTransformAngle(aAngle: Single);

    procedure SetViewport(aViewport: TViViewport);
    procedure GetViewportSize(aX: PInteger; aY: PInteger; aWidth: PInteger;
      aHeight: PInteger); overload;
    procedure GetViewportSize(var aSize: TViRectangle); overload;
    procedure ResetViewport;

    procedure Clear(aColor: TViColor);

    function Lock: Boolean;
    procedure Unlock;

    procedure SetPixel(aX: Single; aY: Single; aColor: TViColor);
    function GetPixel(aX: Single; aY: Single): TViColor;

    procedure DrawLine(aX1: Single; aY1: Single; aX2: Single; aY2: Single;
      aColor: TViColor; aThickness: Single);
    procedure DrawRectangle(aX: Single; aY: Single; aWidth: Single;
      aHeight: Single; aThickness: Single; aColor: TViColor);
    procedure DrawFilledRectangle(aX: Single; aY: Single; aWidth: Single;
      aHeight: Single; aColor: TViColor);
    procedure DrawCircle(aX: Single; aY: Single; aRadius: Single;
      aThickness: Single; aColor: TViColor);
    procedure DrawFilledCircle(aX: Single; aY: Single; aRadius: Single;
      aColor: TColor);

    procedure DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer;
      aThickness: Single; aColor: TViColor);
    procedure DrawFilledPolygon(aVertices: System.PSingle;
      aVertexCount: Integer; aColor: TViColor);

    procedure DrawTriangle(aX1: Single; aY1: Single; aX2: Single; aY2: Single;
      aX3: Single; aY3: Single; aThickness: Single; aColor: TViColor);
    procedure DrawFilledTriangle(aX1: Single; aY1: Single; aX2: Single;
      aY2: Single; aX3: Single; aY3: Single; aColor: TViColor);

    function IsFullscreen: Boolean;
    procedure ToggleFullscreen;
    procedure Show;

    procedure SetTarget(aBitmap: TViBitmap);
    procedure ResetTarget;

    procedure SetBlender(aOperation: Integer; aSource: Integer;
      aDestination: Integer);
    procedure GetBlender(aOperation: PInteger; aSource: PInteger;
      aDestination: PInteger);
    procedure SetBlendColor(aColor: TViColor);
    function GetBlendColor: TViColor;
    procedure SetBlendMode(aMode: TBlendMode);
    procedure SetBlendModeColor(aMode: TBlendModeColor; aColor: TViColor);
    procedure RestoreDefaultBlendMode;

    procedure Save(aFilename: string);
  end;

function GetRenderAPIName(aRenderAPI: TRenderAPI): string;

implementation

uses
  System.IOUtils,
  Vivace.Video,
  Vivace.Engine;

function GetRenderAPIName(aRenderAPI: TRenderAPI): string;
begin
  case aRenderAPI of
    raDirect3D:
      Result := 'Direct3D';
    raOpenGL:
      Result := 'OpenGL';
  else
    Result := '';
  end;
end;

{ TtbDisplay }

procedure TViDisplay.LoadDefaultIcon;
var
  wnd: HWND;
  hnd: THandle;
  ico: TIcon;
begin
  if FHandle = nil then
    Exit;
  hnd := GetModuleHandle(nil);
  if hnd <> 0 then
  begin
    if FindResource(hnd, 'MAINICON', RT_GROUP_ICON) <> 0 then
    begin
      ico := TIcon.Create;
      ico.LoadFromResourceName(hnd, 'MAINICON');
      wnd := al_get_win_window_handle(FHandle);
      SendMessage(wnd, WM_SETICON, ICON_BIG, ico.Handle);
      ico.Free;
    end;
  end;
end;

constructor TViDisplay.Create;
begin
  inherited;
  FHandle := nil;
  FLockRegion := nil;
  FViewport := nil;
  FVSync := False;
  FAntialias := False;
  FRenderAPI := raDirect3D;
  FTransScale := 1;
  al_identity_transform(@FTrans);
end;

destructor TViDisplay.Destroy;
begin
  Close;
  inherited;
end;

procedure TViDisplay.AlignToViewport(var aX: Single; var aY: Single);
var
  VP: TViRectangle;
begin
  self.GetViewportSize(VP);
  aX := VP.X + aX;
  aY := VP.Y + aY;
end;

procedure TViDisplay.Open(aPosX: Integer; aPosY: Integer; aWidth: Integer;
  aHeight: Integer; aFullscreen: Boolean; aVSync: Boolean; aAntiAlias: Boolean;
  aRenderAPI: TRenderAPI; aTitle: string);
var
  value: Integer;
  flags: Integer;
  PosX: Integer;
  PosY: Integer;
  // SW: TStopWatch;
  Title: string;

  procedure ShowHideWindow(aShow: Boolean);
  var
    wh: HWND;
  begin
    wh := al_get_win_window_handle(FHandle);
    if aShow then
      ShowWindow(wh, SW_SHOW)
    else
      ShowWindow(wh, SW_HIDE);
  end;

begin
  if FHandle = nil then
  begin
    ViEngine.OnOpenDisplay;

    Title := aTitle;

    flags := ALLEGRO_PROGRAMMABLE_PIPELINE;
    FSize.Assign(0, 0, aWidth, aHeight);
    if aVSync then
      value := 1
    else
      value := 2;
    al_set_new_display_option(ALLEGRO_VSYNC, value, ALLEGRO_SUGGEST);
    al_set_new_display_option(ALLEGRO_CAN_DRAW_INTO_BITMAP, 1, ALLEGRO_SUGGEST);

    PosX := ViEngine.DefaultWindowPos.X;
    PosY := ViEngine.DefaultWindowPos.Y;

    if aPosX > -1 then
      PosX := aPosX;
    if aPosY > -1 then
      PosY := aPosY;

    al_set_new_window_position(PosX, PosY);

    if not Title.IsEmpty then
      al_set_new_window_title(PAnsiChar(AnsiString(Title)));
    if aFullscreen then
      flags := flags or ALLEGRO_FULLSCREEN_WINDOW;
    al_set_new_display_flags(flags);
    FTitle := Title;
    if aAntiAlias then
    begin
      al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, 1, ALLEGRO_SUGGEST);
      al_set_new_display_option(ALLEGRO_SAMPLES, 8, ALLEGRO_SUGGEST);
    end
    else
    begin
      al_set_new_display_option(ALLEGRO_SAMPLE_BUFFERS, 0, ALLEGRO_SUGGEST);
      al_set_new_display_option(ALLEGRO_SAMPLES, 0, ALLEGRO_SUGGEST);
    end;

    case aRenderAPI of
      raDirect3D:
        al_set_new_display_flags(ALLEGRO_DIRECT3D_INTERNAL);
      raOpenGL:
        al_set_new_display_flags(ALLEGRO_OPENGL);
    end;

    // SW := TStopWatch.Create;
    // SW.Start;

    FHandle := al_create_display(aWidth, aHeight);
    // SW.Stop;
    // WriteLn('al_create_display timing:');
    // WriteLn(Format('   -milliseconds: %3.2f', [SW.TotalMilliseconds]));
    // WriteLn(Format('   -seconds     : %3.2f', [SW.TotalSeconds]));
    if FHandle <> nil then
    begin
      LoadDefaultIcon;
      TransformScale(aFullscreen);
      al_register_event_source(ViEngine.Queue,
        al_get_display_event_source(FHandle));
      FIsFullscreen := aFullscreen;
      FVSync := aVSync;
      FRenderAPI := aRenderAPI;

      var mi: ALLEGRO_MONITOR_INFO;
      al_get_monitor_info(0, @mi);
      var mw := mi.x2 - mi.x1;
      var mh := mi.y2 - mi.y1;
    end;

  end;
  // LoadDefaultIcon;
end;

function TViDisplay.Opened: Boolean;
begin
  Result := Boolean(FHandle <> nil);
end;

procedure TViDisplay.OnClose;
begin
  TViVideo.FreeAll;
  ViEngine.OnCloseDisplay;
end;

procedure TViDisplay.Close;
var
  wh: HWND;
begin
  if FHandle <> nil then
  begin
    OnClose;

    al_unregister_event_source(ViEngine.Queue,
      al_get_display_event_source(FHandle));

    // NOTE: hide window to prevent show default icon for a split second when
    // you have a custom icon set. It's annoying!!! Apparently, allegro restores
    // the defalt icon during destry.
    wh := al_get_win_window_handle(FHandle);
    ShowWindow(wh, SW_HIDE);

    al_destroy_display(FHandle);
    FHandle := nil;
  end;
end;

procedure TViDisplay.Clear(aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_clear_to_color(color);
end;

function TViDisplay.Lock: Boolean;
begin
  Unlock;
  FLockRegion := al_lock_bitmap(al_get_target_bitmap, ALLEGRO_PIXEL_FORMAT_ANY,
    ALLEGRO_LOCK_READWRITE);
  if FLockRegion <> nil then
    Result := True
  else
    Result := False;
end;

procedure TViDisplay.Unlock;
begin
  if FLockRegion <> nil then
  begin
    al_unlock_bitmap(al_get_target_bitmap);
    FLockRegion := nil;
  end;
end;

procedure TViDisplay.SetPixel(aX: Single; aY: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_pixel(aX, aY, color);
end;

function TViDisplay.GetPixel(aX: Single; aY: Single): TViColor;
var
  aResult: ALLEGRO_COLOR absolute Result;
begin
  if FHandle = nil then
    Exit;
  aResult := al_get_pixel(al_get_target_bitmap, Round(aX), Round(aY));
end;

procedure TViDisplay.DrawLine(aX1: Single; aY1: Single; aX2: Single; aY2: Single;
  aColor: TViColor; aThickness: Single);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_line(aX1, aY1, aX2, aY2, color, aThickness);
end;

procedure TViDisplay.DrawRectangle(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single; aThickness: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_rectangle(aX, aY, aX + aWidth, aY + aHeight, color, aThickness);
end;

procedure TViDisplay.DrawFilledRectangle(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_filled_rectangle(aX, aY, aX + aWidth, aY + aHeight, color);
end;

procedure TViDisplay.DrawCircle(aX: Single; aY: Single; aRadius: Single;
  aThickness: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_circle(aX, aY, aRadius, color, aThickness);
end;

procedure TViDisplay.DrawFilledCircle(aX: Single; aY: Single; aRadius: Single;
  aColor: TColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_filled_circle(aX, aY, aRadius, color);
end;

procedure TViDisplay.DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer;
  aThickness: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_polygon(WinApi.Windows.PSingle(aVertices), aVertexCount,
    ALLEGRO_LINE_JOIN_ROUND, color, aThickness, 1.0);
end;

procedure TViDisplay.DrawFilledPolygon(aVertices: System.PSingle;
  aVertexCount: Integer; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_filled_polygon(WinApi.Windows.PSingle(aVertices),
    aVertexCount, color);
end;

function TViDisplay.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TViDisplay.SetTitle(aTitle: string);
begin
  if FHandle <> nil then
  begin
    FTitle := aTitle;
    al_set_window_title(FHandle, PAnsiChar(AnsiString(FTitle)));
  end;
end;

function TViDisplay.TransformScale(aFullscreen: Boolean): Single;
var
  screen_x, screen_y: Integer;
  scale_x, scale_y: Single;
  clip_x, clip_y: Single;
  Scale: Single;
begin
  Result := 1;
  if FHandle = nil then
    Exit;

  screen_x := al_get_display_width(FHandle);
  screen_y := al_get_display_height(FHandle);

  if aFullscreen then
  begin
    scale_x := screen_x / FSize.Width;
    scale_y := screen_y / FSize.Height;
    Scale := min(scale_x, scale_y);
    clip_x := (screen_x - Scale * FSize.Width) / 2;
    clip_y := (screen_y - Scale * FSize.Height) / 2;
    al_build_transform(@FTrans, clip_x, clip_y, Scale, Scale, 0);
    al_use_transform(@FTrans);
    al_set_clipping_rectangle(Round(clip_x), Round(clip_y),
      Round(screen_x - 2 * clip_x), Round(screen_y - 2 * clip_y));
    FTransSize.Assign(clip_x, clip_y, screen_x - 2 * clip_x,
      screen_y - 2 * clip_y);
    Result := Scale;
    FTransScale := Scale;

  end
  else
  begin
    al_identity_transform(@FTrans);
    al_use_transform(@FTrans);
    al_set_clipping_rectangle(0, 0, Round(screen_x), Round(screen_y));
    FTransSize.Assign(0, 0, screen_x, screen_y);
    FTransScale := 1;
  end;
end;

function TViDisplay.IsFullscreen: Boolean;
begin
  Result := FIsFullscreen;
end;

procedure TViDisplay.ToggleFullscreen;
var
  flags: Integer;
  fullscreen: Boolean;
  MX, MY: Integer;
begin
  if FHandle = nil then
    Exit;
  ViEngine.Input.MouseGetInfo(@MX, @MY, nil);
  flags := al_get_display_flags(FHandle);
  fullscreen := Boolean(flags and
    ALLEGRO_FULLSCREEN_WINDOW = ALLEGRO_FULLSCREEN_WINDOW);
  fullscreen := not fullscreen;
  al_set_display_flag(FHandle, ALLEGRO_FULLSCREEN_WINDOW, fullscreen);
  TransformScale(fullscreen);
  FIsFullscreen := fullscreen;
  ViEngine.Input.MouseSetPos(MX, MY);

  ViEngine.OnToggleFullscreen(FIsFullscreen);
end;

procedure TViDisplay.Show;
begin
  if FHandle = nil then
    Exit;
  al_flip_display;
end;

procedure TViDisplay.SetTarget(aBitmap: TViBitmap);
begin
  if aBitmap <> nil then
  begin
    if aBitmap.Handle <> nil then
    begin
      al_set_target_bitmap(aBitmap.Handle);
    end;
  end;
end;

procedure TViDisplay.ResetTarget;
begin
  if FHandle = nil then
    Exit;
  al_set_target_backbuffer(FHandle);
end;

procedure TViDisplay.SetBlender(aOperation: Integer; aSource: Integer;
  aDestination: Integer);
begin
  if FHandle = nil then
    Exit;
  al_set_blender(aOperation, aSource, aDestination);
end;

procedure TViDisplay.GetBlender(aOperation: PInteger; aSource: PInteger;
  aDestination: PInteger);
begin
  if FHandle = nil then
    Exit;
  al_get_blender(aOperation, aSource, aDestination);
end;

procedure TViDisplay.SetBlendColor(aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_set_blend_color(color);
end;

function TViDisplay.GetBlendColor: TViColor;
var
  aResult: ALLEGRO_COLOR absolute Result;
begin
  aResult := al_get_blend_color;
end;

procedure TViDisplay.SetBlendMode(aMode: TBlendMode);
begin
  if FHandle = nil then
    Exit;

  case aMode of
    bmPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
      end;
    bmNonPreMultipliedAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA);
      end;

    bmAdditiveAlpha:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ONE);
      end;

    bmCopySrcToDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_ZERO);
      end;

    bmMultiplySrcAndDest:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_DEST_COLOR, ALLEGRO_ZERO)
      end;
  end;
end;

procedure TViDisplay.SetBlendModeColor(aMode: TBlendModeColor; aColor: TViColor);
begin
  if FHandle = nil then
    Exit;

  case aMode of
    bcColorNormal:
      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_ONE);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue,
          aColor.alpha));
      end;
    bcColorAvgSrcDest:

      begin
        al_set_blender(ALLEGRO_ADD, ALLEGRO_CONST_COLOR, ALLEGRO_CONST_COLOR);
        al_set_blend_color(al_map_rgba_f(aColor.red, aColor.green, aColor.blue,
          aColor.alpha));
      end;
  end;
end;

procedure TViDisplay.RestoreDefaultBlendMode;
begin
  if FHandle = nil then
    Exit;
  al_set_blender(ALLEGRO_ADD, ALLEGRO_ONE, ALLEGRO_INVERSE_ALPHA);
  // al_set_blender(ALLEGRO_ADD, ALLEGRO_ALPHA, ALLEGRO_INVERSE_ALPHA);

  al_set_blend_color(al_map_rgba(255, 255, 255, 255));

end;

procedure TViDisplay.SetIcon(aFilename: string; aColorKey: PViColor);
var
  bmp: TViBitmap;
begin
  if FHandle = nil then
    Exit;
  bmp := TViBitmap.Create;
  bmp.Load(aFilename, aColorKey);
  if bmp.Handle <> nil then
  begin
    al_set_display_icon(FHandle, bmp.Handle);
  end;
  FreeAndNil(bmp);
end;

procedure TViDisplay.ResetTransform;
begin
  if FHandle = nil then
    Exit;
  TransformScale(FIsFullscreen);
end;

procedure TViDisplay.SetTransformPosition(aX: Integer; aY: Integer);
var
  Trans: ALLEGRO_TRANSFORM;
begin
  if FHandle = nil then
    Exit;
  al_copy_transform(@Trans, al_get_current_transform);
  al_translate_transform(@Trans, aX, aY);
  al_use_transform(@Trans);
end;

procedure TViDisplay.SetTransformAngle(aAngle: Single);
var
  Trans: ALLEGRO_TRANSFORM;
  X, Y: Integer;
begin
  if FHandle = nil then
    Exit;
  X := al_get_display_width(FHandle);
  Y := al_get_display_height(FHandle);

  al_copy_transform(@Trans, al_get_current_transform);
  al_translate_transform(@Trans, -(X div 2), -(Y div 2));
  al_rotate_transform(@Trans, aAngle * VIDEG2RAD);
  al_translate_transform(@Trans, 0, 0);
  al_translate_transform(@Trans, X div 2, Y div 2);
  al_use_transform(@Trans);
end;

procedure TViDisplay.DrawTriangle(aX1: Single; aY1: Single; aX2: Single;
  aY2: Single; aX3: Single; aY3: Single; aThickness: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_triangle(aX1, aY1, aX2, aY2, aX3, aY3, color, aThickness);
end;

procedure TViDisplay.DrawFilledTriangle(aX1: Single; aY1: Single; aX2: Single;
  aY2: Single; aX3: Single; aY3: Single; aColor: TViColor);
var
  color: ALLEGRO_COLOR absolute aColor;
begin
  if FHandle = nil then
    Exit;
  al_draw_filled_triangle(aX1, aY1, aX2, aY2, aX3, aY3, color);
end;

procedure TViDisplay.GetSize(aWidth: PInteger; aHeight: PInteger);
begin
  if FHandle = nil then
    Exit;
  if aWidth <> nil then
    aWidth^ := Round(FSize.Width);

  if aHeight <> nil then
    aHeight^ := Round(FSize.Height);
end;

procedure TViDisplay.Save(aFilename: string);
var
  backbuffer: PALLEGRO_BITMAP;
  screenshot: PALLEGRO_BITMAP;
  vx, vy, vw, vh: Integer;
  fn: string;
begin
  if FHandle = nil then
    Exit;

  // get viewport size
  vx := Round(FTransSize.X);
  vy := Round(FTransSize.Y);
  vw := Round(FTransSize.Width);
  vh := Round(FTransSize.Height);

  // create screenshot bitmpat
  al_set_new_bitmap_flags(ALLEGRO_MIN_LINEAR or ALLEGRO_MAG_LINEAR);
  screenshot := al_create_bitmap(vw, vh);

  // exit if failed to create screenshot bitmap
  if screenshot = nil then
    Exit;

  // get backbuffer
  backbuffer := al_get_backbuffer(FHandle);

  // set target to screenshot bitmap
  al_set_target_bitmap(screenshot);

  // draw viewport area of backbuffer to screenshot bitmap
  al_draw_bitmap_region(backbuffer, vx, vy, vw, vh, 0, 0, 0);

  // restore backbuffer target
  al_set_target_bitmap(backbuffer);

  // make sure filename is a PNG file
  fn := aFilename;
  fn := TPath.ChangeExtension(fn, 'png');

  // save screen bitmap to PNG filename
  ViEngine.EnablePhysFS(False);
  al_save_bitmap(PAnsiChar(AnsiString(fn)), screenshot);
  ViEngine.EnablePhysFS(True);

  // destroy screenshot bitmap
  al_destroy_bitmap(screenshot);
end;

// TODO: handle case where viewport object is destroyed
// while still being active, FViewport will then be
// invalid. A possible solution would be to have a parent
// in TViewport and if its destroyed then let parent know
// so it can take appropriet action
// UPDATE: now what I do is if the current view is about
// to be destroyed, if its active, it call SetViewport(nil)
// to deactivate before its released to set the viewport
// back to full screen.
procedure TViDisplay.SetViewport(aViewport: TViViewport);
begin
  if FHandle = nil then
    Exit;

  if aViewport <> nil then
  begin
    // check if same as current
    if FViewport = aViewport then
      Exit
    else
    // setting a new viewport when one is current
    begin
      // set to not active to show it
      if FViewport <> nil then
      begin
        FViewport.SetActive(False);
      end;
    end;

    FViewport := aViewport;
    FViewport.SetActive(True);
  end
  else
  begin
    if FViewport <> nil then
    begin
      FViewport.SetActive(False);
      FViewport := nil;
    end;
  end;
end;

procedure TViDisplay.ResetViewport;
begin
  if FHandle = nil then
    Exit;
  if FViewport <> nil then
  begin
    FViewport.SetActive(False);
  end;
end;

procedure TViDisplay.GetViewportSize(aX: PInteger; aY: PInteger; aWidth: PInteger;
  aHeight: PInteger);
begin
  if FHandle = nil then
    Exit;

  if FViewport <> nil then
  begin
    FViewport.GetSize(aX, aY, aWidth, aHeight);
  end
  else
  begin
    if aX <> nil then
      aX^ := 0;
    if aY <> nil then
      aY^ := 0;
    GetSize(aWidth, aHeight);
  end;
end;

procedure TViDisplay.GetViewportSize(var aSize: TViRectangle);
var
  vx, vy, vw, vh: Integer;
begin
  GetViewportSize(@vx, @vy, @vw, @vh);
  aSize.Assign(vx, vy, vw, vh);
end;

procedure TViDisplay.SetPos(aX: Integer; aY: Integer);
begin
  if FHandle = nil then
    Exit;
  al_set_window_position(FHandle, aX, aY);
end;

procedure TViDisplay.GetPos(aX: PInteger; aY: PInteger);
begin
  if FHandle = nil then
    Exit;
  al_get_window_position(FHandle, aX, aY);
end;

end.

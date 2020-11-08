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
unit Vivace.IMGUI;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Allegro.API,
  Vivace.Nuklear.API,
  Vivace.Font,
  Vivace.Color,
  Vivace.Common;

const
  IMGUI_EDIT_BUFFER_LEN = (1024*1024);

  IMGUI_THEME_DEFAULT = 0;
  IMGUI_THEME_WHITE   = 1;
  IMGUI_THEME_RED     = 2;
  IMGUI_THEME_BLUE    = 3;
  IMGUI_THEME_DARK    = 4;

  IMGUI_EDIT_FILTER_DEFAULT = 0;
  IMGUI_EDIT_FILTER_ASCII = 1;
  IMGUI_EDIT_FILTER_FLOAT = 2;
  IMGUI_EDIT_FILTER_DECIMAL = 3;
  IMGUI_EDIT_FILTER_HEX = 4;
  IMGUI_EDIT_FILTER_OCT = 5;
  IMGUI_EDIT_FILTER_BINARY = 6;

  IMGUI_WINDOW_BORDER = 1;
  IMGUI_WINDOW_MOVABLE = 2;
  IMGUI_WINDOW_SCALABLE = 4;
  IMGUI_WINDOW_CLOSABLE = 8;
  IMGUI_WINDOW_MINIMIZABLE = 16;
  IMGUI_WINDOW_NO_SCROLLBAR = 32;
  IMGUI_WINDOW_TITLE = 64;
  IMGUI_WINDOW_SCROLL_AUTO_HIDE = 128;
  IMGUI_WINDOW_BACKGROUND = 256;
  IMGUI_WINDOW_SCALE_LEFT = 512;
  IMGUI_WINDOW_NO_INPUT = 1024;


type

  { TIMGUI }
  TViIMGUI = class(TViBaseObject)
  protected
    FCtx: nk_context;
    FFont: TViFont;
    FUserFont: nk_user_font;
    FEditBuffer: array of UTF8Char;
  public
    property Font: TViFont read FFont;
    constructor Create; override;
    destructor Destroy; override;

    procedure InputBegin;
    procedure HandleEvent(ev: ALLEGRO_EVENT);
    procedure InputEnd;
    procedure Render;
    procedure Clear;


    function Open(aFontSize: Integer; aFontFilename: string): Boolean;
    procedure Close;

    function WindowBegin(aName: string; aTitle: string; aX: Single; aY: Single;
      aWidth: Single; aHeight: Single; aFlags: array of cardinal): Boolean;
    procedure WindowEnd;

    procedure LayoutRowStatic(aHeight: Single; aWidth: Integer;
      aColumns: Integer);
    procedure LayoutRowDynamic(aHeight: Single; aColumns: Integer);
    procedure LayoutRowBegin(aFormat: Integer; aHeight: Single;
      aColumns: Integer);
    procedure LayoutRowPush(aValue: Single);
    procedure LayoutRowEnd;

    procedure Button(aTitle: string);
    function Option(aTitle: string; aActive: Boolean): Boolean;
    procedure &Label(aTitle: string; aAlign: Integer);
    function Slider(aMin: Single; aMax: Single; aStep: Single;
      var aValue: Single): Boolean;
    function Checkbox(aLabel: string; var aActive: Boolean): Boolean;
    function Combobox(aItems: array of string; aSelected: Integer;
      aItemHeight: Integer; aWidth: Single; aHeight: Single; var aChanged: Boolean): Integer;
    function Edit(aType: Cardinal; aFilter: Integer; var aBuffer: string): Integer;
    function Value(aName: string; aValue: Integer; aMin: Integer; aMax: Integer;
      aStep: Integer; aIncPerPixel: Single): Integer; overload;

    function Value(aName: string; aValue: Double; aMin: Double; aMax: Double;
      aStep: Double; aIncPerPixel: Single): Double; overload;
    function Progress(aCurrent: Cardinal; aMax: Cardinal; aModifyable: Boolean): Cardinal;
    procedure SetStyle(aTheme: Integer);
  end;

implementation

uses
  System.SysUtils,
  Vivace.Math,
  Vivace.Engine;

function get_font_width(handle: nk_handle; height: Single;
  const text: PAnsiChar; len: Integer): Single; cdecl;
var
  Font: TViFont;
  Buff: PAnsiChar;
  S: AnsiString;
begin
  GetMem(Buff, len + 1);
  Buff[len] := #0;
  StrLCopy(Buff, text, len);
  S := AnsiString(Buff);
  Font := TViFont(handle.ptr);
  Result := Font.GetTextWidth(string(S), []);
  FreeMem(Buff, len + 1);
end;

function nk_color_to_allegro_color(color: nk_color): ALLEGRO_COLOR;
begin
  Result := al_map_rgba(color.r, color.g, color.b, color.a);
end;

function nk_color_to_color(color: nk_color): TViColor;
begin
  Result := ViColorMake(color.r, color.g, color.b, color.a);
end;

{ --- TIMGUI ---------------------------------------------------------------- }
procedure TViIMGUI.HandleEvent(ev: ALLEGRO_EVENT);
var
  v2: nk_vec2;
  pos: TViVector;

begin
  case ev.&type of
    ALLEGRO_EVENT_MOUSE_AXES:
      begin
        ViEngine.Input.MouseGetInfo(pos);
        nk_input_motion(@FCtx, round(pos.x), round(pos.y));
        if (ev.mouse.dz <> 0) then
        begin
          v2.x := 0;
          // v2.y := ev.mouse.dz / al_get_mouse_wheel_precision;
          v2.y := pos.Z / al_get_mouse_wheel_precision;
          nk_input_scroll(@FCtx, v2);
        end;

      end;

    ALLEGRO_EVENT_MOUSE_BUTTON_DOWN, ALLEGRO_EVENT_MOUSE_BUTTON_UP:
      begin
        var
          Button: Integer := NK_BUTTON_LEFT;
        var
          down: Integer := 0;
        if ev.&type = ALLEGRO_EVENT_MOUSE_BUTTON_DOWN then
          down := 1;
        if (ev.mouse.Button = 2) then
          Button := NK_BUTTON_RIGHT
        else if (ev.mouse.Button = 3) then
          Button := NK_BUTTON_MIDDLE;
        ViEngine.Input.MouseGetInfo(pos);
        nk_input_button(@FCtx, Button, round(pos.x), round(pos.y), down);
      end;

    ALLEGRO_EVENT_TOUCH_BEGIN, ALLEGRO_EVENT_TOUCH_END:
      begin

      end;

    ALLEGRO_EVENT_TOUCH_MOVE:
      begin

      end;

    ALLEGRO_EVENT_KEY_DOWN, ALLEGRO_EVENT_KEY_UP:
      begin
        var
          kc: Integer := ev.keyboard.keycode;
        var
          down: Integer := 0;
        if ev.&type = ALLEGRO_EVENT_KEY_DOWN then
          down := 1;

        if (kc = ALLEGRO_KEY_LSHIFT) or (kc = ALLEGRO_KEY_RSHIFT) then
          nk_input_key(@FCtx, NK_KEY_SHIFT, down)
        else if (kc = ALLEGRO_KEY_DELETE) then
          nk_input_key(@FCtx, NK_KEY_DEL, down)
        else if (kc = ALLEGRO_KEY_ENTER) then
          nk_input_key(@FCtx, NK_KEY_ENTER, down)
        else if (kc = ALLEGRO_KEY_TAB) then
          nk_input_key(@FCtx, NK_KEY_TAB, down)
        else if (kc = ALLEGRO_KEY_LEFT) then
          nk_input_key(@FCtx, NK_KEY_LEFT, down)
        else if (kc = ALLEGRO_KEY_RIGHT) then
          nk_input_key(@FCtx, NK_KEY_RIGHT, down)
        else if (kc = ALLEGRO_KEY_UP) then
          nk_input_key(@FCtx, NK_KEY_UP, down)
        else if (kc = ALLEGRO_KEY_DOWN) then
          nk_input_key(@FCtx, NK_KEY_DOWN, down)
        else if (kc = ALLEGRO_KEY_BACKSPACE) then
          nk_input_key(@FCtx, NK_KEY_BACKSPACE, down)
        else if (kc = ALLEGRO_KEY_ESCAPE) then
          nk_input_key(@FCtx, NK_KEY_TEXT_RESET_MODE, down)
        else if (kc = ALLEGRO_KEY_PGUP) then
          nk_input_key(@FCtx, NK_KEY_SCROLL_UP, down)
        else if (kc = ALLEGRO_KEY_PGDN) then
          nk_input_key(@FCtx, NK_KEY_SCROLL_DOWN, down)
        else if (kc = ALLEGRO_KEY_HOME) then
        begin
          nk_input_key(@FCtx, NK_KEY_TEXT_START, down);
          nk_input_key(@FCtx, NK_KEY_SCROLL_START, down);
        end
        else if (kc = ALLEGRO_KEY_END) then
        begin
          nk_input_key(@FCtx, NK_KEY_TEXT_END, down);
          nk_input_key(@FCtx, NK_KEY_SCROLL_END, down);
        end;

      end;

    ALLEGRO_EVENT_KEY_CHAR:
      begin
        var
          kc: Integer := ev.keyboard.keycode;
        var
          control_mask: Integer :=
            (ev.keyboard.modifiers and ALLEGRO_KEYMOD_CTRL) or
            (ev.keyboard.modifiers and ALLEGRO_KEYMOD_COMMAND);

        if (kc = ALLEGRO_KEY_C and control_mask) then
          nk_input_key(@FCtx, NK_KEY_COPY, 1)
        else if (kc = ALLEGRO_KEY_V and control_mask) then
          nk_input_key(@FCtx, NK_KEY_PASTE, 1)
        else if (kc = ALLEGRO_KEY_X and control_mask) then
          nk_input_key(@FCtx, NK_KEY_CUT, 1)
        else if (kc = ALLEGRO_KEY_Z and control_mask) then
          nk_input_key(@FCtx, NK_KEY_TEXT_UNDO, 1)
        else if (kc = ALLEGRO_KEY_R and control_mask) then
          nk_input_key(@FCtx, NK_KEY_TEXT_REDO, 1)
        else if (kc = ALLEGRO_KEY_A and control_mask) then
          nk_input_key(@FCtx, NK_KEY_TEXT_SELECT_ALL, 1)
        else
        begin
          if (kc <> ALLEGRO_KEY_BACKSPACE) and (kc <> ALLEGRO_KEY_LEFT) and
            (kc <> ALLEGRO_KEY_RIGHT) and (kc <> ALLEGRO_KEY_UP) and
            (kc <> ALLEGRO_KEY_DOWN) and (kc <> ALLEGRO_KEY_HOME) and
            (kc <> ALLEGRO_KEY_DELETE) and (kc <> ALLEGRO_KEY_ENTER) and
            (kc <> ALLEGRO_KEY_END) and (kc <> ALLEGRO_KEY_ESCAPE) and
            (kc <> ALLEGRO_KEY_PGDN) and (kc <> ALLEGRO_KEY_PGUP) then
            nk_input_unicode(@FCtx, ev.keyboard.unichar);
        end;
      end;

  end;
end;

constructor TViIMGUI.Create;
begin
  inherited;
end;

destructor TViIMGUI.Destroy;
begin
  inherited;
end;

function TViIMGUI.Open(aFontSize: Integer; aFontFilename: string): Boolean;
begin
  SetLength(FEditBuffer, IMGUI_EDIT_BUFFER_LEN);
  FFont := TViFont.Create;
  FFont.Load(aFontSize, aFontFilename);
  FUserFont.userdata.ptr := FFont;
  FUserFont.height := FFont.GetLineHeight;
  FUserFont.width := get_font_width;
  if nk_init_default(@FCtx, @FUserFont) = 1 then
    Result := True
  else
    Result := False;
end;

procedure TViIMGUI.Close;
begin
  nk_free(@FCtx);
  FreeAndNil(FFont);
  FEditBuffer := nil;
end;

function TViIMGUI.WindowBegin(aName: string; aTitle: string; aX: Single; aY: Single;
  aWidth: Single; aHeight: Single; aFlags: array of cardinal): Boolean;
var
  Flags: cardinal;
  Flag: cardinal;
begin
  Flags := 0;
  for Flag in aFlags do
  begin
    Flags := Flags or Flag;
  end;
  Result := Boolean(nk_begin_titled(@FCtx, PAnsiChar(AnsiString(aName)),
    PAnsiChar(AnsiString(aTitle)), nk_rect_(aX, aY, aWidth, aHeight), Flags));
end;

procedure TViIMGUI.WindowEnd;
begin
  nk_end(@FCtx);
end;

procedure TViIMGUI.LayoutRowStatic(aHeight: Single; aWidth: Integer;
  aColumns: Integer);
begin
  nk_layout_row_static(@FCtx, aHeight, aWidth, aColumns);
end;

procedure TViIMGUI.LayoutRowDynamic(aHeight: Single; aColumns: Integer);
begin
  nk_layout_row_dynamic(@FCtx, aHeight, aColumns);
end;

procedure TViIMGUI.LayoutRowBegin(aFormat: Integer; aHeight: Single;
  aColumns: Integer);
begin
  nk_layout_row_begin(@FCtx, aFormat, aHeight, aColumns);
end;

procedure TViIMGUI.LayoutRowPush(aValue: Single);
begin
  nk_layout_row_push(@FCtx, aValue);
end;

procedure TViIMGUI.LayoutRowEnd;
begin
  nk_layout_row_end(@FCtx);
end;

procedure TViIMGUI.Button(aTitle: string);
begin
  nk_button_label(@FCtx, PAnsiChar(AnsiString(aTitle)));
end;

function TViIMGUI.Option(aTitle: string; aActive: Boolean): Boolean;
begin
  Result := Boolean(nk_option_label(@FCtx, PAnsiChar(AnsiString(aTitle)),
    Ord(aActive)));
end;

procedure TViIMGUI.&Label(aTitle: string; aAlign: Integer);
begin
  nk_label(@FCtx, PAnsiChar(AnsiString(aTitle)), aAlign);
end;

function TViIMGUI.Slider(aMin: Single; aMax: Single; aStep: Single;
  var aValue: Single): Boolean;
begin
  Result := Boolean(nk_slider_float(@FCtx, aMin, @aValue, aMax, aStep));
end;

function TViIMGUI.Checkbox(aLabel: string; var aActive: Boolean): Boolean;
var
  Active: Integer;
begin
  Active := Ord(aActive);
  Result := Boolean(nk_checkbox_label(@FCtx, PAnsiChar(AnsiString(aLabel)),
    @Active));
  aActive := Boolean(Active);
end;

function TViIMGUI.Combobox(aItems: array of string; aSelected: Integer;
  aItemHeight: Integer; aWidth: Single; aHeight: Single; var aChanged: Boolean): Integer;
var
  Items: array of AnsiString;
  Item: string;
  Size: nk_vec2;
  Count: Integer;
  I: Integer;
  Sel: Integer;
begin
  Count := Length(aItems);
  SetLength(Items, Count);
  I := 0;
  for Item in aItems do
  begin
    Items[I] := AnsiString(Item);
    Inc(I);
  end;
  Size.x := aWidth;
  Size.y := aHeight;
  //Result := nk_combo(@FCtx, @Items, Count, aSelected, aItemHeight, Size);
  Result := nk_combo(@FCtx, PPUTF8Char(@Items[0]), Count, aSelected, aItemHeight, Size);
  if Result <> aSelected then
    aChanged := True
  else
    aChanged := False;
  Items := nil;
end;

function TViIMGUI.Edit(aType: Cardinal; aFilter: Integer; var aBuffer: string): Integer;
var
  Buffer: UTF8String;
  Len: Integer;
  Filter: nk_plugin_filter;
begin
  Buffer := UTF8String(aBuffer);
  StrLCopy(PUTF8Char(@FEditBuffer[0]), PUTF8Char(Buffer), IMGUI_EDIT_BUFFER_LEN);
  case aFilter of
    IMGUI_EDIT_FILTER_DEFAULT: Filter := nk_filter_default;
    IMGUI_EDIT_FILTER_ASCII: Filter := nk_filter_ascii;
    IMGUI_EDIT_FILTER_FLOAT: Filter := nk_filter_float;
    IMGUI_EDIT_FILTER_DECIMAL: Filter := nk_filter_decimal;
    IMGUI_EDIT_FILTER_HEX: Filter := nk_filter_hex;
    IMGUI_EDIT_FILTER_OCT: Filter := nk_filter_oct;
    IMGUI_EDIT_FILTER_BINARY: Filter := nk_filter_binary;
  else
    Filter := nk_filter_default;
  end;
  Result := nk_edit_string_zero_terminated(@FCtx, aType, PUTF8Char(@FEditBuffer[0]),
    IMGUI_EDIT_BUFFER_LEN-1, Filter);
  Len := StrLen(PUTF8Char(@FEditBuffer[0]));
  if Len > 0 then
    begin
      SetLength(Buffer, Len);
      StrLCopy(PUTF8Char(Buffer), @FEditBuffer[0], Len);
      aBuffer := string(Buffer);
    end
  else
    aBuffer := '';
end;

function TViIMGUI.Value(aName: string; aValue: Integer; aMin: Integer; aMax: Integer;
  aStep: Integer; aIncPerPixel: Single): Integer;
begin
  Result := nk_propertyi(@FCtx, PAnsiChar(AnsiString(aName)), aMin, aValue,
    aMax, aStep, aIncPerPixel);
end;


function TViIMGUI.Value(aName: string; aValue: Double; aMin: Double; aMax: Double;
  aStep: Double; aIncPerPixel: Single): Double;
begin
  Result := nk_propertyd(@FCtx, PAnsiChar(AnsiString(aName)), aMin, aValue,
    aMax, aStep, aIncPerPixel);
end;

function TViIMGUI.Progress(aCurrent: Cardinal; aMax: Cardinal; aModifyable: Boolean): Cardinal;
begin
  Result := nk_prog(@FCtx, aCurrent, aMax, Ord(aModifyable));
end;

procedure TViIMGUI.InputBegin;
begin
  nk_input_begin(@FCtx);
end;

procedure TViIMGUI.InputEnd;
begin
  nk_input_end(@FCtx);
end;

procedure TViIMGUI.Clear;
begin
  nk_clear(@FCtx);
end;

procedure TViIMGUI.Render;
var
  cmd: pnk_command;
  color: ALLEGRO_COLOR;
  vertices: array of Single;
  points: array [0 .. 7] of Single;
begin
  cmd := nk__begin(@FCtx);
  while cmd <> nil do
  begin
    case cmd.&type of
      _NK_COMMAND_NOP:
        begin
        end;

      _NK_COMMAND_SCISSOR:
        begin
          var
            c: Pnk_command_scissor := Pnk_command_scissor(cmd);
          var
            cx, cy, cw, ch, scale: Single;
          scale := ViEngine.Display.TransScale;
          cx := (c.x * scale) + ViEngine.Display.TransSize.x;
          cy := (c.y * scale) + ViEngine.Display.TransSize.y;
          cw := (c.w * scale);
          ch := (c.h * scale);
          al_set_clipping_rectangle(round(cx), round(cy), round(cw), round(ch));
        end;

      _NK_COMMAND_LINE:
        begin
          var
            c: Pnk_command_line := Pnk_command_line(cmd);
          color := nk_color_to_allegro_color(c.color);
          al_draw_line(c.&begin.x, c.&begin.y, c.&end.x, c.&end.y, color,
            c.line_thickness);
        end;

      _NK_COMMAND_RECT:
        begin
          var
            c: Pnk_command_rect := Pnk_command_rect(cmd);
          color := nk_color_to_allegro_color(c.color);
          al_draw_rounded_rectangle(c.x, c.y, (c.x + c.w), (c.y + c.h),
            c.rounding, c.rounding, color, c.line_thickness);
        end;

      _NK_COMMAND_RECT_FILLED:
        begin
          var
            c: Pnk_command_rect_filled := Pnk_command_rect_filled(cmd);
          color := nk_color_to_allegro_color(c.color);
          al_draw_filled_rounded_rectangle(c.x, c.y, (c.x + c.w), (c.y + c.h),
            c.rounding, c.rounding, color);
        end;

      _NK_COMMAND_CIRCLE:
        begin
          var
            c: Pnk_command_circle := Pnk_command_circle(cmd);
          color := nk_color_to_allegro_color(c.color);
          var
            xr: Single := c.w / 2;
          var
            yr: Single := c.h / 2;
          al_draw_ellipse(c.x + xr, c.y + yr, xr, yr, color, c.line_thickness);
        end;

      _NK_COMMAND_CIRCLE_FILLED:
        begin
          var
            c: Pnk_command_circle_filled := Pnk_command_circle_filled(cmd);
          color := nk_color_to_allegro_color(c.color);
          var
            xr: Single := c.w / 2;
          var
            yr: Single := c.h / 2;
          al_draw_filled_ellipse(c.x + xr, c.y + yr, xr, yr, color);

        end;

      _NK_COMMAND_TRIANGLE:
        begin
          var
            c: Pnk_command_triangle := Pnk_command_triangle(cmd);
          color := nk_color_to_allegro_color(c.color);
          al_draw_triangle(c.a.x, c.a.y, c.b.x, c.b.y, c.c.x, c.c.y, color,
            c.line_thickness);
        end;

      _NK_COMMAND_TRIANGLE_FILLED:
        begin
          var
            c: Pnk_command_triangle_filled := Pnk_command_triangle_filled(cmd);
          color := nk_color_to_allegro_color(c.color);
          al_draw_filled_triangle(c.a.x, c.a.y, c.b.x, c.b.y, c.c.x,
            c.c.y, color);
        end;

      _NK_COMMAND_POLYGON:
        begin
          var
            c: Pnk_command_polygon := Pnk_command_polygon(cmd);
          color := nk_color_to_allegro_color(c.color);
          SetLength(vertices, c.point_count * 2);
          for var i := 0 to c.point_count - 1 do
          begin
            vertices[i * 2] := c.points[i].x;
            vertices[(i * 2) + 1] := c.points[i].y;
          end;
          al_draw_polyline(@vertices, (2 * sizeof(Single)), c.point_count,
            ALLEGRO_LINE_JOIN_ROUND, ALLEGRO_LINE_CAP_CLOSED, color,
            c.line_thickness, 0.0);
          vertices := nil;
        end;

      _NK_COMMAND_POLYGON_FILLED:
        begin
          var
            c: Pnk_command_polygon_filled := Pnk_command_polygon_filled(cmd);
          color := nk_color_to_allegro_color(c.color);
          SetLength(vertices, c.point_count * 2);
          for var i := 0 to c.point_count - 1 do
          begin
            vertices[i * 2] := c.points[i].x;
            vertices[(i * 2) + 1] := c.points[i].y;
          end;
          al_draw_filled_polygon(@vertices, c.point_count, color);
          vertices := nil;
        end;

      _NK_COMMAND_POLYLINE:
        begin
          var
            c: Pnk_command_polyline := Pnk_command_polyline(cmd);
          color := nk_color_to_allegro_color(c.color);
          SetLength(vertices, c.point_count * 2);
          for var i := 0 to c.point_count - 1 do
          begin
            vertices[i * 2] := c.points[i].x;
            vertices[(i * 2) + 1] := c.points[i].y;
          end;
          al_draw_polyline(@vertices, (2 * sizeof(Single)), c.point_count,
            ALLEGRO_LINE_JOIN_ROUND, ALLEGRO_LINE_CAP_ROUND, color,
            c.line_thickness, 0.0);
          vertices := nil;

        end;

      _NK_COMMAND_TEXT:
        begin
          var
            c: Pnk_command_text := Pnk_command_text(cmd);
          var
            col: TViColor := nk_color_to_color(c.foreground);
          var
            Font: TViFont := c.Font.userdata.ptr;
          Font.Print(c.x, c.y, col, alLeft, string(PUTF8Char(@c.&string[0])), []);
        end;

      _NK_COMMAND_CURVE:
        begin
          var
            c: Pnk_command_curve := Pnk_command_curve(cmd);
          color := nk_color_to_allegro_color(c.color);
          points[0] := c.&begin.x;
          points[1] := c.&begin.y;
          points[2] := c.ctrl[0].x;
          points[3] := c.ctrl[0].y;
          points[4] := c.ctrl[1].x;
          points[5] := c.ctrl[1].y;
          points[6] := c.&end.x;
          points[7] := c.&end.y;
          al_draw_spline(@points, color, c.line_thickness);
        end;

      _NK_COMMAND_ARC:
        begin
          var
            c: Pnk_command_arc := Pnk_command_arc(cmd);
          color := nk_color_to_allegro_color(c.color);
          al_draw_arc(c.cx, c.cy, c.r, c.a[0], c.a[1], color, c.line_thickness);
        end;

      _NK_COMMAND_IMAGE:
        begin
          var
            c: Pnk_command_image := Pnk_command_image(cmd);
          al_draw_bitmap_region(c.img.handle.ptr, 0, 0, c.w, c.h, c.x, c.y, 0);
        end;

      _NK_COMMAND_RECT_MULTI_COLOR:
        begin
        end;

      _NK_COMMAND_ARC_FILLED:
        begin
        end;

    end;
    cmd := nk__next(@FCtx, cmd);
  end;

end;

procedure TViIMGUI.SetStyle(aTheme: Integer);
var
  Table: array[0 .. NK_COLOR_COUNT-1] of nk_color;
begin
  case aTheme of
    IMGUI_THEME_DEFAULT:
      begin
        nk_style_default(@FCtx);
      end;
    IMGUI_THEME_WHITE:
      begin
        table[NK_COLOR_TEXT] := nk_rgba_(70, 70, 70, 255);
        table[NK_COLOR_WINDOW] := nk_rgba_(175, 175, 175, 255);
        table[NK_COLOR_HEADER] := nk_rgba_(175, 175, 175, 255);
        table[NK_COLOR_BORDER] := nk_rgba_(0, 0, 0, 255);
        table[NK_COLOR_BUTTON] := nk_rgba_(185, 185, 185, 255);
        table[NK_COLOR_BUTTON_HOVER] := nk_rgba_(170, 170, 170, 255);
        table[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(160, 160, 160, 255);
        table[NK_COLOR_TOGGLE] := nk_rgba_(150, 150, 150, 255);
        table[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(120, 120, 120, 255);
        table[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(175, 175, 175, 255);
        table[NK_COLOR_SELECT] := nk_rgba_(190, 190, 190, 255);
        table[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(175, 175, 175, 255);
        table[NK_COLOR_SLIDER] := nk_rgba_(190, 190, 190, 255);
        table[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(80, 80, 80, 255);
        table[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(70, 70, 70, 255);
        table[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(60, 60, 60, 255);
        table[NK_COLOR_PROPERTY] := nk_rgba_(175, 175, 175, 255);
        table[NK_COLOR_EDIT] := nk_rgba_(150, 150, 150, 255);
        table[NK_COLOR_EDIT_CURSOR] := nk_rgba_(0, 0, 0, 255);
        table[NK_COLOR_COMBO] := nk_rgba_(175, 175, 175, 255);
        table[NK_COLOR_CHART] := nk_rgba_(160, 160, 160, 255);
        table[NK_COLOR_CHART_COLOR] := nk_rgba_(45, 45, 45, 255);
        table[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_( 255, 0, 0, 255);
        table[NK_COLOR_SCROLLBAR] := nk_rgba_(180, 180, 180, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(140, 140, 140, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(150, 150, 150, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(160, 160, 160, 255);
        table[NK_COLOR_TAB_HEADER] := nk_rgba_(180, 180, 180, 255);
        nk_style_from_table(@FCtx, @table);
      end;
    IMGUI_THEME_RED:
      begin
        table[NK_COLOR_TEXT] := nk_rgba_(190, 190, 190, 255);
        table[NK_COLOR_WINDOW] := nk_rgba_(30, 33, 40, 215);
        table[NK_COLOR_HEADER] := nk_rgba_(181, 45, 69, 220);
        table[NK_COLOR_BORDER] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_BUTTON] := nk_rgba_(181, 45, 69, 255);
        table[NK_COLOR_BUTTON_HOVER] := nk_rgba_(190, 50, 70, 255);
        table[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(195, 55, 75, 255);
        table[NK_COLOR_TOGGLE] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(45, 60, 60, 255);
        table[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(181, 45, 69, 255);
        table[NK_COLOR_SELECT] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(181, 45, 69, 255);
        table[NK_COLOR_SLIDER] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(181, 45, 69, 255);
        table[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(186, 50, 74, 255);
        table[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(191, 55, 79, 255);
        table[NK_COLOR_PROPERTY] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_EDIT] := nk_rgba_(51, 55, 67, 225);
        table[NK_COLOR_EDIT_CURSOR] := nk_rgba_(190, 190, 190, 255);
        table[NK_COLOR_COMBO] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_CHART] := nk_rgba_(51, 55, 67, 255);
        table[NK_COLOR_CHART_COLOR] := nk_rgba_(170, 40, 60, 255);
        table[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_( 255, 0, 0, 255);
        table[NK_COLOR_SCROLLBAR] := nk_rgba_(30, 33, 40, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(64, 84, 95, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(70, 90, 100, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(75, 95, 105, 255);
        table[NK_COLOR_TAB_HEADER] := nk_rgba_(181, 45, 69, 220);
        nk_style_from_table(@FCtx, @table);
      end;
    IMGUI_THEME_BLUE:
      begin
        table[NK_COLOR_TEXT] := nk_rgba_(20, 20, 20, 255);
        table[NK_COLOR_WINDOW] := nk_rgba_(202, 212, 214, 215);
        table[NK_COLOR_HEADER] := nk_rgba_(137, 182, 224, 220);
        table[NK_COLOR_BORDER] := nk_rgba_(140, 159, 173, 255);
        table[NK_COLOR_BUTTON] := nk_rgba_(137, 182, 224, 255);
        table[NK_COLOR_BUTTON_HOVER] := nk_rgba_(142, 187, 229, 255);
        table[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(147, 192, 234, 255);
        table[NK_COLOR_TOGGLE] := nk_rgba_(177, 210, 210, 255);
        table[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(182, 215, 215, 255);
        table[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(137, 182, 224, 255);
        table[NK_COLOR_SELECT] := nk_rgba_(177, 210, 210, 255);
        table[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(137, 182, 224, 255);
        table[NK_COLOR_SLIDER] := nk_rgba_(177, 210, 210, 255);
        table[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(137, 182, 224, 245);
        table[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(142, 188, 229, 255);
        table[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(147, 193, 234, 255);
        table[NK_COLOR_PROPERTY] := nk_rgba_(210, 210, 210, 255);
        table[NK_COLOR_EDIT] := nk_rgba_(210, 210, 210, 225);
        table[NK_COLOR_EDIT_CURSOR] := nk_rgba_(20, 20, 20, 255);
        table[NK_COLOR_COMBO] := nk_rgba_(210, 210, 210, 255);
        table[NK_COLOR_CHART] := nk_rgba_(210, 210, 210, 255);
        table[NK_COLOR_CHART_COLOR] := nk_rgba_(137, 182, 224, 255);
        table[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_( 255, 0, 0, 255);
        table[NK_COLOR_SCROLLBAR] := nk_rgba_(190, 200, 200, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(64, 84, 95, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(70, 90, 100, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(75, 95, 105, 255);
        table[NK_COLOR_TAB_HEADER] := nk_rgba_(156, 193, 220, 255);
        nk_style_from_table(@FCtx, @table);
      end;
    IMGUI_THEME_DARK:
      begin
        table[NK_COLOR_TEXT] := nk_rgba_(210, 210, 210, 255);
        table[NK_COLOR_WINDOW] := nk_rgba_(57, 67, 71, 215);
        table[NK_COLOR_HEADER] := nk_rgba_(51, 51, 56, 220);
        table[NK_COLOR_BORDER] := nk_rgba_(46, 46, 46, 255);
        table[NK_COLOR_BUTTON] := nk_rgba_(48, 83, 111, 255);
        table[NK_COLOR_BUTTON_HOVER] := nk_rgba_(58, 93, 121, 255);
        table[NK_COLOR_BUTTON_ACTIVE] := nk_rgba_(63, 98, 126, 255);
        table[NK_COLOR_TOGGLE] := nk_rgba_(50, 58, 61, 255);
        table[NK_COLOR_TOGGLE_HOVER] := nk_rgba_(45, 53, 56, 255);
        table[NK_COLOR_TOGGLE_CURSOR] := nk_rgba_(48, 83, 111, 255);
        table[NK_COLOR_SELECT] := nk_rgba_(57, 67, 61, 255);
        table[NK_COLOR_SELECT_ACTIVE] := nk_rgba_(48, 83, 111, 255);
        table[NK_COLOR_SLIDER] := nk_rgba_(50, 58, 61, 255);
        table[NK_COLOR_SLIDER_CURSOR] := nk_rgba_(48, 83, 111, 245);
        table[NK_COLOR_SLIDER_CURSOR_HOVER] := nk_rgba_(53, 88, 116, 255);
        table[NK_COLOR_SLIDER_CURSOR_ACTIVE] := nk_rgba_(58, 93, 121, 255);
        table[NK_COLOR_PROPERTY] := nk_rgba_(50, 58, 61, 255);
        table[NK_COLOR_EDIT] := nk_rgba_(50, 58, 61, 225);
        table[NK_COLOR_EDIT_CURSOR] := nk_rgba_(210, 210, 210, 255);
        table[NK_COLOR_COMBO] := nk_rgba_(50, 58, 61, 255);
        table[NK_COLOR_CHART] := nk_rgba_(50, 58, 61, 255);
        table[NK_COLOR_CHART_COLOR] := nk_rgba_(48, 83, 111, 255);
        table[NK_COLOR_CHART_COLOR_HIGHLIGHT] := nk_rgba_(255, 0, 0, 255);
        table[NK_COLOR_SCROLLBAR] := nk_rgba_(50, 58, 61, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR] := nk_rgba_(48, 83, 111, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_HOVER] := nk_rgba_(53, 88, 116, 255);
        table[NK_COLOR_SCROLLBAR_CURSOR_ACTIVE] := nk_rgba_(58, 93, 121, 255);
        table[NK_COLOR_TAB_HEADER] := nk_rgba_(48, 83, 111, 255);
        nk_style_from_table(@FCtx, @table);
      end;
  else
    nk_style_default(@FCtx);
  end;
end;


end.

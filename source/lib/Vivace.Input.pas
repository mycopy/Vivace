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

unit Vivace.Input;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Common,
  Vivace.Math;

const
  MAX_AXES = 3;
  MAX_STICKS = 16;
  MAX_BUTTONS = 32;

const
  MOUSE_BUTTON_LEFT = 1;
  MOUSE_BUTTON_RIGHT = 2;
  MOUSE_BUTTON_MIDDLE = 3;

{$REGION 'Keyboard Constants'}

const
  // Keyboard Constants
  KEY_A = 1;
  KEY_B = 2;
  KEY_C = 3;
  KEY_D = 4;
  KEY_E = 5;
  KEY_F = 6;
  KEY_G = 7;
  KEY_H = 8;
  KEY_I = 9;
  KEY_J = 10;
  KEY_K = 11;
  KEY_L = 12;
  KEY_M = 13;
  KEY_N = 14;
  KEY_O = 15;
  KEY_P = 16;
  KEY_Q = 17;
  KEY_R = 18;
  KEY_S = 19;
  KEY_T = 20;
  KEY_U = 21;
  KEY_V = 22;
  KEY_W = 23;
  KEY_X = 24;
  KEY_Y = 25;
  KEY_Z = 26;
  KEY_0 = 27;
  KEY_1 = 28;
  KEY_2 = 29;
  KEY_3 = 30;
  KEY_4 = 31;
  KEY_5 = 32;
  KEY_6 = 33;
  KEY_7 = 34;
  KEY_8 = 35;
  KEY_9 = 36;
  KEY_PAD_0 = 37;
  KEY_PAD_1 = 38;
  KEY_PAD_2 = 39;
  KEY_PAD_3 = 40;
  KEY_PAD_4 = 41;
  KEY_PAD_5 = 42;
  KEY_PAD_6 = 43;
  KEY_PAD_7 = 44;
  KEY_PAD_8 = 45;
  KEY_PAD_9 = 46;
  KEY_F1 = 47;
  KEY_F2 = 48;
  KEY_F3 = 49;
  KEY_F4 = 50;
  KEY_F5 = 51;
  KEY_F6 = 52;
  KEY_F7 = 53;
  KEY_F8 = 54;
  KEY_F9 = 55;
  KEY_F10 = 56;
  KEY_F11 = 57;
  KEY_F12 = 58;
  KEY_ESCAPE = 59;
  KEY_TILDE = 60;
  KEY_MINUS = 61;
  KEY_EQUALS = 62;
  KEY_BACKSPACE = 63;
  KEY_TAB = 64;
  KEY_OPENBRACE = 65;
  KEY_CLOSEBRACE = 66;
  KEY_ENTER = 67;
  KEY_SEMICOLON = 68;
  KEY_QUOTE = 69;
  KEY_BACKSLASH = 70;
  KEY_BACKSLASH2 = 71;
  KEY_COMMA = 72;
  KEY_FULLSTOP = 73;
  KEY_SLASH = 74;
  KEY_SPACE = 75;
  KEY_INSERT = 76;
  KEY_DELETE = 77;
  KEY_HOME = 78;
  KEY_END = 79;
  KEY_PGUP = 80;
  KEY_PGDN = 81;
  KEY_LEFT = 82;
  KEY_RIGHT = 83;
  KEY_UP = 84;
  KEY_DOWN = 85;
  KEY_PAD_SLASH = 86;
  KEY_PAD_ASTERISK = 87;
  KEY_PAD_MINUS = 88;
  KEY_PAD_PLUS = 89;
  KEY_PAD_DELETE = 90;
  KEY_PAD_ENTER = 91;
  KEY_PRINTSCREEN = 92;
  KEY_PAUSE = 93;
  KEY_ABNT_C1 = 94;
  KEY_YEN = 95;
  KEY_KANA = 96;
  KEY_CONVERT = 97;
  KEY_NOCONVERT = 98;
  KEY_AT = 99;
  KEY_CIRCUMFLEX = 100;
  KEY_COLON2 = 101;
  KEY_KANJI = 102;
  KEY_PAD_EQUALS = 103;
  KEY_BACKQUOTE = 104;
  KEY_SEMICOLON2 = 105;
  KEY_COMMAND = 106;
  KEY_BACK = 107;
  KEY_VOLUME_UP = 108;
  KEY_VOLUME_DOWN = 109;
  KEY_SEARCH = 110;
  KEY_DPAD_CENTER = 111;
  KEY_BUTTON_X = 112;
  KEY_BUTTON_Y = 113;
  KEY_DPAD_UP = 114;
  KEY_DPAD_DOWN = 115;
  KEY_DPAD_LEFT = 116;
  KEY_DPAD_RIGHT = 117;
  KEY_SELECT = 118;
  KEY_START = 119;
  KEY_BUTTON_L1 = 120;
  KEY_BUTTON_R1 = 121;
  KEY_BUTTON_L2 = 122;
  KEY_BUTTON_R2 = 123;
  KEY_BUTTON_A = 124;
  KEY_BUTTON_B = 125;
  KEY_THUMBL = 126;
  KEY_THUMBR = 127;
  KEY_UNKNOWN = 128;
  KEY_MODIFIERS = 215;
  KEY_LSHIFT = 215;
  KEY_RSHIFT = 216;
  KEY_LCTRL = 217;
  KEY_RCTRL = 218;
  KEY_ALT = 219;
  KEY_ALTGR = 220;
  KEY_LWIN = 221;
  KEY_RWIN = 222;
  KEY_MENU = 223;
  KEY_SCROLLLOCK = 224;
  KEY_NUMLOCK = 225;
  KEY_CAPSLOCK = 226;
  KEY_MAX = 227;
  KEYMOD_SHIFT = $0001;
  KEYMOD_CTRL = $0002;
  KEYMOD_ALT = $0004;
  KEYMOD_LWIN = $0008;
  KEYMOD_RWIN = $0010;
  KEYMOD_MENU = $0020;
  KEYMOD_COMMAND = $0040;
  KEYMOD_SCROLOCK = $0100;
  KEYMOD_NUMLOCK = $0200;
  KEYMOD_CAPSLOCK = $0400;
  KEYMOD_INALTSEQ = $0800;
  KEYMOD_ACCENT1 = $1000;
  KEYMOD_ACCENT2 = $2000;
  KEYMOD_ACCENT3 = $4000;
  KEYMOD_ACCENT4 = $8000;
{$ENDREGION}

var
  // sticks
  JOY_STICK_LS: Integer = 0;
  JOY_STICK_RS: Integer = 1;
  JOY_STICK_LT: Integer = 2;
  JOY_STICK_RT: Integer = 3;

  // axes
  JOY_AXES_X: Integer = 0;
  JOY_AXES_Y: Integer = 1;
  JOY_AXES_Z: Integer = 2;

  // buttons
  JOY_BTN_A: Integer = 0;
  JOY_BTN_B: Integer = 1;
  JOY_BTN_X: Integer = 2;
  JOY_BTN_Y: Integer = 3;
  JOY_BTN_RB: Integer = 4;
  JOY_BTN_LB: Integer = 5;
  JOY_BTN_RT: Integer = 6;
  JOY_BTN_LT: Integer = 7;
  JOY_BTN_BACK: Integer = 8;
  JOY_BTN_START: Integer = 9;
  JOY_BTN_RDPAD: Integer = 10;
  JOY_BTN_LDPAD: Integer = 11;
  JOY_BTN_DDPAD: Integer = 12;
  JOY_BTN_UDPAD: Integer = 13;

type

  { TViJoystick }
  TViJoystick = record
    Name: string;
    Sticks: Integer;
    Buttons: Integer;

    StickName: array [0 .. MAX_STICKS - 1] of string;

    Axes: array [0 .. MAX_STICKS - 1] of Integer;
    AxesName: array [0 .. MAX_STICKS - 1, 0 .. MAX_AXES - 1] of string;

    Pos: array [0 .. MAX_STICKS - 1, 0 .. MAX_AXES - 1] of Single;

    Button: array [0 .. MAX_BUTTONS - 1] of Boolean;
    ButtonName: array [0 .. MAX_BUTTONS - 1] of string;

    procedure Setup(aNum: Integer);
    function GetPos(aStick: Integer; aAxes: Integer): Single;
    function GetButton(aButton: Integer): Boolean;
  end;

  { TViInput }
  TViInput = class(TViBaseObject)
  protected
    FMouseButtons: array [0 .. 256] of Boolean;
    FKeyButtons: array [0 .. 256] of Boolean;
    FJoyButtons: array [0 .. 256] of Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Clear;

    function KeyboardPressed(aKey: Integer): Boolean;
    function KeyboardReleased(aKey: Integer): Boolean;
    function KeyboardDown(aKey: Integer): Boolean;
    function KeyboardGetPressed: Integer;

    function MousePressed(aButton: Integer): Boolean;
    function MouseReleased(aButton: Integer): Boolean;
    function MouseDown(aButton: Integer): Boolean;
    procedure MouseGetInfo(aX: PInteger; aY: PInteger;
      aWheel: PInteger); overload;
    procedure MouseGetInfo(var aPos: TViVector); overload;
    procedure MouseSetPos(aX: Integer; aY: Integer);

    function JoystickPressed(aButton: Integer): Boolean;
    function JoystickReleased(aButton: Integer): Boolean;
    function JoystickDown(aButton: Integer): Boolean;
    function JoystickGetPos(aStick: Integer; aAxes: Integer): Single;
  end;

implementation

uses
  System.Math,
  Vivace.Allegro.API,
  Vivace.Display,
  Vivace.Engine;

{ --- TViJoystick ----------------------------------------------------------- }
procedure TViJoystick.Setup(aNum: Integer);
var
  joycount: Integer;
  joy: PALLEGRO_JOYSTICK;
  jst: ALLEGRO_JOYSTICK_STATE;
  i, j: Integer;
begin
  joycount := al_get_num_joysticks;
  if (aNum < 0) or (aNum > joycount - 1) then
    Exit;

  joy := al_get_joystick(aNum);
  if joy = nil then
  begin
    Sticks := 0;
    Buttons := 0;
    Exit;
  end;

  Name := string(al_get_joystick_name(joy));

  al_get_joystick_state(joy, @jst);

  Sticks := al_get_joystick_num_sticks(joy);
  if (Sticks > MAX_STICKS) then
    Sticks := MAX_STICKS;

  for i := 0 to Sticks - 1 do
  begin
    StickName[i] := string(al_get_joystick_stick_name(joy, i));
    Axes[i] := al_get_joystick_num_axes(joy, i);
    for j := 0 to Axes[i] - 1 do
    begin
      Pos[i, j] := jst.stick[i].axis[j];
      AxesName[i, j] := string(al_get_joystick_axis_name(joy, i, j));
    end;
  end;

  Buttons := al_get_joystick_num_buttons(joy);
  if (Buttons > MAX_BUTTONS) then
    Buttons := MAX_BUTTONS;

  for i := 0 to Buttons - 1 do
  begin
    ButtonName[i] := string(al_get_joystick_button_name(joy, i));
    Button[i] := Boolean(jst.Button[i] >= 16384);
  end

end;

function TViJoystick.GetPos(aStick: Integer; aAxes: Integer): Single;
begin
  Result := Pos[aStick, aAxes];
end;

function TViJoystick.GetButton(aButton: Integer): Boolean;
begin
  Result := Button[aButton];
end;

{ --- TViInput -------------------------------------------------------------- }

constructor TViInput.Create;
begin
  inherited;
end;

destructor TViInput.Destroy;
begin
  inherited;
end;

procedure TViInput.Clear;
begin
  FillChar(FMouseButtons, SizeOf(FMouseButtons), False);
  FillChar(FKeyButtons, SizeOf(FKeyButtons), False);
  FillChar(FJoyButtons, SizeOf(FJoyButtons), False);

  if ViEngine.Display.Handle <> nil then
  begin
    al_clear_keyboard_state(ViEngine.Display.Handle);
  end;
end;

// Keyboard
function TViInput.KeyboardPressed(aKey: Integer): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then
    Exit;
  if KeyboardDown(aKey) and (not FKeyButtons[aKey]) then
  begin
    FKeyButtons[aKey] := True;
    Result := True;
  end
  else if (not KeyboardDown(aKey)) and (FKeyButtons[aKey]) then
  begin
    FKeyButtons[aKey] := False;
    Result := False;
  end;
end;

function TViInput.KeyboardReleased(aKey: Integer): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then
    Exit;
  if KeyboardDown(aKey) and (not FKeyButtons[aKey]) then
  begin
    FKeyButtons[aKey] := True;
    Result := False;
  end
  else if (not KeyboardDown(aKey)) and (FKeyButtons[aKey]) then
  begin
    FKeyButtons[aKey] := False;
    Result := True;
  end;
end;

function TViInput.KeyboardDown(aKey: Integer): Boolean;
begin
  Result := False;
  if not InRange(aKey, 0, 255) then
    Exit;
  Result := al_key_down(@ViEngine.KeyboardState, aKey);
end;

function TViInput.KeyboardGetPressed: Integer;
begin
  Result := ViEngine.KeyCode;
end;

// Mouse
function TViInput.MousePressed(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then
    Exit;

  if MouseDown(aButton) and (not FMouseButtons[aButton]) then
  begin
    FMouseButtons[aButton] := True;
    Result := True;
  end
  else if (not MouseDown(aButton)) and (FMouseButtons[aButton]) then
  begin
    FMouseButtons[aButton] := False;
    Result := False;
  end;
end;

function TViInput.MouseReleased(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then
    Exit;

  if MouseDown(aButton) and (not FMouseButtons[aButton]) then
  begin
    FMouseButtons[aButton] := True;
    Result := False;
  end
  else if (not MouseDown(aButton)) and (FMouseButtons[aButton]) then
  begin
    FMouseButtons[aButton] := False;
    Result := True;
  end;

end;

function TViInput.MouseDown(aButton: Integer): Boolean;
var
  state: ALLEGRO_MOUSE_STATE;
begin
  Result := False;
  if not InRange(aButton, MOUSE_BUTTON_LEFT, MOUSE_BUTTON_MIDDLE) then
    Exit;
  al_get_mouse_state(@state);
  Result := al_mouse_button_down(@state, aButton);
end;

procedure TViInput.MouseGetInfo(var aPos: TViVector);
var
  x, y, z: Integer;
begin
  ViEngine.Input.MouseGetInfo(@x, @y, @z);
  aPos.x := x;
  aPos.y := y;
  aPos.z := z;
end;

procedure TViInput.MouseGetInfo(aX: PInteger; aY: PInteger; aWheel: PInteger);
var
  state: ALLEGRO_MOUSE_STATE;
  MX, MY, MW: Integer;
  VX, VY: Integer;
begin
  VX := Round(ViEngine.Display.TransSize.x);
  VY := Round(ViEngine.Display.TransSize.y);

  al_get_mouse_state(@state);
  MX := al_get_mouse_state_axis(@state, 0);
  MY := al_get_mouse_state_axis(@state, 1);
  MW := al_get_mouse_state_axis(@state, 2);

  if ViEngine.Display.IsFullscreen then
  begin
    MX := Round((MX - VX) / ViEngine.Display.TransScale);
    MY := Round((MY - VY) / ViEngine.Display.TransScale);
  end;

  if aX <> nil then
  begin
    aX^ := MX;
  end;

  if aY <> nil then
  begin
    aY^ := MY;
  end;

  if aWheel <> nil then
  begin
    aWheel^ := MW;
  end;

end;

procedure TViInput.MouseSetPos(aX: Integer; aY: Integer);
var
  MX, MY: Integer;
  VX, VY: Integer;

begin

  MX := aX;
  MY := aY;

  VX := Round(ViEngine.Display.TransSize.x);
  VY := Round(ViEngine.Display.TransSize.y);

  if ViEngine.Display.IsFullscreen then
  begin
    MX := Round(MX * ViEngine.Display.TransScale) + VX;
    MY := Round(MY * ViEngine.Display.TransScale) + VY;
  end;

  al_set_mouse_xy(ViEngine.Display.Handle, MX, MY);
end;

function TViInput.JoystickGetPos(aStick: Integer; aAxes: Integer): Single;
begin
  Result := ViEngine.Joystick.Pos[aStick, aAxes];
end;

function TViInput.JoystickDown(aButton: Integer): Boolean;
begin
  Result := ViEngine.Joystick.Button[aButton];
end;

function TViInput.JoystickPressed(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS) then
    Exit;

  if JoystickDown(aButton) and (not FJoyButtons[aButton]) then
  begin
    FJoyButtons[aButton] := True;
    Result := True;
  end
  else if (not JoystickDown(aButton)) and (FJoyButtons[aButton]) then
  begin
    FJoyButtons[aButton] := False;
    Result := False;
  end;
end;

function TViInput.JoystickReleased(aButton: Integer): Boolean;
begin
  Result := False;
  if not InRange(aButton, 0, MAX_BUTTONS) then
    Exit;

  if JoystickDown(aButton) and (not FJoyButtons[aButton]) then
  begin
    FJoyButtons[aButton] := True;
    Result := False;
  end
  else if (not JoystickDown(aButton)) and (FJoyButtons[aButton]) then
  begin
    FJoyButtons[aButton] := False;
    Result := True;
  end;
end;

end.

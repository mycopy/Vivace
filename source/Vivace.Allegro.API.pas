﻿{==============================================================================
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

unit Vivace.Allegro.API;

{$I Vivace.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Direct3D9,
  WinApi.OpenGL,
  Vivace.Common;

const
  ALLEGRO_WINDOWS = 1;
  ENUM_CURRENT_SETTINGS = -1;

  ALLEGRO_VERSION = 5;
  ALLEGRO_SUB_VERSION = 2;
  ALLEGRO_WIP_VERSION = 6;
  ALLEGRO_UNSTABLE_BIT = 0;
  ALLEGRO_RELEASE_NUMBER = 1;
  ALLEGRO_VERSION_STR = '5.2.6';
  ALLEGRO_DATE_STR = '2020';
  ALLEGRO_DATE = 20200207;
  ALLEGRO_VERSION_INT = ((ALLEGRO_VERSION shl 24) or
    (ALLEGRO_SUB_VERSION shl 16) or (ALLEGRO_WIP_VERSION shl 8) or
    ALLEGRO_RELEASE_NUMBER or ALLEGRO_UNSTABLE_BIT);
  ALLEGRO_PI = 3.14159265358979323846;
  ALLEGRO_NATIVE_PATH_SEP = '\';
  ALLEGRO_NATIVE_DRIVE_SEP = ':';
  ALLEGRO_NEW_WINDOW_TITLE_MAX_SIZE = 255;
  EOF = (-1);
  _AL_MAX_JOYSTICK_AXES = 3;
  _AL_MAX_JOYSTICK_STICKS = 16;
  _AL_MAX_JOYSTICK_BUTTONS = 32;
  ALLEGRO_MOUSE_MAX_EXTRA_AXES = 4;
  ALLEGRO_TOUCH_INPUT_MAX_TOUCH_COUNT = 16;
  ALLEGRO_SHADER_VAR_COLOR = 'al_color';
  ALLEGRO_SHADER_VAR_POS = 'al_pos';
  ALLEGRO_SHADER_VAR_PROJVIEW_MATRIX = 'al_projview_matrix';
  ALLEGRO_SHADER_VAR_TEX = 'al_tex';
  ALLEGRO_SHADER_VAR_TEXCOORD = 'al_texcoord';
  ALLEGRO_SHADER_VAR_TEX_MATRIX = 'al_tex_matrix';
  ALLEGRO_SHADER_VAR_USER_ATTR = 'al_user_attr_';
  ALLEGRO_SHADER_VAR_USE_TEX = 'al_use_tex';
  ALLEGRO_SHADER_VAR_USE_TEX_MATRIX = 'al_use_tex_matrix';
  ALLEGRO_SHADER_VAR_ALPHA_TEST = 'al_alpha_test';
  ALLEGRO_SHADER_VAR_ALPHA_FUNCTION = 'al_alpha_func';
  ALLEGRO_SHADER_VAR_ALPHA_TEST_VALUE = 'al_alpha_test_val';
  ALLEGRO_MAX_CHANNELS = 8;
  ALLEGRO_AUDIO_PAN_NONE = (-1000.0);

  ALLEGRO_VERTEX_CACHE_SIZE = 256;
  ALLEGRO_PRIM_QUALITY = 10;
  ALLEGRO_TTF_NO_KERNING = 1;
  ALLEGRO_TTF_MONOCHROME = 2;
  ALLEGRO_TTF_NO_AUTOHINT = 4;

type
  ALLEGRO_PIXEL_FORMAT = Integer;
  PALLEGRO_PIXEL_FORMAT = ^ALLEGRO_PIXEL_FORMAT;
  off_t = longint;

const
  ALLEGRO_PIXEL_FORMAT_ANY = 0;
  ALLEGRO_PIXEL_FORMAT_ANY_NO_ALPHA = 1;
  ALLEGRO_PIXEL_FORMAT_ANY_WITH_ALPHA = 2;
  ALLEGRO_PIXEL_FORMAT_ANY_15_NO_ALPHA = 3;
  ALLEGRO_PIXEL_FORMAT_ANY_16_NO_ALPHA = 4;
  ALLEGRO_PIXEL_FORMAT_ANY_16_WITH_ALPHA = 5;
  ALLEGRO_PIXEL_FORMAT_ANY_24_NO_ALPHA = 6;
  ALLEGRO_PIXEL_FORMAT_ANY_32_NO_ALPHA = 7;
  ALLEGRO_PIXEL_FORMAT_ANY_32_WITH_ALPHA = 8;
  ALLEGRO_PIXEL_FORMAT_ARGB_8888 = 9;
  ALLEGRO_PIXEL_FORMAT_RGBA_8888 = 10;
  ALLEGRO_PIXEL_FORMAT_ARGB_4444 = 11;
  ALLEGRO_PIXEL_FORMAT_RGB_888 = 12;
  ALLEGRO_PIXEL_FORMAT_RGB_565 = 13;
  ALLEGRO_PIXEL_FORMAT_RGB_555 = 14;
  ALLEGRO_PIXEL_FORMAT_RGBA_5551 = 15;
  ALLEGRO_PIXEL_FORMAT_ARGB_1555 = 16;
  ALLEGRO_PIXEL_FORMAT_ABGR_8888 = 17;
  ALLEGRO_PIXEL_FORMAT_XBGR_8888 = 18;
  ALLEGRO_PIXEL_FORMAT_BGR_888 = 19;
  ALLEGRO_PIXEL_FORMAT_BGR_565 = 20;
  ALLEGRO_PIXEL_FORMAT_BGR_555 = 21;
  ALLEGRO_PIXEL_FORMAT_RGBX_8888 = 22;
  ALLEGRO_PIXEL_FORMAT_XRGB_8888 = 23;
  ALLEGRO_PIXEL_FORMAT_ABGR_F32 = 24;
  ALLEGRO_PIXEL_FORMAT_ABGR_8888_LE = 25;
  ALLEGRO_PIXEL_FORMAT_RGBA_4444 = 26;
  ALLEGRO_PIXEL_FORMAT_SINGLE_CHANNEL_8 = 27;
  ALLEGRO_PIXEL_FORMAT_COMPRESSED_RGBA_DXT1 = 28;
  ALLEGRO_PIXEL_FORMAT_COMPRESSED_RGBA_DXT3 = 29;
  ALLEGRO_PIXEL_FORMAT_COMPRESSED_RGBA_DXT5 = 30;
  ALLEGRO_NUM_PIXEL_FORMATS = 31;

type
  _anonymous_type_1 = Integer;
  P_anonymous_type_1 = ^_anonymous_type_1;

const
  ALLEGRO_MEMORY_BITMAP = 1;
  _ALLEGRO_KEEP_BITMAP_FORMAT = 2;
  ALLEGRO_FORCE_LOCKING = 4;
  ALLEGRO_NO_PRESERVE_TEXTURE = 8;
  _ALLEGRO_ALPHA_TEST = 16;
  _ALLEGRO_INTERNAL_OPENGL = 32;
  ALLEGRO_MIN_LINEAR = 64;
  ALLEGRO_MAG_LINEAR = 128;
  ALLEGRO_MIPMAP = 256;
  _ALLEGRO_NO_PREMULTIPLIED_ALPHA = 512;
  ALLEGRO_VIDEO_BITMAP = 1024;
  ALLEGRO_CONVERT_BITMAP = 4096;

type
  _anonymous_type_2 = Integer;
  P_anonymous_type_2 = ^_anonymous_type_2;

const
  ALLEGRO_FLIP_HORIZONTAL = 1;
  ALLEGRO_FLIP_VERTICAL = 2;

type
  ALLEGRO_SEEK = Integer;
  PALLEGRO_SEEK = ^ALLEGRO_SEEK;

const
  ALLEGRO_SEEK_SET = 0;
  ALLEGRO_SEEK_CUR = 1;
  ALLEGRO_SEEK_END = 2;

type
  _anonymous_type_3 = Integer;
  P_anonymous_type_3 = ^_anonymous_type_3;

const
  ALLEGRO_KEEP_BITMAP_FORMAT = 2;
  ALLEGRO_NO_PREMULTIPLIED_ALPHA = 512;
  ALLEGRO_KEEP_INDEX = 2048;

type
  _anonymous_type_4 = Integer;
  P_anonymous_type_4 = ^_anonymous_type_4;

const
  ALLEGRO_LOCK_READWRITE = 0;
  ALLEGRO_LOCK_READONLY = 1;
  ALLEGRO_LOCK_WRITEONLY = 2;

type
  ALLEGRO_BLEND_MODE = Integer;
  PALLEGRO_BLEND_MODE = ^ALLEGRO_BLEND_MODE;

const
  ALLEGRO_ZERO = 0;
  ALLEGRO_ONE = 1;
  ALLEGRO_ALPHA = 2;
  ALLEGRO_INVERSE_ALPHA = 3;
  ALLEGRO_SRC_COLOR = 4;
  ALLEGRO_DEST_COLOR = 5;
  ALLEGRO_INVERSE_SRC_COLOR = 6;
  ALLEGRO_INVERSE_DEST_COLOR = 7;
  ALLEGRO_CONST_COLOR = 8;
  ALLEGRO_INVERSE_CONST_COLOR = 9;
  ALLEGRO_NUM_BLEND_MODES = 10;

  ALLEGRO_DST_COLOR = (ALLEGRO_DEST_COLOR);
  ALLEGRO_INVERSE_DST_COLOR = (ALLEGRO_INVERSE_DEST_COLOR);

type
  ALLEGRO_BLEND_OPERATIONS = Integer;
  PALLEGRO_BLEND_OPERATIONS = ^ALLEGRO_BLEND_OPERATIONS;

const
  ALLEGRO_ADD = 0;
  ALLEGRO_SRC_MINUS_DEST = 1;
  ALLEGRO_DEST_MINUS_SRC = 2;
  ALLEGRO_NUM_BLEND_OPERATIONS = 3;

type
  _anonymous_type_5 = Integer;
  P_anonymous_type_5 = ^_anonymous_type_5;

const
  ALLEGRO_EVENT_JOYSTICK_AXIS = 1;
  ALLEGRO_EVENT_JOYSTICK_BUTTON_DOWN = 2;
  ALLEGRO_EVENT_JOYSTICK_BUTTON_UP = 3;
  ALLEGRO_EVENT_JOYSTICK_CONFIGURATION = 4;
  ALLEGRO_EVENT_KEY_DOWN = 10;
  ALLEGRO_EVENT_KEY_CHAR = 11;
  ALLEGRO_EVENT_KEY_UP = 12;
  ALLEGRO_EVENT_MOUSE_AXES = 20;
  ALLEGRO_EVENT_MOUSE_BUTTON_DOWN = 21;
  ALLEGRO_EVENT_MOUSE_BUTTON_UP = 22;
  ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY = 23;
  ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY = 24;
  ALLEGRO_EVENT_MOUSE_WARPED = 25;
  ALLEGRO_EVENT_TIMER = 30;
  ALLEGRO_EVENT_DISPLAY_EXPOSE = 40;
  ALLEGRO_EVENT_DISPLAY_RESIZE = 41;
  ALLEGRO_EVENT_DISPLAY_CLOSE = 42;
  ALLEGRO_EVENT_DISPLAY_LOST = 43;
  ALLEGRO_EVENT_DISPLAY_FOUND = 44;
  ALLEGRO_EVENT_DISPLAY_SWITCH_IN = 45;
  ALLEGRO_EVENT_DISPLAY_SWITCH_OUT = 46;
  ALLEGRO_EVENT_DISPLAY_ORIENTATION = 47;
  ALLEGRO_EVENT_DISPLAY_HALT_DRAWING = 48;
  ALLEGRO_EVENT_DISPLAY_RESUME_DRAWING = 49;
  ALLEGRO_EVENT_TOUCH_BEGIN = 50;
  ALLEGRO_EVENT_TOUCH_END = 51;
  ALLEGRO_EVENT_TOUCH_MOVE = 52;
  ALLEGRO_EVENT_TOUCH_CANCEL = 53;
  ALLEGRO_EVENT_DISPLAY_CONNECTED = 60;
  ALLEGRO_EVENT_DISPLAY_DISCONNECTED = 61;

type
  _anonymous_type_6 = Integer;
  P_anonymous_type_6 = ^_anonymous_type_6;

const
  ALLEGRO_WINDOWED = 1;
  ALLEGRO_FULLSCREEN = 2;
  ALLEGRO_OPENGL = 4;
  ALLEGRO_DIRECT3D_INTERNAL = 8;
  ALLEGRO_RESIZABLE = 16;
  ALLEGRO_FRAMELESS = 32;
  ALLEGRO_NOFRAME = 32;
  ALLEGRO_GENERATE_EXPOSE_EVENTS = 64;
  ALLEGRO_OPENGL_3_0 = 128;
  ALLEGRO_OPENGL_FORWARD_COMPATIBLE = 256;
  ALLEGRO_FULLSCREEN_WINDOW = 512;
  ALLEGRO_MINIMIZED = 1024;
  ALLEGRO_PROGRAMMABLE_PIPELINE = 2048;
  ALLEGRO_GTK_TOPLEVEL_INTERNAL = 4096;
  ALLEGRO_MAXIMIZED = 8192;
  ALLEGRO_OPENGL_ES_PROFILE = 16384;

  ALLEGRO_DIRECT3D = ALLEGRO_DIRECT3D_INTERNAL;

type
  ALLEGRO_DISPLAY_OPTIONS = Integer;
  PALLEGRO_DISPLAY_OPTIONS = ^ALLEGRO_DISPLAY_OPTIONS;

const
  ALLEGRO_RED_SIZE = 0;
  ALLEGRO_GREEN_SIZE = 1;
  ALLEGRO_BLUE_SIZE = 2;
  ALLEGRO_ALPHA_SIZE = 3;
  ALLEGRO_RED_SHIFT = 4;
  ALLEGRO_GREEN_SHIFT = 5;
  ALLEGRO_BLUE_SHIFT = 6;
  ALLEGRO_ALPHA_SHIFT = 7;
  ALLEGRO_ACC_RED_SIZE = 8;
  ALLEGRO_ACC_GREEN_SIZE = 9;
  ALLEGRO_ACC_BLUE_SIZE = 10;
  ALLEGRO_ACC_ALPHA_SIZE = 11;
  ALLEGRO_STEREO = 12;
  ALLEGRO_AUX_BUFFERS = 13;
  ALLEGRO_COLOR_SIZE = 14;
  ALLEGRO_DEPTH_SIZE = 15;
  ALLEGRO_STENCIL_SIZE = 16;
  ALLEGRO_SAMPLE_BUFFERS = 17;
  ALLEGRO_SAMPLES = 18;
  ALLEGRO_RENDER_METHOD = 19;
  ALLEGRO_FLOAT_COLOR = 20;
  ALLEGRO_FLOAT_DEPTH = 21;
  ALLEGRO_SINGLE_BUFFER = 22;
  ALLEGRO_SWAP_METHOD = 23;
  ALLEGRO_COMPATIBLE_DISPLAY = 24;
  ALLEGRO_UPDATE_DISPLAY_REGION = 25;
  ALLEGRO_VSYNC = 26;
  ALLEGRO_MAX_BITMAP_SIZE = 27;
  ALLEGRO_SUPPORT_NPOT_BITMAP = 28;
  ALLEGRO_CAN_DRAW_INTO_BITMAP = 29;
  ALLEGRO_SUPPORT_SEPARATE_ALPHA = 30;
  ALLEGRO_AUTO_CONVERT_BITMAPS = 31;
  ALLEGRO_SUPPORTED_ORIENTATIONS = 32;
  ALLEGRO_OPENGL_MAJOR_VERSION = 33;
  ALLEGRO_OPENGL_MINOR_VERSION = 34;
  ALLEGRO_DISPLAY_OPTIONS_COUNT = 35;

type
  _anonymous_type_7 = Integer;
  P_anonymous_type_7 = ^_anonymous_type_7;

const
  ALLEGRO_DONTCARE = 0;
  ALLEGRO_REQUIRE = 1;
  ALLEGRO_SUGGEST = 2;

type
  ALLEGRO_DISPLAY_ORIENTATION = Integer;
  PALLEGRO_DISPLAY_ORIENTATION = ^ALLEGRO_DISPLAY_ORIENTATION;

const
  ALLEGRO_DISPLAY_ORIENTATION_UNKNOWN = 0;
  ALLEGRO_DISPLAY_ORIENTATION_0_DEGREES = 1;
  ALLEGRO_DISPLAY_ORIENTATION_90_DEGREES = 2;
  ALLEGRO_DISPLAY_ORIENTATION_180_DEGREES = 4;
  ALLEGRO_DISPLAY_ORIENTATION_270_DEGREES = 8;
  ALLEGRO_DISPLAY_ORIENTATION_PORTRAIT = 5;
  ALLEGRO_DISPLAY_ORIENTATION_LANDSCAPE = 10;
  ALLEGRO_DISPLAY_ORIENTATION_ALL = 15;
  ALLEGRO_DISPLAY_ORIENTATION_FACE_UP = 16;
  ALLEGRO_DISPLAY_ORIENTATION_FACE_DOWN = 32;

type
  _anonymous_type_8 = Integer;
  P_anonymous_type_8 = ^_anonymous_type_8;

const
  _ALLEGRO_PRIM_MAX_USER_ATTR = 10;

type
  ALLEGRO_FILE_MODE = Integer;
  PALLEGRO_FILE_MODE = ^ALLEGRO_FILE_MODE;

const
  ALLEGRO_FILEMODE_READ = 1;
  ALLEGRO_FILEMODE_WRITE = 2;
  ALLEGRO_FILEMODE_EXECUTE = 4;
  ALLEGRO_FILEMODE_HIDDEN = 8;
  ALLEGRO_FILEMODE_ISFILE = 16;
  ALLEGRO_FILEMODE_ISDIR = 32;

type
  ALLEGRO_FOR_EACH_FS_ENTRY_RESULT = Integer;
  PALLEGRO_FOR_EACH_FS_ENTRY_RESULT = ^ALLEGRO_FOR_EACH_FS_ENTRY_RESULT;

const
  ALLEGRO_FOR_EACH_FS_ENTRY_ERROR = -1;
  ALLEGRO_FOR_EACH_FS_ENTRY_OK = 0;
  ALLEGRO_FOR_EACH_FS_ENTRY_SKIP = 1;
  ALLEGRO_FOR_EACH_FS_ENTRY_STOP = 2;

type
  ALLEGRO_JOYFLAGS = Integer;
  PALLEGRO_JOYFLAGS = ^ALLEGRO_JOYFLAGS;

const
  ALLEGRO_JOYFLAG_DIGITAL = 1;
  ALLEGRO_JOYFLAG_ANALOGUE = 2;

type
  _anonymous_type_9 = Integer;
  P_anonymous_type_9 = ^_anonymous_type_9;

const
  ALLEGRO_KEY_A = 1;
  ALLEGRO_KEY_B = 2;
  ALLEGRO_KEY_C = 3;
  ALLEGRO_KEY_D = 4;
  ALLEGRO_KEY_E = 5;
  ALLEGRO_KEY_F = 6;
  ALLEGRO_KEY_G = 7;
  ALLEGRO_KEY_H = 8;
  ALLEGRO_KEY_I = 9;
  ALLEGRO_KEY_J = 10;
  ALLEGRO_KEY_K = 11;
  ALLEGRO_KEY_L = 12;
  ALLEGRO_KEY_M = 13;
  ALLEGRO_KEY_N = 14;
  ALLEGRO_KEY_O = 15;
  ALLEGRO_KEY_P = 16;
  ALLEGRO_KEY_Q = 17;
  ALLEGRO_KEY_R = 18;
  ALLEGRO_KEY_S = 19;
  ALLEGRO_KEY_T = 20;
  ALLEGRO_KEY_U = 21;
  ALLEGRO_KEY_V = 22;
  ALLEGRO_KEY_W = 23;
  ALLEGRO_KEY_X = 24;
  ALLEGRO_KEY_Y = 25;
  ALLEGRO_KEY_Z = 26;
  ALLEGRO_KEY_0 = 27;
  ALLEGRO_KEY_1 = 28;
  ALLEGRO_KEY_2 = 29;
  ALLEGRO_KEY_3 = 30;
  ALLEGRO_KEY_4 = 31;
  ALLEGRO_KEY_5 = 32;
  ALLEGRO_KEY_6 = 33;
  ALLEGRO_KEY_7 = 34;
  ALLEGRO_KEY_8 = 35;
  ALLEGRO_KEY_9 = 36;
  ALLEGRO_KEY_PAD_0 = 37;
  ALLEGRO_KEY_PAD_1 = 38;
  ALLEGRO_KEY_PAD_2 = 39;
  ALLEGRO_KEY_PAD_3 = 40;
  ALLEGRO_KEY_PAD_4 = 41;
  ALLEGRO_KEY_PAD_5 = 42;
  ALLEGRO_KEY_PAD_6 = 43;
  ALLEGRO_KEY_PAD_7 = 44;
  ALLEGRO_KEY_PAD_8 = 45;
  ALLEGRO_KEY_PAD_9 = 46;
  ALLEGRO_KEY_F1 = 47;
  ALLEGRO_KEY_F2 = 48;
  ALLEGRO_KEY_F3 = 49;
  ALLEGRO_KEY_F4 = 50;
  ALLEGRO_KEY_F5 = 51;
  ALLEGRO_KEY_F6 = 52;
  ALLEGRO_KEY_F7 = 53;
  ALLEGRO_KEY_F8 = 54;
  ALLEGRO_KEY_F9 = 55;
  ALLEGRO_KEY_F10 = 56;
  ALLEGRO_KEY_F11 = 57;
  ALLEGRO_KEY_F12 = 58;
  ALLEGRO_KEY_ESCAPE = 59;
  ALLEGRO_KEY_TILDE = 60;
  ALLEGRO_KEY_MINUS = 61;
  ALLEGRO_KEY_EQUALS = 62;
  ALLEGRO_KEY_BACKSPACE = 63;
  ALLEGRO_KEY_TAB = 64;
  ALLEGRO_KEY_OPENBRACE = 65;
  ALLEGRO_KEY_CLOSEBRACE = 66;
  ALLEGRO_KEY_ENTER = 67;
  ALLEGRO_KEY_SEMICOLON = 68;
  ALLEGRO_KEY_QUOTE = 69;
  ALLEGRO_KEY_BACKSLASH = 70;
  ALLEGRO_KEY_BACKSLASH2 = 71;
  ALLEGRO_KEY_COMMA = 72;
  ALLEGRO_KEY_FULLSTOP = 73;
  ALLEGRO_KEY_SLASH = 74;
  ALLEGRO_KEY_SPACE = 75;
  ALLEGRO_KEY_INSERT = 76;
  ALLEGRO_KEY_DELETE = 77;
  ALLEGRO_KEY_HOME = 78;
  ALLEGRO_KEY_END = 79;
  ALLEGRO_KEY_PGUP = 80;
  ALLEGRO_KEY_PGDN = 81;
  ALLEGRO_KEY_LEFT = 82;
  ALLEGRO_KEY_RIGHT = 83;
  ALLEGRO_KEY_UP = 84;
  ALLEGRO_KEY_DOWN = 85;
  ALLEGRO_KEY_PAD_SLASH = 86;
  ALLEGRO_KEY_PAD_ASTERISK = 87;
  ALLEGRO_KEY_PAD_MINUS = 88;
  ALLEGRO_KEY_PAD_PLUS = 89;
  ALLEGRO_KEY_PAD_DELETE = 90;
  ALLEGRO_KEY_PAD_ENTER = 91;
  ALLEGRO_KEY_PRINTSCREEN = 92;
  ALLEGRO_KEY_PAUSE = 93;
  ALLEGRO_KEY_ABNT_C1 = 94;
  ALLEGRO_KEY_YEN = 95;
  ALLEGRO_KEY_KANA = 96;
  ALLEGRO_KEY_CONVERT = 97;
  ALLEGRO_KEY_NOCONVERT = 98;
  ALLEGRO_KEY_AT = 99;
  ALLEGRO_KEY_CIRCUMFLEX = 100;
  ALLEGRO_KEY_COLON2 = 101;
  ALLEGRO_KEY_KANJI = 102;
  ALLEGRO_KEY_PAD_EQUALS = 103;
  ALLEGRO_KEY_BACKQUOTE = 104;
  ALLEGRO_KEY_SEMICOLON2 = 105;
  ALLEGRO_KEY_COMMAND = 106;
  ALLEGRO_KEY_BACK = 107;
  ALLEGRO_KEY_VOLUME_UP = 108;
  ALLEGRO_KEY_VOLUME_DOWN = 109;
  ALLEGRO_KEY_SEARCH = 110;
  ALLEGRO_KEY_DPAD_CENTER = 111;
  ALLEGRO_KEY_BUTTON_X = 112;
  ALLEGRO_KEY_BUTTON_Y = 113;
  ALLEGRO_KEY_DPAD_UP = 114;
  ALLEGRO_KEY_DPAD_DOWN = 115;
  ALLEGRO_KEY_DPAD_LEFT = 116;
  ALLEGRO_KEY_DPAD_RIGHT = 117;
  ALLEGRO_KEY_SELECT = 118;
  ALLEGRO_KEY_START = 119;
  ALLEGRO_KEY_BUTTON_L1 = 120;
  ALLEGRO_KEY_BUTTON_R1 = 121;
  ALLEGRO_KEY_BUTTON_L2 = 122;
  ALLEGRO_KEY_BUTTON_R2 = 123;
  ALLEGRO_KEY_BUTTON_A = 124;
  ALLEGRO_KEY_BUTTON_B = 125;
  ALLEGRO_KEY_THUMBL = 126;
  ALLEGRO_KEY_THUMBR = 127;
  ALLEGRO_KEY_UNKNOWN = 128;
  ALLEGRO_KEY_MODIFIERS = 215;
  ALLEGRO_KEY_LSHIFT = 215;
  ALLEGRO_KEY_RSHIFT = 216;
  ALLEGRO_KEY_LCTRL = 217;
  ALLEGRO_KEY_RCTRL = 218;
  ALLEGRO_KEY_ALT = 219;
  ALLEGRO_KEY_ALTGR = 220;
  ALLEGRO_KEY_LWIN = 221;
  ALLEGRO_KEY_RWIN = 222;
  ALLEGRO_KEY_MENU = 223;
  ALLEGRO_KEY_SCROLLLOCK = 224;
  ALLEGRO_KEY_NUMLOCK = 225;
  ALLEGRO_KEY_CAPSLOCK = 226;
  ALLEGRO_KEY_MAX = 227;

type
  _anonymous_type_10 = Integer;
  P_anonymous_type_10 = ^_anonymous_type_10;

const
  ALLEGRO_KEYMOD_SHIFT = 1;
  ALLEGRO_KEYMOD_CTRL = 2;
  ALLEGRO_KEYMOD_ALT = 4;
  ALLEGRO_KEYMOD_LWIN = 8;
  ALLEGRO_KEYMOD_RWIN = 16;
  ALLEGRO_KEYMOD_MENU = 32;
  ALLEGRO_KEYMOD_ALTGR = 64;
  ALLEGRO_KEYMOD_COMMAND = 128;
  ALLEGRO_KEYMOD_SCROLLLOCK = 256;
  ALLEGRO_KEYMOD_NUMLOCK = 512;
  ALLEGRO_KEYMOD_CAPSLOCK = 1024;
  ALLEGRO_KEYMOD_INALTSEQ = 2048;
  ALLEGRO_KEYMOD_ACCENT1 = 4096;
  ALLEGRO_KEYMOD_ACCENT2 = 8192;
  ALLEGRO_KEYMOD_ACCENT3 = 16384;
  ALLEGRO_KEYMOD_ACCENT4 = 32768;

type
  _anonymous_type_11 = Integer;
  P_anonymous_type_11 = ^_anonymous_type_11;

const
  ALLEGRO_DEFAULT_DISPLAY_ADAPTER = -1;

type
  ALLEGRO_SYSTEM_MOUSE_CURSOR = Integer;
  PALLEGRO_SYSTEM_MOUSE_CURSOR = ^ALLEGRO_SYSTEM_MOUSE_CURSOR;

const
  ALLEGRO_SYSTEM_MOUSE_CURSOR_NONE = 0;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_DEFAULT = 1;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_ARROW = 2;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_BUSY = 3;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_QUESTION = 4;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_EDIT = 5;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_MOVE = 6;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_N = 7;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_W = 8;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_S = 9;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_E = 10;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_NW = 11;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_SW = 12;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_SE = 13;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_RESIZE_NE = 14;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_PROGRESS = 15;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_PRECISION = 16;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_LINK = 17;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_ALT_SELECT = 18;
  ALLEGRO_SYSTEM_MOUSE_CURSOR_UNAVAILABLE = 19;
  ALLEGRO_NUM_SYSTEM_MOUSE_CURSORS = 20;

type
  ALLEGRO_RENDER_STATE = Integer;
  PALLEGRO_RENDER_STATE = ^ALLEGRO_RENDER_STATE;

const
  ALLEGRO_ALPHA_TEST = 16;
  ALLEGRO_WRITE_MASK = 17;
  ALLEGRO_DEPTH_TEST = 18;
  ALLEGRO_DEPTH_FUNCTION = 19;
  ALLEGRO_ALPHA_FUNCTION = 20;
  ALLEGRO_ALPHA_TEST_VALUE = 21;

type
  ALLEGRO_RENDER_FUNCTION = Integer;
  PALLEGRO_RENDER_FUNCTION = ^ALLEGRO_RENDER_FUNCTION;

const
  ALLEGRO_RENDER_NEVER = 0;
  ALLEGRO_RENDER_ALWAYS = 1;
  ALLEGRO_RENDER_LESS = 2;
  ALLEGRO_RENDER_EQUAL = 3;
  ALLEGRO_RENDER_LESS_EQUAL = 4;
  ALLEGRO_RENDER_GREATER = 5;
  ALLEGRO_RENDER_NOT_EQUAL = 6;
  ALLEGRO_RENDER_GREATER_EQUAL = 7;

type
  ALLEGRO_WRITE_MASK_FLAGS = Integer;
  PALLEGRO_WRITE_MASK_FLAGS = ^ALLEGRO_WRITE_MASK_FLAGS;

const
  ALLEGRO_MASK_RED = 1;
  ALLEGRO_MASK_GREEN = 2;
  ALLEGRO_MASK_BLUE = 4;
  ALLEGRO_MASK_ALPHA = 8;
  ALLEGRO_MASK_DEPTH = 16;
  ALLEGRO_MASK_RGB = 7;
  ALLEGRO_MASK_RGBA = 15;

type
  ALLEGRO_SHADER_TYPE = Integer;
  PALLEGRO_SHADER_TYPE = ^ALLEGRO_SHADER_TYPE;

const
  ALLEGRO_VERTEX_SHADER = 1;
  ALLEGRO_PIXEL_SHADER = 2;

type
  ALLEGRO_SHADER_PLATFORM = Integer;
  PALLEGRO_SHADER_PLATFORM = ^ALLEGRO_SHADER_PLATFORM;

const
  ALLEGRO_SHADER_AUTO = 0;
  ALLEGRO_SHADER_GLSL = 1;
  ALLEGRO_SHADER_HLSL = 2;

type
  ALLEGRO_SYSTEM_ID = Integer;
  PALLEGRO_SYSTEM_ID = ^ALLEGRO_SYSTEM_ID;

const
  ALLEGRO_SYSTEM_ID_UNKNOWN = 0;
  ALLEGRO_SYSTEM_ID_XGLX = 1481067608;
  ALLEGRO_SYSTEM_ID_WINDOWS = 1464421956;
  ALLEGRO_SYSTEM_ID_MACOSX = 1330862112;
  ALLEGRO_SYSTEM_ID_ANDROID = 1095648338;
  ALLEGRO_SYSTEM_ID_IPHONE = 1229998159;
  ALLEGRO_SYSTEM_ID_GP2XWIZ = 1464424992;
  ALLEGRO_SYSTEM_ID_RASPBERRYPI = 1380012880;
  ALLEGRO_SYSTEM_ID_SDL = 1396984882;

type
  _anonymous_type_12 = Integer;
  P_anonymous_type_12 = ^_anonymous_type_12;

const
  ALLEGRO_RESOURCES_PATH = 0;
  ALLEGRO_TEMP_PATH = 1;
  ALLEGRO_USER_DATA_PATH = 2;
  ALLEGRO_USER_HOME_PATH = 3;
  ALLEGRO_USER_SETTINGS_PATH = 4;
  ALLEGRO_USER_DOCUMENTS_PATH = 5;
  ALLEGRO_EXENAME_PATH = 6;
  ALLEGRO_LAST_PATH = 7;

type
  ALLEGRO_STATE_FLAGS = Integer;
  PALLEGRO_STATE_FLAGS = ^ALLEGRO_STATE_FLAGS;

const
  ALLEGRO_STATE_NEW_DISPLAY_PARAMETERS = 1;
  ALLEGRO_STATE_NEW_BITMAP_PARAMETERS = 2;
  ALLEGRO_STATE_DISPLAY = 4;
  ALLEGRO_STATE_TARGET_BITMAP = 8;
  ALLEGRO_STATE_BLENDER = 16;
  ALLEGRO_STATE_NEW_FILE_INTERFACE = 32;
  ALLEGRO_STATE_TRANSFORM = 64;
  ALLEGRO_STATE_PROJECTION_TRANSFORM = 256;
  ALLEGRO_STATE_BITMAP = 10;
  ALLEGRO_STATE_ALL = 65535;

type
  ALLEGRO_AUDIO_EVENT_TYPE = Integer;
  PALLEGRO_AUDIO_EVENT_TYPE = ^ALLEGRO_AUDIO_EVENT_TYPE;

const
  _KCM_STREAM_FEEDER_QUIT_EVENT_TYPE = 512;
  ALLEGRO_EVENT_AUDIO_STREAM_FRAGMENT = 513;
  ALLEGRO_EVENT_AUDIO_STREAM_FINISHED = 514;

type
  ALLEGRO_AUDIO_DEPTH = Integer;
  PALLEGRO_AUDIO_DEPTH = ^ALLEGRO_AUDIO_DEPTH;

const
  ALLEGRO_AUDIO_DEPTH_INT8 = 0;
  ALLEGRO_AUDIO_DEPTH_INT16 = 1;
  ALLEGRO_AUDIO_DEPTH_INT24 = 2;
  ALLEGRO_AUDIO_DEPTH_FLOAT32 = 3;
  ALLEGRO_AUDIO_DEPTH_UNSIGNED = 8;
  ALLEGRO_AUDIO_DEPTH_UINT8 = 8;
  ALLEGRO_AUDIO_DEPTH_UINT16 = 9;
  ALLEGRO_AUDIO_DEPTH_UINT24 = 10;

type
  ALLEGRO_CHANNEL_CONF = Integer;
  PALLEGRO_CHANNEL_CONF = ^ALLEGRO_CHANNEL_CONF;

const
  ALLEGRO_CHANNEL_CONF_1 = 16;
  ALLEGRO_CHANNEL_CONF_2 = 32;
  ALLEGRO_CHANNEL_CONF_3 = 48;
  ALLEGRO_CHANNEL_CONF_4 = 64;
  ALLEGRO_CHANNEL_CONF_5_1 = 81;
  ALLEGRO_CHANNEL_CONF_6_1 = 97;
  ALLEGRO_CHANNEL_CONF_7_1 = 113;

type
  ALLEGRO_PLAYMODE = Integer;
  PALLEGRO_PLAYMODE = ^ALLEGRO_PLAYMODE;

const
  ALLEGRO_PLAYMODE_ONCE = 256;
  ALLEGRO_PLAYMODE_LOOP = 257;
  ALLEGRO_PLAYMODE_BIDIR = 258;
  _ALLEGRO_PLAYMODE_STREAM_ONCE = 259;
  _ALLEGRO_PLAYMODE_STREAM_ONEDIR = 260;

type
  ALLEGRO_MIXER_QUALITY = Integer;
  PALLEGRO_MIXER_QUALITY = ^ALLEGRO_MIXER_QUALITY;

const
  ALLEGRO_MIXER_QUALITY_POINT = 272;
  ALLEGRO_MIXER_QUALITY_LINEAR = 273;
  ALLEGRO_MIXER_QUALITY_CUBIC = 274;

type
  _anonymous_type_13 = Integer;
  P_anonymous_type_13 = ^_anonymous_type_13;

const
  ALLEGRO_NO_KERNING = -1;
  ALLEGRO_ALIGN_LEFT = 0;
  ALLEGRO_ALIGN_CENTRE = 1;
  ALLEGRO_ALIGN_CENTER = 1;
  ALLEGRO_ALIGN_RIGHT = 2;
  ALLEGRO_ALIGN_INTEGER = 4;

type
  _anonymous_type_14 = Integer;
  P_anonymous_type_14 = ^_anonymous_type_14;

const
  ALLEGRO_FILECHOOSER_FILE_MUST_EXIST = 1;
  ALLEGRO_FILECHOOSER_SAVE = 2;
  ALLEGRO_FILECHOOSER_FOLDER = 4;
  ALLEGRO_FILECHOOSER_PICTURES = 8;
  ALLEGRO_FILECHOOSER_SHOW_HIDDEN = 16;
  ALLEGRO_FILECHOOSER_MULTIPLE = 32;

type
  _anonymous_type_15 = Integer;
  P_anonymous_type_15 = ^_anonymous_type_15;

const
  ALLEGRO_MESSAGEBOX_WARN = 1;
  ALLEGRO_MESSAGEBOX_ERROR = 2;
  ALLEGRO_MESSAGEBOX_OK_CANCEL = 4;
  ALLEGRO_MESSAGEBOX_YES_NO = 8;
  ALLEGRO_MESSAGEBOX_QUESTION = 16;

type
  _anonymous_type_16 = Integer;
  P_anonymous_type_16 = ^_anonymous_type_16;

const
  ALLEGRO_TEXTLOG_NO_CLOSE = 1;
  ALLEGRO_TEXTLOG_MONOSPACE = 2;

type
  _anonymous_type_17 = Integer;
  P_anonymous_type_17 = ^_anonymous_type_17;

const
  ALLEGRO_EVENT_NATIVE_DIALOG_CLOSE = 600;
  ALLEGRO_EVENT_MENU_CLICK = 601;

type
  _anonymous_type_18 = Integer;
  P_anonymous_type_18 = ^_anonymous_type_18;

const
  ALLEGRO_MENU_ITEM_ENABLED = 0;
  ALLEGRO_MENU_ITEM_CHECKBOX = 1;
  ALLEGRO_MENU_ITEM_CHECKED = 2;
  ALLEGRO_MENU_ITEM_DISABLED = 4;

type
  ALLEGRO_OPENGL_VARIANT = Integer;
  PALLEGRO_OPENGL_VARIANT = ^ALLEGRO_OPENGL_VARIANT;

const
  ALLEGRO_DESKTOP_OPENGL = 0;
  ALLEGRO_OPENGL_ES = 1;

type
  ALLEGRO_PRIM_TYPE = Integer;
  PALLEGRO_PRIM_TYPE = ^ALLEGRO_PRIM_TYPE;

const
  ALLEGRO_PRIM_LINE_LIST = 0;
  ALLEGRO_PRIM_LINE_STRIP = 1;
  ALLEGRO_PRIM_LINE_LOOP = 2;
  ALLEGRO_PRIM_TRIANGLE_LIST = 3;
  ALLEGRO_PRIM_TRIANGLE_STRIP = 4;
  ALLEGRO_PRIM_TRIANGLE_FAN = 5;
  ALLEGRO_PRIM_POINT_LIST = 6;
  ALLEGRO_PRIM_NUM_TYPES = 7;

type
  _anonymous_type_19 = Integer;
  P_anonymous_type_19 = ^_anonymous_type_19;

const
  ALLEGRO_PRIM_MAX_USER_ATTR = 10;

type
  ALLEGRO_PRIM_ATTR = Integer;
  PALLEGRO_PRIM_ATTR = ^ALLEGRO_PRIM_ATTR;

const
  ALLEGRO_PRIM_POSITION = 1;
  ALLEGRO_PRIM_COLOR_ATTR = 2;
  ALLEGRO_PRIM_TEX_COORD = 3;
  ALLEGRO_PRIM_TEX_COORD_PIXEL = 4;
  ALLEGRO_PRIM_USER_ATTR = 5;
  ALLEGRO_PRIM_ATTR_NUM = 15;

type
  ALLEGRO_PRIM_STORAGE = Integer;
  PALLEGRO_PRIM_STORAGE = ^ALLEGRO_PRIM_STORAGE;

const
  ALLEGRO_PRIM_FLOAT_2 = 0;
  ALLEGRO_PRIM_FLOAT_3 = 1;
  ALLEGRO_PRIM_SHORT_2 = 2;
  ALLEGRO_PRIM_FLOAT_1 = 3;
  ALLEGRO_PRIM_FLOAT_4 = 4;
  ALLEGRO_PRIM_UBYTE_4 = 5;
  ALLEGRO_PRIM_SHORT_4 = 6;
  ALLEGRO_PRIM_NORMALIZED_UBYTE_4 = 7;
  ALLEGRO_PRIM_NORMALIZED_SHORT_2 = 8;
  ALLEGRO_PRIM_NORMALIZED_SHORT_4 = 9;
  ALLEGRO_PRIM_NORMALIZED_USHORT_2 = 10;
  ALLEGRO_PRIM_NORMALIZED_USHORT_4 = 11;
  ALLEGRO_PRIM_HALF_FLOAT_2 = 12;
  ALLEGRO_PRIM_HALF_FLOAT_4 = 13;

type
  ALLEGRO_LINE_JOIN = Integer;
  PALLEGRO_LINE_JOIN = ^ALLEGRO_LINE_JOIN;

const
  ALLEGRO_LINE_JOIN_NONE = 0;
  ALLEGRO_LINE_JOIN_BEVEL = 1;
  ALLEGRO_LINE_JOIN_ROUND = 2;
  ALLEGRO_LINE_JOIN_MITER = 3;
  ALLEGRO_LINE_JOIN_MITRE = 3;

type
  ALLEGRO_LINE_CAP = Integer;
  PALLEGRO_LINE_CAP = ^ALLEGRO_LINE_CAP;

const
  ALLEGRO_LINE_CAP_NONE = 0;
  ALLEGRO_LINE_CAP_SQUARE = 1;
  ALLEGRO_LINE_CAP_ROUND = 2;
  ALLEGRO_LINE_CAP_TRIANGLE = 3;
  ALLEGRO_LINE_CAP_CLOSED = 4;

type
  ALLEGRO_PRIM_BUFFER_FLAGS = Integer;
  PALLEGRO_PRIM_BUFFER_FLAGS = ^ALLEGRO_PRIM_BUFFER_FLAGS;

const
  ALLEGRO_PRIM_BUFFER_STREAM = 1;
  ALLEGRO_PRIM_BUFFER_STATIC = 2;
  ALLEGRO_PRIM_BUFFER_DYNAMIC = 4;
  ALLEGRO_PRIM_BUFFER_READWRITE = 8;

type
  ALLEGRO_VIDEO_EVENT_TYPE = Integer;
  PALLEGRO_VIDEO_EVENT_TYPE = ^ALLEGRO_VIDEO_EVENT_TYPE;

const
  ALLEGRO_EVENT_VIDEO_FRAME_SHOW = 550;
  ALLEGRO_EVENT_VIDEO_FINISHED = 551;
  _ALLEGRO_EVENT_VIDEO_SEEK = 552;

type
  ALLEGRO_VIDEO_POSITION_TYPE = Integer;
  PALLEGRO_VIDEO_POSITION_TYPE = ^ALLEGRO_VIDEO_POSITION_TYPE;

const
  ALLEGRO_VIDEO_POSITION_ACTUAL = 0;
  ALLEGRO_VIDEO_POSITION_VIDEO_DECODE = 1;
  ALLEGRO_VIDEO_POSITION_AUDIO_DECODE = 2;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  PUInt16 = ^UInt16;
  PALLEGRO_USER_EVENT_DESCRIPTOR = Pointer;
  PPALLEGRO_USER_EVENT_DESCRIPTOR = ^PALLEGRO_USER_EVENT_DESCRIPTOR;
  PALLEGRO_JOYSTICK_DRIVER = Pointer;
  PPALLEGRO_JOYSTICK_DRIVER = ^PALLEGRO_JOYSTICK_DRIVER;
  PALLEGRO_HAPTIC_DRIVER = Pointer;
  PPALLEGRO_HAPTIC_DRIVER = ^PALLEGRO_HAPTIC_DRIVER;
  PALLEGRO_TIMEOUT = ^ALLEGRO_TIMEOUT;
  PALLEGRO_COLOR = ^ALLEGRO_COLOR;
  P_al_tagbstring = ^_al_tagbstring;
  PALLEGRO_FILE_INTERFACE = ^ALLEGRO_FILE_INTERFACE;
  PALLEGRO_LOCKED_REGION = ^ALLEGRO_LOCKED_REGION;
  PALLEGRO_EVENT_SOURCE = ^ALLEGRO_EVENT_SOURCE;
  PALLEGRO_ANY_EVENT = ^ALLEGRO_ANY_EVENT;
  PALLEGRO_DISPLAY_EVENT = ^ALLEGRO_DISPLAY_EVENT;
  PALLEGRO_JOYSTICK_EVENT = ^ALLEGRO_JOYSTICK_EVENT;
  PALLEGRO_KEYBOARD_EVENT = ^ALLEGRO_KEYBOARD_EVENT;
  PALLEGRO_MOUSE_EVENT = ^ALLEGRO_MOUSE_EVENT;
  PALLEGRO_TIMER_EVENT = ^ALLEGRO_TIMER_EVENT;
  PALLEGRO_TOUCH_EVENT = ^ALLEGRO_TOUCH_EVENT;
  PALLEGRO_USER_EVENT = ^ALLEGRO_USER_EVENT;
  PALLEGRO_FS_ENTRY = ^ALLEGRO_FS_ENTRY;
  PALLEGRO_FS_INTERFACE = ^ALLEGRO_FS_INTERFACE;
  PALLEGRO_DISPLAY_MODE = ^ALLEGRO_DISPLAY_MODE;
  PALLEGRO_JOYSTICK_STATE = ^ALLEGRO_JOYSTICK_STATE;
  PALLEGRO_KEYBOARD_STATE = ^ALLEGRO_KEYBOARD_STATE;
  PALLEGRO_MOUSE_STATE = ^ALLEGRO_MOUSE_STATE;
  PALLEGRO_TOUCH_STATE = ^ALLEGRO_TOUCH_STATE;
  PALLEGRO_TOUCH_INPUT_STATE = ^ALLEGRO_TOUCH_INPUT_STATE;
  PALLEGRO_MEMORY_INTERFACE = ^ALLEGRO_MEMORY_INTERFACE;
  PALLEGRO_MONITOR_INFO = ^ALLEGRO_MONITOR_INFO;
  PALLEGRO_TRANSFORM = ^ALLEGRO_TRANSFORM;
  PALLEGRO_STATE = ^ALLEGRO_STATE;
  PALLEGRO_SAMPLE_ID = ^ALLEGRO_SAMPLE_ID;
  PALLEGRO_MENU_INFO = ^ALLEGRO_MENU_INFO;
  PALLEGRO_VERTEX_ELEMENT = ^ALLEGRO_VERTEX_ELEMENT;
  PALLEGRO_VERTEX = ^ALLEGRO_VERTEX;

  ALLEGRO_TIMEOUT = record
    __pad1__: UInt64;
    __pad2__: UInt64;
  end;

  ALLEGRO_COLOR = record
    r: Single;
    g: Single;
    b: Single;
    a: Single;
  end;

  _al_tagbstring = record
    mlen: Integer;
    slen: Integer;
    data: PByte;
  end;

  PALLEGRO_BITMAP = Pointer;
  PPALLEGRO_BITMAP = ^PALLEGRO_BITMAP;
  ALLEGRO_USTR = _al_tagbstring;
  PALLEGRO_USTR = ^ALLEGRO_USTR;
  ALLEGRO_USTR_INFO = _al_tagbstring;
  PALLEGRO_USTR_INFO = ^ALLEGRO_USTR_INFO;

  PALLEGRO_PATH = Pointer;
  PPALLEGRO_PATH = ^PALLEGRO_PATH;
  PALLEGRO_FILE = Pointer;
  PPALLEGRO_FILE = ^PALLEGRO_FILE;

  ALLEGRO_FILE_INTERFACE = record
    fi_fopen: function(const path: PUTF8Char; const mode: PUTF8Char)
      : Pointer; cdecl;
    fi_fclose: function(handle: PALLEGRO_FILE): Boolean; cdecl;
    fi_fread: function(f: PALLEGRO_FILE; ptr: Pointer; size: NativeUInt)
      : NativeUInt; cdecl;
    fi_fwrite: function(f: PALLEGRO_FILE; const ptr: Pointer; size: NativeUInt)
      : NativeUInt; cdecl;
    fi_fflush: function(f: PALLEGRO_FILE): Boolean; cdecl;
    fi_ftell: function(f: PALLEGRO_FILE): Int64; cdecl;
    fi_fseek: function(f: PALLEGRO_FILE; offset: Int64; whence: Integer)
      : Boolean; cdecl;
    fi_feof: function(f: PALLEGRO_FILE): Boolean; cdecl;
    fi_ferror: function(f: PALLEGRO_FILE): Integer; cdecl;
    fi_ferrmsg: function(f: PALLEGRO_FILE): PUTF8Char; cdecl;
    fi_fclearerr: procedure(f: PALLEGRO_FILE); cdecl;
    fi_fungetc: function(f: PALLEGRO_FILE; c: Integer): Integer; cdecl;
    fi_fsize: function(f: PALLEGRO_FILE): off_t; cdecl;
  end;

  ALLEGRO_IIO_LOADER_FUNCTION = function(const filename: PUTF8Char;
    flags: Integer): PALLEGRO_BITMAP; cdecl;

  ALLEGRO_IIO_FS_LOADER_FUNCTION = function(fp: PALLEGRO_FILE; flags: Integer)
    : PALLEGRO_BITMAP; cdecl;

  ALLEGRO_IIO_SAVER_FUNCTION = function(const filename: PUTF8Char;
    bitmap: PALLEGRO_BITMAP): Boolean; cdecl;

  ALLEGRO_IIO_FS_SAVER_FUNCTION = function(fp: PALLEGRO_FILE;
    bitmap: PALLEGRO_BITMAP): Boolean; cdecl;

  ALLEGRO_IIO_IDENTIFIER_FUNCTION = function(f: PALLEGRO_FILE): Boolean; cdecl;

  ALLEGRO_LOCKED_REGION = record
    data: Pointer;
    format: Integer;
    pitch: Integer;
    pixel_size: Integer;
  end;

  ALLEGRO_EVENT_TYPE = Cardinal;

  ALLEGRO_EVENT_SOURCE = record
    __pad: array [0 .. 31] of Integer;
  end;

  ALLEGRO_ANY_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_EVENT_SOURCE;
    timestamp: Double;
  end;

  PALLEGRO_DISPLAY = Pointer;
  PPALLEGRO_DISPLAY = ^PALLEGRO_DISPLAY;

  PALLEGRO_JOYSTICK = Pointer;
  PPALLEGRO_JOYSTICK = ^PALLEGRO_JOYSTICK;

  PALLEGRO_KEYBOARD = Pointer;
  PPALLEGRO_KEYBOARD = ^PALLEGRO_KEYBOARD;

  PALLEGRO_MOUSE = Pointer;
  PPALLEGRO_MOUSE = ^PALLEGRO_MOUSE;

  PALLEGRO_TIMER = Pointer;
  PPALLEGRO_TIMER = ^PALLEGRO_TIMER;

  PALLEGRO_TOUCH_INPUT = Pointer;
  PPALLEGRO_TOUCH_INPUT = ^PALLEGRO_TOUCH_INPUT;

  ALLEGRO_DISPLAY_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_DISPLAY;
    timestamp: Double;
    x: Integer;
    y: Integer;
    width: Integer;
    height: Integer;
    orientation: Integer;
  end;

  ALLEGRO_JOYSTICK_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_JOYSTICK;
    timestamp: Double;
    id: PALLEGRO_JOYSTICK;
    stick: Integer;
    axis: Integer;
    pos: Single;
    button: Integer;
  end;

  ALLEGRO_KEYBOARD_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_KEYBOARD;
    timestamp: Double;
    display: PALLEGRO_DISPLAY;
    keycode: Integer;
    unichar: Integer;
    modifiers: Cardinal;
    &repeat: Boolean;
  end;

  ALLEGRO_MOUSE_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_MOUSE;
    timestamp: Double;
    display: PALLEGRO_DISPLAY;
    x: Integer;
    y: Integer;
    z: Integer;
    w: Integer;
    dx: Integer;
    dy: Integer;
    dz: Integer;
    dw: Integer;
    button: Cardinal;
    pressure: Single;
  end;

  ALLEGRO_TIMER_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_TIMER;
    timestamp: Double;
    count: Int64;
    error: Double;
  end;

  ALLEGRO_TOUCH_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_TOUCH_INPUT;
    timestamp: Double;
    display: PALLEGRO_DISPLAY;
    id: Integer;
    x: Single;
    y: Single;
    dx: Single;
    dy: Single;
    primary: Boolean;
  end;

  ALLEGRO_USER_EVENT = record
    &type: ALLEGRO_EVENT_TYPE;
    source: PALLEGRO_EVENT_SOURCE;
    timestamp: Double;
    __internal__descr: PALLEGRO_USER_EVENT_DESCRIPTOR;
    data1: IntPtr;
    data2: IntPtr;
    data3: IntPtr;
    data4: IntPtr;
  end;

  PALLEGRO_EVENT = ^ALLEGRO_EVENT;

  ALLEGRO_EVENT = record
    case Integer of
      0:
      (&type: ALLEGRO_EVENT_TYPE);
      1:
      (any: ALLEGRO_ANY_EVENT);
      2:
      (display: ALLEGRO_DISPLAY_EVENT);
      3:
      (joystick: ALLEGRO_JOYSTICK_EVENT);
      4:
      (keyboard: ALLEGRO_KEYBOARD_EVENT);
      5:
      (mouse: ALLEGRO_MOUSE_EVENT);
      6:
      (timer: ALLEGRO_TIMER_EVENT);
      7:
      (touch: ALLEGRO_TOUCH_EVENT);
      8:
      (user: ALLEGRO_USER_EVENT);
  end;

  PALLEGRO_EVENT_QUEUE = Pointer;
  PPALLEGRO_EVENT_QUEUE = ^PALLEGRO_EVENT_QUEUE;
  PALLEGRO_CONFIG = Pointer;
  PPALLEGRO_CONFIG = ^PALLEGRO_CONFIG;
  PALLEGRO_CONFIG_SECTION = Pointer;
  PPALLEGRO_CONFIG_SECTION = ^PALLEGRO_CONFIG_SECTION;
  PALLEGRO_CONFIG_ENTRY = Pointer;
  PPALLEGRO_CONFIG_ENTRY = ^PALLEGRO_CONFIG_ENTRY;
  al_fixed = Int32;

  ALLEGRO_FS_ENTRY = record
    vtable: PALLEGRO_FS_INTERFACE;
  end;

  ALLEGRO_FS_INTERFACE = record
    fs_create_entry: function(const path: PUTF8Char): PALLEGRO_FS_ENTRY; cdecl;
    fs_destroy_entry: procedure(e: PALLEGRO_FS_ENTRY); cdecl;
    fs_entry_name: function(e: PALLEGRO_FS_ENTRY): PUTF8Char; cdecl;
    fs_update_entry: function(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
    fs_entry_mode: function(e: PALLEGRO_FS_ENTRY): UInt32; cdecl;
    fs_entry_atime: function(e: PALLEGRO_FS_ENTRY): longint; cdecl;
    fs_entry_mtime: function(e: PALLEGRO_FS_ENTRY): longint; cdecl;
    fs_entry_ctime: function(e: PALLEGRO_FS_ENTRY): longint; cdecl;
    fs_entry_size: function(e: PALLEGRO_FS_ENTRY): off_t; cdecl;
    fs_entry_exists: function(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
    fs_remove_entry: function(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
    fs_open_directory: function(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
    fs_read_directory: function(e: PALLEGRO_FS_ENTRY): PALLEGRO_FS_ENTRY; cdecl;
    fs_close_directory: function(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
    fs_filename_exists: function(const path: PUTF8Char): Boolean; cdecl;
    fs_remove_filename: function(const path: PUTF8Char): Boolean; cdecl;
    fs_get_current_directory: function(): PUTF8Char; cdecl;
    fs_change_directory: function(const path: PUTF8Char): Boolean; cdecl;
    fs_make_directory: function(const path: PUTF8Char): Boolean; cdecl;
    fs_open_file: function(e: PALLEGRO_FS_ENTRY; const mode: PUTF8Char)
      : PALLEGRO_FILE; cdecl;
  end;

  ALLEGRO_DISPLAY_MODE = record
    width: Integer;
    height: Integer;
    format: Integer;
    refresh_rate: Integer;
  end;

  _anonymous_type_20 = record
    axis: array [0 .. 2] of Single;
  end;

  P_anonymous_type_20 = ^_anonymous_type_20;

  ALLEGRO_JOYSTICK_STATE = record
    stick: array [0 .. 15] of _anonymous_type_20;
    button: array [0 .. 31] of Integer;
  end;

  ALLEGRO_KEYBOARD_STATE = record
    display: PALLEGRO_DISPLAY;
    __key_down__internal__: array [0 .. 7] of Cardinal;
  end;

  ALLEGRO_MOUSE_STATE = record
    x: Integer;
    y: Integer;
    z: Integer;
    w: Integer;
    more_axes: array [0 .. 3] of Integer;
    buttons: Integer;
    pressure: Single;
    display: PALLEGRO_DISPLAY;
  end;

  ALLEGRO_TOUCH_STATE = record
    id: Integer;
    x: Single;
    y: Single;
    dx: Single;
    dy: Single;
    primary: Boolean;
    display: PALLEGRO_DISPLAY;
  end;

  ALLEGRO_TOUCH_INPUT_STATE = record
    touches: array [0 .. 15] of ALLEGRO_TOUCH_STATE;
  end;

  ALLEGRO_MEMORY_INTERFACE = record
    mi_malloc: function(n: NativeUInt; line: Integer; const &file: PUTF8Char;
      const func: PUTF8Char): Pointer; cdecl;
    mi_free: procedure(ptr: Pointer; line: Integer; const &file: PUTF8Char;
      const func: PUTF8Char); cdecl;
    mi_realloc: function(ptr: Pointer; n: NativeUInt; line: Integer;
      const &file: PUTF8Char; const func: PUTF8Char): Pointer; cdecl;
    mi_calloc: function(count: NativeUInt; n: NativeUInt; line: Integer;
      const &file: PUTF8Char; const func: PUTF8Char): Pointer; cdecl;
  end;

  ALLEGRO_MONITOR_INFO = record
    x1: Integer;
    y1: Integer;
    x2: Integer;
    y2: Integer;
  end;

  PALLEGRO_MOUSE_CURSOR = Pointer;
  PPALLEGRO_MOUSE_CURSOR = ^PALLEGRO_MOUSE_CURSOR;

  ALLEGRO_TRANSFORM = record
    m: array [0 .. 3] of array [0 .. 3] of Single;
  end;

  PALLEGRO_SHADER = Pointer;
  PPALLEGRO_SHADER = ^PALLEGRO_SHADER;
  PALLEGRO_SYSTEM = Pointer;
  PPALLEGRO_SYSTEM = ^PALLEGRO_SYSTEM;
  PALLEGRO_THREAD = Pointer;
  PPALLEGRO_THREAD = ^PALLEGRO_THREAD;
  PALLEGRO_MUTEX = Pointer;
  PPALLEGRO_MUTEX = ^PALLEGRO_MUTEX;
  PALLEGRO_COND = Pointer;
  PPALLEGRO_COND = ^PALLEGRO_COND;

  ALLEGRO_STATE = record
    _tls: array [0 .. 1023] of UTF8Char;
  end;

  PALLEGRO_SAMPLE = Pointer;
  PPALLEGRO_SAMPLE = ^PALLEGRO_SAMPLE;

  ALLEGRO_SAMPLE_ID = record
    _index: Integer;
    _id: Integer;
  end;

  PALLEGRO_SAMPLE_INSTANCE = Pointer;
  PPALLEGRO_SAMPLE_INSTANCE = ^PALLEGRO_SAMPLE_INSTANCE;
  PALLEGRO_AUDIO_STREAM = Pointer;
  PPALLEGRO_AUDIO_STREAM = ^PALLEGRO_AUDIO_STREAM;
  PALLEGRO_MIXER = Pointer;
  PPALLEGRO_MIXER = ^PALLEGRO_MIXER;
  PALLEGRO_VOICE = Pointer;
  PPALLEGRO_VOICE = ^PALLEGRO_VOICE;
  PALLEGRO_FONT = Pointer;
  PPALLEGRO_FONT = ^PALLEGRO_FONT;
  PALLEGRO_FILECHOOSER = Pointer;
  PPALLEGRO_FILECHOOSER = ^PALLEGRO_FILECHOOSER;
  PALLEGRO_TEXTLOG = Pointer;
  PPALLEGRO_TEXTLOG = ^PALLEGRO_TEXTLOG;
  PALLEGRO_MENU = Pointer;
  PPALLEGRO_MENU = ^PALLEGRO_MENU;

  ALLEGRO_MENU_INFO = record
    caption: PUTF8Char;
    id: UInt16;
    flags: Integer;
    icon: PALLEGRO_BITMAP;
  end;

  PALLEGRO_OGL_EXT_LIST = Pointer;
  PPALLEGRO_OGL_EXT_LIST = ^PALLEGRO_OGL_EXT_LIST;

  ALLEGRO_VERTEX_ELEMENT = record
    attribute: Integer;
    storage: Integer;
    offset: Integer;
  end;

  PALLEGRO_VERTEX_DECL = Pointer;
  PPALLEGRO_VERTEX_DECL = ^PALLEGRO_VERTEX_DECL;

  ALLEGRO_VERTEX = record
    x: Single;
    y: Single;
    z: Single;
    u: Single;
    v: Single;
    color: ALLEGRO_COLOR;
  end;

  PALLEGRO_VERTEX_BUFFER = Pointer;
  PPALLEGRO_VERTEX_BUFFER = ^PALLEGRO_VERTEX_BUFFER;
  PALLEGRO_INDEX_BUFFER = Pointer;
  PPALLEGRO_INDEX_BUFFER = ^PALLEGRO_INDEX_BUFFER;
  PALLEGRO_VIDEO = Pointer;
  PPALLEGRO_VIDEO = ^PALLEGRO_VIDEO;

function al_get_allegro_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_version';

type
  al_run_main_ = function(p1: Integer; p2: PPUTF8Char): Integer; cdecl;

function al_run_main(argc: Integer; argv: PPUTF8Char; p3: al_run_main_)
  : Integer; cdecl; external cDllName name _PU + 'al_run_main';

function al_get_time(): Double; cdecl;
  external cDllName name _PU + 'al_get_time';

procedure al_rest(seconds: Double); cdecl;
  external cDllName name _PU + 'al_rest';

procedure al_init_timeout(timeout: PALLEGRO_TIMEOUT; seconds: Double); cdecl;
  external cDllName name _PU + 'al_init_timeout';

function al_map_rgb(r: Byte; g: Byte; b: Byte): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_map_rgb';

function al_map_rgba(r: Byte; g: Byte; b: Byte; a: Byte): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_map_rgba';

function al_map_rgb_f(r: Single; g: Single; b: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_map_rgb_f';

function al_map_rgba_f(r: Single; g: Single; b: Single; a: Single)
  : ALLEGRO_COLOR; cdecl; external cDllName name _PU + 'al_map_rgba_f';

function al_premul_rgba(r: Byte; g: Byte; b: Byte; a: Byte): ALLEGRO_COLOR;
  cdecl; external cDllName name _PU + 'al_premul_rgba';

function al_premul_rgba_f(r: Single; g: Single; b: Single; a: Single)
  : ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_premul_rgba_f';

procedure al_unmap_rgb(color: ALLEGRO_COLOR; r: PByte; g: PByte; b: PByte);
  cdecl; external cDllName name _PU + 'al_unmap_rgb';

procedure al_unmap_rgba(color: ALLEGRO_COLOR; r: PByte; g: PByte; b: PByte;
  a: PByte); cdecl; external cDllName name _PU + 'al_unmap_rgba';

procedure al_unmap_rgb_f(color: ALLEGRO_COLOR; r: PSingle; g: PSingle;
  b: PSingle); cdecl; external cDllName name _PU + 'al_unmap_rgb_f';

procedure al_unmap_rgba_f(color: ALLEGRO_COLOR; r: PSingle; g: PSingle;
  b: PSingle; a: PSingle); cdecl;
  external cDllName name _PU + 'al_unmap_rgba_f';

function al_get_pixel_size(format: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_pixel_size';

function al_get_pixel_format_bits(format: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_pixel_format_bits';

function al_get_pixel_block_size(format: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_pixel_block_size';

function al_get_pixel_block_width(format: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_pixel_block_width';

function al_get_pixel_block_height(format: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_pixel_block_height';

procedure al_set_new_bitmap_format(format: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_bitmap_format';

procedure al_set_new_bitmap_flags(flags: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_bitmap_flags';

function al_get_new_bitmap_format(): Integer; cdecl;
  external cDllName name _PU + 'al_get_new_bitmap_format';

function al_get_new_bitmap_flags(): Integer; cdecl;
  external cDllName name _PU + 'al_get_new_bitmap_flags';

procedure al_add_new_bitmap_flag(flag: Integer); cdecl;
  external cDllName name _PU + 'al_add_new_bitmap_flag';

function al_get_bitmap_width(bitmap: PALLEGRO_BITMAP): Integer; cdecl;
  external cDllName name _PU + 'al_get_bitmap_width';

function al_get_bitmap_height(bitmap: PALLEGRO_BITMAP): Integer; cdecl;
  external cDllName name _PU + 'al_get_bitmap_height';

function al_get_bitmap_format(bitmap: PALLEGRO_BITMAP): Integer; cdecl;
  external cDllName name _PU + 'al_get_bitmap_format';

function al_get_bitmap_flags(bitmap: PALLEGRO_BITMAP): Integer; cdecl;
  external cDllName name _PU + 'al_get_bitmap_flags';

function al_create_bitmap(w: Integer; h: Integer): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_create_bitmap';

procedure al_destroy_bitmap(bitmap: PALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_destroy_bitmap';

procedure al_put_pixel(x: Integer; y: Integer; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_put_pixel';

procedure al_put_blended_pixel(x: Integer; y: Integer; color: ALLEGRO_COLOR);
  cdecl; external cDllName name _PU + 'al_put_blended_pixel';

function al_get_pixel(bitmap: PALLEGRO_BITMAP; x: Integer; y: Integer)
  : ALLEGRO_COLOR; cdecl; external cDllName name _PU + 'al_get_pixel';

procedure al_convert_mask_to_alpha(bitmap: PALLEGRO_BITMAP;
  mask_color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_convert_mask_to_alpha';

procedure al_set_clipping_rectangle(x: Integer; y: Integer; width: Integer;
  height: Integer); cdecl;
  external cDllName name _PU + 'al_set_clipping_rectangle';

procedure al_reset_clipping_rectangle(); cdecl;
  external cDllName name _PU + 'al_reset_clipping_rectangle';

procedure al_get_clipping_rectangle(x: PInteger; y: PInteger; w: PInteger;
  h: PInteger); cdecl; external cDllName name _PU +
  'al_get_clipping_rectangle';

function al_create_sub_bitmap(parent: PALLEGRO_BITMAP; x: Integer; y: Integer;
  w: Integer; h: Integer): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_create_sub_bitmap';

function al_is_sub_bitmap(bitmap: PALLEGRO_BITMAP): Boolean; cdecl;
  external cDllName name _PU + 'al_is_sub_bitmap';

function al_get_parent_bitmap(bitmap: PALLEGRO_BITMAP): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_get_parent_bitmap';

function al_get_bitmap_x(bitmap: PALLEGRO_BITMAP): Integer; cdecl;
  external cDllName name _PU + 'al_get_bitmap_x';

function al_get_bitmap_y(bitmap: PALLEGRO_BITMAP): Integer; cdecl;
  external cDllName name _PU + 'al_get_bitmap_y';

procedure al_reparent_bitmap(bitmap: PALLEGRO_BITMAP; parent: PALLEGRO_BITMAP;
  x: Integer; y: Integer; w: Integer; h: Integer); cdecl;
  external cDllName name _PU + 'al_reparent_bitmap';

function al_clone_bitmap(bitmap: PALLEGRO_BITMAP): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_clone_bitmap';

procedure al_convert_bitmap(bitmap: PALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_convert_bitmap';

procedure al_convert_memory_bitmaps(); cdecl;
  external cDllName name _PU + 'al_convert_memory_bitmaps';

procedure al_draw_bitmap(bitmap: PALLEGRO_BITMAP; dx: Single; dy: Single;
  flags: Integer); cdecl; external cDllName name _PU + 'al_draw_bitmap';

procedure al_draw_bitmap_region(bitmap: PALLEGRO_BITMAP; sx: Single; sy: Single;
  sw: Single; sh: Single; dx: Single; dy: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_bitmap_region';

procedure al_draw_scaled_bitmap(bitmap: PALLEGRO_BITMAP; sx: Single; sy: Single;
  sw: Single; sh: Single; dx: Single; dy: Single; dw: Single; dh: Single;
  flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_scaled_bitmap';

procedure al_draw_rotated_bitmap(bitmap: PALLEGRO_BITMAP; cx: Single;
  cy: Single; dx: Single; dy: Single; angle: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_rotated_bitmap';

procedure al_draw_scaled_rotated_bitmap(bitmap: PALLEGRO_BITMAP; cx: Single;
  cy: Single; dx: Single; dy: Single; xscale: Single; yscale: Single;
  angle: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_scaled_rotated_bitmap';

procedure al_draw_tinted_bitmap(bitmap: PALLEGRO_BITMAP; tint: ALLEGRO_COLOR;
  dx: Single; dy: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_tinted_bitmap';

procedure al_draw_tinted_bitmap_region(bitmap: PALLEGRO_BITMAP;
  tint: ALLEGRO_COLOR; sx: Single; sy: Single; sw: Single; sh: Single;
  dx: Single; dy: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_tinted_bitmap_region';

procedure al_draw_tinted_scaled_bitmap(bitmap: PALLEGRO_BITMAP;
  tint: ALLEGRO_COLOR; sx: Single; sy: Single; sw: Single; sh: Single;
  dx: Single; dy: Single; dw: Single; dh: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_tinted_scaled_bitmap';

procedure al_draw_tinted_rotated_bitmap(bitmap: PALLEGRO_BITMAP;
  tint: ALLEGRO_COLOR; cx: Single; cy: Single; dx: Single; dy: Single;
  angle: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_tinted_rotated_bitmap';

procedure al_draw_tinted_scaled_rotated_bitmap(bitmap: PALLEGRO_BITMAP;
  tint: ALLEGRO_COLOR; cx: Single; cy: Single; dx: Single; dy: Single;
  xscale: Single; yscale: Single; angle: Single; flags: Integer); cdecl;
  external cDllName name _PU + 'al_draw_tinted_scaled_rotated_bitmap';

procedure al_draw_tinted_scaled_rotated_bitmap_region(bitmap: PALLEGRO_BITMAP;
  sx: Single; sy: Single; sw: Single; sh: Single; tint: ALLEGRO_COLOR;
  cx: Single; cy: Single; dx: Single; dy: Single; xscale: Single;
  yscale: Single; angle: Single; flags: Integer); cdecl;
  external cDllName name _PU +
  'al_draw_tinted_scaled_rotated_bitmap_region';

function al_ustr_new(const s: PUTF8Char): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ustr_new';

function al_ustr_new_from_buffer(const s: PUTF8Char; size: NativeUInt)
  : PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ustr_new_from_buffer';

function al_ustr_newf(const fmt: PUTF8Char): PALLEGRO_USTR varargs; cdecl;
  external cDllName name _PU + 'al_ustr_newf';

procedure al_ustr_free(us: PALLEGRO_USTR); cdecl;
  external cDllName name _PU + 'al_ustr_free';

function al_cstr(const us: PALLEGRO_USTR): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_cstr';

procedure al_ustr_to_buffer(const us: PALLEGRO_USTR; buffer: PUTF8Char;
  size: Integer); cdecl;
  external cDllName name _PU + 'al_ustr_to_buffer';

function al_cstr_dup(const us: PALLEGRO_USTR): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_cstr_dup';

function al_ustr_dup(const us: PALLEGRO_USTR): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ustr_dup';

function al_ustr_dup_substr(const us: PALLEGRO_USTR; start_pos: Integer;
  end_pos: Integer): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ustr_dup_substr';

function al_ustr_empty_string(): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ustr_empty_string';

function al_ref_cstr(info: PALLEGRO_USTR_INFO; const s: PUTF8Char)
  : PALLEGRO_USTR; cdecl; external cDllName name _PU + 'al_ref_cstr';

function al_ref_buffer(info: PALLEGRO_USTR_INFO; const s: PUTF8Char;
  size: NativeUInt): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ref_buffer';

function al_ref_ustr(info: PALLEGRO_USTR_INFO; const us: PALLEGRO_USTR;
  start_pos: Integer; end_pos: Integer): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ref_ustr';

function al_ustr_size(const us: PALLEGRO_USTR): NativeUInt; cdecl;
  external cDllName name _PU + 'al_ustr_size';

function al_ustr_length(const us: PALLEGRO_USTR): NativeUInt; cdecl;
  external cDllName name _PU + 'al_ustr_length';

function al_ustr_offset(const us: PALLEGRO_USTR; index: Integer): Integer;
  cdecl; external cDllName name _PU + 'al_ustr_offset';

function al_ustr_next(const us: PALLEGRO_USTR; pos: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_next';

function al_ustr_prev(const us: PALLEGRO_USTR; pos: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_prev';

function al_ustr_get(const us: PALLEGRO_USTR; pos: Integer): Int32; cdecl;
  external cDllName name _PU + 'al_ustr_get';

function al_ustr_get_next(const us: PALLEGRO_USTR; pos: PInteger): Int32; cdecl;
  external cDllName name _PU + 'al_ustr_get_next';

function al_ustr_prev_get(const us: PALLEGRO_USTR; pos: PInteger): Int32; cdecl;
  external cDllName name _PU + 'al_ustr_prev_get';

function al_ustr_insert(us1: PALLEGRO_USTR; pos: Integer;
  const us2: PALLEGRO_USTR): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_insert';

function al_ustr_insert_cstr(us: PALLEGRO_USTR; pos: Integer;
  const us2: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_insert_cstr';

function al_ustr_insert_chr(us: PALLEGRO_USTR; pos: Integer; c: Int32)
  : NativeUInt; cdecl; external cDllName name _PU +
  'al_ustr_insert_chr';

function al_ustr_append(us1: PALLEGRO_USTR; const us2: PALLEGRO_USTR): Boolean;
  cdecl; external cDllName name _PU + 'al_ustr_append';

function al_ustr_append_cstr(us: PALLEGRO_USTR; const s: PUTF8Char): Boolean;
  cdecl; external cDllName name _PU + 'al_ustr_append_cstr';

function al_ustr_append_chr(us: PALLEGRO_USTR; c: Int32): NativeUInt; cdecl;
  external cDllName name _PU + 'al_ustr_append_chr';

function al_ustr_appendf(us: PALLEGRO_USTR; const fmt: PUTF8Char)
  : Boolean varargs; cdecl;
  external cDllName name _PU + 'al_ustr_appendf';

function al_ustr_vappendf(us: PALLEGRO_USTR; const fmt: PUTF8Char; ap: Pointer)
  : Boolean; cdecl; external cDllName name _PU + 'al_ustr_vappendf';

function al_ustr_remove_chr(us: PALLEGRO_USTR; pos: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_remove_chr';

function al_ustr_remove_range(us: PALLEGRO_USTR; start_pos: Integer;
  end_pos: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_remove_range';

function al_ustr_truncate(us: PALLEGRO_USTR; start_pos: Integer): Boolean;
  cdecl; external cDllName name _PU + 'al_ustr_truncate';

function al_ustr_ltrim_ws(us: PALLEGRO_USTR): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_ltrim_ws';

function al_ustr_rtrim_ws(us: PALLEGRO_USTR): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_rtrim_ws';

function al_ustr_trim_ws(us: PALLEGRO_USTR): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_trim_ws';

function al_ustr_assign(us1: PALLEGRO_USTR; const us2: PALLEGRO_USTR): Boolean;
  cdecl; external cDllName name _PU + 'al_ustr_assign';

function al_ustr_assign_substr(us1: PALLEGRO_USTR; const us2: PALLEGRO_USTR;
  start_pos: Integer; end_pos: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_assign_substr';

function al_ustr_assign_cstr(us1: PALLEGRO_USTR; const s: PUTF8Char): Boolean;
  cdecl; external cDllName name _PU + 'al_ustr_assign_cstr';

function al_ustr_set_chr(us: PALLEGRO_USTR; pos: Integer; c: Int32): NativeUInt;
  cdecl; external cDllName name _PU + 'al_ustr_set_chr';

function al_ustr_replace_range(us1: PALLEGRO_USTR; start_pos1: Integer;
  end_pos1: Integer; const us2: PALLEGRO_USTR): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_replace_range';

function al_ustr_find_chr(const us: PALLEGRO_USTR; start_pos: Integer; c: Int32)
  : Integer; cdecl; external cDllName name _PU + 'al_ustr_find_chr';

function al_ustr_rfind_chr(const us: PALLEGRO_USTR; start_pos: Integer;
  c: Int32): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_rfind_chr';

function al_ustr_find_set(const us: PALLEGRO_USTR; start_pos: Integer;
  const accept: PALLEGRO_USTR): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_find_set';

function al_ustr_find_set_cstr(const us: PALLEGRO_USTR; start_pos: Integer;
  const accept: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_find_set_cstr';

function al_ustr_find_cset(const us: PALLEGRO_USTR; start_pos: Integer;
  const reject: PALLEGRO_USTR): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_find_cset';

function al_ustr_find_cset_cstr(const us: PALLEGRO_USTR; start_pos: Integer;
  const reject: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_find_cset_cstr';

function al_ustr_find_str(const haystack: PALLEGRO_USTR; start_pos: Integer;
  const needle: PALLEGRO_USTR): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_find_str';

function al_ustr_find_cstr(const haystack: PALLEGRO_USTR; start_pos: Integer;
  const needle: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_find_cstr';

function al_ustr_rfind_str(const haystack: PALLEGRO_USTR; start_pos: Integer;
  const needle: PALLEGRO_USTR): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_rfind_str';

function al_ustr_rfind_cstr(const haystack: PALLEGRO_USTR; start_pos: Integer;
  const needle: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_rfind_cstr';

function al_ustr_find_replace(us: PALLEGRO_USTR; start_pos: Integer;
  const find: PALLEGRO_USTR; const replace: PALLEGRO_USTR): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_find_replace';

function al_ustr_find_replace_cstr(us: PALLEGRO_USTR; start_pos: Integer;
  const find: PUTF8Char; const replace: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_ustr_find_replace_cstr';

function al_ustr_equal(const us1: PALLEGRO_USTR; const us2: PALLEGRO_USTR)
  : Boolean; cdecl; external cDllName name _PU + 'al_ustr_equal';

function al_ustr_compare(const u: PALLEGRO_USTR; const v: PALLEGRO_USTR)
  : Integer; cdecl; external cDllName name _PU + 'al_ustr_compare';

function al_ustr_ncompare(const us1: PALLEGRO_USTR; const us2: PALLEGRO_USTR;
  n: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_ustr_ncompare';

function al_ustr_has_prefix(const u: PALLEGRO_USTR; const v: PALLEGRO_USTR)
  : Boolean; cdecl; external cDllName name _PU + 'al_ustr_has_prefix';

function al_ustr_has_prefix_cstr(const u: PALLEGRO_USTR; const s: PUTF8Char)
  : Boolean; cdecl; external cDllName name _PU +
  'al_ustr_has_prefix_cstr';

function al_ustr_has_suffix(const u: PALLEGRO_USTR; const v: PALLEGRO_USTR)
  : Boolean; cdecl; external cDllName name _PU + 'al_ustr_has_suffix';

function al_ustr_has_suffix_cstr(const us1: PALLEGRO_USTR; const s: PUTF8Char)
  : Boolean; cdecl; external cDllName name _PU +
  'al_ustr_has_suffix_cstr';

function al_utf8_width(c: Int32): NativeUInt; cdecl;
  external cDllName name _PU + 'al_utf8_width';

function al_utf8_encode(s: PUTF8Char; c: Int32): NativeUInt; cdecl;
  external cDllName name _PU + 'al_utf8_encode';

function al_ustr_new_from_utf16(const s: PUInt16): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_ustr_new_from_utf16';

function al_ustr_size_utf16(const us: PALLEGRO_USTR): NativeUInt; cdecl;
  external cDllName name _PU + 'al_ustr_size_utf16';

function al_ustr_encode_utf16(const us: PALLEGRO_USTR; s: PUInt16;
  n: NativeUInt): NativeUInt; cdecl;
  external cDllName name _PU + 'al_ustr_encode_utf16';

function al_utf16_width(c: Integer): NativeUInt; cdecl;
  external cDllName name _PU + 'al_utf16_width';

function al_utf16_encode(s: PUInt16; c: Int32): NativeUInt; cdecl;
  external cDllName name _PU + 'al_utf16_encode';

function al_create_path(const str: PUTF8Char): PALLEGRO_PATH; cdecl;
  external cDllName name _PU + 'al_create_path';

function al_create_path_for_directory(const str: PUTF8Char): PALLEGRO_PATH;
  cdecl; external cDllName name _PU + 'al_create_path_for_directory';

function al_clone_path(const path: PALLEGRO_PATH): PALLEGRO_PATH; cdecl;
  external cDllName name _PU + 'al_clone_path';

function al_get_path_num_components(const path: PALLEGRO_PATH): Integer; cdecl;
  external cDllName name _PU + 'al_get_path_num_components';

function al_get_path_component(const path: PALLEGRO_PATH; i: Integer)
  : PUTF8Char; cdecl; external cDllName name _PU +
  'al_get_path_component';

procedure al_replace_path_component(path: PALLEGRO_PATH; i: Integer;
  const s: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_replace_path_component';

procedure al_remove_path_component(path: PALLEGRO_PATH; i: Integer); cdecl;
  external cDllName name _PU + 'al_remove_path_component';

procedure al_insert_path_component(path: PALLEGRO_PATH; i: Integer;
  const s: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_insert_path_component';

function al_get_path_tail(const path: PALLEGRO_PATH): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_path_tail';

procedure al_drop_path_tail(path: PALLEGRO_PATH); cdecl;
  external cDllName name _PU + 'al_drop_path_tail';

procedure al_append_path_component(path: PALLEGRO_PATH; const s: PUTF8Char);
  cdecl; external cDllName name _PU + 'al_append_path_component';

function al_join_paths(path: PALLEGRO_PATH; const tail: PALLEGRO_PATH): Boolean;
  cdecl; external cDllName name _PU + 'al_join_paths';

function al_rebase_path(const head: PALLEGRO_PATH; tail: PALLEGRO_PATH)
  : Boolean; cdecl; external cDllName name _PU + 'al_rebase_path';

function al_path_cstr(const path: PALLEGRO_PATH; delim: UTF8Char): PUTF8Char;
  cdecl; external cDllName name _PU + 'al_path_cstr';

function al_path_ustr(const path: PALLEGRO_PATH; delim: UTF8Char)
  : PALLEGRO_USTR; cdecl; external cDllName name _PU + 'al_path_ustr';

procedure al_destroy_path(path: PALLEGRO_PATH); cdecl;
  external cDllName name _PU + 'al_destroy_path';

procedure al_set_path_drive(path: PALLEGRO_PATH; const drive: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_path_drive';

function al_get_path_drive(const path: PALLEGRO_PATH): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_path_drive';

procedure al_set_path_filename(path: PALLEGRO_PATH; const filename: PUTF8Char);
  cdecl; external cDllName name _PU + 'al_set_path_filename';

function al_get_path_filename(const path: PALLEGRO_PATH): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_path_filename';

function al_get_path_extension(const path: PALLEGRO_PATH): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_path_extension';

function al_set_path_extension(path: PALLEGRO_PATH; const extension: PUTF8Char)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_path_extension';

function al_get_path_basename(const path: PALLEGRO_PATH): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_path_basename';

function al_make_path_canonical(path: PALLEGRO_PATH): Boolean; cdecl;
  external cDllName name _PU + 'al_make_path_canonical';

function al_fopen(const path: PUTF8Char; const mode: PUTF8Char): PALLEGRO_FILE;
  cdecl; external cDllName name _PU + 'al_fopen';

function al_fopen_interface(const vt: PALLEGRO_FILE_INTERFACE;
  const path: PUTF8Char; const mode: PUTF8Char): PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_fopen_interface';

function al_create_file_handle(const vt: PALLEGRO_FILE_INTERFACE;
  userdata: Pointer): PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_create_file_handle';

function al_fclose(f: PALLEGRO_FILE): Boolean; cdecl;
  external cDllName name _PU + 'al_fclose';

function al_fread(f: PALLEGRO_FILE; ptr: Pointer; size: NativeUInt): NativeUInt;
  cdecl; external cDllName name _PU + 'al_fread';

function al_fwrite(f: PALLEGRO_FILE; const ptr: Pointer; size: NativeUInt)
  : NativeUInt; cdecl; external cDllName name _PU + 'al_fwrite';

function al_fflush(f: PALLEGRO_FILE): Boolean; cdecl;
  external cDllName name _PU + 'al_fflush';

function al_ftell(f: PALLEGRO_FILE): Int64; cdecl;
  external cDllName name _PU + 'al_ftell';

function al_fseek(f: PALLEGRO_FILE; offset: Int64; whence: Integer): Boolean;
  cdecl; external cDllName name _PU + 'al_fseek';

function al_feof(f: PALLEGRO_FILE): Boolean; cdecl;
  external cDllName name _PU + 'al_feof';

function al_ferror(f: PALLEGRO_FILE): Integer; cdecl;
  external cDllName name _PU + 'al_ferror';

function al_ferrmsg(f: PALLEGRO_FILE): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_ferrmsg';

procedure al_fclearerr(f: PALLEGRO_FILE); cdecl;
  external cDllName name _PU + 'al_fclearerr';

function al_fungetc(f: PALLEGRO_FILE; c: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_fungetc';

function al_fsize(f: PALLEGRO_FILE): Int64; cdecl;
  external cDllName name _PU + 'al_fsize';

function al_fgetc(f: PALLEGRO_FILE): Integer; cdecl;
  external cDllName name _PU + 'al_fgetc';

function al_fputc(f: PALLEGRO_FILE; c: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_fputc';

function al_fread16le(f: PALLEGRO_FILE): Int16; cdecl;
  external cDllName name _PU + 'al_fread16le';

function al_fread16be(f: PALLEGRO_FILE): Int16; cdecl;
  external cDllName name _PU + 'al_fread16be';

function al_fwrite16le(f: PALLEGRO_FILE; w: Int16): NativeUInt; cdecl;
  external cDllName name _PU + 'al_fwrite16le';

function al_fwrite16be(f: PALLEGRO_FILE; w: Int16): NativeUInt; cdecl;
  external cDllName name _PU + 'al_fwrite16be';

function al_fread32le(f: PALLEGRO_FILE): Int32; cdecl;
  external cDllName name _PU + 'al_fread32le';

function al_fread32be(f: PALLEGRO_FILE): Int32; cdecl;
  external cDllName name _PU + 'al_fread32be';

function al_fwrite32le(f: PALLEGRO_FILE; l: Int32): NativeUInt; cdecl;
  external cDllName name _PU + 'al_fwrite32le';

function al_fwrite32be(f: PALLEGRO_FILE; l: Int32): NativeUInt; cdecl;
  external cDllName name _PU + 'al_fwrite32be';

function al_fgets(f: PALLEGRO_FILE; const p: PUTF8Char; max: NativeUInt)
  : PUTF8Char; cdecl; external cDllName name _PU + 'al_fgets';

function al_fget_ustr(f: PALLEGRO_FILE): PALLEGRO_USTR; cdecl;
  external cDllName name _PU + 'al_fget_ustr';

function al_fputs(f: PALLEGRO_FILE; const p: PUTF8Char): Integer; cdecl;
  external cDllName name _PU + 'al_fputs';

function al_fprintf(f: PALLEGRO_FILE; const format: PUTF8Char): Integer varargs;
  cdecl; external cDllName name _PU + 'al_fprintf';

function al_vfprintf(f: PALLEGRO_FILE; const format: PUTF8Char; args: Pointer)
  : Integer; cdecl; external cDllName name _PU + 'al_vfprintf';

function al_fopen_fd(fd: Integer; const mode: PUTF8Char): PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_fopen_fd';

function al_make_temp_file(const tmpl: PUTF8Char; ret_path: PPALLEGRO_PATH)
  : PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_make_temp_file';

function al_fopen_slice(fp: PALLEGRO_FILE; initial_size: NativeUInt;
  const mode: PUTF8Char): PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_fopen_slice';

function al_get_new_file_interface(): PALLEGRO_FILE_INTERFACE; cdecl;
  external cDllName name _PU + 'al_get_new_file_interface';

procedure al_set_new_file_interface(const file_interface
  : PALLEGRO_FILE_INTERFACE); cdecl;
  external cDllName name _PU + 'al_set_new_file_interface';

procedure al_set_standard_file_interface(); cdecl;
  external cDllName name _PU + 'al_set_standard_file_interface';

function al_get_file_userdata(f: PALLEGRO_FILE): Pointer; cdecl;
  external cDllName name _PU + 'al_get_file_userdata';

function al_register_bitmap_loader(const ext: PUTF8Char;
  loader: ALLEGRO_IIO_LOADER_FUNCTION): Boolean; cdecl;
  external cDllName name _PU + 'al_register_bitmap_loader';

function al_register_bitmap_saver(const ext: PUTF8Char;
  saver: ALLEGRO_IIO_SAVER_FUNCTION): Boolean; cdecl;
  external cDllName name _PU + 'al_register_bitmap_saver';

function al_register_bitmap_loader_f(const ext: PUTF8Char;
  fs_loader: ALLEGRO_IIO_FS_LOADER_FUNCTION): Boolean; cdecl;
  external cDllName name _PU + 'al_register_bitmap_loader_f';

function al_register_bitmap_saver_f(const ext: PUTF8Char;
  fs_saver: ALLEGRO_IIO_FS_SAVER_FUNCTION): Boolean; cdecl;
  external cDllName name _PU + 'al_register_bitmap_saver_f';

function al_register_bitmap_identifier(const ext: PUTF8Char;
  identifier: ALLEGRO_IIO_IDENTIFIER_FUNCTION): Boolean; cdecl;
  external cDllName name _PU + 'al_register_bitmap_identifier';

function al_load_bitmap(const filename: PUTF8Char): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_load_bitmap';

function al_load_bitmap_flags(const filename: PUTF8Char; flags: Integer)
  : PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_load_bitmap_flags';

function al_load_bitmap_f(fp: PALLEGRO_FILE; const ident: PUTF8Char)
  : PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_load_bitmap_f';

function al_load_bitmap_flags_f(fp: PALLEGRO_FILE; const ident: PUTF8Char;
  flags: Integer): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_load_bitmap_flags_f';

function al_save_bitmap(const filename: PUTF8Char; bitmap: PALLEGRO_BITMAP)
  : Boolean; cdecl; external cDllName name _PU + 'al_save_bitmap';

function al_save_bitmap_f(fp: PALLEGRO_FILE; const ident: PUTF8Char;
  bitmap: PALLEGRO_BITMAP): Boolean; cdecl;
  external cDllName name _PU + 'al_save_bitmap_f';

function al_identify_bitmap_f(fp: PALLEGRO_FILE): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_identify_bitmap_f';

function al_identify_bitmap(const filename: PUTF8Char): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_identify_bitmap';

function al_lock_bitmap(bitmap: PALLEGRO_BITMAP; format: Integer;
  flags: Integer): PALLEGRO_LOCKED_REGION; cdecl;
  external cDllName name _PU + 'al_lock_bitmap';

function al_lock_bitmap_region(bitmap: PALLEGRO_BITMAP; x: Integer; y: Integer;
  width: Integer; height: Integer; format: Integer; flags: Integer)
  : PALLEGRO_LOCKED_REGION; cdecl;
  external cDllName name _PU + 'al_lock_bitmap_region';

function al_lock_bitmap_blocked(bitmap: PALLEGRO_BITMAP; flags: Integer)
  : PALLEGRO_LOCKED_REGION; cdecl;
  external cDllName name _PU + 'al_lock_bitmap_blocked';

function al_lock_bitmap_region_blocked(bitmap: PALLEGRO_BITMAP;
  x_block: Integer; y_block: Integer; width_block: Integer;
  height_block: Integer; flags: Integer): PALLEGRO_LOCKED_REGION; cdecl;
  external cDllName name _PU + 'al_lock_bitmap_region_blocked';

procedure al_unlock_bitmap(bitmap: PALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_unlock_bitmap';

function al_is_bitmap_locked(bitmap: PALLEGRO_BITMAP): Boolean; cdecl;
  external cDllName name _PU + 'al_is_bitmap_locked';

procedure al_set_blender(op: Integer; source: Integer; dest: Integer); cdecl;
  external cDllName name _PU + 'al_set_blender';

procedure al_set_blend_color(color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_set_blend_color';

procedure al_get_blender(op: PInteger; source: PInteger; dest: PInteger); cdecl;
  external cDllName name _PU + 'al_get_blender';

function al_get_blend_color(): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_get_blend_color';

procedure al_set_separate_blender(op: Integer; source: Integer; dest: Integer;
  alpha_op: Integer; alpha_source: Integer; alpha_dest: Integer); cdecl;
  external cDllName name _PU + 'al_set_separate_blender';

procedure al_get_separate_blender(op: PInteger; source: PInteger;
  dest: PInteger; alpha_op: PInteger; alpha_src: PInteger;
  alpha_dest: PInteger); cdecl;
  external cDllName name _PU + 'al_get_separate_blender';

procedure al_init_user_event_source(p1: PALLEGRO_EVENT_SOURCE); cdecl;
  external cDllName name _PU + 'al_init_user_event_source';

procedure al_destroy_user_event_source(p1: PALLEGRO_EVENT_SOURCE); cdecl;
  external cDllName name _PU + 'al_destroy_user_event_source';

type
  al_emit_user_event_dtor = procedure(p1: PALLEGRO_USER_EVENT); cdecl;

function al_emit_user_event(p1: PALLEGRO_EVENT_SOURCE; p2: PALLEGRO_EVENT;
  dtor: al_emit_user_event_dtor): Boolean; cdecl;
  external cDllName name _PU + 'al_emit_user_event';

procedure al_unref_user_event(p1: PALLEGRO_USER_EVENT); cdecl;
  external cDllName name _PU + 'al_unref_user_event';

procedure al_set_event_source_data(p1: PALLEGRO_EVENT_SOURCE; data: IntPtr);
  cdecl; external cDllName name _PU + 'al_set_event_source_data';

function al_get_event_source_data(const p1: PALLEGRO_EVENT_SOURCE): IntPtr;
  cdecl; external cDllName name _PU + 'al_get_event_source_data';

function al_create_event_queue(): PALLEGRO_EVENT_QUEUE; cdecl;
  external cDllName name _PU + 'al_create_event_queue';

procedure al_destroy_event_queue(p1: PALLEGRO_EVENT_QUEUE); cdecl;
  external cDllName name _PU + 'al_destroy_event_queue';

function al_is_event_source_registered(p1: PALLEGRO_EVENT_QUEUE;
  p2: PALLEGRO_EVENT_SOURCE): Boolean; cdecl;
  external cDllName name _PU + 'al_is_event_source_registered';

procedure al_register_event_source(p1: PALLEGRO_EVENT_QUEUE;
  p2: PALLEGRO_EVENT_SOURCE); cdecl;
  external cDllName name _PU + 'al_register_event_source';

procedure al_unregister_event_source(p1: PALLEGRO_EVENT_QUEUE;
  p2: PALLEGRO_EVENT_SOURCE); cdecl;
  external cDllName name _PU + 'al_unregister_event_source';

procedure al_pause_event_queue(p1: PALLEGRO_EVENT_QUEUE; p2: Boolean); cdecl;
  external cDllName name _PU + 'al_pause_event_queue';

function al_is_event_queue_paused(const p1: PALLEGRO_EVENT_QUEUE): Boolean;
  cdecl; external cDllName name _PU + 'al_is_event_queue_paused';

function al_is_event_queue_empty(p1: PALLEGRO_EVENT_QUEUE): Boolean; cdecl;
  external cDllName name _PU + 'al_is_event_queue_empty';

function al_get_next_event(p1: PALLEGRO_EVENT_QUEUE; ret_event: PALLEGRO_EVENT)
  : Boolean; cdecl; external cDllName name _PU + 'al_get_next_event';

function al_peek_next_event(p1: PALLEGRO_EVENT_QUEUE; ret_event: PALLEGRO_EVENT)
  : Boolean; cdecl; external cDllName name _PU + 'al_peek_next_event';

function al_drop_next_event(p1: PALLEGRO_EVENT_QUEUE): Boolean; cdecl;
  external cDllName name _PU + 'al_drop_next_event';

procedure al_flush_event_queue(p1: PALLEGRO_EVENT_QUEUE); cdecl;
  external cDllName name _PU + 'al_flush_event_queue';

procedure al_wait_for_event(p1: PALLEGRO_EVENT_QUEUE;
  ret_event: PALLEGRO_EVENT); cdecl;
  external cDllName name _PU + 'al_wait_for_event';

function al_wait_for_event_timed(p1: PALLEGRO_EVENT_QUEUE;
  ret_event: PALLEGRO_EVENT; secs: Single): Boolean; cdecl;
  external cDllName name _PU + 'al_wait_for_event_timed';

function al_wait_for_event_until(queue: PALLEGRO_EVENT_QUEUE;
  ret_event: PALLEGRO_EVENT; timeout: PALLEGRO_TIMEOUT): Boolean; cdecl;
  external cDllName name _PU + 'al_wait_for_event_until';

procedure al_set_new_display_refresh_rate(refresh_rate: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_display_refresh_rate';

procedure al_set_new_display_flags(flags: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_display_flags';

function al_get_new_display_refresh_rate(): Integer; cdecl;
  external cDllName name _PU + 'al_get_new_display_refresh_rate';

function al_get_new_display_flags(): Integer; cdecl;
  external cDllName name _PU + 'al_get_new_display_flags';

procedure al_set_new_window_title(const title: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_new_window_title';

function al_get_new_window_title(): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_new_window_title';

function al_get_display_width(display: PALLEGRO_DISPLAY): Integer; cdecl;
  external cDllName name _PU + 'al_get_display_width';

function al_get_display_height(display: PALLEGRO_DISPLAY): Integer; cdecl;
  external cDllName name _PU + 'al_get_display_height';

function al_get_display_format(display: PALLEGRO_DISPLAY): Integer; cdecl;
  external cDllName name _PU + 'al_get_display_format';

function al_get_display_refresh_rate(display: PALLEGRO_DISPLAY): Integer; cdecl;
  external cDllName name _PU + 'al_get_display_refresh_rate';

function al_get_display_flags(display: PALLEGRO_DISPLAY): Integer; cdecl;
  external cDllName name _PU + 'al_get_display_flags';

function al_get_display_orientation(display: PALLEGRO_DISPLAY): Integer; cdecl;
  external cDllName name _PU + 'al_get_display_orientation';

function al_set_display_flag(display: PALLEGRO_DISPLAY; flag: Integer;
  onoff: Boolean): Boolean; cdecl;
  external cDllName name _PU + 'al_set_display_flag';

function al_create_display(w: Integer; h: Integer): PALLEGRO_DISPLAY; cdecl;
  external cDllName name _PU + 'al_create_display';

procedure al_destroy_display(display: PALLEGRO_DISPLAY); cdecl;
  external cDllName name _PU + 'al_destroy_display';

function al_get_current_display(): PALLEGRO_DISPLAY; cdecl;
  external cDllName name _PU + 'al_get_current_display';

procedure al_set_target_bitmap(bitmap: PALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_set_target_bitmap';

procedure al_set_target_backbuffer(display: PALLEGRO_DISPLAY); cdecl;
  external cDllName name _PU + 'al_set_target_backbuffer';

function al_get_backbuffer(display: PALLEGRO_DISPLAY): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_get_backbuffer';

function al_get_target_bitmap(): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_get_target_bitmap';

function al_acknowledge_resize(display: PALLEGRO_DISPLAY): Boolean; cdecl;
  external cDllName name _PU + 'al_acknowledge_resize';

function al_resize_display(display: PALLEGRO_DISPLAY; width: Integer;
  height: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_resize_display';

procedure al_flip_display(); cdecl;
  external cDllName name _PU + 'al_flip_display';

procedure al_update_display_region(x: Integer; y: Integer; width: Integer;
  height: Integer); cdecl;
  external cDllName name _PU + 'al_update_display_region';

function al_is_compatible_bitmap(bitmap: PALLEGRO_BITMAP): Boolean; cdecl;
  external cDllName name _PU + 'al_is_compatible_bitmap';

function al_wait_for_vsync(): Boolean; cdecl;
  external cDllName name _PU + 'al_wait_for_vsync';

function al_get_display_event_source(display: PALLEGRO_DISPLAY)
  : PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_display_event_source';

procedure al_set_display_icon(display: PALLEGRO_DISPLAY; icon: PALLEGRO_BITMAP);
  cdecl; external cDllName name _PU + 'al_set_display_icon';

procedure al_set_display_icons(display: PALLEGRO_DISPLAY; num_icons: Integer;
  icons: PPALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_set_display_icons';

function al_get_new_display_adapter(): Integer; cdecl;
  external cDllName name _PU + 'al_get_new_display_adapter';

procedure al_set_new_display_adapter(adapter: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_display_adapter';

procedure al_set_new_window_position(x: Integer; y: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_window_position';

procedure al_get_new_window_position(x: PInteger; y: PInteger); cdecl;
  external cDllName name _PU + 'al_get_new_window_position';

procedure al_set_window_position(display: PALLEGRO_DISPLAY; x: Integer;
  y: Integer); cdecl; external cDllName name _PU +
  'al_set_window_position';

procedure al_get_window_position(display: PALLEGRO_DISPLAY; x: PInteger;
  y: PInteger); cdecl; external cDllName name _PU +
  'al_get_window_position';

function al_set_window_constraints(display: PALLEGRO_DISPLAY; min_w: Integer;
  min_h: Integer; max_w: Integer; max_h: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_window_constraints';

function al_get_window_constraints(display: PALLEGRO_DISPLAY; min_w: PInteger;
  min_h: PInteger; max_w: PInteger; max_h: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_get_window_constraints';

procedure al_apply_window_constraints(display: PALLEGRO_DISPLAY;
  onoff: Boolean); cdecl;
  external cDllName name _PU + 'al_apply_window_constraints';

procedure al_set_window_title(display: PALLEGRO_DISPLAY;
  const title: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_window_title';

procedure al_set_new_display_option(option: Integer; value: Integer;
  importance: Integer); cdecl;
  external cDllName name _PU + 'al_set_new_display_option';

function al_get_new_display_option(option: Integer; importance: PInteger)
  : Integer; cdecl; external cDllName name _PU +
  'al_get_new_display_option';

procedure al_reset_new_display_options(); cdecl;
  external cDllName name _PU + 'al_reset_new_display_options';

procedure al_set_display_option(display: PALLEGRO_DISPLAY; option: Integer;
  value: Integer); cdecl;
  external cDllName name _PU + 'al_set_display_option';

function al_get_display_option(display: PALLEGRO_DISPLAY; option: Integer)
  : Integer; cdecl; external cDllName name _PU +
  'al_get_display_option';

procedure al_hold_bitmap_drawing(hold: Boolean); cdecl;
  external cDllName name _PU + 'al_hold_bitmap_drawing';

function al_is_bitmap_drawing_held(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_bitmap_drawing_held';

procedure al_acknowledge_drawing_halt(display: PALLEGRO_DISPLAY); cdecl;
  external cDllName name _PU + 'al_acknowledge_drawing_halt';

procedure al_acknowledge_drawing_resume(display: PALLEGRO_DISPLAY); cdecl;
  external cDllName name _PU + 'al_acknowledge_drawing_resume';

function al_get_clipboard_text(display: PALLEGRO_DISPLAY): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_clipboard_text';

function al_set_clipboard_text(display: PALLEGRO_DISPLAY; const text: PUTF8Char)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_clipboard_text';

function al_clipboard_has_text(display: PALLEGRO_DISPLAY): Boolean; cdecl;
  external cDllName name _PU + 'al_clipboard_has_text';

function al_create_config(): PALLEGRO_CONFIG; cdecl;
  external cDllName name _PU + 'al_create_config';

procedure al_add_config_section(config: PALLEGRO_CONFIG; const name: PUTF8Char);
  cdecl; external cDllName name _PU + 'al_add_config_section';

procedure al_set_config_value(config: PALLEGRO_CONFIG; const section: PUTF8Char;
  const key: PUTF8Char; const value: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_config_value';

procedure al_add_config_comment(config: PALLEGRO_CONFIG;
  const section: PUTF8Char; const comment: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_add_config_comment';

function al_get_config_value(const config: PALLEGRO_CONFIG;
  const section: PUTF8Char; const key: PUTF8Char): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_config_value';

function al_load_config_file(const filename: PUTF8Char): PALLEGRO_CONFIG; cdecl;
  external cDllName name _PU + 'al_load_config_file';

function al_load_config_file_f(filename: PALLEGRO_FILE): PALLEGRO_CONFIG; cdecl;
  external cDllName name _PU + 'al_load_config_file_f';

function al_save_config_file(const filename: PUTF8Char;
  const config: PALLEGRO_CONFIG): Boolean; cdecl;
  external cDllName name _PU + 'al_save_config_file';

function al_save_config_file_f(&file: PALLEGRO_FILE;
  const config: PALLEGRO_CONFIG): Boolean; cdecl;
  external cDllName name _PU + 'al_save_config_file_f';

procedure al_merge_config_into(master: PALLEGRO_CONFIG;
  const add: PALLEGRO_CONFIG); cdecl;
  external cDllName name _PU + 'al_merge_config_into';

function al_merge_config(const cfg1: PALLEGRO_CONFIG;
  const cfg2: PALLEGRO_CONFIG): PALLEGRO_CONFIG; cdecl;
  external cDllName name _PU + 'al_merge_config';

procedure al_destroy_config(config: PALLEGRO_CONFIG); cdecl;
  external cDllName name _PU + 'al_destroy_config';

function al_remove_config_section(config: PALLEGRO_CONFIG;
  const section: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_remove_config_section';

function al_remove_config_key(config: PALLEGRO_CONFIG; const section: PUTF8Char;
  const key: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_remove_config_key';

function al_get_first_config_section(const config: PALLEGRO_CONFIG;
  iterator: PPALLEGRO_CONFIG_SECTION): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_first_config_section';

function al_get_next_config_section(iterator: PPALLEGRO_CONFIG_SECTION)
  : PUTF8Char; cdecl; external cDllName name _PU +
  'al_get_next_config_section';

function al_get_first_config_entry(const config: PALLEGRO_CONFIG;
  const section: PUTF8Char; iterator: PPALLEGRO_CONFIG_ENTRY): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_first_config_entry';

function al_get_next_config_entry(iterator: PPALLEGRO_CONFIG_ENTRY): PUTF8Char;
  cdecl; external cDllName name _PU + 'al_get_next_config_entry';

function al_get_cpu_count(): Integer; cdecl;
  external cDllName name _PU + 'al_get_cpu_count';

function al_get_ram_size(): Integer; cdecl;
  external cDllName name _PU + 'al_get_ram_size';

function _al_trace_prefix(const channel: PUTF8Char; level: Integer;
  const &file: PUTF8Char; line: Integer; const &function: PUTF8Char): Boolean;
  cdecl; external cDllName name _PU + '_al_trace_prefix';

procedure _al_trace_suffix(const msg: PUTF8Char)varargs; cdecl;
  external cDllName name _PU + '_al_trace_suffix';

type
  al_register_assert_handler_handler = procedure(const expr: PUTF8Char;
    const &file: PUTF8Char; line: Integer; const func: PUTF8Char); cdecl;

procedure al_register_assert_handler
  (handler: al_register_assert_handler_handler); cdecl;
  external cDllName name _PU + 'al_register_assert_handler';

type
  al_register_trace_handler_handler = procedure(const p1: PUTF8Char); cdecl;

procedure al_register_trace_handler(handler: al_register_trace_handler_handler);
  cdecl; external cDllName name _PU + 'al_register_trace_handler';

procedure al_clear_to_color(color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_clear_to_color';

procedure al_clear_depth_buffer(x: Single); cdecl;
  external cDllName name _PU + 'al_clear_depth_buffer';

procedure al_draw_pixel(x: Single; y: Single; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_pixel';

function al_get_errno(): Integer; cdecl;
  external cDllName name _PU + 'al_get_errno';

procedure al_set_errno(errnum: Integer); cdecl;
  external cDllName name _PU + 'al_set_errno';

function al_fixsqrt(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixsqrt';

function al_fixhypot(x: al_fixed; y: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixhypot';

function al_fixatan(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixatan';

function al_fixatan2(y: al_fixed; x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixatan2';

function al_ftofix(x: Double): al_fixed; cdecl;
  external cDllName name _PU + 'al_ftofix';

function al_fixtof(x: al_fixed): Double; cdecl;
  external cDllName name _PU + 'al_fixtof';

function al_fixadd(x: al_fixed; y: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixadd';

function al_fixsub(x: al_fixed; y: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixsub';

function al_fixmul(x: al_fixed; y: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixmul';

function al_fixdiv(x: al_fixed; y: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixdiv';

function al_fixfloor(x: al_fixed): Integer; cdecl;
  external cDllName name _PU + 'al_fixfloor';

function al_fixceil(x: al_fixed): Integer; cdecl;
  external cDllName name _PU + 'al_fixceil';

function al_itofix(x: Integer): al_fixed; cdecl;
  external cDllName name _PU + 'al_itofix';

function al_fixtoi(x: al_fixed): Integer; cdecl;
  external cDllName name _PU + 'al_fixtoi';

function al_fixcos(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixcos';

function al_fixsin(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixsin';

function al_fixtan(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixtan';

function al_fixacos(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixacos';

function al_fixasin(x: al_fixed): al_fixed; cdecl;
  external cDllName name _PU + 'al_fixasin';

function al_create_fs_entry(const path: PUTF8Char): PALLEGRO_FS_ENTRY; cdecl;
  external cDllName name _PU + 'al_create_fs_entry';

procedure al_destroy_fs_entry(e: PALLEGRO_FS_ENTRY); cdecl;
  external cDllName name _PU + 'al_destroy_fs_entry';

function al_get_fs_entry_name(e: PALLEGRO_FS_ENTRY): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_fs_entry_name';

function al_update_fs_entry(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
  external cDllName name _PU + 'al_update_fs_entry';

function al_get_fs_entry_mode(e: PALLEGRO_FS_ENTRY): UInt32; cdecl;
  external cDllName name _PU + 'al_get_fs_entry_mode';

function al_get_fs_entry_atime(e: PALLEGRO_FS_ENTRY): longint; cdecl;
  external cDllName name _PU + 'al_get_fs_entry_atime';

function al_get_fs_entry_mtime(e: PALLEGRO_FS_ENTRY): longint; cdecl;
  external cDllName name _PU + 'al_get_fs_entry_mtime';

function al_get_fs_entry_ctime(e: PALLEGRO_FS_ENTRY): longint; cdecl;
  external cDllName name _PU + 'al_get_fs_entry_ctime';

function al_get_fs_entry_size(e: PALLEGRO_FS_ENTRY): off_t; cdecl;
  external cDllName name _PU + 'al_get_fs_entry_size';

function al_fs_entry_exists(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
  external cDllName name _PU + 'al_fs_entry_exists';

function al_remove_fs_entry(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
  external cDllName name _PU + 'al_remove_fs_entry';

function al_open_directory(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
  external cDllName name _PU + 'al_open_directory';

function al_read_directory(e: PALLEGRO_FS_ENTRY): PALLEGRO_FS_ENTRY; cdecl;
  external cDllName name _PU + 'al_read_directory';

function al_close_directory(e: PALLEGRO_FS_ENTRY): Boolean; cdecl;
  external cDllName name _PU + 'al_close_directory';

function al_filename_exists(const path: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_filename_exists';

function al_remove_filename(const path: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_remove_filename';

function al_get_current_directory(): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_current_directory';

function al_change_directory(const path: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_change_directory';

function al_make_directory(const path: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_make_directory';

function al_open_fs_entry(e: PALLEGRO_FS_ENTRY; const mode: PUTF8Char)
  : PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_open_fs_entry';

type
  al_for_each_fs_entry_callback = function(entry: PALLEGRO_FS_ENTRY;
    extra: Pointer): Integer; cdecl;

function al_for_each_fs_entry(dir: PALLEGRO_FS_ENTRY;
  callback: al_for_each_fs_entry_callback; extra: Pointer): Integer; cdecl;
  external cDllName name _PU + 'al_for_each_fs_entry';

function al_get_fs_interface(): PALLEGRO_FS_INTERFACE; cdecl;
  external cDllName name _PU + 'al_get_fs_interface';

procedure al_set_fs_interface(const vtable: PALLEGRO_FS_INTERFACE); cdecl;
  external cDllName name _PU + 'al_set_fs_interface';

procedure al_set_standard_fs_interface(); cdecl;
  external cDllName name _PU + 'al_set_standard_fs_interface';

function al_get_num_display_modes(): Integer; cdecl;
  external cDllName name _PU + 'al_get_num_display_modes';

function al_get_display_mode(index: Integer; mode: PALLEGRO_DISPLAY_MODE)
  : PALLEGRO_DISPLAY_MODE; cdecl;
  external cDllName name _PU + 'al_get_display_mode';

function al_install_joystick(): Boolean; cdecl;
  external cDllName name _PU + 'al_install_joystick';

procedure al_uninstall_joystick(); cdecl;
  external cDllName name _PU + 'al_uninstall_joystick';

function al_is_joystick_installed(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_joystick_installed';

function al_reconfigure_joysticks(): Boolean; cdecl;
  external cDllName name _PU + 'al_reconfigure_joysticks';

function al_get_num_joysticks(): Integer; cdecl;
  external cDllName name _PU + 'al_get_num_joysticks';

function al_get_joystick(joyn: Integer): PALLEGRO_JOYSTICK; cdecl;
  external cDllName name _PU + 'al_get_joystick';

procedure al_release_joystick(p1: PALLEGRO_JOYSTICK); cdecl;
  external cDllName name _PU + 'al_release_joystick';

function al_get_joystick_active(p1: PALLEGRO_JOYSTICK): Boolean; cdecl;
  external cDllName name _PU + 'al_get_joystick_active';

function al_get_joystick_name(p1: PALLEGRO_JOYSTICK): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_joystick_name';

function al_get_joystick_num_sticks(p1: PALLEGRO_JOYSTICK): Integer; cdecl;
  external cDllName name _PU + 'al_get_joystick_num_sticks';

function al_get_joystick_stick_flags(p1: PALLEGRO_JOYSTICK; stick: Integer)
  : Integer; cdecl; external cDllName name _PU +
  'al_get_joystick_stick_flags';

function al_get_joystick_stick_name(p1: PALLEGRO_JOYSTICK; stick: Integer)
  : PUTF8Char; cdecl; external cDllName name _PU +
  'al_get_joystick_stick_name';

function al_get_joystick_num_axes(p1: PALLEGRO_JOYSTICK; stick: Integer)
  : Integer; cdecl; external cDllName name _PU +
  'al_get_joystick_num_axes';

function al_get_joystick_axis_name(p1: PALLEGRO_JOYSTICK; stick: Integer;
  axis: Integer): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_joystick_axis_name';

function al_get_joystick_num_buttons(p1: PALLEGRO_JOYSTICK): Integer; cdecl;
  external cDllName name _PU + 'al_get_joystick_num_buttons';

function al_get_joystick_button_name(p1: PALLEGRO_JOYSTICK; buttonn: Integer)
  : PUTF8Char; cdecl; external cDllName name _PU +
  'al_get_joystick_button_name';

procedure al_get_joystick_state(p1: PALLEGRO_JOYSTICK;
  ret_state: PALLEGRO_JOYSTICK_STATE); cdecl;
  external cDllName name _PU + 'al_get_joystick_state';

function al_get_joystick_event_source(): PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_joystick_event_source';

function al_is_keyboard_installed(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_keyboard_installed';

function al_install_keyboard(): Boolean; cdecl;
  external cDllName name _PU + 'al_install_keyboard';

procedure al_uninstall_keyboard(); cdecl;
  external cDllName name _PU + 'al_uninstall_keyboard';

function al_set_keyboard_leds(leds: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_keyboard_leds';

function al_keycode_to_name(keycode: Integer): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_keycode_to_name';

procedure al_get_keyboard_state(ret_state: PALLEGRO_KEYBOARD_STATE); cdecl;
  external cDllName name _PU + 'al_get_keyboard_state';

procedure al_clear_keyboard_state(display: PALLEGRO_DISPLAY); cdecl;
  external cDllName name _PU + 'al_clear_keyboard_state';

function al_key_down(const p1: PALLEGRO_KEYBOARD_STATE; keycode: Integer)
  : Boolean; cdecl; external cDllName name _PU + 'al_key_down';

function al_get_keyboard_event_source(): PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_keyboard_event_source';

function al_is_mouse_installed(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_mouse_installed';

function al_install_mouse(): Boolean; cdecl;
  external cDllName name _PU + 'al_install_mouse';

procedure al_uninstall_mouse(); cdecl;
  external cDllName name _PU + 'al_uninstall_mouse';

function al_get_mouse_num_buttons(): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_mouse_num_buttons';

function al_get_mouse_num_axes(): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_mouse_num_axes';

function al_set_mouse_xy(display: PALLEGRO_DISPLAY; x: Integer; y: Integer)
  : Boolean; cdecl; external cDllName name _PU + 'al_set_mouse_xy';

function al_set_mouse_z(z: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_mouse_z';

function al_set_mouse_w(w: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_mouse_w';

function al_set_mouse_axis(axis: Integer; value: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_mouse_axis';

procedure al_get_mouse_state(ret_state: PALLEGRO_MOUSE_STATE); cdecl;
  external cDllName name _PU + 'al_get_mouse_state';

function al_mouse_button_down(const state: PALLEGRO_MOUSE_STATE;
  button: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_mouse_button_down';

function al_get_mouse_state_axis(const state: PALLEGRO_MOUSE_STATE;
  axis: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_mouse_state_axis';

function al_get_mouse_cursor_position(ret_x: PInteger; ret_y: PInteger)
  : Boolean; cdecl; external cDllName name _PU +
  'al_get_mouse_cursor_position';

function al_grab_mouse(display: PALLEGRO_DISPLAY): Boolean; cdecl;
  external cDllName name _PU + 'al_grab_mouse';

function al_ungrab_mouse(): Boolean; cdecl;
  external cDllName name _PU + 'al_ungrab_mouse';

procedure al_set_mouse_wheel_precision(precision: Integer); cdecl;
  external cDllName name _PU + 'al_set_mouse_wheel_precision';

function al_get_mouse_wheel_precision(): Integer; cdecl;
  external cDllName name _PU + 'al_get_mouse_wheel_precision';

function al_get_mouse_event_source(): PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_mouse_event_source';

function al_is_touch_input_installed(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_touch_input_installed';

function al_install_touch_input(): Boolean; cdecl;
  external cDllName name _PU + 'al_install_touch_input';

procedure al_uninstall_touch_input(); cdecl;
  external cDllName name _PU + 'al_uninstall_touch_input';

procedure al_get_touch_input_state(ret_state: PALLEGRO_TOUCH_INPUT_STATE);
  cdecl; external cDllName name _PU + 'al_get_touch_input_state';

function al_get_touch_input_event_source(): PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_touch_input_event_source';

procedure al_set_memory_interface(iface: PALLEGRO_MEMORY_INTERFACE); cdecl;
  external cDllName name _PU + 'al_set_memory_interface';

function al_malloc_with_context(n: NativeUInt; line: Integer;
  const &file: PUTF8Char; const func: PUTF8Char): Pointer; cdecl;
  external cDllName name _PU + 'al_malloc_with_context';

procedure al_free_with_context(ptr: Pointer; line: Integer;
  const &file: PUTF8Char; const func: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_free_with_context';

function al_realloc_with_context(ptr: Pointer; n: NativeUInt; line: Integer;
  const &file: PUTF8Char; const func: PUTF8Char): Pointer; cdecl;
  external cDllName name _PU + 'al_realloc_with_context';

function al_calloc_with_context(count: NativeUInt; n: NativeUInt; line: Integer;
  const &file: PUTF8Char; const func: PUTF8Char): Pointer; cdecl;
  external cDllName name _PU + 'al_calloc_with_context';

function al_get_num_video_adapters(): Integer; cdecl;
  external cDllName name _PU + 'al_get_num_video_adapters';

function al_get_monitor_info(adapter: Integer; info: PALLEGRO_MONITOR_INFO)
  : Boolean; cdecl; external cDllName name _PU + 'al_get_monitor_info';

function al_get_monitor_dpi(adapter: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_monitor_dpi';

function al_create_mouse_cursor(sprite: PALLEGRO_BITMAP; xfocus: Integer;
  yfocus: Integer): PALLEGRO_MOUSE_CURSOR; cdecl;
  external cDllName name _PU + 'al_create_mouse_cursor';

procedure al_destroy_mouse_cursor(p1: PALLEGRO_MOUSE_CURSOR); cdecl;
  external cDllName name _PU + 'al_destroy_mouse_cursor';

function al_set_mouse_cursor(display: PALLEGRO_DISPLAY;
  cursor: PALLEGRO_MOUSE_CURSOR): Boolean; cdecl;
  external cDllName name _PU + 'al_set_mouse_cursor';

function al_set_system_mouse_cursor(display: PALLEGRO_DISPLAY;
  cursor_id: ALLEGRO_SYSTEM_MOUSE_CURSOR): Boolean; cdecl;
  external cDllName name _PU + 'al_set_system_mouse_cursor';

function al_show_mouse_cursor(display: PALLEGRO_DISPLAY): Boolean; cdecl;
  external cDllName name _PU + 'al_show_mouse_cursor';

function al_hide_mouse_cursor(display: PALLEGRO_DISPLAY): Boolean; cdecl;
  external cDllName name _PU + 'al_hide_mouse_cursor';

procedure al_set_render_state(state: ALLEGRO_RENDER_STATE; value: Integer);
  cdecl; external cDllName name _PU + 'al_set_render_state';

procedure al_use_transform(const trans: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_use_transform';

procedure al_use_projection_transform(const trans: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_use_projection_transform';

procedure al_copy_transform(dest: PALLEGRO_TRANSFORM;
  const src: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_copy_transform';

procedure al_identity_transform(trans: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_identity_transform';

procedure al_build_transform(trans: PALLEGRO_TRANSFORM; x: Single; y: Single;
  sx: Single; sy: Single; theta: Single); cdecl;
  external cDllName name _PU + 'al_build_transform';

procedure al_build_camera_transform(trans: PALLEGRO_TRANSFORM;
  position_x: Single; position_y: Single; position_z: Single; look_x: Single;
  look_y: Single; look_z: Single; up_x: Single; up_y: Single; up_z: Single);
  cdecl; external cDllName name _PU + 'al_build_camera_transform';

procedure al_translate_transform(trans: PALLEGRO_TRANSFORM; x: Single;
  y: Single); cdecl; external cDllName name _PU +
  'al_translate_transform';

procedure al_translate_transform_3d(trans: PALLEGRO_TRANSFORM; x: Single;
  y: Single; z: Single); cdecl;
  external cDllName name _PU + 'al_translate_transform_3d';

procedure al_rotate_transform(trans: PALLEGRO_TRANSFORM; theta: Single); cdecl;
  external cDllName name _PU + 'al_rotate_transform';

procedure al_rotate_transform_3d(trans: PALLEGRO_TRANSFORM; x: Single;
  y: Single; z: Single; angle: Single); cdecl;
  external cDllName name _PU + 'al_rotate_transform_3d';

procedure al_scale_transform(trans: PALLEGRO_TRANSFORM; sx: Single; sy: Single);
  cdecl; external cDllName name _PU + 'al_scale_transform';

procedure al_scale_transform_3d(trans: PALLEGRO_TRANSFORM; sx: Single;
  sy: Single; sz: Single); cdecl;
  external cDllName name _PU + 'al_scale_transform_3d';

procedure al_transform_coordinates(const trans: PALLEGRO_TRANSFORM; x: PSingle;
  y: PSingle); cdecl; external cDllName name _PU +
  'al_transform_coordinates';

procedure al_transform_coordinates_3d(const trans: PALLEGRO_TRANSFORM;
  x: PSingle; y: PSingle; z: PSingle); cdecl;
  external cDllName name _PU + 'al_transform_coordinates_3d';

procedure al_transform_coordinates_4d(const trans: PALLEGRO_TRANSFORM;
  x: PSingle; y: PSingle; z: PSingle; w: PSingle); cdecl;
  external cDllName name _PU + 'al_transform_coordinates_4d';

procedure al_transform_coordinates_3d_projective(const trans
  : PALLEGRO_TRANSFORM; x: PSingle; y: PSingle; z: PSingle); cdecl;
  external cDllName name _PU + 'al_transform_coordinates_3d_projective';

procedure al_compose_transform(trans: PALLEGRO_TRANSFORM;
  const other: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_compose_transform';

function al_get_current_transform(): PALLEGRO_TRANSFORM; cdecl;
  external cDllName name _PU + 'al_get_current_transform';

function al_get_current_inverse_transform(): PALLEGRO_TRANSFORM; cdecl;
  external cDllName name _PU + 'al_get_current_inverse_transform';

function al_get_current_projection_transform(): PALLEGRO_TRANSFORM; cdecl;
  external cDllName name _PU + 'al_get_current_projection_transform';

procedure al_invert_transform(trans: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_invert_transform';

procedure al_transpose_transform(trans: PALLEGRO_TRANSFORM); cdecl;
  external cDllName name _PU + 'al_transpose_transform';

function al_check_inverse(const trans: PALLEGRO_TRANSFORM; tol: Single)
  : Integer; cdecl; external cDllName name _PU + 'al_check_inverse';

procedure al_orthographic_transform(trans: PALLEGRO_TRANSFORM; left: Single;
  top: Single; n: Single; right: Single; bottom: Single; f: Single); cdecl;
  external cDllName name _PU + 'al_orthographic_transform';

procedure al_perspective_transform(trans: PALLEGRO_TRANSFORM; left: Single;
  top: Single; n: Single; right: Single; bottom: Single; f: Single); cdecl;
  external cDllName name _PU + 'al_perspective_transform';

procedure al_horizontal_shear_transform(trans: PALLEGRO_TRANSFORM;
  theta: Single); cdecl;
  external cDllName name _PU + 'al_horizontal_shear_transform';

procedure al_vertical_shear_transform(trans: PALLEGRO_TRANSFORM; theta: Single);
  cdecl; external cDllName name _PU + 'al_vertical_shear_transform';

function al_create_shader(&platform: ALLEGRO_SHADER_PLATFORM): PALLEGRO_SHADER;
  cdecl; external cDllName name _PU + 'al_create_shader';

function al_attach_shader_source(shader: PALLEGRO_SHADER;
  &type: ALLEGRO_SHADER_TYPE; const source: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_attach_shader_source';

function al_attach_shader_source_file(shader: PALLEGRO_SHADER;
  &type: ALLEGRO_SHADER_TYPE; const filename: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_attach_shader_source_file';

function al_build_shader(shader: PALLEGRO_SHADER): Boolean; cdecl;
  external cDllName name _PU + 'al_build_shader';

function al_get_shader_log(shader: PALLEGRO_SHADER): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_shader_log';

function al_get_shader_platform(shader: PALLEGRO_SHADER)
  : ALLEGRO_SHADER_PLATFORM; cdecl;
  external cDllName name _PU + 'al_get_shader_platform';

function al_use_shader(shader: PALLEGRO_SHADER): Boolean; cdecl;
  external cDllName name _PU + 'al_use_shader';

procedure al_destroy_shader(shader: PALLEGRO_SHADER); cdecl;
  external cDllName name _PU + 'al_destroy_shader';

function al_set_shader_sampler(const name: PUTF8Char; bitmap: PALLEGRO_BITMAP;
  &unit: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_shader_sampler';

function al_set_shader_matrix(const name: PUTF8Char;
  const matrix: PALLEGRO_TRANSFORM): Boolean; cdecl;
  external cDllName name _PU + 'al_set_shader_matrix';

function al_set_shader_int(const name: PUTF8Char; i: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_shader_int';

function al_set_shader_float(const name: PUTF8Char; f: Single): Boolean; cdecl;
  external cDllName name _PU + 'al_set_shader_float';

function al_set_shader_int_vector(const name: PUTF8Char;
  num_components: Integer; const i: PInteger; num_elems: Integer): Boolean;
  cdecl; external cDllName name _PU + 'al_set_shader_int_vector';

function al_set_shader_float_vector(const name: PUTF8Char;
  num_components: Integer; const f: PSingle; num_elems: Integer): Boolean;
  cdecl; external cDllName name _PU + 'al_set_shader_float_vector';

function al_set_shader_bool(const name: PUTF8Char; b: Boolean): Boolean; cdecl;
  external cDllName name _PU + 'al_set_shader_bool';

function al_get_default_shader_source(&platform: ALLEGRO_SHADER_PLATFORM;
  &type: ALLEGRO_SHADER_TYPE): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_default_shader_source';

type
  atexit_ptr_ = Pointer;
  al_install_system_atexit_ptr = function(p1: atexit_ptr_): Integer; cdecl;

function al_install_system(version: Integer;
  atexit_ptr: al_install_system_atexit_ptr): Boolean; cdecl;
  external cDllName name _PU + 'al_install_system';

procedure al_uninstall_system(); cdecl;
  external cDllName name _PU + 'al_uninstall_system';

function al_is_system_installed(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_system_installed';

function al_get_system_driver(): PALLEGRO_SYSTEM; cdecl;
  external cDllName name _PU + 'al_get_system_driver';

function al_get_system_config(): PALLEGRO_CONFIG; cdecl;
  external cDllName name _PU + 'al_get_system_config';

function al_get_system_id(): ALLEGRO_SYSTEM_ID; cdecl;
  external cDllName name _PU + 'al_get_system_id';

function al_get_standard_path(id: Integer): PALLEGRO_PATH; cdecl;
  external cDllName name _PU + 'al_get_standard_path';

procedure al_set_exe_name(const path: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_exe_name';

procedure al_set_org_name(const org_name: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_org_name';

procedure al_set_app_name(const app_name: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_app_name';

function al_get_org_name(): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_org_name';

function al_get_app_name(): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_app_name';

function al_inhibit_screensaver(inhibit: Boolean): Boolean; cdecl;
  external cDllName name _PU + 'al_inhibit_screensaver';

type
  al_create_thread_proc = function(thread: PALLEGRO_THREAD; arg: Pointer)
    : Pointer; cdecl;

function al_create_thread(proc: al_create_thread_proc; arg: Pointer)
  : PALLEGRO_THREAD; cdecl;
  external cDllName name _PU + 'al_create_thread';

procedure al_start_thread(outer: PALLEGRO_THREAD); cdecl;
  external cDllName name _PU + 'al_start_thread';

procedure al_join_thread(outer: PALLEGRO_THREAD; ret_value: PPointer); cdecl;
  external cDllName name _PU + 'al_join_thread';

procedure al_set_thread_should_stop(outer: PALLEGRO_THREAD); cdecl;
  external cDllName name _PU + 'al_set_thread_should_stop';

function al_get_thread_should_stop(outer: PALLEGRO_THREAD): Boolean; cdecl;
  external cDllName name _PU + 'al_get_thread_should_stop';

procedure al_destroy_thread(thread: PALLEGRO_THREAD); cdecl;
  external cDllName name _PU + 'al_destroy_thread';

type
  al_run_detached_thread_proc = function(arg: Pointer): Pointer; cdecl;

procedure al_run_detached_thread(proc: al_run_detached_thread_proc;
  arg: Pointer); cdecl;
  external cDllName name _PU + 'al_run_detached_thread';

function al_create_mutex(): PALLEGRO_MUTEX; cdecl;
  external cDllName name _PU + 'al_create_mutex';

function al_create_mutex_recursive(): PALLEGRO_MUTEX; cdecl;
  external cDllName name _PU + 'al_create_mutex_recursive';

procedure al_lock_mutex(mutex: PALLEGRO_MUTEX); cdecl;
  external cDllName name _PU + 'al_lock_mutex';

procedure al_unlock_mutex(mutex: PALLEGRO_MUTEX); cdecl;
  external cDllName name _PU + 'al_unlock_mutex';

procedure al_destroy_mutex(mutex: PALLEGRO_MUTEX); cdecl;
  external cDllName name _PU + 'al_destroy_mutex';

function al_create_cond(): PALLEGRO_COND; cdecl;
  external cDllName name _PU + 'al_create_cond';

procedure al_destroy_cond(cond: PALLEGRO_COND); cdecl;
  external cDllName name _PU + 'al_destroy_cond';

procedure al_wait_cond(cond: PALLEGRO_COND; mutex: PALLEGRO_MUTEX); cdecl;
  external cDllName name _PU + 'al_wait_cond';

function al_wait_cond_until(cond: PALLEGRO_COND; mutex: PALLEGRO_MUTEX;
  const timeout: PALLEGRO_TIMEOUT): Integer; cdecl;
  external cDllName name _PU + 'al_wait_cond_until';

procedure al_broadcast_cond(cond: PALLEGRO_COND); cdecl;
  external cDllName name _PU + 'al_broadcast_cond';

procedure al_signal_cond(cond: PALLEGRO_COND); cdecl;
  external cDllName name _PU + 'al_signal_cond';

function al_create_timer(speed_secs: Double): PALLEGRO_TIMER; cdecl;
  external cDllName name _PU + 'al_create_timer';

procedure al_destroy_timer(timer: PALLEGRO_TIMER); cdecl;
  external cDllName name _PU + 'al_destroy_timer';

procedure al_start_timer(timer: PALLEGRO_TIMER); cdecl;
  external cDllName name _PU + 'al_start_timer';

procedure al_stop_timer(timer: PALLEGRO_TIMER); cdecl;
  external cDllName name _PU + 'al_stop_timer';

procedure al_resume_timer(timer: PALLEGRO_TIMER); cdecl;
  external cDllName name _PU + 'al_resume_timer';

function al_get_timer_started(const timer: PALLEGRO_TIMER): Boolean; cdecl;
  external cDllName name _PU + 'al_get_timer_started';

function al_get_timer_speed(const timer: PALLEGRO_TIMER): Double; cdecl;
  external cDllName name _PU + 'al_get_timer_speed';

procedure al_set_timer_speed(timer: PALLEGRO_TIMER; speed_secs: Double); cdecl;
  external cDllName name _PU + 'al_set_timer_speed';

function al_get_timer_count(const timer: PALLEGRO_TIMER): Int64; cdecl;
  external cDllName name _PU + 'al_get_timer_count';

procedure al_set_timer_count(timer: PALLEGRO_TIMER; count: Int64); cdecl;
  external cDllName name _PU + 'al_set_timer_count';

procedure al_add_timer_count(timer: PALLEGRO_TIMER; diff: Int64); cdecl;
  external cDllName name _PU + 'al_add_timer_count';

function al_get_timer_event_source(timer: PALLEGRO_TIMER)
  : PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_timer_event_source';

procedure al_store_state(state: PALLEGRO_STATE; flags: Integer); cdecl;
  external cDllName name _PU + 'al_store_state';

procedure al_restore_state(const state: PALLEGRO_STATE); cdecl;
  external cDllName name _PU + 'al_restore_state';

function _WinMain(_main: Pointer; hInst: Pointer; hPrev: Pointer;
  Cmd: PUTF8Char; nShow: Integer): Integer; cdecl;
  external cDllName name _PU + '_WinMain';

function al_create_sample(buf: Pointer; samples: Cardinal; freq: Cardinal;
  depth: ALLEGRO_AUDIO_DEPTH; chan_conf: ALLEGRO_CHANNEL_CONF;
  free_buf: Boolean): PALLEGRO_SAMPLE; cdecl;
  external cDllName name _PU + 'al_create_sample';

procedure al_destroy_sample(spl: PALLEGRO_SAMPLE); cdecl;
  external cDllName name _PU + 'al_destroy_sample';

// ALLEGRO_SAMPLE_INSTANCE* al_lock_sample_id(ALLEGRO_SAMPLE_ID *spl_id)
function al_lock_sample_id(spl_id: PALLEGRO_SAMPLE_ID)
  : PALLEGRO_SAMPLE_INSTANCE;
  external cDllName name _PU + 'al_lock_sample_id';

// void al_unlock_sample_id(ALLEGRO_SAMPLE_ID *spl_id)
procedure al_unlock_sample_id(spl_id: PALLEGRO_SAMPLE_ID);
  external cDllName name _PU + 'al_unlock_sample_id';

function al_create_sample_instance(data: PALLEGRO_SAMPLE)
  : PALLEGRO_SAMPLE_INSTANCE; cdecl;
  external cDllName name _PU + 'al_create_sample_instance';

procedure al_destroy_sample_instance(spl: PALLEGRO_SAMPLE_INSTANCE); cdecl;
  external cDllName name _PU + 'al_destroy_sample_instance';

function al_get_sample_frequency(const spl: PALLEGRO_SAMPLE): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_sample_frequency';

function al_get_sample_length(const spl: PALLEGRO_SAMPLE): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_sample_length';

function al_get_sample_depth(const spl: PALLEGRO_SAMPLE): ALLEGRO_AUDIO_DEPTH;
  cdecl; external cDllName name _PU + 'al_get_sample_depth';

function al_get_sample_channels(const spl: PALLEGRO_SAMPLE)
  : ALLEGRO_CHANNEL_CONF; cdecl;
  external cDllName name _PU + 'al_get_sample_channels';

function al_get_sample_data(const spl: PALLEGRO_SAMPLE): Pointer; cdecl;
  external cDllName name _PU + 'al_get_sample_data';

function al_get_sample_instance_frequency(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Cardinal; cdecl; external cDllName name _PU +
  'al_get_sample_instance_frequency';

function al_get_sample_instance_length(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Cardinal; cdecl; external cDllName name _PU +
  'al_get_sample_instance_length';

function al_get_sample_instance_position(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Cardinal; cdecl; external cDllName name _PU +
  'al_get_sample_instance_position';

function al_get_sample_instance_speed(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Single; cdecl; external cDllName name _PU +
  'al_get_sample_instance_speed';

function al_get_sample_instance_gain(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Single; cdecl; external cDllName name _PU +
  'al_get_sample_instance_gain';

function al_get_sample_instance_pan(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Single; cdecl; external cDllName name _PU +
  'al_get_sample_instance_pan';

function al_get_sample_instance_time(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Single; cdecl; external cDllName name _PU +
  'al_get_sample_instance_time';

function al_get_sample_instance_depth(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : ALLEGRO_AUDIO_DEPTH; cdecl;
  external cDllName name _PU + 'al_get_sample_instance_depth';

function al_get_sample_instance_channels(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : ALLEGRO_CHANNEL_CONF; cdecl;
  external cDllName name _PU + 'al_get_sample_instance_channels';

function al_get_sample_instance_playmode(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : ALLEGRO_PLAYMODE; cdecl;
  external cDllName name _PU + 'al_get_sample_instance_playmode';

function al_get_sample_instance_playing(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Boolean; cdecl; external cDllName name _PU +
  'al_get_sample_instance_playing';

function al_get_sample_instance_attached(const spl: PALLEGRO_SAMPLE_INSTANCE)
  : Boolean; cdecl; external cDllName name _PU +
  'al_get_sample_instance_attached';

function al_set_sample_instance_position(spl: PALLEGRO_SAMPLE_INSTANCE;
  val: Cardinal): Boolean; cdecl;
  external cDllName name _PU + 'al_set_sample_instance_position';

function al_set_sample_instance_length(spl: PALLEGRO_SAMPLE_INSTANCE;
  val: Cardinal): Boolean; cdecl;
  external cDllName name _PU + 'al_set_sample_instance_length';

function al_set_sample_instance_speed(spl: PALLEGRO_SAMPLE_INSTANCE;
  val: Single): Boolean; cdecl;
  external cDllName name _PU + 'al_set_sample_instance_speed';

function al_set_sample_instance_gain(spl: PALLEGRO_SAMPLE_INSTANCE; val: Single)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_sample_instance_gain';

function al_set_sample_instance_pan(spl: PALLEGRO_SAMPLE_INSTANCE; val: Single)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_sample_instance_pan';

function al_set_sample_instance_playmode(spl: PALLEGRO_SAMPLE_INSTANCE;
  val: ALLEGRO_PLAYMODE): Boolean; cdecl;
  external cDllName name _PU + 'al_set_sample_instance_playmode';

function al_set_sample_instance_playing(spl: PALLEGRO_SAMPLE_INSTANCE;
  val: Boolean): Boolean; cdecl;
  external cDllName name _PU + 'al_set_sample_instance_playing';

function al_detach_sample_instance(spl: PALLEGRO_SAMPLE_INSTANCE): Boolean;
  cdecl; external cDllName name _PU + 'al_detach_sample_instance';

function al_set_sample(spl: PALLEGRO_SAMPLE_INSTANCE; data: PALLEGRO_SAMPLE)
  : Boolean; cdecl; external cDllName name _PU + 'al_set_sample';

function al_get_sample(spl: PALLEGRO_SAMPLE_INSTANCE): PALLEGRO_SAMPLE; cdecl;
  external cDllName name _PU + 'al_get_sample';

function al_play_sample_instance(spl: PALLEGRO_SAMPLE_INSTANCE): Boolean; cdecl;
  external cDllName name _PU + 'al_play_sample_instance';

function al_stop_sample_instance(spl: PALLEGRO_SAMPLE_INSTANCE): Boolean; cdecl;
  external cDllName name _PU + 'al_stop_sample_instance';

function al_create_audio_stream(buffer_count: NativeUInt; samples: Cardinal;
  freq: Cardinal; depth: ALLEGRO_AUDIO_DEPTH; chan_conf: ALLEGRO_CHANNEL_CONF)
  : PALLEGRO_AUDIO_STREAM; cdecl;
  external cDllName name _PU + 'al_create_audio_stream';

procedure al_destroy_audio_stream(stream: PALLEGRO_AUDIO_STREAM); cdecl;
  external cDllName name _PU + 'al_destroy_audio_stream';

procedure al_drain_audio_stream(stream: PALLEGRO_AUDIO_STREAM); cdecl;
  external cDllName name _PU + 'al_drain_audio_stream';

function al_get_audio_stream_frequency(const stream: PALLEGRO_AUDIO_STREAM)
  : Cardinal; cdecl; external cDllName name _PU +
  'al_get_audio_stream_frequency';

function al_get_audio_stream_length(const stream: PALLEGRO_AUDIO_STREAM)
  : Cardinal; cdecl; external cDllName name _PU +
  'al_get_audio_stream_length';

function al_get_audio_stream_fragments(const stream: PALLEGRO_AUDIO_STREAM)
  : Cardinal; cdecl; external cDllName name _PU +
  'al_get_audio_stream_fragments';

function al_get_available_audio_stream_fragments(const stream
  : PALLEGRO_AUDIO_STREAM): Cardinal; cdecl;
  external cDllName name _PU +
  'al_get_available_audio_stream_fragments';

function al_get_audio_stream_speed(const stream: PALLEGRO_AUDIO_STREAM): Single;
  cdecl; external cDllName name _PU + 'al_get_audio_stream_speed';

function al_get_audio_stream_gain(const stream: PALLEGRO_AUDIO_STREAM): Single;
  cdecl; external cDllName name _PU + 'al_get_audio_stream_gain';

function al_get_audio_stream_pan(const stream: PALLEGRO_AUDIO_STREAM): Single;
  cdecl; external cDllName name _PU + 'al_get_audio_stream_pan';

function al_get_audio_stream_channels(const stream: PALLEGRO_AUDIO_STREAM)
  : ALLEGRO_CHANNEL_CONF; cdecl;
  external cDllName name _PU + 'al_get_audio_stream_channels';

function al_get_audio_stream_depth(const stream: PALLEGRO_AUDIO_STREAM)
  : ALLEGRO_AUDIO_DEPTH; cdecl;
  external cDllName name _PU + 'al_get_audio_stream_depth';

function al_get_audio_stream_playmode(const stream: PALLEGRO_AUDIO_STREAM)
  : ALLEGRO_PLAYMODE; cdecl;
  external cDllName name _PU + 'al_get_audio_stream_playmode';

function al_get_audio_stream_playing(const spl: PALLEGRO_AUDIO_STREAM): Boolean;
  cdecl; external cDllName name _PU + 'al_get_audio_stream_playing';

function al_get_audio_stream_attached(const spl: PALLEGRO_AUDIO_STREAM)
  : Boolean; cdecl; external cDllName name _PU +
  'al_get_audio_stream_attached';

function al_get_audio_stream_played_samples(const stream: PALLEGRO_AUDIO_STREAM)
  : UInt64; cdecl; external cDllName name _PU +
  'al_get_audio_stream_played_samples';

function al_get_audio_stream_fragment(const stream: PALLEGRO_AUDIO_STREAM)
  : Pointer; cdecl; external cDllName name _PU +
  'al_get_audio_stream_fragment';

function al_set_audio_stream_speed(stream: PALLEGRO_AUDIO_STREAM; val: Single)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_audio_stream_speed';

function al_set_audio_stream_gain(stream: PALLEGRO_AUDIO_STREAM; val: Single)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_audio_stream_gain';

function al_set_audio_stream_pan(stream: PALLEGRO_AUDIO_STREAM; val: Single)
  : Boolean; cdecl; external cDllName name _PU +
  'al_set_audio_stream_pan';

function al_set_audio_stream_playmode(stream: PALLEGRO_AUDIO_STREAM;
  val: ALLEGRO_PLAYMODE): Boolean; cdecl;
  external cDllName name _PU + 'al_set_audio_stream_playmode';

function al_set_audio_stream_playing(stream: PALLEGRO_AUDIO_STREAM;
  val: Boolean): Boolean; cdecl;
  external cDllName name _PU + 'al_set_audio_stream_playing';

function al_detach_audio_stream(stream: PALLEGRO_AUDIO_STREAM): Boolean; cdecl;
  external cDllName name _PU + 'al_detach_audio_stream';

function al_set_audio_stream_fragment(stream: PALLEGRO_AUDIO_STREAM;
  val: Pointer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_audio_stream_fragment';

function al_rewind_audio_stream(stream: PALLEGRO_AUDIO_STREAM): Boolean; cdecl;
  external cDllName name _PU + 'al_rewind_audio_stream';

function al_seek_audio_stream_secs(stream: PALLEGRO_AUDIO_STREAM; time: Double)
  : Boolean; cdecl; external cDllName name _PU +
  'al_seek_audio_stream_secs';

function al_get_audio_stream_position_secs(stream: PALLEGRO_AUDIO_STREAM)
  : Double; cdecl; external cDllName name _PU +
  'al_get_audio_stream_position_secs';

function al_get_audio_stream_length_secs(stream: PALLEGRO_AUDIO_STREAM): Double;
  cdecl; external cDllName name _PU + 'al_get_audio_stream_length_secs';

function al_set_audio_stream_loop_secs(stream: PALLEGRO_AUDIO_STREAM;
  start: Double; &end: Double): Boolean; cdecl;
  external cDllName name _PU + 'al_set_audio_stream_loop_secs';

function al_get_audio_stream_event_source(stream: PALLEGRO_AUDIO_STREAM)
  : PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_audio_stream_event_source';

function al_create_mixer(freq: Cardinal; depth: ALLEGRO_AUDIO_DEPTH;
  chan_conf: ALLEGRO_CHANNEL_CONF): PALLEGRO_MIXER; cdecl;
  external cDllName name _PU + 'al_create_mixer';

procedure al_destroy_mixer(mixer: PALLEGRO_MIXER); cdecl;
  external cDllName name _PU + 'al_destroy_mixer';

function al_attach_sample_instance_to_mixer(stream: PALLEGRO_SAMPLE_INSTANCE;
  mixer: PALLEGRO_MIXER): Boolean; cdecl;
  external cDllName name _PU + 'al_attach_sample_instance_to_mixer';

function al_attach_audio_stream_to_mixer(stream: PALLEGRO_AUDIO_STREAM;
  mixer: PALLEGRO_MIXER): Boolean; cdecl;
  external cDllName name _PU + 'al_attach_audio_stream_to_mixer';

function al_attach_mixer_to_mixer(stream: PALLEGRO_MIXER; mixer: PALLEGRO_MIXER)
  : Boolean; cdecl; external cDllName name _PU +
  'al_attach_mixer_to_mixer';

type
  al_set_mixer_postprocess_callback_cb = procedure(buf: Pointer;
    samples: Cardinal; data: Pointer); cdecl;

function al_set_mixer_postprocess_callback(mixer: PALLEGRO_MIXER;
  cb: al_set_mixer_postprocess_callback_cb; data: Pointer): Boolean; cdecl;
  external cDllName name _PU + 'al_set_mixer_postprocess_callback';

function al_get_mixer_frequency(const mixer: PALLEGRO_MIXER): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_mixer_frequency';

function al_get_mixer_channels(const mixer: PALLEGRO_MIXER)
  : ALLEGRO_CHANNEL_CONF; cdecl;
  external cDllName name _PU + 'al_get_mixer_channels';

function al_get_mixer_depth(const mixer: PALLEGRO_MIXER): ALLEGRO_AUDIO_DEPTH;
  cdecl; external cDllName name _PU + 'al_get_mixer_depth';

function al_get_mixer_quality(const mixer: PALLEGRO_MIXER)
  : ALLEGRO_MIXER_QUALITY; cdecl;
  external cDllName name _PU + 'al_get_mixer_quality';

function al_get_mixer_gain(const mixer: PALLEGRO_MIXER): Single; cdecl;
  external cDllName name _PU + 'al_get_mixer_gain';

function al_get_mixer_playing(const mixer: PALLEGRO_MIXER): Boolean; cdecl;
  external cDllName name _PU + 'al_get_mixer_playing';

function al_get_mixer_attached(const mixer: PALLEGRO_MIXER): Boolean; cdecl;
  external cDllName name _PU + 'al_get_mixer_attached';

function al_set_mixer_frequency(mixer: PALLEGRO_MIXER; val: Cardinal): Boolean;
  cdecl; external cDllName name _PU + 'al_set_mixer_frequency';

function al_set_mixer_quality(mixer: PALLEGRO_MIXER; val: ALLEGRO_MIXER_QUALITY)
  : Boolean; cdecl; external cDllName name _PU + 'al_set_mixer_quality';

function al_set_mixer_gain(mixer: PALLEGRO_MIXER; gain: Single): Boolean; cdecl;
  external cDllName name _PU + 'al_set_mixer_gain';

function al_set_mixer_playing(mixer: PALLEGRO_MIXER; val: Boolean): Boolean;
  cdecl; external cDllName name _PU + 'al_set_mixer_playing';

function al_detach_mixer(mixer: PALLEGRO_MIXER): Boolean; cdecl;
  external cDllName name _PU + 'al_detach_mixer';

function al_create_voice(freq: Cardinal; depth: ALLEGRO_AUDIO_DEPTH;
  chan_conf: ALLEGRO_CHANNEL_CONF): PALLEGRO_VOICE; cdecl;
  external cDllName name _PU + 'al_create_voice';

procedure al_destroy_voice(voice: PALLEGRO_VOICE); cdecl;
  external cDllName name _PU + 'al_destroy_voice';

function al_attach_sample_instance_to_voice(stream: PALLEGRO_SAMPLE_INSTANCE;
  voice: PALLEGRO_VOICE): Boolean; cdecl;
  external cDllName name _PU + 'al_attach_sample_instance_to_voice';

function al_attach_audio_stream_to_voice(stream: PALLEGRO_AUDIO_STREAM;
  voice: PALLEGRO_VOICE): Boolean; cdecl;
  external cDllName name _PU + 'al_attach_audio_stream_to_voice';

function al_attach_mixer_to_voice(mixer: PALLEGRO_MIXER; voice: PALLEGRO_VOICE)
  : Boolean; cdecl; external cDllName name _PU +
  'al_attach_mixer_to_voice';

procedure al_detach_voice(voice: PALLEGRO_VOICE); cdecl;
  external cDllName name _PU + 'al_detach_voice';

function al_get_voice_frequency(const voice: PALLEGRO_VOICE): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_voice_frequency';

function al_get_voice_position(const voice: PALLEGRO_VOICE): Cardinal; cdecl;
  external cDllName name _PU + 'al_get_voice_position';

function al_get_voice_channels(const voice: PALLEGRO_VOICE)
  : ALLEGRO_CHANNEL_CONF; cdecl;
  external cDllName name _PU + 'al_get_voice_channels';

function al_get_voice_depth(const voice: PALLEGRO_VOICE): ALLEGRO_AUDIO_DEPTH;
  cdecl; external cDllName name _PU + 'al_get_voice_depth';

function al_get_voice_playing(const voice: PALLEGRO_VOICE): Boolean; cdecl;
  external cDllName name _PU + 'al_get_voice_playing';

function al_set_voice_position(voice: PALLEGRO_VOICE; val: Cardinal): Boolean;
  cdecl; external cDllName name _PU + 'al_set_voice_position';

function al_set_voice_playing(voice: PALLEGRO_VOICE; val: Boolean): Boolean;
  cdecl; external cDllName name _PU + 'al_set_voice_playing';

function al_install_audio(): Boolean; cdecl;
  external cDllName name _PU + 'al_install_audio';

procedure al_uninstall_audio(); cdecl;
  external cDllName name _PU + 'al_uninstall_audio';

function al_is_audio_installed(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_audio_installed';

function al_get_allegro_audio_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_audio_version';

function al_get_channel_count(conf: ALLEGRO_CHANNEL_CONF): NativeUInt; cdecl;
  external cDllName name _PU + 'al_get_channel_count';

function al_get_audio_depth_size(conf: ALLEGRO_AUDIO_DEPTH): NativeUInt; cdecl;
  external cDllName name _PU + 'al_get_audio_depth_size';

procedure al_fill_silence(buf: Pointer; samples: Cardinal;
  depth: ALLEGRO_AUDIO_DEPTH; chan_conf: ALLEGRO_CHANNEL_CONF); cdecl;
  external cDllName name _PU + 'al_fill_silence';

function al_reserve_samples(reserve_samples: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_reserve_samples';

function al_get_default_mixer(): PALLEGRO_MIXER; cdecl;
  external cDllName name _PU + 'al_get_default_mixer';

function al_set_default_mixer(mixer: PALLEGRO_MIXER): Boolean; cdecl;
  external cDllName name _PU + 'al_set_default_mixer';

function al_restore_default_mixer(): Boolean; cdecl;
  external cDllName name _PU + 'al_restore_default_mixer';

function al_play_sample(data: PALLEGRO_SAMPLE; gain: Single; pan: Single;
  speed: Single; loop: ALLEGRO_PLAYMODE; ret_id: PALLEGRO_SAMPLE_ID): Boolean;
  cdecl; external cDllName name _PU + 'al_play_sample';

procedure al_stop_sample(spl_id: PALLEGRO_SAMPLE_ID); cdecl;
  external cDllName name _PU + 'al_stop_sample';

procedure al_stop_samples(); cdecl;
  external cDllName name _PU + 'al_stop_samples';

function al_get_default_voice(): PALLEGRO_VOICE; cdecl;
  external cDllName name _PU + 'al_get_default_voice';

procedure al_set_default_voice(voice: PALLEGRO_VOICE); cdecl;
  external cDllName name _PU + 'al_set_default_voice';

type
  al_register_sample_loader_loader = function(const filename: PUTF8Char)
    : PALLEGRO_SAMPLE; cdecl;

function al_register_sample_loader(const ext: PUTF8Char;
  loader: al_register_sample_loader_loader): Boolean; cdecl;
  external cDllName name _PU + 'al_register_sample_loader';

type
  al_register_sample_saver_saver = function(const filename: PUTF8Char;
    spl: PALLEGRO_SAMPLE): Boolean; cdecl;

function al_register_sample_saver(const ext: PUTF8Char;
  saver: al_register_sample_saver_saver): Boolean; cdecl;
  external cDllName name _PU + 'al_register_sample_saver';

type
  al_register_audio_stream_loader_stream_loader = function(const filename
    : PUTF8Char; buffer_count: NativeUInt; samples: Cardinal)
    : PALLEGRO_AUDIO_STREAM; cdecl;

function al_register_audio_stream_loader(const ext: PUTF8Char;
  stream_loader: al_register_audio_stream_loader_stream_loader): Boolean; cdecl;
  external cDllName name _PU + 'al_register_audio_stream_loader';

type
  al_register_sample_loader_f_loader = function(fp: PALLEGRO_FILE)
    : PALLEGRO_SAMPLE; cdecl;

function al_register_sample_loader_f(const ext: PUTF8Char;
  loader: al_register_sample_loader_f_loader): Boolean; cdecl;
  external cDllName name _PU + 'al_register_sample_loader_f';

type
  al_register_sample_saver_f_saver = function(fp: PALLEGRO_FILE;
    spl: PALLEGRO_SAMPLE): Boolean; cdecl;

function al_register_sample_saver_f(const ext: PUTF8Char;
  saver: al_register_sample_saver_f_saver): Boolean; cdecl;
  external cDllName name _PU + 'al_register_sample_saver_f';

type
  al_register_audio_stream_loader_f_stream_loader = function(fp: PALLEGRO_FILE;
    buffer_count: NativeUInt; samples: Cardinal): PALLEGRO_AUDIO_STREAM; cdecl;

function al_register_audio_stream_loader_f(const ext: PUTF8Char;
  stream_loader: al_register_audio_stream_loader_f_stream_loader): Boolean;
  cdecl; external cDllName name _PU +
  'al_register_audio_stream_loader_f';

function al_load_sample(const filename: PUTF8Char): PALLEGRO_SAMPLE; cdecl;
  external cDllName name _PU + 'al_load_sample';

function al_save_sample(const filename: PUTF8Char; spl: PALLEGRO_SAMPLE)
  : Boolean; cdecl; external cDllName name _PU + 'al_save_sample';

function al_load_audio_stream(const filename: PUTF8Char;
  buffer_count: NativeUInt; samples: Cardinal): PALLEGRO_AUDIO_STREAM; cdecl;
  external cDllName name _PU + 'al_load_audio_stream';

function al_load_sample_f(fp: PALLEGRO_FILE; const ident: PUTF8Char)
  : PALLEGRO_SAMPLE; cdecl;
  external cDllName name _PU + 'al_load_sample_f';

function al_save_sample_f(fp: PALLEGRO_FILE; const ident: PUTF8Char;
  spl: PALLEGRO_SAMPLE): Boolean; cdecl;
  external cDllName name _PU + 'al_save_sample_f';

function al_load_audio_stream_f(fp: PALLEGRO_FILE; const ident: PUTF8Char;
  buffer_count: NativeUInt; samples: Cardinal): PALLEGRO_AUDIO_STREAM; cdecl;
  external cDllName name _PU + 'al_load_audio_stream_f';

function al_init_acodec_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_acodec_addon';

function al_is_acodec_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_acodec_addon_initialized';

function al_get_allegro_acodec_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_acodec_version';

function al_get_allegro_color_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_color_version';

procedure al_color_hsv_to_rgb(hue: Single; saturation: Single; value: Single;
  red: PSingle; green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_hsv_to_rgb';

procedure al_color_rgb_to_hsl(red: Single; green: Single; blue: Single;
  hue: PSingle; saturation: PSingle; lightness: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_hsl';

procedure al_color_rgb_to_hsv(red: Single; green: Single; blue: Single;
  hue: PSingle; saturation: PSingle; value: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_hsv';

procedure al_color_hsl_to_rgb(hue: Single; saturation: Single;
  lightness: Single; red: PSingle; green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_hsl_to_rgb';

function al_color_name_to_rgb(const name: PUTF8Char; r: PSingle; g: PSingle;
  b: PSingle): Boolean; cdecl;
  external cDllName name _PU + 'al_color_name_to_rgb';

function al_color_rgb_to_name(r: Single; g: Single; b: Single): PUTF8Char;
  cdecl; external cDllName name _PU + 'al_color_rgb_to_name';

procedure al_color_cmyk_to_rgb(cyan: Single; magenta: Single; yellow: Single;
  key: Single; red: PSingle; green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_cmyk_to_rgb';

procedure al_color_rgb_to_cmyk(red: Single; green: Single; blue: Single;
  cyan: PSingle; magenta: PSingle; yellow: PSingle; key: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_cmyk';

procedure al_color_yuv_to_rgb(y: Single; u: Single; v: Single; red: PSingle;
  green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_yuv_to_rgb';

procedure al_color_rgb_to_yuv(red: Single; green: Single; blue: Single;
  y: PSingle; u: PSingle; v: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_yuv';

procedure al_color_rgb_to_html(red: Single; green: Single; blue: Single;
  &string: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_html';

function al_color_html_to_rgb(const &string: PUTF8Char; red: PSingle;
  green: PSingle; blue: PSingle): Boolean; cdecl;
  external cDllName name _PU + 'al_color_html_to_rgb';

function al_color_yuv(y: Single; u: Single; v: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_yuv';

function al_color_cmyk(c: Single; m: Single; y: Single; k: Single)
  : ALLEGRO_COLOR; cdecl; external cDllName name _PU + 'al_color_cmyk';

function al_color_hsl(h: Single; s: Single; l: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_hsl';

function al_color_hsv(h: Single; s: Single; v: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_hsv';

function al_color_name(const name: PUTF8Char): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_name';

function al_color_html(const &string: PUTF8Char): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_html';

procedure al_color_xyz_to_rgb(x: Single; y: Single; z: Single; red: PSingle;
  green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_xyz_to_rgb';

procedure al_color_rgb_to_xyz(red: Single; green: Single; blue: Single;
  x: PSingle; y: PSingle; z: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_xyz';

function al_color_xyz(x: Single; y: Single; z: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_xyz';

procedure al_color_lab_to_rgb(l: Single; a: Single; b: Single; red: PSingle;
  green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_lab_to_rgb';

procedure al_color_rgb_to_lab(red: Single; green: Single; blue: Single;
  l: PSingle; a: PSingle; b: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_lab';

function al_color_lab(l: Single; a: Single; b: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_lab';

procedure al_color_xyy_to_rgb(x: Single; y: Single; y2: Single; red: PSingle;
  green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_xyy_to_rgb';

procedure al_color_rgb_to_xyy(red: Single; green: Single; blue: Single;
  x: PSingle; y: PSingle; y2: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_xyy';

function al_color_xyy(x: Single; y: Single; y2: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_xyy';

function al_color_distance_ciede2000(c1: ALLEGRO_COLOR; c2: ALLEGRO_COLOR)
  : Double; cdecl; external cDllName name _PU +
  'al_color_distance_ciede2000';

procedure al_color_lch_to_rgb(l: Single; c: Single; h: Single; red: PSingle;
  green: PSingle; blue: PSingle); cdecl;
  external cDllName name _PU + 'al_color_lch_to_rgb';

procedure al_color_rgb_to_lch(red: Single; green: Single; blue: Single;
  l: PSingle; c: PSingle; h: PSingle); cdecl;
  external cDllName name _PU + 'al_color_rgb_to_lch';

function al_color_lch(l: Single; c: Single; h: Single): ALLEGRO_COLOR; cdecl;
  external cDllName name _PU + 'al_color_lch';

function al_is_color_valid(color: ALLEGRO_COLOR): Boolean; cdecl;
  external cDllName name _PU + 'al_is_color_valid';

type
  LPDIRECT3DDEVICE9 = ^IDIRECT3DDEVICE9;

function al_get_d3d_device(p1: PALLEGRO_DISPLAY): LPDIRECT3DDEVICE9; cdecl;
  external cDllName name _PU + 'al_get_d3d_device';

type
  LPDIRECT3DTEXTURE9 = ^IDIRECT3DTEXTURE9;

function al_get_d3d_system_texture(p1: PALLEGRO_BITMAP): LPDIRECT3DTEXTURE9;
  cdecl; external cDllName name _PU + 'al_get_d3d_system_texture';

function al_get_d3d_video_texture(p1: PALLEGRO_BITMAP): LPDIRECT3DTEXTURE9;
  cdecl; external cDllName name _PU + 'al_get_d3d_video_texture';

function al_have_d3d_non_pow2_texture_support(): Boolean; cdecl;
  external cDllName name _PU + 'al_have_d3d_non_pow2_texture_support';

function al_have_d3d_non_square_texture_support(): Boolean; cdecl;
  external cDllName name _PU + 'al_have_d3d_non_square_texture_support';

procedure al_get_d3d_texture_position(bitmap: PALLEGRO_BITMAP; u: PInteger;
  v: PInteger); cdecl; external cDllName name _PU +
  'al_get_d3d_texture_position';

function al_get_d3d_texture_size(bitmap: PALLEGRO_BITMAP; width: PInteger;
  height: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_get_d3d_texture_size';

function al_is_d3d_device_lost(display: PALLEGRO_DISPLAY): Boolean; cdecl;
  external cDllName name _PU + 'al_is_d3d_device_lost';

type
  al_set_d3d_device_release_callback_callback = procedure
    (display: PALLEGRO_DISPLAY); cdecl;

procedure al_set_d3d_device_release_callback
  (callback: al_set_d3d_device_release_callback_callback); cdecl;
  external cDllName name _PU + 'al_set_d3d_device_release_callback';

type
  al_set_d3d_device_restore_callback_callback = procedure
    (display: PALLEGRO_DISPLAY); cdecl;

procedure al_set_d3d_device_restore_callback
  (callback: al_set_d3d_device_restore_callback_callback); cdecl;
  external cDllName name _PU + 'al_set_d3d_device_restore_callback';

type
  al_register_font_loader_load = function(const filename: PUTF8Char;
    size: Integer; flags: Integer): PALLEGRO_FONT; cdecl;

function al_register_font_loader(const ext: PUTF8Char;
  load: al_register_font_loader_load): Boolean; cdecl;
  external cDllName name _PU + 'al_register_font_loader';

function al_load_bitmap_font(const filename: PUTF8Char): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_load_bitmap_font';

function al_load_bitmap_font_flags(const filename: PUTF8Char; flags: Integer)
  : PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_load_bitmap_font_flags';

function al_load_font(const filename: PUTF8Char; size: Integer; flags: Integer)
  : PALLEGRO_FONT; cdecl; external cDllName name _PU + 'al_load_font';

function al_grab_font_from_bitmap(bmp: PALLEGRO_BITMAP; n: Integer;
  ranges: PInteger): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_grab_font_from_bitmap';

function al_create_builtin_font(): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_create_builtin_font';

procedure al_draw_ustr(const font: PALLEGRO_FONT; color: ALLEGRO_COLOR;
  x: Single; y: Single; flags: Integer; const ustr: PALLEGRO_USTR); cdecl;
  external cDllName name _PU + 'al_draw_ustr';

procedure al_draw_text(const font: PALLEGRO_FONT; color: ALLEGRO_COLOR;
  x: Single; y: Single; flags: Integer; const text: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_draw_text';

procedure al_draw_justified_text(const font: PALLEGRO_FONT;
  color: ALLEGRO_COLOR; x1: Single; x2: Single; y: Single; diff: Single;
  flags: Integer; const text: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_draw_justified_text';

procedure al_draw_justified_ustr(const font: PALLEGRO_FONT;
  color: ALLEGRO_COLOR; x1: Single; x2: Single; y: Single; diff: Single;
  flags: Integer; const text: PALLEGRO_USTR); cdecl;
  external cDllName name _PU + 'al_draw_justified_ustr';

procedure al_draw_textf(const font: PALLEGRO_FONT; color: ALLEGRO_COLOR;
  x: Single; y: Single; flags: Integer; const format: PUTF8Char)varargs; cdecl;
  external cDllName name _PU + 'al_draw_textf';

procedure al_draw_justified_textf(const font: PALLEGRO_FONT;
  color: ALLEGRO_COLOR; x1: Single; x2: Single; y: Single; diff: Single;
  flags: Integer; const format: PUTF8Char)varargs; cdecl;
  external cDllName name _PU + 'al_draw_justified_textf';

function al_get_text_width(const f: PALLEGRO_FONT; const str: PUTF8Char)
  : Integer; cdecl; external cDllName name _PU + 'al_get_text_width';

function al_get_ustr_width(const f: PALLEGRO_FONT; const ustr: PALLEGRO_USTR)
  : Integer; cdecl; external cDllName name _PU + 'al_get_ustr_width';

function al_get_font_line_height(const f: PALLEGRO_FONT): Integer; cdecl;
  external cDllName name _PU + 'al_get_font_line_height';

function al_get_font_ascent(const f: PALLEGRO_FONT): Integer; cdecl;
  external cDllName name _PU + 'al_get_font_ascent';

function al_get_font_descent(const f: PALLEGRO_FONT): Integer; cdecl;
  external cDllName name _PU + 'al_get_font_descent';

procedure al_destroy_font(f: PALLEGRO_FONT); cdecl;
  external cDllName name _PU + 'al_destroy_font';

procedure al_get_ustr_dimensions(const f: PALLEGRO_FONT;
  const text: PALLEGRO_USTR; bbx: PInteger; bby: PInteger; bbw: PInteger;
  bbh: PInteger); cdecl;
  external cDllName name _PU + 'al_get_ustr_dimensions';

procedure al_get_text_dimensions(const f: PALLEGRO_FONT; const text: PUTF8Char;
  bbx: PInteger; bby: PInteger; bbw: PInteger; bbh: PInteger); cdecl;
  external cDllName name _PU + 'al_get_text_dimensions';

function al_init_font_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_font_addon';

function al_is_font_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_font_addon_initialized';

procedure al_shutdown_font_addon(); cdecl;
  external cDllName name _PU + 'al_shutdown_font_addon';

function al_get_allegro_font_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_font_version';

function al_get_font_ranges(font: PALLEGRO_FONT; ranges_count: Integer;
  ranges: PInteger): Integer; cdecl;
  external cDllName name _PU + 'al_get_font_ranges';

procedure al_draw_glyph(const font: PALLEGRO_FONT; color: ALLEGRO_COLOR;
  x: Single; y: Single; codepoint: Integer); cdecl;
  external cDllName name _PU + 'al_draw_glyph';

function al_get_glyph_width(const f: PALLEGRO_FONT; codepoint: Integer)
  : Integer; cdecl; external cDllName name _PU + 'al_get_glyph_width';

function al_get_glyph_dimensions(const f: PALLEGRO_FONT; codepoint: Integer;
  bbx: PInteger; bby: PInteger; bbw: PInteger; bbh: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_get_glyph_dimensions';

function al_get_glyph_advance(const f: PALLEGRO_FONT; codepoint1: Integer;
  codepoint2: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_get_glyph_advance';

procedure al_draw_multiline_text(const font: PALLEGRO_FONT;
  color: ALLEGRO_COLOR; x: Single; y: Single; max_width: Single;
  line_height: Single; flags: Integer; const text: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_draw_multiline_text';

procedure al_draw_multiline_textf(const font: PALLEGRO_FONT;
  color: ALLEGRO_COLOR; x: Single; y: Single; max_width: Single;
  line_height: Single; flags: Integer; const format: PUTF8Char)varargs; cdecl;
  external cDllName name _PU + 'al_draw_multiline_textf';

procedure al_draw_multiline_ustr(const font: PALLEGRO_FONT;
  color: ALLEGRO_COLOR; x: Single; y: Single; max_width: Single;
  line_height: Single; flags: Integer; const text: PALLEGRO_USTR); cdecl;
  external cDllName name _PU + 'al_draw_multiline_ustr';

type
  al_do_multiline_text_cb = function(line_num: Integer; const line: PUTF8Char;
    size: Integer; extra: Pointer): Boolean; cdecl;

procedure al_do_multiline_text(const font: PALLEGRO_FONT; max_width: Single;
  const text: PUTF8Char; cb: al_do_multiline_text_cb; extra: Pointer); cdecl;
  external cDllName name _PU + 'al_do_multiline_text';

type
  al_do_multiline_ustr_cb = function(line_num: Integer;
    const line: PALLEGRO_USTR; extra: Pointer): Boolean; cdecl;

procedure al_do_multiline_ustr(const font: PALLEGRO_FONT; max_width: Single;
  const ustr: PALLEGRO_USTR; cb: al_do_multiline_ustr_cb; extra: Pointer);
  cdecl; external cDllName name _PU + 'al_do_multiline_ustr';

procedure al_set_fallback_font(font: PALLEGRO_FONT; fallback: PALLEGRO_FONT);
  cdecl; external cDllName name _PU + 'al_set_fallback_font';

function al_get_fallback_font(font: PALLEGRO_FONT): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_get_fallback_font';

function al_init_image_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_image_addon';

function al_is_image_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_image_addon_initialized';

procedure al_shutdown_image_addon(); cdecl;
  external cDllName name _PU + 'al_shutdown_image_addon';

function al_get_allegro_image_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_image_version';

function al_open_memfile(mem: Pointer; size: Int64; const mode: PUTF8Char)
  : PALLEGRO_FILE; cdecl;
  external cDllName name _PU + 'al_open_memfile';

function al_get_allegro_memfile_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_memfile_version';

function al_init_native_dialog_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_native_dialog_addon';

function al_is_native_dialog_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_native_dialog_addon_initialized';

procedure al_shutdown_native_dialog_addon(); cdecl;
  external cDllName name _PU + 'al_shutdown_native_dialog_addon';

function al_create_native_file_dialog(const initial_path: PUTF8Char;
  const title: PUTF8Char; const patterns: PUTF8Char; mode: Integer)
  : PALLEGRO_FILECHOOSER; cdecl;
  external cDllName name _PU + 'al_create_native_file_dialog';

function al_show_native_file_dialog(display: PALLEGRO_DISPLAY;
  dialog: PALLEGRO_FILECHOOSER): Boolean; cdecl;
  external cDllName name _PU + 'al_show_native_file_dialog';

function al_get_native_file_dialog_count(const dialog: PALLEGRO_FILECHOOSER)
  : Integer; cdecl; external cDllName name _PU +
  'al_get_native_file_dialog_count';

function al_get_native_file_dialog_path(const dialog: PALLEGRO_FILECHOOSER;
  index: NativeUInt): PUTF8Char; cdecl;
  external cDllName name _PU + 'al_get_native_file_dialog_path';

procedure al_destroy_native_file_dialog(dialog: PALLEGRO_FILECHOOSER); cdecl;
  external cDllName name _PU + 'al_destroy_native_file_dialog';

function al_show_native_message_box(display: PALLEGRO_DISPLAY;
  const title: PUTF8Char; const heading: PUTF8Char; const text: PUTF8Char;
  const buttons: PUTF8Char; flags: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_show_native_message_box';

function al_open_native_text_log(const title: PUTF8Char; flags: Integer)
  : PALLEGRO_TEXTLOG; cdecl;
  external cDllName name _PU + 'al_open_native_text_log';

procedure al_close_native_text_log(textlog: PALLEGRO_TEXTLOG); cdecl;
  external cDllName name _PU + 'al_close_native_text_log';

procedure al_append_native_text_log(textlog: PALLEGRO_TEXTLOG;
  const format: PUTF8Char)varargs; cdecl;
  external cDllName name _PU + 'al_append_native_text_log';

function al_get_native_text_log_event_source(textlog: PALLEGRO_TEXTLOG)
  : PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_native_text_log_event_source';

function al_create_menu(): PALLEGRO_MENU; cdecl;
  external cDllName name _PU + 'al_create_menu';

function al_create_popup_menu(): PALLEGRO_MENU; cdecl;
  external cDllName name _PU + 'al_create_popup_menu';

function al_build_menu(info: PALLEGRO_MENU_INFO): PALLEGRO_MENU; cdecl;
  external cDllName name _PU + 'al_build_menu';

function al_append_menu_item(parent: PALLEGRO_MENU; const title: PUTF8Char;
  id: UInt16; flags: Integer; icon: PALLEGRO_BITMAP; submenu: PALLEGRO_MENU)
  : Integer; cdecl; external cDllName name _PU + 'al_append_menu_item';

function al_insert_menu_item(parent: PALLEGRO_MENU; pos: Integer;
  const title: PUTF8Char; id: UInt16; flags: Integer; icon: PALLEGRO_BITMAP;
  submenu: PALLEGRO_MENU): Integer; cdecl;
  external cDllName name _PU + 'al_insert_menu_item';

function al_remove_menu_item(menu: PALLEGRO_MENU; pos: Integer): Boolean; cdecl;
  external cDllName name _PU + 'al_remove_menu_item';

function al_clone_menu(menu: PALLEGRO_MENU): PALLEGRO_MENU; cdecl;
  external cDllName name _PU + 'al_clone_menu';

function al_clone_menu_for_popup(menu: PALLEGRO_MENU): PALLEGRO_MENU; cdecl;
  external cDllName name _PU + 'al_clone_menu_for_popup';

procedure al_destroy_menu(menu: PALLEGRO_MENU); cdecl;
  external cDllName name _PU + 'al_destroy_menu';

function al_get_menu_item_caption(menu: PALLEGRO_MENU; pos: Integer): PUTF8Char;
  cdecl; external cDllName name _PU + 'al_get_menu_item_caption';

procedure al_set_menu_item_caption(menu: PALLEGRO_MENU; pos: Integer;
  const caption: PUTF8Char); cdecl;
  external cDllName name _PU + 'al_set_menu_item_caption';

function al_get_menu_item_flags(menu: PALLEGRO_MENU; pos: Integer): Integer;
  cdecl; external cDllName name _PU + 'al_get_menu_item_flags';

procedure al_set_menu_item_flags(menu: PALLEGRO_MENU; pos: Integer;
  flags: Integer); cdecl;
  external cDllName name _PU + 'al_set_menu_item_flags';

function al_get_menu_item_icon(menu: PALLEGRO_MENU; pos: Integer)
  : PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_get_menu_item_icon';

procedure al_set_menu_item_icon(menu: PALLEGRO_MENU; pos: Integer;
  icon: PALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_set_menu_item_icon';

function al_find_menu(haystack: PALLEGRO_MENU; id: UInt16): PALLEGRO_MENU;
  cdecl; external cDllName name _PU + 'al_find_menu';

function al_find_menu_item(haystack: PALLEGRO_MENU; id: UInt16;
  menu: PPALLEGRO_MENU; index: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_find_menu_item';

function al_get_default_menu_event_source(): PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_default_menu_event_source';

function al_enable_menu_event_source(menu: PALLEGRO_MENU)
  : PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_enable_menu_event_source';

procedure al_disable_menu_event_source(menu: PALLEGRO_MENU); cdecl;
  external cDllName name _PU + 'al_disable_menu_event_source';

function al_get_display_menu(display: PALLEGRO_DISPLAY): PALLEGRO_MENU; cdecl;
  external cDllName name _PU + 'al_get_display_menu';

function al_set_display_menu(display: PALLEGRO_DISPLAY; menu: PALLEGRO_MENU)
  : Boolean; cdecl; external cDllName name _PU + 'al_set_display_menu';

function al_popup_menu(popup: PALLEGRO_MENU; display: PALLEGRO_DISPLAY)
  : Boolean; cdecl; external cDllName name _PU + 'al_popup_menu';

function al_remove_display_menu(display: PALLEGRO_DISPLAY): PALLEGRO_MENU;
  cdecl; external cDllName name _PU + 'al_remove_display_menu';

function al_get_allegro_native_dialog_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_native_dialog_version';

function al_get_opengl_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_opengl_version';

function al_have_opengl_extension(const extension: PUTF8Char): Boolean; cdecl;
  external cDllName name _PU + 'al_have_opengl_extension';

function al_get_opengl_proc_address(const name: PUTF8Char): Pointer; cdecl;
  external cDllName name _PU + 'al_get_opengl_proc_address';

function al_get_opengl_extension_list(): PALLEGRO_OGL_EXT_LIST; cdecl;
  external cDllName name _PU + 'al_get_opengl_extension_list';

function al_get_opengl_texture(bitmap: PALLEGRO_BITMAP): GLuint; cdecl;
  external cDllName name _PU + 'al_get_opengl_texture';

procedure al_remove_opengl_fbo(bitmap: PALLEGRO_BITMAP); cdecl;
  external cDllName name _PU + 'al_remove_opengl_fbo';

function al_get_opengl_fbo(bitmap: PALLEGRO_BITMAP): GLuint; cdecl;
  external cDllName name _PU + 'al_get_opengl_fbo';

function al_get_opengl_texture_size(bitmap: PALLEGRO_BITMAP; w: PInteger;
  h: PInteger): Boolean; cdecl;
  external cDllName name _PU + 'al_get_opengl_texture_size';

procedure al_get_opengl_texture_position(bitmap: PALLEGRO_BITMAP; u: PInteger;
  v: PInteger); cdecl; external cDllName name _PU +
  'al_get_opengl_texture_position';

function al_get_opengl_program_object(shader: PALLEGRO_SHADER): GLuint; cdecl;
  external cDllName name _PU + 'al_get_opengl_program_object';

procedure al_set_current_opengl_context(display: PALLEGRO_DISPLAY); cdecl;
  external cDllName name _PU + 'al_set_current_opengl_context';

function al_get_opengl_variant(): Integer; cdecl;
  external cDllName name _PU + 'al_get_opengl_variant';

procedure al_set_physfs_file_interface(); cdecl;
  external cDllName name _PU + 'al_set_physfs_file_interface';

function al_get_allegro_physfs_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_physfs_version';

function al_get_allegro_primitives_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_primitives_version';

function al_init_primitives_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_primitives_addon';

function al_is_primitives_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_primitives_addon_initialized';

procedure al_shutdown_primitives_addon(); cdecl;
  external cDllName name _PU + 'al_shutdown_primitives_addon';

function al_draw_prim(const vtxs: Pointer; const decl: PALLEGRO_VERTEX_DECL;
  texture: PALLEGRO_BITMAP; start: Integer; &end: Integer; &type: Integer)
  : Integer; cdecl; external cDllName name _PU + 'al_draw_prim';

function al_draw_indexed_prim(const vtxs: Pointer;
  const decl: PALLEGRO_VERTEX_DECL; texture: PALLEGRO_BITMAP;
  const indices: PInteger; num_vtx: Integer; &type: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_draw_indexed_prim';

function al_draw_vertex_buffer(vertex_buffer: PALLEGRO_VERTEX_BUFFER;
  texture: PALLEGRO_BITMAP; start: Integer; &end: Integer; &type: Integer)
  : Integer; cdecl; external cDllName name _PU +
  'al_draw_vertex_buffer';

function al_draw_indexed_buffer(vertex_buffer: PALLEGRO_VERTEX_BUFFER;
  texture: PALLEGRO_BITMAP; index_buffer: PALLEGRO_INDEX_BUFFER; start: Integer;
  &end: Integer; &type: Integer): Integer; cdecl;
  external cDllName name _PU + 'al_draw_indexed_buffer';

function al_create_vertex_decl(const elements: PALLEGRO_VERTEX_ELEMENT;
  stride: Integer): PALLEGRO_VERTEX_DECL; cdecl;
  external cDllName name _PU + 'al_create_vertex_decl';

procedure al_destroy_vertex_decl(decl: PALLEGRO_VERTEX_DECL); cdecl;
  external cDllName name _PU + 'al_destroy_vertex_decl';

function al_create_vertex_buffer(decl: PALLEGRO_VERTEX_DECL;
  const initial_data: Pointer; num_vertices: Integer; flags: Integer)
  : PALLEGRO_VERTEX_BUFFER; cdecl;
  external cDllName name _PU + 'al_create_vertex_buffer';

procedure al_destroy_vertex_buffer(buffer: PALLEGRO_VERTEX_BUFFER); cdecl;
  external cDllName name _PU + 'al_destroy_vertex_buffer';

function al_lock_vertex_buffer(buffer: PALLEGRO_VERTEX_BUFFER; offset: Integer;
  length: Integer; flags: Integer): Pointer; cdecl;
  external cDllName name _PU + 'al_lock_vertex_buffer';

procedure al_unlock_vertex_buffer(buffer: PALLEGRO_VERTEX_BUFFER); cdecl;
  external cDllName name _PU + 'al_unlock_vertex_buffer';

function al_get_vertex_buffer_size(buffer: PALLEGRO_VERTEX_BUFFER): Integer;
  cdecl; external cDllName name _PU + 'al_get_vertex_buffer_size';

function al_create_index_buffer(index_size: Integer;
  const initial_data: Pointer; num_indices: Integer; flags: Integer)
  : PALLEGRO_INDEX_BUFFER; cdecl;
  external cDllName name _PU + 'al_create_index_buffer';

procedure al_destroy_index_buffer(buffer: PALLEGRO_INDEX_BUFFER); cdecl;
  external cDllName name _PU + 'al_destroy_index_buffer';

function al_lock_index_buffer(buffer: PALLEGRO_INDEX_BUFFER; offset: Integer;
  length: Integer; flags: Integer): Pointer; cdecl;
  external cDllName name _PU + 'al_lock_index_buffer';

procedure al_unlock_index_buffer(buffer: PALLEGRO_INDEX_BUFFER); cdecl;
  external cDllName name _PU + 'al_unlock_index_buffer';

function al_get_index_buffer_size(buffer: PALLEGRO_INDEX_BUFFER): Integer;
  cdecl; external cDllName name _PU + 'al_get_index_buffer_size';

type
  al_triangulate_polygon_emit_triangle = procedure(p1: Integer; p2: Integer;
    p3: Integer; p4: Pointer); cdecl;

function al_triangulate_polygon(const vertices: PSingle;
  vertex_stride: NativeUInt; const vertex_counts: PInteger;
  emit_triangle: al_triangulate_polygon_emit_triangle; userdata: Pointer)
  : Boolean; cdecl; external cDllName name _PU +
  'al_triangulate_polygon';

type
  al_draw_soft_triangle_init = procedure(p1: UIntPtr; p2: PALLEGRO_VERTEX;
    p3: PALLEGRO_VERTEX; p4: PALLEGRO_VERTEX); cdecl;

type
  al_draw_soft_triangle_first = procedure(p1: UIntPtr; p2: Integer; p3: Integer;
    p4: Integer; p5: Integer); cdecl;

type
  al_draw_soft_triangle_step = procedure(p1: UIntPtr; p2: Integer); cdecl;

type
  al_draw_soft_triangle_draw = procedure(p1: UIntPtr; p2: Integer; p3: Integer;
    p4: Integer); cdecl;

procedure al_draw_soft_triangle(v1: PALLEGRO_VERTEX; v2: PALLEGRO_VERTEX;
  v3: PALLEGRO_VERTEX; state: UIntPtr; init: al_draw_soft_triangle_init;
  first: al_draw_soft_triangle_first; step: al_draw_soft_triangle_step;
  draw: al_draw_soft_triangle_draw); cdecl;
  external cDllName name _PU + 'al_draw_soft_triangle';

type
  al_draw_soft_line_first = procedure(p1: UIntPtr; p2: Integer; p3: Integer;
    p4: PALLEGRO_VERTEX; p5: PALLEGRO_VERTEX); cdecl;

type
  al_draw_soft_line_step = procedure(p1: UIntPtr; p2: Integer); cdecl;

type
  al_draw_soft_line_draw = procedure(p1: UIntPtr; p2: Integer;
    p3: Integer); cdecl;

procedure al_draw_soft_line(v1: PALLEGRO_VERTEX; v2: PALLEGRO_VERTEX;
  state: UIntPtr; first: al_draw_soft_line_first; step: al_draw_soft_line_step;
  draw: al_draw_soft_line_draw); cdecl;
  external cDllName name _PU + 'al_draw_soft_line';

procedure al_draw_line(x1: Single; y1: Single; x2: Single; y2: Single;
  color: ALLEGRO_COLOR; thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_line';

procedure al_draw_triangle(x1: Single; y1: Single; x2: Single; y2: Single;
  x3: Single; y3: Single; color: ALLEGRO_COLOR; thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_triangle';

procedure al_draw_rectangle(x1: Single; y1: Single; x2: Single; y2: Single;
  color: ALLEGRO_COLOR; thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_rectangle';

procedure al_draw_rounded_rectangle(x1: Single; y1: Single; x2: Single;
  y2: Single; rx: Single; ry: Single; color: ALLEGRO_COLOR; thickness: Single);
  cdecl; external cDllName name _PU + 'al_draw_rounded_rectangle';

procedure al_calculate_arc(dest: PSingle; stride: Integer; cx: Single;
  cy: Single; rx: Single; ry: Single; start_theta: Single; delta_theta: Single;
  thickness: Single; num_points: Integer); cdecl;
  external cDllName name _PU + 'al_calculate_arc';

procedure al_draw_circle(cx: Single; cy: Single; r: Single;
  color: ALLEGRO_COLOR; thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_circle';

procedure al_draw_ellipse(cx: Single; cy: Single; rx: Single; ry: Single;
  color: ALLEGRO_COLOR; thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_ellipse';

procedure al_draw_arc(cx: Single; cy: Single; r: Single; start_theta: Single;
  delta_theta: Single; color: ALLEGRO_COLOR; thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_arc';

procedure al_draw_elliptical_arc(cx: Single; cy: Single; rx: Single; ry: Single;
  start_theta: Single; delta_theta: Single; color: ALLEGRO_COLOR;
  thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_elliptical_arc';

procedure al_draw_pieslice(cx: Single; cy: Single; r: Single;
  start_theta: Single; delta_theta: Single; color: ALLEGRO_COLOR;
  thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_pieslice';

procedure al_calculate_spline(dest: PSingle; stride: Integer; points: PSingle;
  thickness: Single; num_segments: Integer); cdecl;
  external cDllName name _PU + 'al_calculate_spline';

procedure al_draw_spline(points: PSingle; color: ALLEGRO_COLOR;
  thickness: Single); cdecl;
  external cDllName name _PU + 'al_draw_spline';

procedure al_calculate_ribbon(dest: PSingle; dest_stride: Integer;
  const points: PSingle; points_stride: Integer; thickness: Single;
  num_segments: Integer); cdecl;
  external cDllName name _PU + 'al_calculate_ribbon';

procedure al_draw_ribbon(const points: PSingle; points_stride: Integer;
  color: ALLEGRO_COLOR; thickness: Single; num_segments: Integer); cdecl;
  external cDllName name _PU + 'al_draw_ribbon';

procedure al_draw_filled_triangle(x1: Single; y1: Single; x2: Single;
  y2: Single; x3: Single; y3: Single; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_triangle';

procedure al_draw_filled_rectangle(x1: Single; y1: Single; x2: Single;
  y2: Single; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_rectangle';

procedure al_draw_filled_ellipse(cx: Single; cy: Single; rx: Single; ry: Single;
  color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_ellipse';

procedure al_draw_filled_circle(cx: Single; cy: Single; r: Single;
  color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_circle';

procedure al_draw_filled_pieslice(cx: Single; cy: Single; r: Single;
  start_theta: Single; delta_theta: Single; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_pieslice';

procedure al_draw_filled_rounded_rectangle(x1: Single; y1: Single; x2: Single;
  y2: Single; rx: Single; ry: Single; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_rounded_rectangle';

procedure al_draw_polyline(const vertices: PSingle; vertex_stride: Integer;
  vertex_count: Integer; join_style: Integer; cap_style: Integer;
  color: ALLEGRO_COLOR; thickness: Single; miter_limit: Single); cdecl;
  external cDllName name _PU + 'al_draw_polyline';

procedure al_draw_polygon(const vertices: PSingle; vertex_count: Integer;
  join_style: Integer; color: ALLEGRO_COLOR; thickness: Single;
  miter_limit: Single); cdecl;
  external cDllName name _PU + 'al_draw_polygon';

procedure al_draw_filled_polygon(const vertices: PSingle; vertex_count: Integer;
  color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_polygon';

procedure al_draw_filled_polygon_with_holes(const vertices: PSingle;
  const vertex_counts: PInteger; color: ALLEGRO_COLOR); cdecl;
  external cDllName name _PU + 'al_draw_filled_polygon_with_holes';

function al_load_ttf_font(const filename: PUTF8Char; size: Integer;
  flags: Integer): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_load_ttf_font';

function al_load_ttf_font_f(&file: PALLEGRO_FILE; const filename: PUTF8Char;
  size: Integer; flags: Integer): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_load_ttf_font_f';

function al_load_ttf_font_stretch(const filename: PUTF8Char; w: Integer;
  h: Integer; flags: Integer): PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_load_ttf_font_stretch';

function al_load_ttf_font_stretch_f(&file: PALLEGRO_FILE;
  const filename: PUTF8Char; w: Integer; h: Integer; flags: Integer)
  : PALLEGRO_FONT; cdecl;
  external cDllName name _PU + 'al_load_ttf_font_stretch_f';

function al_init_ttf_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_ttf_addon';

function al_is_ttf_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_ttf_addon_initialized';

procedure al_shutdown_ttf_addon(); cdecl;
  external cDllName name _PU + 'al_shutdown_ttf_addon';

function al_get_allegro_ttf_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_ttf_version';

function al_open_video(const filename: PUTF8Char): PALLEGRO_VIDEO; cdecl;
  external cDllName name _PU + 'al_open_video';

procedure al_close_video(video: PALLEGRO_VIDEO); cdecl;
  external cDllName name _PU + 'al_close_video';

procedure al_start_video(video: PALLEGRO_VIDEO; mixer: PALLEGRO_MIXER); cdecl;
  external cDllName name _PU + 'al_start_video';

procedure al_start_video_with_voice(video: PALLEGRO_VIDEO;
  voice: PALLEGRO_VOICE); cdecl;
  external cDllName name _PU + 'al_start_video_with_voice';

function al_get_video_event_source(video: PALLEGRO_VIDEO)
  : PALLEGRO_EVENT_SOURCE; cdecl;
  external cDllName name _PU + 'al_get_video_event_source';

procedure al_set_video_playing(video: PALLEGRO_VIDEO; playing: Boolean); cdecl;
  external cDllName name _PU + 'al_set_video_playing';

function al_is_video_playing(video: PALLEGRO_VIDEO): Boolean; cdecl;
  external cDllName name _PU + 'al_is_video_playing';

function al_get_video_audio_rate(video: PALLEGRO_VIDEO): Double; cdecl;
  external cDllName name _PU + 'al_get_video_audio_rate';

function al_get_video_fps(video: PALLEGRO_VIDEO): Double; cdecl;
  external cDllName name _PU + 'al_get_video_fps';

function al_get_video_scaled_width(video: PALLEGRO_VIDEO): Single; cdecl;
  external cDllName name _PU + 'al_get_video_scaled_width';

function al_get_video_scaled_height(video: PALLEGRO_VIDEO): Single; cdecl;
  external cDllName name _PU + 'al_get_video_scaled_height';

function al_get_video_frame(video: PALLEGRO_VIDEO): PALLEGRO_BITMAP; cdecl;
  external cDllName name _PU + 'al_get_video_frame';

function al_get_video_position(video: PALLEGRO_VIDEO;
  which: ALLEGRO_VIDEO_POSITION_TYPE): Double; cdecl;
  external cDllName name _PU + 'al_get_video_position';

function al_seek_video(video: PALLEGRO_VIDEO; pos_in_seconds: Double): Boolean;
  cdecl; external cDllName name _PU + 'al_seek_video';

function al_init_video_addon(): Boolean; cdecl;
  external cDllName name _PU + 'al_init_video_addon';

function al_is_video_addon_initialized(): Boolean; cdecl;
  external cDllName name _PU + 'al_is_video_addon_initialized';

procedure al_shutdown_video_addon(); cdecl;
  external cDllName name _PU + 'al_shutdown_video_addon';

function al_get_allegro_video_version(): UInt32; cdecl;
  external cDllName name _PU + 'al_get_allegro_video_version';

function al_get_win_window_handle(display: PALLEGRO_DISPLAY): HWND; cdecl;
  external cDllName name _PU + 'al_get_win_window_handle';

type

  PLRESULT = ^LRESULT;
  al_win_add_window_callback_callback = function(display: PALLEGRO_DISPLAY;
    &message: UINT; wparam: wparam; lparam: lparam; result: PLRESULT;
    userdata: Pointer): Boolean; cdecl;

function al_win_add_window_callback(display: PALLEGRO_DISPLAY;
  callback: al_win_add_window_callback_callback; userdata: Pointer): Boolean;
  cdecl; external cDllName name _PU + 'al_win_add_window_callback';

type
  al_win_remove_window_callback_callback = function(display: PALLEGRO_DISPLAY;
    &message: UINT; wparam: wparam; lparam: lparam; result: PLRESULT;
    userdata: Pointer): Boolean; cdecl;

function al_win_remove_window_callback(display: PALLEGRO_DISPLAY;
  callback: al_win_remove_window_callback_callback; userdata: Pointer): Boolean;
  cdecl; external cDllName name _PU + 'al_win_remove_window_callback';

function al_init: LongBool; cdecl;

{ physfs.h }
function PHYSFS_init(argv0: PUTF8Char): LongBool; cdecl;
  external cDllName name _PU + 'PHYSFS_init';

function PHYSFS_isInit: LongBool; cdecl;
  external cDllName name _PU + 'PHYSFS_isInit';

function PHYSFS_deinit: LongBool; cdecl;
  external cDllName name _PU + 'PHYSFS_deinit';

function PHYSFS_mount(newDir: PUTF8Char; mountPoint: PUTF8Char;
  appendToPath: LongBool): LongBool; cdecl;
  external cDllName name _PU + 'PHYSFS_mount';

function PHYSFS_getMountPoint(const dir: PUTF8Char): PUTF8Char; cdecl;
  external cDllName name _PU + 'PHYSFS_getMountPoint';

function PHYSFS_unmount(const oldDir: PUTF8Char): LongBool; cdecl;
  external cDllName name _PU + 'PHYSFS_unmount';

implementation

function al_init: LongBool;
begin
  result := al_install_system(ALLEGRO_VERSION_INT, nil);
end;

end.

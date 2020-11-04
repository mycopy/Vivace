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

unit Vivace.Lua.API;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Common;

const

  // basic types
  LUA_TNONE = -1;
  LUA_TNIL = 0;
  LUA_TBOOLEAN = 1;
  LUA_TLIGHTUSERDATA = 2;
  LUA_TNUMBER = 3;
  LUA_TSTRING = 4;
  LUA_TTABLE = 5;
  LUA_TFUNCTION = 6;
  LUA_TUSERDATA = 7;
  LUA_TTHREAD = 8;

  // minimum Lua stack available to a C function
  LUA_MINSTACK = 20;

  // option for multiple returns in `lua_pcall' and `lua_call'
  LUA_MULTRET = -1;

  // pseudo-indices
  LUA_REGISTRYINDEX = -10000;
  LUA_ENVIRONINDEX = -10001;
  LUA_GLOBALSINDEX = -10002;

  // thread status;
  LUA_OK = 0;
  LUA_YIELD_ = 1;
  LUA_ERRRUN = 2;
  LUA_ERRSYNTAX = 3;
  LUA_ERRMEM = 4;
  LUA_ERRERR = 5;

  LUA_GCSTOP = 0;
  LUA_GCRESTART = 1;
  LUA_GCCOLLECT = 2;
  LUA_GCCOUNT = 3;
  LUA_GCCOUNTB = 4;
  LUA_GCSTEP = 5;
  LUA_GCSETPAUSE = 6;
  LUA_GCSETSTEPMUL = 7;

type
  { TLuaCFunction }
  TLuaCFunction = function(aState: Pointer): Integer; cdecl;

  { TLuaWriter }
  TLuaWriter = function(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
    aData: Pointer): Integer; cdecl;

  { TLuaReader }
  TLuaReader = function(aState: Pointer; aData: Pointer;
     aSize: PNativeUInt): PAnsiChar; cdecl;


function lua_gc(aState: Pointer; aWhat: Integer; aData: Integer): Integer;
  cdecl; external cDllName name 'lua_gc';

function lua_gettop(aState: Pointer): Integer; cdecl;
   external cDllName name 'lua_gettop';

procedure lua_settop(aState: Pointer; aIndex: Integer); cdecl;
  external cDllName name 'lua_settop';

procedure lua_pushvalue(aState: Pointer; aIndex: Integer); cdecl;
  external cDllName name 'lua_pushvalue';

procedure lua_call(aState: Pointer; aNumArgs, aNumResults: Integer); cdecl;
  external cDllName name 'lua_call';

function lua_pcall(aState: Pointer; aNumArgs, aNumResults,
  errfunc: Integer): Integer; cdecl; external cDllName name 'lua_pcall';

function lua_tonumber(aState: Pointer; aIndex: Integer): Double; cdecl;
  external cDllName name 'lua_tonumber';

function lua_tointeger(aState: Pointer; aIndex: Integer): Integer; cdecl;
  external cDllName name 'lua_tointeger';

function lua_toboolean(aState: Pointer; aIndex: Integer): LongBool; cdecl;
  external cDllName name 'lua_toboolean';

function lua_tolstring(aState: Pointer; aIndex: Integer;
  len: PNativeUInt): PAnsiChar; cdecl;
  external cDllName name 'lua_tolstring';

function lua_touserdata(aState: Pointer; aIndex: Integer): Pointer; cdecl;
  external cDllName name 'lua_touserdata';

function lua_topointer(aState: Pointer; aIndex: Integer): Pointer; cdecl;
  external cDllName name 'lua_topointer';

procedure lua_close(aState: Pointer); cdecl;
  external cDllName name 'lua_close';

function lua_type(aState: Pointer; aIndex: Integer): Integer; cdecl;
  external cDllName name 'lua_type';

function lua_iscfunction(aState: Pointer; aIndex: Integer): LongBool; cdecl;
  external cDllName name 'lua_iscfunction';

procedure lua_pushnil(aState: Pointer); cdecl;
  external cDllName name 'lua_pushnil';

procedure lua_pushnumber(aState: Pointer; n: Double); cdecl;
  external cDllName name 'lua_pushnumber';

procedure lua_pushinteger(aState: Pointer; n: Integer); cdecl;
  external cDllName name 'lua_pushinteger';

procedure lua_pushlstring(aState: Pointer; const aStr: PAnsiChar;
  aLen: NativeUInt); cdecl; external cDllName name 'lua_pushlstring';

procedure lua_pushstring(aState: Pointer; const aStr: PAnsiChar);
  cdecl; external cDllName name 'lua_pushstring';

procedure lua_pushcclosure(aState: Pointer; aFuncn: TLuaCFunction;
  aCount: Integer); cdecl; external cDllName name 'lua_pushcclosure';

procedure lua_pushboolean(L: Pointer; b: LongBool); cdecl;
  external cDllName name 'lua_pushboolean';

procedure lua_pushlightuserdata(aState: Pointer; aData: Pointer); cdecl;
  external cDllName name 'lua_pushlightuserdata';

procedure lua_createtable(aState: Pointer; narr, nrec: Integer); cdecl;
  external cDllName name 'lua_createtable';

procedure lua_setfield(aState: Pointer; aIndex: Integer;
  const aName: PAnsiChar); cdecl; external cDllName name 'lua_setfield';

procedure lua_getfield(aState: Pointer; aIndex: Integer; aName: PAnsiChar);
  cdecl; external cDllName name 'lua_getfield';

function lua_dump(aState: Pointer; aWriter: TLuaWriter;
  aData: Pointer): Integer; cdecl; external cDllName name 'lua_dump';

procedure lua_rawset(aState: Pointer; aIndex: Integer); cdecl;
  external cDllName name 'lua_rawset';

function lua_load(aState: Pointer; aReader: TLuaReader; aData: Pointer;
  aChunkName: PAnsiChar): Integer; cdecl; external cDllName name 'lua_load';

function luaL_error(aState: Pointer; const aFormat: PAnsiChar): Integer;
  varargs; cdecl; external cDllName name 'luaL_error';

function luaL_newstate: Pointer; cdecl;
  external cDllName name 'luaL_newstate';

procedure luaL_openlibs(aState: Pointer); cdecl;
  external cDllName name 'luaL_openlibs';

function luaL_loadfile(aState: Pointer; const filename: PAnsiChar): Integer;
  cdecl; external cDllName name 'luaL_loadfile';

function luaL_loadstring(aState: Pointer; const aStr: PAnsiChar): Integer;
  cdecl; external cDllName name 'luaL_loadstring';

function luaL_loadbuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aName: PAnsiChar): Integer; cdecl; external cDllName name 'luaL_loadbuffer';

// macros
function lua_isfunction(aState: Pointer; n: Integer): Boolean; inline;

function lua_isvariable(aState: Pointer; n: Integer): Boolean; inline;

procedure lua_newtable(aState: Pointer); inline;

procedure lua_pop(aState: Pointer; n: Integer); inline;

procedure lua_getglobal(aState: Pointer; aName: PAnsiChar); inline;

procedure lua_setglobal(aState: Pointer; aName: PAnsiChar); inline;

procedure lua_pushcfunction(aState: Pointer; aFunc: TLuaCFunction); inline;

procedure lua_register(aState: Pointer; aName: PAnsiChar;
  aFunc: TLuaCFunction); inline;

function lua_isnil(aState: Pointer; n: Integer): Boolean; inline;

function lua_tostring(aState: Pointer; idx: Integer): string; inline;

function luaL_dofile(aState: Pointer; aFilename: PAnsiChar): Integer; inline;

function luaL_dostring(aState: Pointer; aStr: PAnsiChar): Integer; inline;

function luaL_dobuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aName: PAnsiChar): Integer; inline;

function lua_upvalueindex(i: Integer): Integer; inline;

implementation

// macros
function lua_isfunction(aState: Pointer; n: Integer): Boolean; inline;
begin
  Result := Boolean(lua_type(aState, n) = LUA_TFUNCTION);
end;

function lua_isvariable(aState: Pointer; n: Integer): Boolean; inline;
var
  aType: Integer;
begin
  aType := lua_type(aState, n);

  if (aType = LUA_TBOOLEAN) or (aType = LUA_TLIGHTUSERDATA) or
    (aType = LUA_TNUMBER) or (aType = LUA_TSTRING) then
    Result := True
  else
    Result := False;
end;

procedure lua_newtable(aState: Pointer); inline;
begin
  lua_createtable(aState, 0, 0);
end;

procedure lua_pop(aState: Pointer; n: Integer); inline;
begin
  lua_settop(aState, -n - 1);
end;

procedure lua_getglobal(aState: Pointer; aName: PAnsiChar); inline;
begin
  lua_getfield(aState, LUA_GLOBALSINDEX, aName);
end;

procedure lua_setglobal(aState: Pointer; aName: PAnsiChar); inline;
begin
  lua_setfield(aState, LUA_GLOBALSINDEX, aName);
end;

procedure lua_pushcfunction(aState: Pointer; aFunc: TLuaCFunction); inline;
begin
  lua_pushcclosure(aState, aFunc, 0);
end;

procedure lua_register(aState: Pointer; aName: PAnsiChar;
  aFunc: TLuaCFunction); inline;
begin
  lua_pushcfunction(aState, aFunc);
  lua_setglobal(aState, aName);
end;

function lua_isnil(aState: Pointer; n: Integer): Boolean; inline;
begin
  Result := Boolean(lua_type(aState, n) = LUA_TNIL);
end;

function lua_tostring(aState: Pointer; idx: Integer): string; inline;
begin
  Result := string(lua_tolstring(aState, idx, nil));
end;

function luaL_dofile(aState: Pointer; aFilename: PAnsiChar): Integer; inline;
Var
  Res: Integer;
begin
  Res := luaL_loadfile(aState, aFilename);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function luaL_dostring(aState: Pointer; aStr: PAnsiChar): Integer; inline;
Var
  Res: Integer;
begin
  Res := luaL_loadstring(aState, aStr);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function luaL_dobuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aName: PAnsiChar): Integer; inline;
var
  Res: Integer;
begin
  Res := luaL_loadbuffer(aState, aBuffer, aSize, aName);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function lua_upvalueindex(i: Integer): Integer; inline;
begin
  Result := LUA_GLOBALSINDEX - i;
end;

end.

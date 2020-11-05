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

unit Vivace.Lua;

{$I Vivace.Defines.inc}

interface

uses
  System.Generics.Defaults,
  System.SysUtils,
  System.Classes,
  System.Rtti,
  Vivace.Common;


type

  { TViLuaType }
  TViLuaType = (ltNone = -1, ltNil = 0, ltBoolean = 1, ltLightUserData = 2,
    ltNumber = 3, ltString = 4, ltTable = 5, ltFunction = 6, ltUserData = 7,
    ltThread = 8);

  { TViLuaTable }
  TViLuaTable = (LuaTable);

  { TViLuaValueType }
  TViLuaValueType = (vtInteger, vtDouble, vtString, vtTable, vtPointer,
    vtBoolean);

  { TViLuaValue }
  TViLuaValue = record
    AsType: TViLuaValueType;
    class operator Implicit(const aValue: Integer): TViLuaValue;
    class operator Implicit(aValue: Double): TViLuaValue;
    class operator Implicit(aValue: PChar): TViLuaValue;
    class operator Implicit(aValue: TViLuaTable): TViLuaValue;
    class operator Implicit(aValue: Pointer): TViLuaValue;
    class operator Implicit(aValue: Boolean): TViLuaValue;

    class operator Implicit(aValue: TViLuaValue): Integer;
    class operator Implicit(aValue: TViLuaValue): Double;
    class operator Implicit(aValue: TViLuaValue): PChar;
    class operator Implicit(aValue: TViLuaValue): Pointer;
    class operator Implicit(aValue: TViLuaValue): Boolean;

    case Integer of
      0: (AsInteger: Integer);
      1: (AsNumber: Double);
      2: (AsString: PChar);
      3: (AsTable: TViLuaTable);
      4: (AsPointer: Pointer);
      5: (AsBoolean: Boolean);
  end;

  { IViLuaContext }
  IViLuaContext = interface
    ['{6AEC306C-45BC-4C65-A0E1-044739DED1EB}']

    function ArgCount: Integer;

    function PushCount: Integer;

    procedure ClearStack;

    procedure PopStack(aCount: Integer);

    function GetStackType(aIndex: Integer): TViLuaType;

    function GetValue(aType: TViLuaValueType; aIndex: Integer): TViLuaValue;

    procedure PushValue(aValue: TViLuaValue);

    procedure SetTableFieldValue(aName: string; aValue: TViLuaValue;
      aIndex: Integer);

    function GetTableFieldValue(aName: string; aType: TViLuaValueType;
      aIndex: Integer): TViLuaValue;

  end;

  { TViLuaFunction }
  TViLuaFunction = procedure(aLua: IViLuaContext) of object;

  { IViLua }
  IViLua = interface
    ['{671FAB20-00F2-4C81-96A6-6F675A37D00B}']

    procedure Reset;

    procedure LoadFile(aFilename: string; aAutoRun: Boolean = True);

    procedure LoadString(aData: string; aAutoRun: Boolean = True);

    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt;
      aAutoRun: Boolean = True);

    procedure Run;

    function RoutineExist(aName: string): Boolean;

    function Call(aName: string;
      const aParams: array of TViLuaValue): TViLuaValue;

    function VariableExist(aName: string): Boolean;

    procedure SetVariable(aName: string; aValue: TViLuaValue);

    function GetVariable(aName: string; aType: TViLuaValueType): TViLuaValue;

    procedure RegisterRoutine(aName: string; aData: Pointer;
      aCode: Pointer); overload;

    procedure RegisterRoutine(aName: string;
      aRoutine: TViLuaFunction); overload;

    procedure RegisterRoutines(aClass: TClass); overload;

    procedure RegisterRoutines(aObject: TObject); overload;

    procedure RegisterRoutines(aTables: string; aClass: TClass;
      aTableName: string = ''); overload;

    procedure RegisterRoutines(aTables: string; aObject: TObject;
      aTableName: string = ''); overload;

  end;

  { Forwards }
  TViLua = class;
  TViLuaContext = class;

  { EViLuaException }
  EViLuaException = class(Exception);

  { EViLuaRuntimeException }
  EViLuaRuntimeException = class(Exception);

  { EViLuaSyntaxError }
  EViLuaSyntaxError = class(Exception);

  { TViLuaContext }
  TViLuaContext = class(TSingletonImplementation, IViLuaContext)
  protected
    FLua: TViLua;
    FPushCount: Integer;
    FPushFlag: Boolean;

    procedure Setup;

    procedure Check;

    procedure IncStackPushCount;

    procedure Cleanup;

    function PushTableForSet(aName: array of string; aIndex: Integer;
      var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;

    function PushTableForGet(aName: array of string; aIndex: Integer;
      var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;

  public
    constructor Create(aLua: TViLua);

    destructor Destroy; override;

    function ArgCount: Integer;

    function PushCount: Integer;

    procedure ClearStack;

    procedure PopStack(aCount: Integer);

    function GetStackType(aIndex: Integer): TViLuaType;

    function GetValue(aType: TViLuaValueType;
      aIndex: Integer): TViLuaValue; overload;

    procedure PushValue(aValue: TViLuaValue); overload;

    procedure SetTableFieldValue(aName: string; aValue: TViLuaValue;
      aIndex: Integer); overload;

    function GetTableFieldValue(aName: string; aType: TViLuaValueType;
      aIndex: Integer): TViLuaValue; overload;

    procedure SetTableIndexValue(aName: string; aValue: TViLuaValue;
      aIndex: Integer; aKey: Integer);

    procedure GetTableIndexValue(aName: string; aType: TViLuaValueType;
      aIndex: Integer; aKey: Integer);

  end;


  { TViLua }
  TViLua = class(TSingletonImplementation, IViLua)
  public
    FState: Pointer;
    FContext: TViLuaContext;
    FGCStep: Integer;

    procedure Open;

    procedure Close;

    procedure CheckLuaError(const r: Integer);

    function PushGlobalTableForSet(aName: array of string;
      var aIndex: Integer): Boolean;

    function PushGlobalTableForGet(aName: array of string;
      var aIndex: Integer): Boolean;

    procedure PushTValue(aValue: TValue);

    function CallFunction(const aParams: array of TValue): TValue;

    procedure SaveByteCode(aStream: TStream);

    procedure LoadByteCode(aStream: TStream; aName: string;
      aAutoRun: Boolean = True);

    procedure CompileToStream(aFilename: string; aStream: TStream;
      aCleanOutput: Boolean);

    procedure Bundle(aInFilename: string; aOutFilename: string);

    procedure PushLuaValue(aValue: TViLuaValue);

    function GetLuaValue(aIndex: Integer): TViLuaValue;

    function DoCall(const aParams: array of TViLuaValue): TViLuaValue;

    procedure CleanStack;

    property State: Pointer read FState;

    property Context: TViLuaContext read FContext;

  public
    constructor Create; virtual;

    destructor Destroy; override;

    procedure LoadStream(aStream: TStream; aSize: NativeUInt = 0;
      aAutoRun: Boolean = True);

    procedure Reset;

    procedure LoadFile(aFilename: string; aAutoRun: Boolean = True);

    procedure LoadString(aData: string; aAutoRun: Boolean = True);

    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt;
      aAutoRun: Boolean = True);

    function Call(aName: string; const aParams: array of TViLuaValue): TViLuaValue;

    function RoutineExist(aName: string): Boolean;

    procedure Run;

    function VariableExist(aName: string): Boolean;

    procedure SetVariable(aName: string; aValue: TViLuaValue);

    function GetVariable(aName: string; aType: TViLuaValueType): TViLuaValue;

    procedure RegisterRoutine(aName: string; aData: Pointer;
      aCode: Pointer); overload;

    procedure RegisterRoutine(aName: string;
      aRoutine: TViLuaFunction); overload;

    procedure RegisterRoutines(aClass: TClass); overload;

    procedure RegisterRoutines(aObject: TObject); overload;

    procedure RegisterRoutines(aTables: string; aClass: TClass;
      aTableName: string = ''); overload;

    procedure RegisterRoutines(aTables: string; aObject: TObject;
      aTableName: string = ''); overload;

    procedure SetGCStepSize(aStep: Integer);

    function GetGCStepSize: Integer;

    function GetGCMemoryUsed: Integer;

    procedure CollectGarbage;
  end;

implementation

uses
  System.IOUtils,
  System.TypInfo,
  Vivace.Lua.API;

const
  cLuaExt = 'lua';
  cLuacExt = 'luac';
  cLuaAutoSetup = 'AutoSetup';

function LuaWrapperClosure(aState: Pointer): Integer; cdecl;
var
  method: TMethod;
  closure: TViLuaFunction absolute method;
  lua: TViLua;
begin
  // get lua object
  lua := lua_touserdata(aState, lua_upvalueindex(1));

  // get lua class routine
  method.Code := lua_touserdata(aState, lua_upvalueindex(2));
  method.Data := lua_touserdata(aState, lua_upvalueindex(3));

  // init the context
  lua.Context.Setup;

  // call class routines
  closure(lua.Context);

  // return result count
  Result := lua.Context.PushCount;

  // clean up stack
  lua.Context.Cleanup;
end;

function LuaWrapperWriter(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aData: Pointer): Integer; cdecl;
var
  stream: TStream;
begin
  stream := TStream(aData);
  try
    stream.WriteBuffer(aBuffer^, aSize);
    Result := 0;
  except
    on E: EStreamError do
      Result := 1;
  end;
end;

{ --------------------------------------------------------------------------- }
const
  cLoader_luac: array [1 .. 200] of Byte = ($1B, $4C, $4A, $02, $02, $87, $01,
    $00, $01, $04, $01, $03, $00, $16, $2D, $01, $00, $00, $38, $01, $00, $01,
    $0B, $01, $00, $00, $58, $01, $05, $80, $2D, $01, $00, $00, $36, $02, $00,
    $00, $12, $03, $00, $00, $42, $02, $02, $02, $3C, $02, $00, $01, $2D, $01,
    $00, $00, $38, $01, $00, $01, $0A, $01, $00, $00, $58, $01, $03, $80, $2D,
    $01, $00, $00, $38, $01, $00, $01, $44, $01, $01, $00, $36, $01, $01, $00,
    $27, $02, $02, $00, $12, $03, $00, $00, $26, $02, $03, $02, $42, $01, $02,
    $01, $4B, $00, $01, $00, $00, $C0, $1B, $46, $61, $69, $6C, $65, $64, $20,
    $74, $6F, $20, $6C, $6F, $61, $64, $20, $73, $63, $72, $69, $70, $74, $20,
    $0A, $65, $72, $72, $6F, $72, $0D, $6C, $6F, $61, $64, $66, $69, $6C, $65,
    $23, $01, $00, $02, $00, $02, $00, $05, $34, $00, $00, $00, $33, $01, $00,
    $00, $37, $01, $01, $00, $32, $00, $00, $80, $4B, $00, $01, $00, $0B, $69,
    $6D, $70, $6F, $72, $74, $00, $14, $03, $00, $01, $00, $01, $00, $03, $33,
    $00, $00, $00, $42, $00, $01, $01, $4B, $00, $01, $00, $00, $00);

const
  cLuabundle_luac: array [1 .. 1834] of Byte = ($1B, $4C, $4A, $02, $02, $75,
    $00, $01, $09, $03, $04, $00, $11, $2D, $01, $00, $00, $12, $02, $00, $00,
    $42, $01, $02, $02, $2D, $02, $01, $00, $39, $03, $00, $01, $3C, $03, $00,
    $02, $36, $02, $01, $00, $39, $03, $02, $01, $42, $02, $02, $04, $48, $05,
    $04, $80, $2D, $07, $02, $00, $39, $07, $03, $07, $12, $08, $06, $00, $42,
    $07, $02, $01, $46, $05, $03, $03, $52, $05, $FA, $7F, $4B, $00, $01, $00,
    $00, $00, $02, $C0, $01, $C0, $11, $70, $72, $6F, $63, $65, $73, $73, $5F,
    $66, $69, $6C, $65, $0D, $69, $6E, $63, $6C, $75, $64, $65, $73, $0A, $70,
    $61, $69, $72, $73, $0C, $63, $6F, $6E, $74, $65, $6E, $74, $C1, $04, $00,
    $01, $0B, $02, $14, $00, $56, $36, $01, $00, $00, $39, $01, $01, $01, $12,
    $02, $00, $00, $27, $03, $02, $00, $42, $01, $03, $02, $12, $03, $01, $00,
    $39, $02, $03, $01, $27, $04, $04, $00, $42, $02, $03, $01, $12, $03, $01,
    $00, $39, $02, $03, $01, $27, $04, $05, $00, $42, $02, $03, $01, $34, $02,
    $00, $00, $36, $03, $06, $00, $2D, $04, $00, $00, $42, $03, $02, $04, $48,
    $06, $05, $80, $36, $08, $07, $00, $39, $08, $08, $08, $12, $09, $02, $00,
    $12, $0A, $06, $00, $42, $08, $03, $01, $46, $06, $03, $03, $52, $06, $F9,
    $7F, $36, $03, $07, $00, $39, $03, $09, $03, $12, $04, $02, $00, $42, $03,
    $02, $01, $36, $03, $06, $00, $12, $04, $02, $00, $42, $03, $02, $04, $48,
    $06, $15, $80, $12, $09, $01, $00, $39, $08, $03, $01, $27, $0A, $0A, $00,
    $42, $08, $03, $01, $12, $09, $01, $00, $39, $08, $03, $01, $12, $0A, $07,
    $00, $42, $08, $03, $01, $12, $09, $01, $00, $39, $08, $03, $01, $27, $0A,
    $0B, $00, $42, $08, $03, $01, $12, $09, $01, $00, $39, $08, $03, $01, $2D,
    $0A, $00, $00, $38, $0A, $07, $0A, $42, $08, $03, $01, $12, $09, $01, $00,
    $39, $08, $03, $01, $27, $0A, $0C, $00, $42, $08, $03, $01, $46, $06, $03,
    $03, $52, $06, $E9, $7F, $12, $04, $01, $00, $39, $03, $03, $01, $27, $05,
    $0D, $00, $42, $03, $03, $01, $12, $04, $01, $00, $39, $03, $03, $01, $27,
    $05, $0E, $00, $42, $03, $03, $01, $12, $04, $01, $00, $39, $03, $03, $01,
    $27, $05, $0C, $00, $42, $03, $03, $01, $12, $04, $01, $00, $39, $03, $03,
    $01, $27, $05, $0F, $00, $2D, $06, $01, $00, $27, $07, $10, $00, $26, $05,
    $07, $05, $42, $03, $03, $01, $12, $04, $01, $00, $39, $03, $03, $01, $27,
    $05, $11, $00, $42, $03, $03, $01, $12, $04, $01, $00, $39, $03, $12, $01,
    $42, $03, $02, $01, $12, $04, $01, $00, $39, $03, $13, $01, $42, $03, $02,
    $01, $4B, $00, $01, $00, $02, $C0, $00, $C0, $0A, $63, $6C, $6F, $73, $65,
    $0A, $66, $6C, $75, $73, $68, $10, $65, $6E, $64, $29, $28, $7B, $2E, $2E,
    $2E, $7D, $29, $08, $27, $29, $0A, $1B, $6C, $6F, $63, $61, $6C, $20, $65,
    $6E, $74, $72, $79, $20, $3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $27,
    $2B, $72, $65, $74, $75, $72, $6E, $20, $6D, $6F, $64, $75, $6C, $65, $73,
    $5B, $6E, $5D, $28, $74, $61, $62, $6C, $65, $2E, $75, $6E, $70, $61, $63,
    $6B, $28, $61, $72, $67, $73, $29, $29, $0A, $18, $66, $75, $6E, $63, $74,
    $69, $6F, $6E, $20, $69, $6D, $70, $6F, $72, $74, $28, $6E, $29, $0A, $09,
    $65, $6E, $64, $0A, $18, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74,
    $69, $6F, $6E, $28, $2E, $2E, $2E, $29, $0A, $0E, $6D, $6F, $64, $75, $6C,
    $65, $73, $5B, $27, $09, $73, $6F, $72, $74, $0B, $69, $6E, $73, $65, $72,
    $74, $0A, $74, $61, $62, $6C, $65, $0A, $70, $61, $69, $72, $73, $18, $6C,
    $6F, $63, $61, $6C, $20, $6D, $6F, $64, $75, $6C, $65, $73, $20, $3D, $20,
    $7B, $7D, $0A, $15, $28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $61,
    $72, $67, $73, $29, $0A, $0A, $77, $72, $69, $74, $65, $06, $77, $09, $6F,
    $70, $65, $6E, $07, $69, $6F, $45, $01, $01, $04, $01, $04, $00, $08, $34,
    $01, $00, $00, $34, $02, $00, $00, $33, $03, $01, $00, $3D, $03, $00, $01,
    $33, $03, $03, $00, $3D, $03, $02, $01, $32, $00, $00, $80, $4C, $01, $02,
    $00, $00, $C0, $00, $11, $62, $75, $69, $6C, $64, $5F, $62, $75, $6E, $64,
    $6C, $65, $00, $11, $70, $72, $6F, $63, $65, $73, $73, $5F, $66, $69, $6C,
    $65, $3D, $03, $00, $02, $00, $03, $00, $06, $36, $00, $00, $00, $27, $01,
    $01, $00, $42, $00, $02, $02, $33, $01, $02, $00, $32, $00, $00, $80, $4C,
    $01, $02, $00, $00, $1A, $61, $70, $70, $2F, $73, $6F, $75, $72, $63, $65,
    $5F, $70, $61, $72, $73, $65, $72, $2E, $6C, $75, $61, $0B, $69, $6D, $70,
    $6F, $72, $74, $EA, $01, $00, $01, $07, $01, $08, $02, $23, $15, $01, $00,
    $00, $09, $01, $00, $00, $58, $01, $0A, $80, $3A, $01, $01, $00, $07, $01,
    $00, $00, $58, $01, $07, $80, $36, $01, $01, $00, $27, $02, $02, $00, $42,
    $01, $02, $01, $36, $01, $03, $00, $39, $01, $04, $01, $42, $01, $01, $01,
    $58, $01, $09, $80, $15, $01, $00, $00, $08, $01, $01, $00, $58, $01, $06,
    $80, $36, $01, $01, $00, $27, $02, $05, $00, $42, $01, $02, $01, $36, $01,
    $03, $00, $39, $01, $04, $01, $42, $01, $01, $01, $3A, $01, $01, $00, $3A,
    $02, $02, $00, $2D, $03, $00, $00, $12, $04, $01, $00, $42, $03, $02, $02,
    $39, $04, $06, $03, $12, $05, $01, $00, $12, $06, $03, $00, $42, $04, $03,
    $01, $39, $04, $07, $03, $12, $05, $02, $00, $42, $04, $02, $01, $4B, $00,
    $01, $00, $00, $C0, $11, $62, $75, $69, $6C, $64, $5F, $62, $75, $6E, $64,
    $6C, $65, $11, $70, $72, $6F, $63, $65, $73, $73, $5F, $66, $69, $6C, $65,
    $1C, $75, $73, $61, $67, $65, $3A, $20, $6C, $75, $61, $62, $75, $6E, $64,
    $6C, $65, $20, $69, $6E, $20, $6F, $75, $74, $09, $65, $78, $69, $74, $07,
    $6F, $73, $14, $6C, $75, $61, $62, $75, $6E, $64, $6C, $65, $20, $76, $30,
    $2E, $30, $31, $0A, $70, $72, $69, $6E, $74, $07, $2D, $76, $02, $04, $3E,
    $03, $00, $02, $00, $03, $00, $06, $36, $00, $00, $00, $27, $01, $01, $00,
    $42, $00, $02, $02, $33, $01, $02, $00, $32, $00, $00, $80, $4C, $01, $02,
    $00, $00, $1B, $61, $70, $70, $2F, $62, $75, $6E, $64, $6C, $65, $5F, $6D,
    $61, $6E, $61, $67, $65, $72, $2E, $6C, $75, $61, $0B, $69, $6D, $70, $6F,
    $72, $74, $B7, $02, $00, $01, $0B, $00, $11, $00, $2B, $36, $01, $00, $00,
    $39, $01, $01, $01, $12, $02, $00, $00, $27, $03, $02, $00, $42, $01, $03,
    $02, $0B, $01, $00, $00, $58, $02, $05, $80, $36, $02, $03, $00, $27, $03,
    $04, $00, $12, $04, $00, $00, $26, $03, $04, $03, $42, $02, $02, $01, $12,
    $03, $01, $00, $39, $02, $05, $01, $27, $04, $06, $00, $42, $02, $03, $02,
    $12, $04, $01, $00, $39, $03, $07, $01, $42, $03, $02, $01, $34, $03, $00,
    $00, $36, $04, $08, $00, $39, $04, $09, $04, $12, $05, $02, $00, $27, $06,
    $0A, $00, $42, $04, $03, $04, $58, $07, $05, $80, $36, $08, $0B, $00, $39,
    $08, $0C, $08, $12, $09, $03, $00, $12, $0A, $07, $00, $42, $08, $03, $01,
    $45, $07, $03, $02, $52, $07, $F9, $7F, $34, $04, $00, $00, $37, $04, $0D,
    $00, $36, $04, $0D, $00, $3D, $00, $0E, $04, $36, $04, $0D, $00, $3D, $02,
    $0F, $04, $36, $04, $0D, $00, $3D, $03, $10, $04, $36, $04, $0D, $00, $4C,
    $04, $02, $00, $0D, $69, $6E, $63, $6C, $75, $64, $65, $73, $0C, $63, $6F,
    $6E, $74, $65, $6E, $74, $0D, $66, $69, $6C, $65, $6E, $61, $6D, $65, $09,
    $73, $65, $6C, $66, $0B, $69, $6E, $73, $65, $72, $74, $0A, $74, $61, $62,
    $6C, $65, $1F, $69, $6D, $70, $6F, $72, $74, $25, $28, $5B, $22, $27, $5D,
    $28, $5B, $5E, $27, $22, $5D, $2D, $29, $5B, $22, $27, $5D, $25, $29, $0B,
    $67, $6D, $61, $74, $63, $68, $0B, $73, $74, $72, $69, $6E, $67, $0A, $63,
    $6C, $6F, $73, $65, $07, $2A, $61, $09, $72, $65, $61, $64, $15, $46, $69,
    $6C, $65, $20, $6E, $6F, $74, $20, $66, $6F, $75, $6E, $64, $3A, $20, $0A,
    $65, $72, $72, $6F, $72, $06, $72, $09, $6F, $70, $65, $6E, $07, $69, $6F,
    $14, $03, $00, $01, $00, $01, $00, $03, $33, $00, $00, $00, $32, $00, $00,
    $80, $4C, $00, $02, $00, $00, $74, $02, $00, $03, $00, $04, $01, $0F, $34,
    $00, $03, $00, $47, $01, $00, $00, $3F, $01, $00, $00, $36, $01, $00, $00,
    $0B, $01, $00, $00, $58, $01, $03, $80, $36, $01, $01, $00, $27, $02, $02,
    $00, $42, $01, $02, $01, $36, $01, $00, $00, $27, $02, $03, $00, $42, $01,
    $02, $02, $12, $02, $00, $00, $42, $01, $02, $01, $4B, $00, $01, $00, $11,
    $61, $70, $70, $2F, $6D, $61, $69, $6E, $2E, $6C, $75, $61, $14, $75, $74,
    $69, $6C, $2F, $6C, $6F, $61, $64, $65, $72, $2E, $6C, $75, $61, $0B, $64,
    $6F, $66, $69, $6C, $65, $0B, $69, $6D, $70, $6F, $72, $74, $03, $80, $80,
    $C0, $99, $04, $34, $00, $01, $04, $02, $02, $00, $07, $2D, $01, $00, $00,
    $38, $01, $00, $01, $36, $02, $00, $00, $39, $02, $01, $02, $2D, $03, $01,
    $00, $42, $02, $02, $00, $43, $01, $00, $00, $01, $C0, $00, $C0, $0B, $75,
    $6E, $70, $61, $63, $6B, $0A, $74, $61, $62, $6C, $65, $9B, $01, $01, $01,
    $04, $00, $0A, $00, $10, $34, $01, $00, $00, $33, $02, $01, $00, $3D, $02,
    $00, $01, $33, $02, $03, $00, $3D, $02, $02, $01, $33, $02, $05, $00, $3D,
    $02, $04, $01, $33, $02, $07, $00, $3D, $02, $06, $01, $33, $02, $08, $00,
    $37, $02, $09, $00, $36, $02, $09, $00, $27, $03, $06, $00, $42, $02, $02,
    $02, $32, $00, $00, $80, $4B, $00, $01, $00, $0B, $69, $6D, $70, $6F, $72,
    $74, $00, $00, $12, $6C, $75, $61, $62, $75, $6E, $64, $6C, $65, $2E, $6C,
    $75, $61, $00, $1A, $61, $70, $70, $2F, $73, $6F, $75, $72, $63, $65, $5F,
    $70, $61, $72, $73, $65, $72, $2E, $6C, $75, $61, $00, $11, $61, $70, $70,
    $2F, $6D, $61, $69, $6E, $2E, $6C, $75, $61, $00, $1B, $61, $70, $70, $2F,
    $62, $75, $6E, $64, $6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72, $2E,
    $6C, $75, $61, $26, $03, $00, $03, $00, $01, $01, $06, $33, $00, $00, $00,
    $34, $01, $03, $00, $47, $02, $00, $00, $3F, $02, $00, $00, $42, $00, $02,
    $01, $4B, $00, $01, $00, $00, $03, $80, $80, $C0, $99, $04, $00);

  { --- Routines -------------------------------------------------------------- }
function ParseTableNames(aNames: string): TStringArray;
var
  Items: TArray<string>;
  i: Integer;
begin
  Items := aNames.Split(['.']);
  SetLength(Result, Length(Items));
  for i := 0 to High(Items) do
  begin
    Result[i] := Items[i];
  end;
end;

{ --- TLuaValue ------------------------------------------------------------- }
class operator TViLuaValue.Implicit(const aValue: Integer): TViLuaValue;
begin
  Result.AsType := vtInteger;
  Result.AsInteger := aValue;
end;

class operator TViLuaValue.Implicit(aValue: Double): TViLuaValue;
begin
  Result.AsType := vtDouble;
  Result.AsNumber := aValue;
end;

class operator TViLuaValue.Implicit(aValue: PChar): TViLuaValue;
begin
  Result.AsType := vtString;
  Result.AsString := aValue;
end;

class operator TViLuaValue.Implicit(aValue: TViLuaTable): TViLuaValue;
begin
  Result.AsType := vtTable;
  Result.AsTable := aValue;
end;

class operator TViLuaValue.Implicit(aValue: Pointer): TViLuaValue;
begin
  Result.AsType := vtPointer;
  Result.AsPointer := aValue;
end;

class operator TViLuaValue.Implicit(aValue: Boolean): TViLuaValue;
begin
  Result.AsType := vtBoolean;
  Result.AsBoolean := aValue;
end;

class operator TViLuaValue.Implicit(aValue: TViLuaValue): Integer;
begin
  Result := aValue.AsInteger;
end;

class operator TViLuaValue.Implicit(aValue: TViLuaValue): Double;
begin
  Result := aValue.AsNumber;
end;

class operator TViLuaValue.Implicit(aValue: TViLuaValue): PChar;
const
{$J+}
  Value: string = '';
{$J-}
begin
  Value := aValue.AsString;
  Result := PChar(Value);
end;

class operator TViLuaValue.Implicit(aValue: TViLuaValue): Pointer;
begin
  Result := aValue.AsPointer
end;

class operator TViLuaValue.Implicit(aValue: TViLuaValue): Boolean;
begin
  Result := aValue.AsBoolean;
end;

{ --- TLuaContext ----------------------------------------------------------- }
procedure TViLuaContext.Setup;
begin
  FPushCount := 0;
  FPushFlag := True;
end;

procedure TViLuaContext.Check;
begin
  if FPushFlag then
  begin
    FPushFlag := False;
    ClearStack;
  end;
end;

procedure TViLuaContext.IncStackPushCount;
begin
  Inc(FPushCount);
end;

procedure TViLuaContext.Cleanup;
begin
  if FPushFlag then
  begin
    ClearStack;
  end;
end;

function TViLuaContext.PushTableForSet(aName: array of string; aIndex: Integer;
  var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
begin
  Result := False;

  // validate name array size
  aStackIndex := Length(aName);
  if aStackIndex < 1 then
    Exit;

  // validate return aStackIndex and aFieldNameIndex
  if Length(aName) = 1 then
    aFieldNameIndex := 0
  else
    aFieldNameIndex := Length(aName) - 1;

  // table does not exist, exit
  if lua_type(FLua.State, aIndex) <> LUA_TTABLE then
    Exit;

  // process sub tables
  for i := 0 to aStackIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FLua.State, 1);

      // push new table
      lua_newtable(FLua.State);

      // set new table a field
      lua_setfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);

      // push field table back on stack
      lua_getfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);
    end;
  end;

  Result := True;
end;

function TViLuaContext.PushTableForGet(aName: array of string; aIndex: Integer;
  var aStackIndex: Integer; var aFieldNameIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
begin
  Result := False;

  // validate name array size
  aStackIndex := Length(aName);
  if aStackIndex < 1 then
    Exit;

  // validate return aStackIndex and aFieldNameIndex
  if aStackIndex = 1 then
    aFieldNameIndex := 0
  else
    aFieldNameIndex := aStackIndex - 1;

  // table does not exist, exit
  if lua_type(FLua.State, aIndex) <> LUA_TTABLE then
    Exit;

  // process sub tables
  for i := 0 to aStackIndex - 2 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, i + aIndex, Marshall.AsAnsi(aName[i]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then
      Exit;
  end;

  Result := True;
end;

constructor TViLuaContext.Create(aLua: TViLua);
begin
  FLua := aLua;
  FPushCount := 0;
  FPushFlag := False;
end;

destructor TViLuaContext.Destroy;
begin
  FLua := nil;
  FPushCount := 0;
  FPushFlag := False;
  inherited;
end;

function TViLuaContext.ArgCount: Integer;
begin
  Result := lua_gettop(FLua.State);
end;

function TViLuaContext.PushCount: Integer;
begin
  Result := FPushCount;
end;

procedure TViLuaContext.ClearStack;
begin
  lua_pop(FLua.State, lua_gettop(FLua.State));
  FPushCount := 0;
  FPushFlag := False;
end;

procedure TViLuaContext.PopStack(aCount: Integer);
begin
  lua_pop(FLua.State, aCount);
end;

function TViLuaContext.GetStackType(aIndex: Integer): TViLuaType;
begin
  Result := TViLuaType(lua_type(FLua.State, aIndex));
end;

function TViLuaContext.GetValue(aType: TViLuaValueType; aIndex: Integer): TViLuaValue;
const
{$J+}
  Str: string = '';
{$J-}
begin
  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FLua.State, aIndex);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FLua.State, aIndex);
      end;
    vtString:
      begin
        Str := lua_tostring(FLua.State, aIndex);
        Result := PChar(Str);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FLua.State, aIndex);
      end;
    vtBoolean:
      begin
        var
          Bool: LongBool := lua_toboolean(FLua.State, aIndex);
        Result := Boolean(Bool);
      end;
  else
    begin

    end;
  end;
end;

procedure TViLuaContext.PushValue(aValue: TViLuaValue);
begin
  Check;

  case aValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FLua.State, aValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FLua.State, aValue);
      end;
    vtString:
      begin
        var
          Marshall: TMarshaller;
        var
          Value: string := aValue.AsString;
        lua_pushstring(FLua.State, Marshall.AsAnsi(Value).ToPointer);
      end;
    vtTable:
      begin
        lua_newtable(FLua.State);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FLua.State, aValue);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := aValue.AsBoolean;
        lua_pushboolean(FLua.State, Value);
      end;
  end;

  IncStackPushCount;
end;

procedure TViLuaContext.SetTableFieldValue(aName: string; aValue: TViLuaValue;
  aIndex: Integer);
var
  Marshall: TMarshaller;
  StackIndex: Integer;
  FieldNameIndex: Integer;
  Items: TStringArray;
  ok: Boolean;
begin
  Items := ParseTableNames(aName);
  if not PushTableForSet(Items, aIndex, StackIndex, FieldNameIndex) then
    Exit;
  ok := True;

  case aValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FLua.State, aValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FLua.State, aValue);
      end;
    vtString:
      begin
        var
          Value: string := aValue.AsString;
        lua_pushstring(FLua.State, Marshall.AsAnsi(Value).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FLua.State, aValue);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := aValue.AsBoolean;
        lua_pushboolean(FLua.State, Value);
      end;
  else
    begin
      ok := False;
    end;
  end;

  if ok then
  begin
    lua_setfield(FLua.State, StackIndex + (aIndex - 1),
      Marshall.AsAnsi(Items[FieldNameIndex]).ToPointer);
  end;

  PopStack(StackIndex);
end;

function TViLuaContext.GetTableFieldValue(aName: string; aType: TViLuaValueType;
  aIndex: Integer): TViLuaValue;
const
{$J+}
  Str: string = '';
{$J-}
var
  Marshall: TMarshaller;
  StackIndex: Integer;
  FieldNameIndex: Integer;
  Items: TStringArray;
  ok: Boolean;
begin
  Items := ParseTableNames(aName);
  if not PushTableForGet(Items, aIndex, StackIndex, FieldNameIndex) then
    Exit;
  lua_getfield(FLua.State, StackIndex + (aIndex - 1),
    Marshall.AsAnsi(Items[FieldNameIndex]).ToPointer);

  ok := True;

  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FLua.State, -1);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FLua.State, -1);
      end;
    vtString:
      begin
        Str := lua_tostring(FLua.State, -1);
        Result := PChar(Str);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FLua.State, -1);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := lua_toboolean(FLua.State, -1);
        Result := Boolean(Value);
      end;
  else
    begin
      ok := False;
    end;
  end;

  PopStack(StackIndex);
end;

procedure TViLuaContext.SetTableIndexValue(aName: string; aValue: TViLuaValue;
  aIndex: Integer; aKey: Integer);
begin

end;

procedure TViLuaContext.GetTableIndexValue(aName: string; aType: TViLuaValueType;
  aIndex: Integer; aKey: Integer);
begin

end;

{ --- TViLua ---------------------------------------------------------------- }
procedure TViLua.Open;
var
  ms: TMemoryStream;
  ls: TStringList;
begin
  if FState <> nil then
    Exit;
  FState := luaL_newstate;
  SetGCStepSize(200);
  luaL_openlibs(FState);
  LoadBuffer(@cLoader_luac, Length(cLoader_luac));
  FContext := TViLuaContext.Create(Self);
  SetVariable('vivace.luaversion', GetVariable('jit.version', vtString));
end;

procedure TViLua.Close;
begin
  if FState = nil then
    Exit;
  FreeAndNil(FContext);
  lua_close(FState);
  FState := nil;
end;

procedure TViLua.CheckLuaError(const r: Integer);
var
  err: string;
begin
  case r of
    // success
    0:
      begin

      end;
    // a runtime error.
    LUA_ERRRUN:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise EViLuaRuntimeException.CreateFmt('Runtime error [%s]', [err]);
      end;
    // memory allocation error. For such errors, Lua does not call the error handler function.
    LUA_ERRMEM:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise EViLuaException.CreateFmt('Memory allocation error [%s]', [err]);
      end;
    // error while running the error handler function.
    LUA_ERRERR:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise EViLuaException.CreateFmt
          ('Error while running the error handler function [%s]', [err]);
      end;
    LUA_ERRSYNTAX:
      begin
        err := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise EViLuaSyntaxError.CreateFmt('Syntax Error [%s]', [err]);
      end
  else
    begin
      err := lua_tostring(FState, -1);
      lua_pop(FState, 1);
      raise EViLuaException.CreateFmt('Unknown Error [%s]', [err]);
    end;
  end;
end;

function TViLua.PushGlobalTableForSet(aName: array of string;
  var aIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
begin
  Result := False;

  if Length(aName) < 2 then
    Exit;

  aIndex := Length(aName) - 1;

  // check if global table exists
  lua_getglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);

  // table does not exist, create new one
  if lua_type(FState, lua_gettop(FState)) <> LUA_TTABLE then
  begin
    // clean up stack
    lua_pop(FState, 1);

    // create new table
    lua_newtable(FState);

    // make it global
    lua_setglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);

    // push global table back on stack
    lua_getglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);
  end;

  // process tables in global table at index 1+
  // global table on stack, process remaining tables
  for i := 1 to aIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FState, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FState, 1);

      // push new table
      lua_newtable(FState);

      // set new table a field
      lua_setfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);

      // push field table back on stack
      lua_getfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);
    end;
  end;

  Result := True;
end;

function TViLua.PushGlobalTableForGet(aName: array of string;
  var aIndex: Integer): Boolean;
var
  Marshall: TMarshaller;
  i: Integer;
begin
  // assume false
  Result := False;

  // check for valid table name count
  if Length(aName) < 2 then
    Exit;

  // init stack index
  aIndex := Length(aName) - 1;

  // lookup global table
  lua_getglobal(FState, Marshall.AsAnsi(aName[0]).ToPointer);

  // check of global table exits
  if lua_type(FState, lua_gettop(FState)) = LUA_TTABLE then
  begin
    // process tables in global table at index 1+
    // global table on stack, process remaining tables
    for i := 1 to aIndex - 1 do
    begin
      // get table at field aIndex[i]
      lua_getfield(FState, i, Marshall.AsAnsi(aName[i]).ToPointer);

      // table field does not exists, exit
      if lua_type(FState, -1) <> LUA_TTABLE then
      begin
        // table name does not exit so we are out of here with an error
        Exit;
      end;
    end;
  end;

  // all table names exits we are good
  Result := True;
end;

procedure TViLua.PushTValue(aValue: TValue);
var
  utf8s: RawByteString;
begin
  case aValue.Kind of
    tkUnknown, tkChar, tkSet, tkMethod, tkVariant, tkArray, tkProcedure,
      tkRecord, tkInterface, tkDynArray, tkClassRef:
      begin
        lua_pushnil(FState);
      end;
    tkInteger:
      lua_pushinteger(FState, aValue.AsInteger);
    tkEnumeration:
      begin
        if aValue.IsType<Boolean> then
        begin
          if aValue.AsBoolean then
            lua_pushboolean(FState, True)
          else
            lua_pushboolean(FState, False);
        end
        else
          lua_pushinteger(FState, aValue.AsInteger);
      end;
    tkFloat:
      lua_pushnumber(FState, aValue.AsExtended);
    tkString, tkWChar, tkLString, tkWString, tkUString:
      begin
        utf8s := UTF8Encode(aValue.AsString);
        lua_pushstring(FState, PAnsiChar(utf8s));
      end;
    tkClass:
      { lua_pushlightuserdata(FState, Pointer(Value.AsObject)) };
    tkInt64:
      lua_pushnumber(FState, aValue.AsInt64);
    tkPointer:
      { lua_pushlightuserdata(FState, Pointer(Value.AsObject)) };
  end;
end;

function TViLua.CallFunction(const aParams: array of TValue): TValue;
var
  p: TValue;
  r: Integer;
begin
  for p in aParams do
    PushTValue(p);
  r := lua_pcall(FState, Length(aParams), 1, 0);
  CheckLuaError(r);
  lua_pop(FState, 1);
  case lua_type(FState, -1) of
    LUA_TNIL:
      begin
        Result := nil;
      end;

    LUA_TBOOLEAN:
      begin
        Result := Boolean(lua_toboolean(FState, -1));
      end;

    LUA_TNUMBER:
      begin
        Result := lua_tonumber(FState, -1);
      end;

    LUA_TSTRING:
      begin
        Result := lua_tostring(FState, -1);
      end;
  else
    Result := nil;
    // ELuaException.Create('Unsupported return type');
  end;
end;

procedure TViLua.Bundle(aInFilename: string; aOutFilename: string);
var
  err: string;
  Res: Integer;
  Marshall: TMarshaller;
begin
  if aInFilename.IsEmpty then
    Exit;
  if aOutFilename.IsEmpty then
    Exit;

  LoadBuffer(@cLuabundle_luac, Length(cLuabundle_luac), False);
  DoCall([PChar(aInFilename), PChar(aOutFilename)]);
end;


constructor TViLua.Create;
begin
  inherited;
  FState := nil;
  Open;
end;

destructor TViLua.Destroy;
begin
  Close;
  inherited;
end;

procedure TViLua.Reset;
begin
  Close;
  Open;
end;

procedure TViLua.LoadFile(aFilename: string; aAutoRun: Boolean);
var
  Marshall: TMarshaller;
  err: string;
  Res: Integer;
  fname: string;
  filename: string;
begin
  filename := aFilename;
  if filename.IsEmpty then
    Exit;

  fname := TPath.ChangeExtension(filename, cLuaExt);

  if not TFile.Exists(fname) then
  begin
    fname := TPath.ChangeExtension(filename, cLuacExt);
    if not TFile.Exists(fname) then
  end;

  if aAutoRun then
    Res := luaL_dofile(FState, Marshall.AsAnsi(fname).ToPointer)
  else
    Res := luaL_loadfile(FState, Marshall.AsAnsi(fname).ToPointer);

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise EViLuaException.Create(err);
  end;
end;

procedure TViLua.LoadString(aData: string; aAutoRun: Boolean);
var
  Marshall: TMarshaller;
  err: string;
  Res: Integer;
  Data: string;
begin
  Data := aData;
  if Data.IsEmpty then
    Exit;

  if aAutoRun then
    Res := luaL_dostring(FState, Marshall.AsAnsi(Data).ToPointer)
  else
    Res := luaL_loadstring(FState, Marshall.AsAnsi(Data).ToPointer);

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise EViLuaException.Create(err);
  end;
end;

procedure TViLua.LoadStream(aStream: TStream; aSize: NativeUInt;
  aAutoRun: Boolean);
var
  ms: TMemoryStream;
  size: NativeUInt;
begin
  ms := TMemoryStream.Create;
  try
    if aSize = 0 then
      size := aStream.size
    else
      size := aSize;
    ms.Position := 0;
    ms.CopyFrom(aStream, size);
    LoadBuffer(ms.Memory, ms.size, aAutoRun);
  finally
    FreeAndNil(ms);
  end;
end;

procedure TViLua.LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  ms.Write(aData^, aSize);
  ms.Position := 0;
  if aAutoRun then
    luaL_dobuffer(FState, ms.Memory, ms.size, 'LoadBuffer')
  else
    luaL_loadbuffer(FState, ms.Memory, ms.size, 'LoadBuffer');
  FreeAndNil(ms);
end;

procedure TViLua.SaveByteCode(aStream: TStream);
var
  ret: Integer;
begin
  if lua_type(FState, lua_gettop(FState)) <> LUA_TFUNCTION then
    Exit;

  try
    ret := lua_dump(FState, LuaWrapperWriter, aStream);
    if ret <> 0 then
      raise EViLuaException.CreateFmt('lua_dump returned code %d', [ret]);
  finally
    lua_pop(FState, 1);
  end;
end;

procedure TViLua.LoadByteCode(aStream: TStream; aName: string; aAutoRun: Boolean);
var
  Res: Integer;
  err: string;
  ms: TMemoryStream;
  Marshall: TMarshaller;
begin
  if aStream = nil then
    Exit;
  if aStream.size <= 0 then
    Exit;

  ms := TMemoryStream.Create;

  try
    ms.CopyFrom(aStream, aStream.size);

    if aAutoRun then
    begin
      Res := luaL_dobuffer(FState, ms.Memory, ms.size,
        Marshall.AsAnsi(aName).ToPointer)
    end
    else
      Res := luaL_loadbuffer(FState, ms.Memory, ms.size,
        Marshall.AsAnsi(aName).ToPointer);
  finally
    ms.Free;
  end;

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise EViLuaException.Create(err);
  end;

end;

procedure TViLua.PushLuaValue(aValue: TViLuaValue);
begin
  case aValue.AsType of
    vtInteger:
      begin
        var value: Integer := aValue.AsInteger;
        lua_pushinteger(FState, value);
      end;
    vtDouble:
      begin
        var value: Double := aVAlue.AsNumber;
        lua_pushnumber(FState, value);
      end;
    vtString:
      begin
        var
          utf8s: RawByteString := UTF8Encode(aValue.AsString);
        lua_pushstring(FState, PAnsiChar(utf8s));
      end;
    vtPointer:
      begin
        var value: Pointer := aValue.AsPointer;
        lua_pushlightuserdata(FState, value);
      end;
    vtBoolean:
      begin
        var
          Value: LongBool := aValue.AsBoolean;
        lua_pushboolean(FState, Value);
      end;
  else
    begin
      lua_pushnil(FState);
    end;
  end;
end;

function TViLua.GetLuaValue(aIndex: Integer): TViLuaValue;
const
{$J+}
  Str: string = '';
{$J-}
begin
  case lua_type(FState, aIndex) of
    LUA_TNIL:
      begin
        Result := nil;
      end;

    LUA_TBOOLEAN:
      begin
        Result := Boolean(lua_toboolean(FState, aIndex));
      end;

    LUA_TNUMBER:
      begin
        Result := lua_tonumber(FState, aIndex);
      end;

    LUA_TSTRING:
      begin
        Str := lua_tostring(FState, aIndex);
        Result := PChar(Str);
      end;
  else
    begin
      Result := nil;
    end;
  end;
end;

function TViLua.DoCall(const aParams: array of TViLuaValue): TViLuaValue;
var
  Value: TViLuaValue;
  Res: Integer;
begin
  for Value in aParams do
  begin
    PushLuaValue(Value);
  end;

  Res := lua_pcall(FState, Length(aParams), 1, 0);
  CheckLuaError(Res);
  Result := GetLuaValue(-1);
  CleanStack;
end;

procedure TViLua.CleanStack;
begin
  lua_pop(FState, lua_gettop(FState));
end;

function TViLua.Call(aName: string; const aParams: array of TViLuaValue): TViLuaValue;
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
begin

  if aName.IsEmpty then
    Exit;

  CleanStack;

  Items := ParseTableNames(aName);

  if Length(Items) > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;

    lua_getfield(FState,  Index,
      Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Items[0]).ToPointer);
  end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := DoCall(aParams);
    end;
  end;
end;

function TViLua.RoutineExist(aName: string): Boolean;
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  Count: Integer;
  Name: string;
begin
  Result := False;

  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(Name);

  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Name).ToPointer);
  end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := True;
    end;
  end;

  CleanStack;
end;

procedure TViLua.Run;
var
  err: string;
  Res: Integer;
begin
  Res := LUA_OK;

  if lua_type(FState, lua_gettop(FState)) = LUA_TFUNCTION then
  begin
    Res := lua_pcall(FState, 0, LUA_MULTRET, 0);
  end;

  if Res <> 0 then
  begin
    err := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise EViLuaException.Create(err);
  end;
end;

function TViLua.VariableExist(aName: string): Boolean;
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  ok: Boolean;
  Count: Integer;
  Name: string;
begin
  Result := False;
  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(Name);
  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else if Count = 1 then
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Name).ToPointer);
  end
  else
  begin
    Exit;
  end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    Result := lua_isvariable(FState, -1);
  end;

  CleanStack;
end;

function TViLua.GetVariable(aName: string; aType: TViLuaValueType): TViLuaValue;
const
{$J+}
  Str: string = '';
{$J-}
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  ok: Boolean;
  Count: Integer;
  Name: string;
begin
  Result := nil;
  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(Name);
  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForGet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
    lua_getfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer);
  end
  else if Count = 1 then
  begin
    lua_getglobal(FState, Marshall.AsAnsi(Name).ToPointer);
  end
  else
  begin
    Exit;
  end;

  ok := True;

  case aType of
    vtInteger:
      begin
        Result := lua_tointeger(FState, -1);
      end;
    vtDouble:
      begin
        Result := lua_tonumber(FState, -1);
      end;
    vtString:
      begin
        Str := lua_tostring(FState, -1);
        Result := PChar(Str);
      end;
    vtPointer:
      begin
        Result := lua_touserdata(FState, -1);
      end;
    vtBoolean:
      begin
        var
          Bool: LongBool := lua_toboolean(FState, -1);
        Result := Boolean(Bool);
      end;
  else
    begin
      ok := False;
    end;
  end;

  CleanStack;
end;

procedure TViLua.SetVariable(aName: string; aValue: TViLuaValue);
var
  Marshall: TMarshaller;
  Index: Integer;
  Items: TStringArray;
  ok: Boolean;
  Count: Integer;
  Name: string;
begin
  Name := aName;
  if Name.IsEmpty then
    Exit;

  Items := ParseTableNames(aName);
  Count := Length(Items);

  if Count > 1 then
  begin
    if not PushGlobalTableForSet(Items, Index) then
    begin
      CleanStack;
      Exit;
    end;
  end
  else if Count < 1 then
  begin
    Exit;
  end;

  ok := True;

  case aValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FState, aValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FState, aValue);
      end;
    vtString:
      begin
        var
          s: string := aValue;
        lua_pushstring(FState, Marshall.AsAnsi(s).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FState, aValue);
      end;
    vtBoolean:
      begin
        var
          Bool: LongBool := aValue.AsBoolean;
        lua_pushboolean(FState, Bool);
      end;
  else
    begin
      ok := False;
    end;
  end;

  if ok then
  begin
    if Count > 1 then
    begin
      lua_setfield(FState, Index, Marshall.AsAnsi(Items[Index]).ToPointer)
    end
    else
    begin
      lua_setglobal(FState, Marshall.AsAnsi(Name).ToPointer);
    end;
  end;

  CleanStack;
end;

procedure TViLua.RegisterRoutine(aName: string; aRoutine: TViLuaFunction);
var
  method: TMethod;
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  i: Integer;
  Items: TStringArray;
  Count: Integer;
begin
  if aName.IsEmpty then
    Exit;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aName);

  Count := Length(Items);

  SetLength(Names, Length(Items));

  for i := 0 to High(Items) do
  begin
    Names[i] := Items[i];
  end;

  // init sub table names
  if Count > 1 then
  begin

    // push global table to stack
    if not PushGlobalTableForSet(Names, Index) then
    begin
      CleanStack;
      Exit;
    end;

    // push closure
    method.Code := TMethod(aRoutine).Code;
    method.Data := TMethod(aRoutine).Data;
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, method.Code);
    lua_pushlightuserdata(FState, method.Data);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // add field to table
    lua_setfield(FState, -2, Marshall.AsAnsi(Names[Index]).ToPointer);

    CleanStack;
  end
  else if (Count = 1) then
  begin
    // push closure
    method.Code := TMethod(aRoutine).Code;
    method.Data := TMethod(aRoutine).Data;
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, method.Code);
    lua_pushlightuserdata(FState, method.Data);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // set as global
    lua_setglobal(FState, Marshall.AsAnsi(Names[0]).ToPointer);
  end;
end;

procedure TViLua.RegisterRoutine(aName: string; aData: Pointer; aCode: Pointer);
var
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  i: Integer;
  Items: TStringArray;
  Count: Integer;
begin
  if aName.IsEmpty then
    Exit;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aName);

  Count := Length(Items);

  SetLength(Names, Length(Items));

  for i := 0 to High(Items) do
  begin
    Names[i] := Items[i];
  end;

  // init sub table names
  if Count > 1 then
  begin

    // push global table to stack
    if not PushGlobalTableForSet(Names, Index) then
    begin
      CleanStack;
      Exit;
    end;

    // push closure
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, aCode);
    lua_pushlightuserdata(FState, aData);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // add field to table
    lua_setfield(FState, -2, Marshall.AsAnsi(Names[Index]).ToPointer);

    CleanStack;
  end
  else if (Count = 1) then
  begin
    // push closure
    lua_pushlightuserdata(FState, Self);
    lua_pushlightuserdata(FState, aCode);
    lua_pushlightuserdata(FState, aData);
    lua_pushcclosure(FState, @LuaWrapperClosure, 3);

    // set as global
    lua_setglobal(FState, Marshall.AsAnsi(Names[0]).ToPointer);
  end;
end;

procedure TViLua.RegisterRoutines(aClass: TClass);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;

  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
begin
  rttiType := FRttiContext.GetType(aClass);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aClass, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      // lua_setfield(FState, -2,  Marshall.AsAnsi(rttiMethod.Name).ToPointer);
      lua_setglobal(FState, Marshall.AsAnsi(rttiMethod.Name).ToPointer);

    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aClass, [Self]);

    // clean up stack
    // Lua_Pop(FState, Lua_GetTop(FState));
    CleanStack;
  end;

end;

procedure TViLua.RegisterRoutines(aObject: TObject);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;
  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
begin
  rttiType := FRttiContext.GetType(aObject.ClassType);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aObject.ClassType, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      // lua_setfield(FState, -2,  Marshall.AsAnsi(rttiMethod.Name).ToPointer);
      lua_setglobal(FState, Marshall.AsAnsi(rttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aObject, [Self]);

    // clean up stack
    CleanStack;
  end;

end;

procedure TViLua.RegisterRoutines(aTables: string; aClass: TClass;
  aTableName: string);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;

  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  TblName: string;
  i: Integer;
  Items: TStringArray;
begin
  // init the routines table name
  if aTableName.IsEmpty then
    TblName := aClass.ClassName
  else
    TblName := aTableName;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aTables);

  // init sub table names
  if Length(Items) > 0 then
  begin
    SetLength(Names, Length(Items) + 2);

    for i := 0 to High(Items) do
    begin
      Names[i] := Items[i];
    end;

    // set last as table name for functions
    Names[i] := TblName;
    Names[i + 1] := TblName;
  end
  else
  begin
    SetLength(Names, 2);
    Names[0] := TblName;
    Names[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(Names, Index) then
  begin
    CleanStack;
    Exit;
  end;

  rttiType := FRttiContext.GetType(aClass);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aClass, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, Marshall.AsAnsi(rttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  // Lua_Pop(FState, Lua_GetTop(FState));
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aClass, [Self]);

    // clean up stack
    // Lua_Pop(FState, Lua_GetTop(FState));
    CleanStack;
  end;

end;

procedure TViLua.RegisterRoutines(aTables: string; aObject: TObject;
  aTableName: string);
var
  FRttiContext: TRttiContext;
  rttiType: TRttiType;
  rttiMethod: TRttiMethod;
  methodAutoSetup: TRttiMethod;
  rttiParameters: TArray<System.Rtti.TRttiParameter>;
  method: TMethod;
  Marshall: TMarshaller;
  Index: Integer;
  Names: array of string;
  TblName: string;
  i: Integer;
  Items: TStringArray;
begin
  // init the routines table name
  if aTableName.IsEmpty then
    TblName := aObject.ClassName
  else
    TblName := aTableName;

  // parse table names in table.table.xxx format
  Items := ParseTableNames(aTables);

  // init sub table names
  if Length(Items) > 0 then
  begin
    SetLength(Names, Length(Items) + 2);

    for i := 0 to High(Items) do
    begin
      Names[i] := Items[i];
    end;

    // set last as table name for functions
    Names[i] := TblName;
    Names[i + 1] := TblName;
  end
  else
  begin
    SetLength(Names, 2);
    Names[0] := TblName;
    Names[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(Names, Index) then
  begin
    CleanStack;
    Exit;
  end;

  rttiType := FRttiContext.GetType(aObject.ClassType);
  methodAutoSetup := nil;
  for rttiMethod in rttiType.GetMethods do
  begin
    if (rttiMethod.MethodKind <> mkProcedure) then
      continue;
    if (rttiMethod.Visibility <> mvPublic) then
      continue;

    rttiParameters := rttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(rttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType)
        ) and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
        (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLua) then
      begin
        // call auto setup for this class
        // rttiMethod.Invoke(aObject.ClassType, [Self]);
        methodAutoSetup := rttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(rttiParameters) = 1) and (Assigned(rttiParameters[0].ParamType))
      and (rttiParameters[0].ParamType.TypeKind = tkInterface) and
      (TRttiInterfaceType(rttiParameters[0].ParamType).GUID = IViLuaContext) then
    begin
      // push closure
      method.Code := rttiMethod.CodeAddress;
      method.Data := aObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, method.Code);
      lua_pushlightuserdata(FState, method.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, Marshall.AsAnsi(rttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack;

  // invoke autosetup?
  if Assigned(methodAutoSetup) then
  begin
    // call auto setup method
    methodAutoSetup.Invoke(aObject, [Self]);

    // clean up stack
    CleanStack;
  end;

end;

procedure TViLua.CompileToStream(aFilename: string; aStream: TStream;
  aCleanOutput: Boolean);
var
  InFilename: string;
  BundleFilename: string;
begin
  InFilename := aFilename;
  BundleFilename := TPath.GetFileNameWithoutExtension(InFilename) +
    '_bundle.lua';

  Bundle(InFilename, BundleFilename);
  LoadFile(PChar(BundleFilename), False);
  SaveByteCode(aStream);
  CleanStack;

  if aCleanOutput then
  begin
    if TFile.Exists(BundleFilename) then
    begin
      TFile.Delete(BundleFilename);
    end;
  end;
end;

procedure TViLua.SetGCStepSize(aStep: Integer);
begin
  FGCStep := aStep;
end;

function TViLua.GetGCStepSize: Integer;
begin
  Result := FGCStep;
end;

function TViLua.GetGCMemoryUsed: Integer;
begin
  Result := lua_gc(FState, LUA_GCCOUNT, 0);
end;

procedure TViLua.CollectGarbage;
begin
  lua_gc(FState, LUA_GCSTEP, FGCStep);
end;


end.

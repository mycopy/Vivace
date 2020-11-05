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

unit Vivace.Math;

{$I Vivace.Defines.inc}

interface

uses
  Vivace.Common;

const
  // Degree/Radian conversion
  VIRAD2DEG = 180.0 / PI;
  VIDEG2RAD = PI / 180.0;

  // Max Data Type Values
  VIMAXSINGLE = 340282346638528859811704183484516925440.0;

type

  { TViPointi }
  PViPointi = ^TViPointi;
  TViPointi = record
    X: Integer;
    Y: Integer;
  end;

  { TViRange }
  PViRange = ^TViRange;
  TViRange = record
    MinX: Single;
    MinY: Single;
    MaxX: Single;
    MaxY: Single;
  end;

  { TViPointf }
  PViPointf = ^TViPointf;
  TViPointf = record
    X: Single;
    Y: Single;
    constructor Create(aX: Single; aY: Single);
    procedure Assign(aX: Single; aY: Single); inline;
    procedure SetUndefined; inline;
    function IsUndefined: Boolean; inline;
  end;

  { TViVector }
  PViVector = ^TViVector;
  TViVector = record
    X: Single;
    Y: Single;
    Z: Single;
    constructor Create(aX: Single; aY: Single);
    procedure Assign(aX: Single; aY: Single); overload; inline;
    procedure Assign(aVector: TViVector); overload; inline;
    procedure Clear; inline;
    procedure Add(aVector: TViVector); inline;
    procedure Subtract(aVector: TViVector); inline;
    procedure Multiply(aVector: TViVector); inline;
    procedure Divide(aVector: TViVector); inline;
    function Magnitude: Single; inline;
    function MagnitudeTruncate(aMaxMagitude: Single): TViVector; inline;
    function Distance(aVector: TViVector): Single; inline;
    procedure Normalize; inline;
    function Angle(aVector: TViVector): Single; inline;
    procedure Trust(aAngle: Single; aSpeed: Single); inline;
    function MagnitudeSquared: Single; inline;
    function DotProduct(aVector: TViVector): Single; inline;
    procedure Scale(aValue: Single); inline;
    procedure DivideBy(aValue: Single); inline;
    function Project(aVector: TViVector): TViVector; inline;
    procedure Negate; inline;
    procedure SetUndefined; inline;
    function IsUndefined: Boolean; inline;
  end;

  { TViRectangle }
  PViRectangle = ^TViRectangle;
  TViRectangle = record
    X: Single;
    Y: Single;
    Width: Single;
    Height: Single;
    constructor Create(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
    procedure Assign(aX: Single; aY: Single; aWidth: Single;
      aHeight: Single); inline;
    function Intersect(aRect: TViRectangle): Boolean; inline;
    procedure SetUndefined; inline;
    function IsUndefined: Boolean; inline;
  end;

  { TViMath }
  TViMath = class(TViBaseObject)
  protected
    FCosTable: array [0 .. 360] of Single;
    FSinTable: array [0 .. 360] of Single;
    procedure InitSinCosTable;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Randomize;
    function RandomRange(aMin, aMax: Integer): Integer; overload;
    function RandomRange(aMin, aMax: Single): Single; overload;
    function RandomBool: Boolean;
    function GetRandomSeed: Integer;
    procedure SetRandomSeed(aValue: Integer);

    function AngleCos(aAngle: Integer): Single;
    function AngleSin(aAngle: Integer): Single;
    function AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
    procedure AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);

    function ClipValue(var aValue: Single; aMin: Single; aMax: Single;
      aWrap: Boolean): Single; overload;
    function ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer;
      aWrap: Boolean): Integer; overload;

    function SameSign(aValue1: Integer; aValue2: Integer): Boolean; overload;
    function SameSign(aValue1: Single; aValue2: Single): Boolean; overload;

    function SameValue(aA: Double; aB: Double; aEpsilon: Double = 0)
      : Boolean; overload;
    function SameValue(aA: Single; aB: Single; aEpsilon: Single = 0)
      : Boolean; overload;

  end;

  { Routines }
function ViPoint(aX: Single; aY: Single): TViPointf; inline;
function ViVector(aX: Single; aY: Single): TViVector; inline;
function ViRectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single)
  : TViRectangle; inline;

implementation

uses
  System.Math,
  Vivace.Engine;

type
  // Algorithm by David Blackman and Sebastiano Vigna
  TXoroShiro128Plus = record
    Seed: array [0 .. 1] of UInt64;
    procedure SetSeed64(seed64: UInt64);
    procedure Randomize;
    function Next: UInt64;
  end;

  // RDTSC
function RDTSC: UInt64;
asm
  RDTSC
end;

// RotL
function RotL(const X: UInt64; k: Integer): UInt64; inline;
begin
  Result := (X shl k) or (X shr (64 - k));
end;

// SplitMix64 - Algorithm by by Sebastiano Vigna
function SplitMix64(var X: UInt64): UInt64;
var
  Z: UInt64;
begin
  Inc(X, UInt64($9E3779B97F4A7C15));
  Z := (X xor (X shr 30)) * UInt64($BF58476D1CE4E5B9);
  Z := (Z xor (Z shr 27)) * UInt64($94D049BB133111EB);
  Result := Z xor (Z shr 31);
end;

// SetSeed64
procedure TXoroShiro128Plus.SetSeed64(seed64: UInt64);
begin
  Seed[0] := SplitMix64(seed64);
  Seed[1] := SplitMix64(seed64);
end;

// Randomize
procedure TXoroShiro128Plus.Randomize;
begin
  SetSeed64(RDTSC);
end;

// Next
function TXoroShiro128Plus.Next: UInt64;
{$IFDEF WIN32_ASM}
asm
  mov   ecx, eax

  // s0 := Seed[0];
  movq  mm0, [ecx]
  // s1 := Seed[1];
  movq  mm1, [ecx+8]

  // Result := s0 + s1;
  mov   eax, [ecx]
  mov   edx, [ecx+4]
  add   eax, [ecx+8]
  adc   edx, [ecx+12]

  // s1 := s1 xor s0;
  pxor  mm1, mm0

  // Seed[0] := RotL(s0, 55) xor s1 xor (s1 shl 14);
  movq  mm2, mm0
  psllq mm0, 55
  psrlq mm2, 64-55
  por   mm0, mm2
  pxor  mm0, mm1
  movq  mm3, mm1
  psllq mm3, 14
  pxor  mm0, mm3
  movq  [ecx], mm0

  // Seed[1] := RotL(s1, 36);
  movq  mm4, mm1
  psllq mm1, 36
  psrlq mm4, 64-36
  pxor  mm1, mm4
  movq  [ecx+8], mm1

  emms
  {$ELSE}
var
  s0, s1: UInt64;
begin
  s0 := Seed[0];
  s1 := Seed[1];
  Result := s0 + s1;

  s1 := s1 xor s0;
  Seed[0] := RotL(s0, 55) xor s1 xor (s1 shl 14);
  Seed[1] := RotL(s1, 36);
{$ENDIF}
end;

var
  XoroShiro128Plus: TXoroShiro128Plus;
  Seed: UInt64;

function FastRandom(const ARange: Integer): Integer;
var
  Temp: UInt32;
begin
  Temp := XoroShiro128Plus.Next;
  Result := (UInt64(UInt32(ARange)) * UInt64(Temp)) shr 32;
end;

function FastRandomRange(const AFrom, ATo: Integer): Integer;
begin
  if AFrom > ATo then
    // Result := Random(AFrom - ATo) + ATo
    Result := FastRandom(AFrom - ATo) + ATo
  else
    // Result := Random(ATo - AFrom) + AFrom;
    Result := FastRandom(ATo - AFrom) + AFrom;
end;

{ --- Routines -------------------------------------------------------------- }
function ViPoint(aX: Single; aY: Single): TViPointf;
begin
  Result.X := aX;
  Result.Y := aY;
end;

function ViVector(aX: Single; aY: Single): TViVector;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Z := 0;
end;

function ViRectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single)
  : TViRectangle;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Width := aWidth;
  Result.Height := aHeight;
end;

{ --- TViPointf ------------------------------------------------------------- }
constructor TViPointf.Create(aX: Single; aY: Single);
begin
  Assign(aX, aY);
end;

procedure TViPointf.Assign(aX: Single; aY: Single);
begin
  X := aX;
  Y := aY;
end;

procedure TViPointf.SetUndefined;
begin
  X := VIMAXSINGLE;
  Y := VIMAXSINGLE;
end;

function TViPointf.IsUndefined: Boolean;
begin
  Result := Boolean((X = VIMAXSINGLE) and (Y = VIMAXSINGLE));
end;

{ --- TViVector ------------------------------------------------------------- }
constructor TViVector.Create(aX: Single; aY: Single);
begin
  Assign(aX, aY);
  Z := 0;
end;

procedure TViVector.Assign(aX: Single; aY: Single);
begin
  X := aX;
  Y := aY;
end;

procedure TViVector.Clear;
begin
  X := 0;
  Y := 0;
  Z := 0;
end;

procedure TViVector.Assign(aVector: TViVector);
begin
  X := aVector.X;
  Y := aVector.Y;
end;

procedure TViVector.Add(aVector: TViVector);
begin
  X := X + aVector.X;
  Y := Y + aVector.Y;
end;

procedure TViVector.Subtract(aVector: TViVector);
begin
  X := X - aVector.X;
  Y := Y - aVector.Y;
end;

procedure TViVector.Multiply(aVector: TViVector);
begin
  X := X * aVector.X;
  Y := Y * aVector.Y;
end;

procedure TViVector.Divide(aVector: TViVector);
begin
  X := X / aVector.X;
  Y := Y / aVector.Y;

end;

function TViVector.Magnitude: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function TViVector.MagnitudeTruncate(aMaxMagitude: Single): TViVector;
var
  MaxMagSqrd: Single;
  VecMagSqrd: Single;
  Truc: Single;
begin
  Result.Assign(X, Y);
  MaxMagSqrd := aMaxMagitude * aMaxMagitude;
  VecMagSqrd := Result.Magnitude;
  if VecMagSqrd > MaxMagSqrd then
  begin
    Truc := (aMaxMagitude / Sqrt(VecMagSqrd));
    Result.X := Result.X * Truc;
    Result.Y := Result.Y * Truc;
  end;
end;

function TViVector.Distance(aVector: TViVector): Single;
var
  DirVec: TViVector;
begin
  DirVec.X := X - aVector.X;
  DirVec.Y := Y - aVector.Y;
  Result := DirVec.Magnitude;
end;

procedure TViVector.Normalize;
var
  Len, OOL: Single;
begin
  Len := self.Magnitude;
  if Len <> 0 then
  begin
    OOL := 1.0 / Len;
    X := X * OOL;
    Y := Y * OOL;
  end;
end;

function TViVector.Angle(aVector: TViVector): Single;
var
  xoy: Single;
  R: TViVector;
begin
  R.Assign(self);
  R.Subtract(aVector);
  R.Normalize;

  if R.Y = 0 then
  begin
    R.Y := 0.001;
  end;

  xoy := R.X / R.Y;

  Result := ArcTan(xoy) * VIRAD2DEG;
  if R.Y < 0 then
    Result := Result + 180.0;

end;

procedure TViVector.Trust(aAngle: Single; aSpeed: Single);
var
  A: Single;
begin
  A := aAngle + 90.0;
  ViEngine.Math.ClipValue(A, 0, 360, True);

  X := X + ViEngine.Math.AngleCos(Round(A)) * -(aSpeed);
  Y := Y + ViEngine.Math.AngleSin(Round(A)) * -(aSpeed);
end;

function TViVector.MagnitudeSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

function TViVector.DotProduct(aVector: TViVector): Single;
begin
  Result := (X * aVector.X) + (Y * aVector.Y);
end;

procedure TViVector.Scale(aValue: Single);
begin
  X := X * aValue;
  Y := Y * aValue;
end;

procedure TViVector.DivideBy(aValue: Single);
begin
  X := X / aValue;
  Y := Y / aValue;
end;

function TViVector.Project(aVector: TViVector): TViVector;
var
  dp: Single;
begin
  dp := self.DotProduct(aVector);
  Result.X := (dp / (aVector.X * aVector.X + aVector.Y * aVector.Y)) *
    aVector.X;
  Result.Y := (dp / (aVector.X * aVector.X + aVector.Y * aVector.Y)) *
    aVector.Y;
end;

procedure TViVector.Negate;
begin
  X := -X;
  Y := -Y;
end;

procedure TViVector.SetUndefined;
begin
  X := VIMAXSINGLE;
  Y := VIMAXSINGLE;
end;

function TViVector.IsUndefined: Boolean;
begin
  Result := Boolean((X = VIMAXSINGLE) and (Y = VIMAXSINGLE))
end;

{ --- TViRectangle ---------------------------------------------------------- }
constructor TViRectangle.Create(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single);
begin
  Assign(aX, aY, aWidth, aHeight);
end;

procedure TViRectangle.Assign(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single);
begin
  X := aX;
  Y := aY;
  Width := aWidth;
  Height := aHeight;
end;

function TViRectangle.Intersect(aRect: TViRectangle): Boolean;
var
  r1r, r1b: Single;
  r2r, r2b: Single;
begin
  r1r := X - (Width - 1);
  r1b := Y - (Height - 1);
  r2r := aRect.X - (aRect.Width - 1);
  r2b := aRect.Y - (aRect.Height - 1);

  Result := (X < r2r) and (r1r > aRect.X) and (Y < r2b) and (r1b > aRect.Y);
end;

procedure TViRectangle.SetUndefined;
begin
  Assign(VIMAXSINGLE, VIMAXSINGLE, VIMAXSINGLE, VIMAXSINGLE)
end;

function TViRectangle.IsUndefined: Boolean;
begin
  Result := Boolean((X = VIMAXSINGLE) and (Y = VIMAXSINGLE) and (Width = VIMAXSINGLE)
    and (Height = VIMAXSINGLE))
end;

{ --- TViMath --------------------------------------------------------------- }
procedure TViMath.InitSinCosTable;
var
  i: Integer;
begin
  for i := 0 to 360 do
  begin
    FCosTable[i] := cos((i * PI / 180.0));
    FSinTable[i] := sin((i * PI / 180.0));
  end;
end;

constructor TViMath.Create;
begin
  inherited;
  Randomize;
  InitSinCosTable;
end;

destructor TViMath.Destroy;
begin
  inherited;
end;

procedure TViMath.Randomize;
begin
  System.Randomize;
  XoroShiro128Plus.Randomize;
end;

function TViMath.RandomRange(aMin, aMax: Integer): Integer;
begin
  // Result := System.Math.RandomRange(aMin, aMax + 1);
  Result := FastRandomRange(aMin, aMax + 1);
end;

function TViMath.RandomRange(aMin, aMax: Single): Single;
var
  N: Single;
begin
  // N := System.Math.RandomRange(0, MaxInt) / MaxInt;
  N := FastRandomRange(0, MaxInt) / MaxInt;
  Result := aMin + (N * (aMax - aMin));
end;

function TViMath.RandomBool: Boolean;
begin
  // Result := Boolean(System.Math.RandomRange(0, 2) = 1);
  Result := Boolean(FastRandomRange(0, 2) = 1);
end;

function TViMath.GetRandomSeed: Integer;
begin
  // Result := RandSeed;
  Result := Seed;
end;

procedure TViMath.SetRandomSeed(aValue: Integer);
begin
  // RandSeed := aValue;
  Seed := aValue;
  XoroShiro128Plus.SetSeed64(Seed)
end;

function TViMath.AngleCos(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then
    Exit;
  Result := FCosTable[aAngle];
end;

function TViMath.AngleSin(aAngle: Integer): Single;
begin
  Result := 0;
  if (aAngle < 0) or (aAngle > 360) then
    Exit;
  Result := FSinTable[aAngle];
end;

function TViMath.AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single;
var
  C: Single;
begin
  C := aDestAngle - aSrcAngle -
    (Floor((aDestAngle - aSrcAngle) / 360.0) * 360.0);

  if C >= (360.0 / 2) then
  begin
    C := C - 360.0;
  end;
  Result := C;
end;

procedure TViMath.AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single);
var
  nx, ny: Single;
  ia: Integer;
begin
  (*
    if aAngle > 360 then
    aAngle := aAngle - 360
    else if aAngle < 0 then
    aAngle := aAngle + 360;
  *)

  ClipValue(aAngle, 0, 359, True);

  ia := Round(aAngle);

  nx := aX * FCosTable[ia] - aY * FSinTable[ia];
  ny := aY * FCosTable[ia] + aX * FSinTable[ia];

  aX := nx;
  aY := ny;
end;

function TViMath.ClipValue(var aValue: Single; aMin: Single; aMax: Single;
  aWrap: Boolean): Single;
begin
  if aWrap then
  begin
    if (aValue > aMax) then
    begin
      aValue := aMin + Abs(aValue - aMax);
      if aValue > aMax then
        aValue := aMax;
    end
    else if (aValue < aMin) then
    begin
      aValue := aMax - Abs(aValue - aMin);
      if aValue < aMin then
        aValue := aMin;
    end
  end
  else
  begin
    if aValue < aMin then
      aValue := aMin
    else if aValue > aMax then
      aValue := aMax;
  end;

  Result := aValue;

end;

function TViMath.ClipValue(var aValue: Integer; aMin: Integer; aMax: Integer;
  aWrap: Boolean): Integer;
begin
  if aWrap then
  begin
    if (aValue > aMax) then
    begin
      aValue := aMin + Abs(aValue - aMax);
      if aValue > aMax then
        aValue := aMax;
    end
    else if (aValue < aMin) then
    begin
      aValue := aMax - Abs(aValue - aMin);
      if aValue < aMin then
        aValue := aMin;
    end
  end
  else
  begin
    if aValue < aMin then
      aValue := aMin
    else if aValue > aMax then
      aValue := aMax;
  end;

  Result := aValue;
end;

function TViMath.SameSign(aValue1: Integer; aValue2: Integer): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

function TViMath.SameSign(aValue1: Single; aValue2: Single): Boolean;
begin
  if Sign(aValue1) = Sign(aValue2) then
    Result := True
  else
    Result := False;
end;

function TViMath.SameValue(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

function TViMath.SameValue(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean;
begin
  Result := System.Math.SameValue(aA, aB, aEpsilon);
end;

end.

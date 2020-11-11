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

unit Vivace.Actor;

{$I Vivace.Defines.inc}

interface

uses
  System.Classes,
  System.Contnrs,
  Vivace.Math,
  Vivace.Common,
  Vivace.Entity;

type

  // Class Forwards
  TViActorList = class;
  TViAIStateMachine = class;

  { TActorAttributeSet }
  TViActorAttributeSet = set of Byte;

  { TViActorMessage }
  PViActorMessage = ^TViActorMessage;
  TViActorMessage = record
    Id: Integer;
    Data: Pointer;
    DataSize: Cardinal;
  end;

  { TViActor }
  TViActor = class(TViBaseObject)
  protected
    FOwner: TViActor;
    FPrev: TViActor;
    FNext: TViActor;
    FAttributes: TViActorAttributeSet;
    FTerminated: Boolean;
    FActorList: TViActorList;
    FCanCollide: Boolean;
    FChildren: TViActorList;
    function GetAttribute(aIndex: Byte): Boolean;
    procedure SetAttribute(aIndex: Byte; aValue: Boolean);
    function GetAttributes: TViActorAttributeSet;
    procedure SetAttributes(aValue: TViActorAttributeSet);
  public
    property Owner: TViActor read FOwner write FOwner;
    property Prev: TViActor read FPrev write FPrev;
    property Next: TViActor read FNext write FNext;
    property Attribute[aIndex: Byte]: Boolean read GetAttribute write SetAttribute;
    property Attributes: TViActorAttributeSet read GetAttributes  write SetAttributes;
    property Terminated: Boolean read FTerminated write FTerminated;
    property Children: TViActorList read FChildren write FChildren;
    property ActorList: TViActorList read FActorList write FActorList;
    property CanCollide: Boolean read FCanCollide write FCanCollide;
    procedure OnVisit(aSender: TViActor; aEventId: Integer; var aDone: Boolean); virtual;
    procedure OnUpdate(aDeltaTime: Single); virtual;
    procedure OnRender; virtual;
    function OnMessage(aMsg: PViActorMessage): TViActor; virtual;
    procedure OnCollide(aActor: TViActor; aHitPos: TViVector); virtual;
    constructor Create; override;
    destructor Destroy; override;
    function AttributesAreSet(aAttrs: TViActorAttributeSet): Boolean;
    function Collide(aActor: TViActor; var aHitPos: TViVector): Boolean; virtual;
    function Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean; overload; virtual;
    function Overlap(aActor: TViActor): Boolean; overload; virtual;
  end;

  { TViActorList }
  TViActorList = class(TViBaseObject)
  protected
    FHead: TViActor;
    FTail: TViActor;
    FCount: Integer;
  public
    property Count: Integer read FCount;
    constructor Create; override;
    destructor Destroy; override;
    procedure Clean;
    procedure Add(aActor: TViActor);
    procedure Remove(aActor: TViActor; aDispose: Boolean);
    procedure Clear(aAttrs: TViActorAttributeSet);
    procedure ForEach(aSender: TViActor; aAttrs: TViActorAttributeSet; aEventId: Integer; var aDone: Boolean);
    procedure Update(aAttrs: TViActorAttributeSet; aDeltaTime: Single);
    procedure Render(aAttrs: TViActorAttributeSet);
    function SendMessage(aAttrs: TViActorAttributeSet; aMsg: PViActorMessage; aBroadcast: Boolean): TViActor;
    procedure CheckCollision(aAttrs: TViActorAttributeSet; aActor: TViActor);
  end;

  { TViAIState }
  TViAIState = class(TViBaseObject)
  protected
    FOwner: TObject;
    FChildren: TViActorList;
    FStateMachine: TViAIStateMachine;
  public
    property Owner: TObject read FOwner write FOwner;
    property Children: TViActorList read FChildren;
    property StateMachine: TViAIStateMachine read FStateMachine write FStateMachine;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnEnter; virtual;
    procedure OnExit; virtual;
    procedure OnUpdate(aDeltaTime: Single); virtual;
    procedure OnRender; virtual;
  end;

  { TViAIStateMachine }
  TViAIStateMachine = class(TViBaseObject)
  protected
    FOwner: TViActor;
    FCurrentState: TViAIState;
    FGlobalState: TViAIState;
    FPreviousState: TViAIState;
    FStateList: TObjectList;
    FStateIndex: Integer;
    procedure ChangeStateObj(aValue: TViAIState);
    procedure SetCurrentStateObj(aValue: TViAIState);
    procedure RemoveStateObj(aState: TViAIState);
    procedure SetGlobalStateObj(aValue: TViAIState);
    procedure SetPreviousStateObj(aValue: TViAIState);
    function GetStateCount: Integer;
    function GetStateIndex: Integer;
    function GetStates(aIndex: Integer): TViAIState;
    function GetCurrentState: Integer;
    procedure SetCurrentState(aIndex: Integer);
    function GetGlobalState: Integer;
    procedure SetGlobalState(aIndex: Integer);
    function GetPreviousState: Integer;
    procedure SetPreviousState(aIndex: Integer);
  public
    property Owner: TViActor read FOwner write FOwner;
    property StateCount: Integer read GetStateCount;
    property StateIndex: Integer read GetStateIndex;
    property States[aIndex: Integer]: TViAIState read GetStates;
    property CurrentState: Integer read GetCurrentState write SetCurrentState;
    property GlobalState: Integer read GetGlobalState write SetGlobalState;
    property PreviousState: Integer read GetPreviousState write SetPreviousState;
    constructor Create; override;
    destructor Destroy; override;
    procedure Update(aDeltaTime: Single);
    procedure Render;
    procedure RevertToPreviousState;
    procedure ClearStates;
    function AddState(aState: TViAIState): Integer;
    procedure RemoveState(aIndex: Integer);
    procedure ChangeState(aIndex: Integer);
    function PrevState(aWrap: Boolean): Integer;
    function NextState(aWrap: Boolean): Integer;
  end;

  { TViAIActor }
  TViAIActor = class(TViActor)
  protected
    FStateMachine: TViAIStateMachine;
  public
    property StateMachine: TViAIStateMachine read FStateMachine write FStateMachine;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Single); override;
    procedure OnRender; override;
  end;

  { TViActorSceneEvent }
  TViActorSceneEvent = procedure(aSceneNum: Integer) of object;


  { TViActorScene }
  TViActorScene = class(TViBaseObject)
  protected
    FLists: array of TViActorList;
    FCount: Integer;
    function GetList(aIndex: Integer): TViActorList;
    function GetCount: Integer;
  public
    property Lists[aIndex: Integer]: TViActorList read GetList; default;
    property Count: Integer read GetCount;
    constructor Create; override;
    destructor Destroy; override;
    procedure Alloc(aNum: Integer);
    procedure Dealloc;
    procedure Clean(aIndex: Integer);
    procedure Clear(aIndex: Integer; aAttrs: TViActorAttributeSet);
    procedure ClearAll;
    procedure Update(aAttrs: TViActorAttributeSet; aDeltaTime: Single);
    procedure Render(aAttrs: TViActorAttributeSet; aBefore: TViActorSceneEvent;
      aAfter: TViActorSceneEvent);
    function SendMessage(aAttrs: TViActorAttributeSet; aMsg: PViActorMessage; aBroadcast: Boolean): TViActor;
  end;

  { TViActorEntity }
  TViActorEntity = class(TViActor)
  protected
    FEntity: TViEntity;
  public
    property Entity: TViEntity read FEntity;
    constructor Create; override;
    destructor Destroy; override;
    function Collide(aActor: TViActor; var aHitPos: TViVector): Boolean; override;
    function Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean; override;
    function Overlap(aActor: TViActor): Boolean; override;
    procedure OnRender; override;
  end;

  { TViAIActorEntity }
  TViAIActorEntity = class(TViActorEntity)
  protected
    FStateMachine: TViAIStateMachine;
  public
    property StateMachine: TViAIStateMachine read FStateMachine;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Single); override;
    procedure OnRender; override;
  end;

implementation

uses
  System.Types,
  System.SysUtils;

{ --- TViActor ------------------------------------------------------------ }
function TViActor.GetAttribute(aIndex: Byte): Boolean;
begin
  Result := Boolean(aIndex in FAttributes);
end;

procedure TViActor.SetAttribute(aIndex: Byte; aValue: Boolean);
begin
  if aValue then
    Include(FAttributes, aIndex)
  else
    Exclude(FAttributes, aIndex);
end;

function TViActor.GetAttributes: TViActorAttributeSet;
begin
  Result := FAttributes;
end;

procedure TViActor.SetAttributes(aValue: TViActorAttributeSet);
begin
  FAttributes := aValue;
end;

procedure TViActor.OnVisit(aSender: TViActor; aEventId: Integer; var aDone: Boolean);
begin
  aDone := False;
end;

procedure TViActor.OnUpdate(aDeltaTime: Single);
begin
  // update all children by default
  FChildren.Update([], aDeltaTime);
end;

procedure TViActor.OnRender;
begin
  // render all children by default
  FChildren.Render([]);
end;

function TViActor.OnMessage(aMsg: PViActorMessage): TViActor;
begin
  Result := nil;
end;

procedure TViActor.OnCollide(aActor: TViActor; aHitPos: TViVector);
begin
end;

constructor TViActor.Create;
begin
  inherited;
  FOwner := nil;
  FPrev := nil;
  FNext := nil;
  FAttributes := [];
  FTerminated := False;
  FActorList := nil;
  FCanCollide := False;
  FChildren := TViActorList.Create;
end;

destructor TViActor.Destroy;
begin
  FreeAndNil(FChildren);
  inherited;
end;

function TViActor.AttributesAreSet(aAttrs: TViActorAttributeSet): Boolean;
var
  A: Byte;
begin
  Result := False;
  for A in aAttrs do
  begin
    if A in FAttributes then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TViActor.Collide(aActor: TViActor; var aHitPos: TViVector): Boolean;
begin
  Result := False;
end;

function TViActor.Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean;
begin
  Result := False;
end;

function TViActor.Overlap(aActor: TViActor): Boolean;
begin
  Result := False;
end;

{ --- TViAIState ---------------------------------------------------------- }
constructor TViAIState.Create;
begin
  inherited;
  FStateMachine := nil;
  FOwner := nil;
  FChildren := TViActorList.Create;
end;

destructor TViAIState.Destroy;
begin
  FreeAndNil(FChildren);
  inherited;
end;

procedure TViAIState.OnEnter;
begin
end;

procedure TViAIState.OnExit;
begin
end;

procedure TViAIState.OnUpdate(aDeltaTime: Single);
begin
  // update all children by default
  FChildren.Update([], aDeltaTime);
end;

procedure TViAIState.OnRender;
begin
  // render all children by default
  FChildren.Render([]);
end;

{ --- TViAIStateMachine --------------------------------------------------- }
procedure TViAIStateMachine.ChangeStateObj(aValue: TViAIState);
begin
  if not Assigned(aValue) then
    Exit;

  FPreviousState := FCurrentState;

  if Assigned(FCurrentState) then
    FCurrentState.OnExit;

  FCurrentState := aValue;
  FCurrentState.Owner := FOwner;

  FCurrentState.OnEnter;
end;

procedure TViAIStateMachine.SetCurrentStateObj(aValue: TViAIState);
begin
  FCurrentState := aValue;
  FCurrentState.Owner := FOwner;
  if Assigned(FCurrentState) then
  begin
    FCurrentState.OnEnter;
  end;
end;

procedure TViAIStateMachine.RemoveStateObj(aState: TViAIState);
begin
  FStateList.Remove(aState);
  if FStateList.Count < 1 then
    FStateIndex := -1
  else
    FStateIndex := 0;
end;

procedure TViAIStateMachine.SetGlobalStateObj(aValue: TViAIState);
begin
  FGlobalState := aValue;
  FGlobalState.Owner := FOwner;
  if Assigned(FGlobalState) then
  begin
    FGlobalState.OnEnter;
  end;
end;

procedure TViAIStateMachine.SetPreviousStateObj(aValue: TViAIState);
begin
  FPreviousState := aValue;
  FPreviousState.Owner := FOwner;
end;

function TViAIStateMachine.GetStateCount: Integer;
begin
  Result := FStateList.Count;
end;

function TViAIStateMachine.GetStateIndex: Integer;
begin
  Result := FStateIndex;
end;

function TViAIStateMachine.GetStates(aIndex: Integer): TViAIState;
begin
  Result := nil;
  if (aIndex < 0) or (aIndex > FStateList.Count - 1) then
    Exit;
  Result := TViAIState(FStateList.Items[aIndex]);
end;

function TViAIStateMachine.GetCurrentState: Integer;
begin
  Result := FStateList.IndexOf(FCurrentState);
end;

procedure TViAIStateMachine.SetCurrentState(aIndex: Integer);
var
  obj: TViAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    SetCurrentStateObj(obj);
    FStateIndex := aIndex;
  end;
end;

function TViAIStateMachine.GetGlobalState: Integer;
begin
  Result := FStateList.IndexOf(FGlobalState);
end;

procedure TViAIStateMachine.SetGlobalState(aIndex: Integer);
var
  obj: TViAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    SetGlobalStateObj(obj);
  end;
end;

function TViAIStateMachine.GetPreviousState: Integer;
begin
  Result := FStateList.IndexOf(FPreviousState);
end;

procedure TViAIStateMachine.SetPreviousState(aIndex: Integer);
var
  obj: TViAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    SetPreviousStateObj(obj);
  end;
end;

constructor TViAIStateMachine.Create;
begin
  inherited;
  FOwner := nil;
  FCurrentState := nil;
  FGlobalState := nil;
  FPreviousState := nil;
  FStateList := FStateList.Create(True);
  FStateIndex := -1;
end;

destructor TViAIStateMachine.Destroy;
begin
  FreeAndNil(FStateList);
  inherited;
end;

procedure TViAIStateMachine.Update(aDeltaTime: Single);
begin
  if Assigned(FGlobalState) then
    FGlobalState.OnUpdate(aDeltaTime);
  if Assigned(FCurrentState) then
    FCurrentState.OnUpdate(aDeltaTime);
end;

procedure TViAIStateMachine.Render;
begin
  if Assigned(FGlobalState) then
    FGlobalState.OnRender;
  if Assigned(FCurrentState) then
    FCurrentState.OnRender;
end;

procedure TViAIStateMachine.RevertToPreviousState;
begin
  ChangeStateObj(FPreviousState);
end;

procedure TViAIStateMachine.ClearStates;
begin
  FStateList.Clear;
  FStateIndex := -1;
end;

function TViAIStateMachine.AddState(aState: TViAIState): Integer;
begin
  Result := -1;
  if FStateList.IndexOf(aState) = -1 then
  begin
    Result := FStateList.Add(aState);
    if GetStateCount <= 1 then
    begin
      SetCurrentState(Result);
    end;
    aState.StateMachine := self;
  end;
end;

procedure TViAIStateMachine.RemoveState(aIndex: Integer);
var
  obj: TViAIState;
begin
  if (aIndex < 0) or (aIndex > FStateList.Count - 1) then
    Exit;
  obj := TViAIState(FStateList.Items[aIndex]);
  RemoveStateObj(obj);
end;

procedure TViAIStateMachine.ChangeState(aIndex: Integer);
var
  obj: TViAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    ChangeStateObj(obj);
    FStateIndex := aIndex;
  end;
end;

function TViAIStateMachine.PrevState(aWrap: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;
  if FStateList.Count < 2 then
    Exit;

  I := FStateIndex;
  Dec(I);
  if I < 0 then
  begin
    if not aWrap then
      Exit;
    I := FStateList.Count - 1;
  end;
  ChangeState(I);
end;

function TViAIStateMachine.NextState(aWrap: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;
  if FStateList.Count < 2 then
    Exit;

  I := FStateIndex;
  Inc(I);
  if I > FStateList.Count - 1 then
  begin
    if not aWrap then
      Exit;
    I := 0;
  end;
  ChangeState(I);
end;

{ --- TViAIActor ---------------------------------------------------------- }
constructor TViAIActor.Create;
begin
  inherited;
  FStateMachine := TViAIStateMachine.Create;
  FStateMachine.Owner := self;
end;

destructor TViAIActor.Destroy;
begin
  FreeAndNil(FStateMachine);
  inherited;
end;

procedure TViAIActor.OnUpdate(aDeltaTime: Single);
begin
  // process states
  FStateMachine.Update(aDeltaTime);
end;

procedure TViAIActor.OnRender;
begin
  // render state
  FStateMachine.Render;
end;

{ --- TViActorList -------------------------------------------------------- }
constructor TViActorList.Create;
begin
  inherited;
  FHead := nil;
  FTail := nil;
  FCount := 0;
end;

destructor TViActorList.Destroy;
begin
  Clear([]);
  inherited;
end;

procedure TViActorList.Add(aActor: TViActor);
begin
  if not Assigned(aActor) then
    Exit;

  aActor.Prev := FTail;
  aActor.Next := nil;

  if FHead = nil then
  begin
    FHead := aActor;
    FTail := aActor;
  end
  else
  begin
    FTail.Next := aActor;
    FTail := aActor;
  end;

  Inc(FCount);
end;

procedure TViActorList.Remove(aActor: TViActor; aDispose: Boolean);
var
  Flag: Boolean;
begin
  if not Assigned(aActor) then
    Exit;

  Flag := False;

  if aActor.Next <> nil then
  begin
    aActor.Next.Prev := aActor.Prev;
    Flag := True;
  end;

  if aActor.Prev <> nil then
  begin
    aActor.Prev.Next := aActor.Next;
    Flag := True;
  end;

  if FTail = aActor then
  begin
    FTail := FTail.Prev;
    Flag := True;
  end;

  if FHead = aActor then
  begin
    FHead := FHead.Next;
    Flag := True;
  end;

  if Flag = True then
  begin
    Dec(FCount);
    if aDispose then
    begin
      aActor.Free;
    end;
  end;
end;

procedure TViActorList.Clear(aAttrs: TViActorAttributeSet);
var
  P: TViActor;
  N: TViActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next object
    N := P.Next;

    if NoAttrs then
    begin
      Remove(P, True);
    end
    else
    begin
      if P.AttributesAreSet(aAttrs) then
      begin
        Remove(P, True);
      end;
    end;

    // get pointer to next object
    P := N;

  until P = nil;
end;

procedure TViActorList.Clean;
var
  P: TViActor;
  N: TViActor;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  repeat
    // save pointer to next object
    N := P.Next;

    if P.Terminated then
    begin
      Remove(P, True);
    end;

    // get pointer to next object
    P := N;

  until P = nil;
end;

procedure TViActorList.ForEach(aSender: TViActor; aAttrs: TViActorAttributeSet; aEventId: Integer; var aDone: Boolean);
var
  P: TViActor;
  N: TViActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        aDone := False;
        P.OnVisit(aSender, aEventId, aDone);
        if aDone then
        begin
          Exit;
        end;
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          aDone := False;
          P.OnVisit(aSender, aEventId, aDone);
          if aDone then
          begin
            Exit;
          end;
        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

procedure TViActorList.Update(aAttrs: TViActorAttributeSet; aDeltaTime: Single);
var
  P: TViActor;
  N: TViActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        // call actor's OnUpdate method
        P.OnUpdate(aDeltaTime);
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          // call actor's OnUpdate method
          P.OnUpdate(aDeltaTime);
        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;

  // perform garbage collection
  Clean;
end;

procedure TViActorList.Render(aAttrs: TViActorAttributeSet);
var
  P: TViActor;
  N: TViActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        // call actor's OnRender method
        P.OnRender;
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          // call actor's OnRender method
          P.OnRender;
        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

function TViActorList.SendMessage(aAttrs: TViActorAttributeSet; aMsg: PViActorMessage; aBroadcast: Boolean): TViActor;
var
  P: TViActor;
  N: TViActor;
  NoAttrs: Boolean;
begin
  Result := nil;

  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        // send message to object
        Result := P.OnMessage(aMsg);
        if not aBroadcast then
        begin
          if Result <> nil then
          begin
            Exit;
          end;
        end;
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          // send message to object
          Result := P.OnMessage(aMsg);
          if not aBroadcast then
          begin
            if Result <> nil then
            begin
              Exit;
            end;
          end;

        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

procedure TViActorList.CheckCollision(aAttrs: TViActorAttributeSet; aActor: TViActor);
var
  P: TViActor;
  N: TViActor;
  NoAttrs: Boolean;
  HitPos: TViVector;
begin
  // check if terminated
  if aActor.Terminated then
    Exit;

  // check if can collide
  if not aActor.CanCollide then
    Exit;

  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so check collision with this actor
      if NoAttrs then
      begin

        if P.CanCollide then
        begin
          // HitPos.Clear;
          HitPos.X := 0;
          HitPos.Y := 0;
          if aActor.Collide(P, HitPos) then
          begin
            P.OnCollide(aActor, HitPos);
            aActor.OnCollide(P, HitPos);
            // Exit;
          end;
        end;

      end
      else
      begin
        // check collision with this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          if P.CanCollide then
          begin
            // HitPos.Clear;
            HitPos.X := 0;
            HitPos.Y := 0;
            if aActor.Collide(P, HitPos) then
            begin
              P.OnCollide(aActor, HitPos);
              aActor.OnCollide(P, HitPos);
              // Exit;
            end;
          end;

        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

{ --- TViActorScene --------------------------------------------------------- }
function TViActorScene.GetList(aIndex: Integer): TViActorList;
begin
  Result := FLists[aIndex];
end;

function TViActorScene.GetCount: Integer;
begin
  Result := FCount;
end;

constructor TViActorScene.Create;
begin
  inherited;
  FLists := nil;
  FCount := 0;
end;

destructor TViActorScene.Destroy;
begin
  Dealloc;
  inherited;
end;

procedure TViActorScene.Alloc(aNum: Integer);
var
  I: Integer;
begin
  Dealloc;
  FCount := aNum;
  SetLength(FLists, FCount);
  for I := 0 to FCount - 1 do
  begin
    FLists[I] := TViActorList.Create;
  end;
end;

procedure TViActorScene.Dealloc;
var
  I: Integer;
begin
  ClearAll;
  for I := 0 to FCount - 1 do
  begin
    FLists[I].Free;
  end;
  FLists := nil;
  FCount := 0;
end;

procedure TViActorScene.Clean(aIndex: Integer);
begin
  if (aIndex < 0) or (aIndex > FCount - 1) then
    Exit;
  FLists[aIndex].Clean;
end;

procedure TViActorScene.Clear(aIndex: Integer; aAttrs: TViActorAttributeSet);
begin
  if (aIndex < 0) or (aIndex > FCount - 1) then
    Exit;

  FLists[aIndex].Clear(aAttrs);
end;

procedure TViActorScene.ClearAll;
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
  begin
    FLists[I].Clear([]);
  end;
end;

procedure TViActorScene.Update(aAttrs: TViActorAttributeSet; aDeltaTime: Single);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
  begin
    FLists[I].Update(aAttrs, aDeltaTime);
  end;
end;

procedure TViActorScene.Render(aAttrs: TViActorAttributeSet;
  aBefore: TViActorSceneEvent; aAfter: TViActorSceneEvent);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
  begin
    if Assigned(aBefore) then
      aBefore(I);
    FLists[I].Render(aAttrs);
    if Assigned(aAfter) then
      aAfter(I);
  end;
end;

function TViActorScene.SendMessage(aAttrs: TViActorAttributeSet;
  aMsg: PViActorMessage; aBroadcast: Boolean): TViActor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FCount - 1 do
  begin
    Result := FLists[I].SendMessage(aAttrs, aMsg, aBroadcast);
    if not aBroadcast then
    begin
      if Result <> nil then
      begin
        Exit;
      end;
    end;
  end;
end;

{ --- TViActorEntity -------------------------------------------------------- }
constructor TViActorEntity.Create;
begin
  inherited;
  FEntity := TViEntity.Create;
end;

destructor TViActorEntity.Destroy;
begin
  FreeAndNil(FEntity);
  inherited;
end;

function TViActorEntity.Collide(aActor: TViActor; var aHitPos: TViVector): Boolean;
begin
  Result := False;
  if aActor is TViActorEntity then
  begin
    Result := FEntity.CollidePolyPoint(TViActorEntity(aActor).Entity,
      aHitPos);
  end
end;

function TViActorEntity.Overlap(aX, aY, aRadius,
  aShrinkFactor: Single): Boolean;
begin
  Result := FEntity.Overlap(aX, aY, aRadius, aShrinkFactor);
end;

function TViActorEntity.Overlap(aActor: TViActor): Boolean;
var
  e: TViActorEntity;
begin
  Result := False;
  if aActor is TViActorEntity then
  begin
    e := TViActorEntity(aActor);
    Result := FEntity.Overlap(e.Entity);
  end;
end;

procedure TViActorEntity.OnRender;
begin
  FEntity.Render(0,0);
end;


{ --- TViAIActorEntity ------------------------------------------------------ }
constructor TViAIActorEntity.Create;
begin
  inherited;
  FStateMachine := TViAIStateMachine.Create;
end;

destructor TViAIActorEntity.Destroy;
begin
  FreeAndNil(FStateMachine);
  inherited;
end;

procedure TViAIActorEntity.OnUpdate(aDeltaTime: Single);
begin
  // process states
  FStateMachine.Update(aDeltaTime);
end;

procedure TViAIActorEntity.OnRender;
begin
  // render state
  FStateMachine.Render;
end;

end.

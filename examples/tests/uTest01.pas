unit uTest01;

interface

procedure RunTest01;

implementation

uses
  System.SysUtils,
  Vivace.Allegro.API,
  Vivace.Common,
  Vivace.Speech,
  uTests;

procedure Test01;
begin
  WriteLn('Vivace ', cVivaceVersion);
  WaitForEnter;
end;

procedure Test02;
begin
  if al_init then
  begin
    WriteLn('Succesfully initialized Allegro');
    al_uninstall_system;
  end;
  WaitForEnter;
end;

procedure Test03;
var
  Spk: TViSpeech;
  I: Integer;
  S: string;
  Say: string;
begin
  Say := 'Vivace Game Toolkit';
  Spk := TViSpeech.Create;
  WriteLn(Format('Found %d speech voices: ', [Spk.GetVoiceCount]));
  for I := 0 to  Spk.GetVoiceCount-1 do
  begin
    Spk.ChangeVoice(I);
    S := Spk.GetVoiceAttribute(I, vaDescription);
    WriteLn;
    WriteLn(Format('Voice #%d: %s', [I+1, S]));
    Spk.Speak('Vivace Game Toolkit', True);
    WaitForEnter;
  end;
  FreeAndNil(Spk);
end;

procedure RunTest01;
begin
  //Test01;  // Vivace version
  //Test02;  // Init Allegro
  Test03;  // Speech;
end;



end.

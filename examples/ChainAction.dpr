program ChainAction;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Vivace.Game,
  uCommon in 'uCommon.pas',
  uChainAction in 'uChainAction.pas';

begin
  try
    ViRunGame(TChainActionDemo);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

program Elastic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Vivace.Game,
  uElastic in 'uElastic.pas',
  uCommon in 'uCommon.pas';

begin
  try
    ViRunGame(TElasticDemo);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

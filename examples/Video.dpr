program Video;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Vivace.Game,
  uVideo in 'uVideo.pas';

begin
  try
    ViRunGame(TVideoDemo);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

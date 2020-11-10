program TiledBitmap;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Vivace.Game,
  uTiledBitmap in 'uTiledBitmap.pas';

begin
  try
    ViRunGame(TTiledBitmapDemo);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

program ServerAuthSystem;

uses
  Windows,
  Classes,
  Forms,
  Main in 'Main.pas' {MainForm},
  ProcessorUsage in 'ProcessorUsage.pas',
  cHash in 'HashModules\cHash.pas',
  BaseUtils in 'BaseUtils.pas',
  PlayersUtils in 'PlayersUtils.pas',
  MySQLSupport in 'MySQLSupport.pas',
  OOPSocketsTCP in '..\..\# Common Modules\OOPSocketsTCP.pas',
  PipesAPI in '..\..\# Common Modules\PipesAPI.pas',
  ProcessAPI in '..\..\# Common Modules\ProcessAPI.pas',
  RegistryUtils in '..\..\# Common Modules\RegistryUtils.pas',
  CodepageAPI in '..\..\# Common Modules\CodepageAPI.pas';

{$R *.res}
{$R Font.res}
{$SETPEFLAGS $0001 or $0002 or $0004 or $0008 or $0010 or $0020 or $0200 or $0400 or $0800 or $1000}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function LoadResourceFont(Instance: THandle; FontName: String; ResType: PChar = RT_RCDATA): THandle;
var
  Res: TResourceStream;
  Count: Integer;
begin
  Res:= TResourceStream.Create(Instance, FontName, ResType);
  try
    Result := AddFontMemResourceEx(Res.Memory, Res.Size, nil, @Count);
  finally
    Res.Free;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure FreeResourceFont(Font: THandle);
begin
  RemoveFontMemResourceEx(Font);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

var
  MuseoSlabFont: THandle;

begin
  MuseoSlabFont := LoadResourceFont(hInstance, 'MUSEOSLAB', RT_RCDATA);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

  FreeResourceFont(MuseoSlabFont);
end.


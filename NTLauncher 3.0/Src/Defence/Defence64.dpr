program Defence64;


{$SETPEFLAGS $0001 or $0002 or $0004 or $0008 or $0010 or $0020 or $0200 or $0400 or $0800 or $1000}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

uses
  Windows,
  SysUtils,
  CodepageAPI in '..\..\..\# Common Modules\CodepageAPI.pas',
  MappingAPI in '..\..\..\# Common Modules\MappingAPI.pas',
  OOPSocketsTCP in '..\..\..\# Common Modules\OOPSocketsTCP.pas',
  Ratibor in '..\..\..\# Common Modules\Ratibor.pas';

const
  Salt: string = 'Соль';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure StartDefence; stdcall; external LibName;
procedure StopDefence; stdcall; external LibName;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function GetXMLParameter(Data: string; Param: string): string;
var
  PosStart, PosEnd: Word;
  StartParam, EndParam: string;
begin
  Result := '';
  StartParam := '<'+Param+'>';
  EndParam := '</'+Param+'>';
  PosStart := Pos(StartParam, Data);
  PosEnd := Pos(EndParam, Data);

  if PosStart = 0 then Exit;
  if PosEnd <= PosStart then Exit;

  PosStart := PosStart + Length(StartParam);
  Result := Copy(Data, PosStart, PosEnd - PosStart);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure KillTask(ProcessID: LongWord);
var
  ProcessHandle: THandle;
begin
  ProcessHandle := OpenProcess(PROCESS_TERMINATE, FALSE, ProcessID);
  TerminateProcess(ProcessHandle, 0);
  CloseHandle(ProcessHandle);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure WaitProcess(ProcessID: LongWord);
var
  ProcessHandle: THandle;
begin
  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, FALSE, ProcessID);
  if ProcessHandle = 0 then Exit;

  WaitForSingleObject(ProcessHandle, INFINITE);
  CloseHandle(ProcessHandle);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

var
  LauncherID, MinecraftID: Integer;
  UseWatchDog, UseInjectors: Boolean;

  Login: string;
  PrimaryIP, SecondaryIP: string;
  Port: Integer;
  CommandLine: string;

  Socket: TClientSocketTCP;
  Package: AnsiString;

  Threads: packed record
    MinecraftWait: THandle;
    LauncherWait: THandle;
  end;

  ThreadID: LongWord;

const
  PROCESS_MODE_BACKGROUND_BEGIN = $100000;
begin
  // Ставим минимальный приоритет:
  SetPriorityClass(GetCurrentProcess, PROCESS_MODE_BACKGROUND_BEGIN);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_LOWEST);

  CommandLine := GetCommandLine;

  // Получаем идентификаторы:
  if not TryStrToInt(GetXMLParameter(CommandLine, 'launcher_id'), LauncherID) then Exit;
  if not TryStrToInt(GetXMLParameter(CommandLine, 'minecraft_id'), MinecraftID) then Exit;

  // Получаем данные для соединения:
  Login       := GetXMLParameter(CommandLine, 'login');
  PrimaryIP   := GetXMLParameter(CommandLine, 'primary_ip');
  SecondaryIP := GetXMLParameter(CommandLine, 'secondary_ip');
  if not TryStrToInt(GetXMLParameter(CommandLine, 'port'), Port) then Exit;

  // Параметры защиты:
  UseWatchDog  := Pos('<wd>', CommandLine) <> 0;
  UseInjectors := Pos('<injectors>', CommandLine) <> 0;

  if not (UseWatchDog or UseInjectors) then Exit;

  // Включаем защиту:
  if UseInjectors then StartDefence;

  // Запускаем два потока ожидания:
  Threads.MinecraftWait := BeginThread(nil, 0, @WaitProcess, Pointer(MinecraftID), 0, ThreadID);
  Threads.LauncherWait := BeginThread(nil, 0, @WaitProcess, Pointer(LauncherID), 0, ThreadID);

  // Ждём, пока кто-либо из них завершится:
  WaitForMultipleObjects(2, @Threads, FALSE, INFINITE);

  CloseHandle(Threads.MinecraftWait);
  CloseHandle(Threads.LauncherWait);

  KillTask(MinecraftID);

  if UseWatchDog then
  begin
    Socket := TClientSocketTCP.Create;
    Socket.Timeout := 3500;

    Socket.ConnectToServer(WideToAnsi(PrimaryIP), Port);
    if Socket.ConnectionStatus then
    begin
      Package := WideToAnsi(Salt + '<wd><type>deauth</type><login>' + Login + '</login>');
      Socket.Send(PAnsiChar(Package), Length(Package));
    end
    else
    begin
      Socket.Disconnect;

      Socket.ConnectToServer(WideToAnsi(SecondaryIP), Port);
      if Socket.ConnectionStatus then
      begin
        Package := WideToAnsi(Salt + '<wd><type>deauth</type><login>' + Login + '</login>');
        Socket.Send(PAnsiChar(Package), Length(Package));
      end;
    end;

    Socket.Disconnect;
    Socket.Destroy;
  end;

  if UseInjectors then StopDefence;
end.

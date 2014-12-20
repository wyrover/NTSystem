unit Defence;

interface

uses
  Windows, SysUtils, Classes, LauncherSettings, ProcessAPI, Ratibor, MappingAPI;

{$I Definitions.inc}

// Поток ожидания завершения любого из процессов:
type
  TControlThread = class(TThread)
    protected
    MainFormHandle: THandle;

    {$IFDEF USE_INJECTORS}
    MappingObject: THandle;
    {$ENDIF}

    Use64: Boolean;

    Handles: packed record
      Minecraft: THandle;
      Injectors: packed record
        x32: THandle;
        x64: THandle;
      end;
    end;

    SendProc: procedure;
    procedure Execute; override;
    procedure SendDeauthMessage;
  end;

  TBeaconThread = class(TThread)
    Interval: LongWord;
    MCHandle: THandle;
    protected
    SendProc: procedure;
    procedure Execute; override;
    procedure SendBeaconMessage;
  end;

  TEuristicDefence = class(TThread)
    MinecraftID: LongWord;
    MCHandle: THandle;
    Interval: LongWord;
    protected
    procedure Execute; override;
  end;

procedure StartDefence(MinecraftHandle, MainFormHandle: THandle; Login: string; MinecraftID: LongWord; SendProcPtr: Pointer);
procedure StartEuristicDefence(MinecraftHandle: THandle; MinecraftID: LongWord; Interval: LongWord);
procedure StartBeacon(MinecraftHandle: THandle; Delay: LongWord; SendProcPtr: Pointer);
procedure StartProcess(CommandLine: string; out ProcessHandle: THandle; out ProcessID: LongWord);

{$IFDEF CONTROL_PROCESSES}
{$R Defence.res}
{$ENDIF}

const
  Injector32Name: string = 'Defence32.exe';
  Injector64Name: string = 'Defence64.exe';
  HookLib32Name: string = 'RatiborLib32.dll';
  HookLib64Name: string = 'RatiborLib64.dll';

implementation

function GetProcessId(Handle: THandle): LongWord; stdcall; external 'kernel32.dll';


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


procedure StartProcess(CommandLine: string; out ProcessHandle: THandle; out ProcessID: LongWord);
var
  ProcessInfo: _PROCESS_INFORMATION;
  StartupInfo: _STARTUPINFOA;
begin
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  FillChar(ProcessInfo, SizeOf(ProcessInfo), #0);

  StartupInfo.wShowWindow := SW_SHOWNORMAL;

  CreateProcess(
                 nil,
                 PAnsiChar(CommandLine),
                 nil,
                 nil,
                 FALSE,
                 0,
                 nil,
                 nil,
                 StartupInfo,
                 ProcessInfo
                );

  CloseHandle(ProcessInfo.hThread);

  ProcessHandle := ProcessInfo.hProcess;
  ProcessID := ProcessInfo.dwProcessId;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure ExtractRes(ResName, FileName: string);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(hInstance, ResName, RT_RCDATA);
  Res.SaveToFile(FileName);
  Res.Free;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function Is64BitWindows: Boolean;
{$IFNDEF CPUX64}
var
  Wow64Process: Bool;
  IsWow64Process: function(ProcessHandle: THandle; out Wow64Process: BOOL): BOOL; stdcall;
{$ENDIF}
begin
{$IFDEF CPUX64}
  Result := True;
{$ELSE}
  IsWow64Process := GetProcAddress(GetModuleHandle(kernel32), 'IsWow64Process');
  Wow64Process := false;
  if Assigned(IsWow64Process) then Wow64Process := IsWow64Process(GetCurrentProcess, Wow64Process) and Wow64Process;

  Result := Wow64Process;
{$ENDIF}
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function FindOverlappings(const MainStr, SubStr: string): Word;
var
  TempStr: string;
  StartPos, SubStrLength: Word;
begin
  TempStr := MainStr;
  Result := 0;
  SubStrLength := Length(SubStr);

  StartPos := Pos(SubStr, TempStr);
  while StartPos <> 0 do
  begin
    Delete(TempStr, 1, StartPos + SubStrLength - 1);
    Inc(Result);
    StartPos := Pos(SubStr, TempStr);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure KillOverlappingProcesses(MinecraftID: LongWord);
var
  ProcessList: TProcessList;
  ProcessInfo: PROCESS_INFO;
  I, ProcessLength: Word;
begin

    GetProcessList(ProcessList);
    ProcessLength := Length(ProcessList);

    for I := 0 to ProcessLength - 1 do
    begin
      // Получаем всю информацию о каждом процессе:
      GetProcessInfo(ProcessList[I].ProcessID, ProcessInfo);

      // Приводим всё в нижний регистр:
      ProcessInfo.CommandLine := LowerCase(ProcessInfo.CommandLine);

      if ProcessInfo.ID = MinecraftID then Continue; // А не наш ли это процесс?

      if
        (ProcessInfo.ReservedMemory shr 20 > 64) // Процесс не наш, но ест память?
        and
        (
          (FindOverlappings(ProcessInfo.CommandLine, '.jar') > 2) // И джаров там больше двух?
          or
          (Pos('net.minecraft.client.main.main', ProcessInfo.CommandLine) <> 0) // И даже классы совпадают?!
          or
          (Pos('net.minecraft.launchwrapper.launch', ProcessInfo.CommandLine) <> 0) // Да там ещё и фордж!!
        )
      then
        KillTask(ProcessList[I].ProcessID); // Да провались оно всё, валим его, братан!
    end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure StartEuristicDefence(MinecraftHandle: THandle; MinecraftID: LongWord; Interval: LongWord);
var
  EuristicDefence: TEuristicDefence;
begin
  EuristicDefence := TEuristicDefence.Create(True);
  EuristicDefence.MCHandle := MinecraftHandle;
  EuristicDefence.MinecraftID := MinecraftID;
  EuristicDefence.Interval := Interval;
  EuristicDefence.FreeOnTerminate := True;
  EuristicDefence.Priority := tpLower;
  EuristicDefence.Resume;
end;



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


{ TEuristicDefence }

procedure TEuristicDefence.Execute;
begin
  inherited;
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_LOWEST);
  while WaitForSingleObject(MCHandle, Interval) = WAIT_TIMEOUT do
    KillOverlappingProcesses(MinecraftID);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure StartDefence(MinecraftHandle, MainFormHandle: THandle; Login: string; MinecraftID: LongWord; SendProcPtr: Pointer);
var
  ControlThread: TControlThread;
  Use64: Boolean;
  ProcessID: LongWord;
  MinecraftIDStr, LauncherIDStr: string;
  {$IFDEF USE_INJECTORS}
  HookInfo: THookInfo;
  {$ENDIF}
begin
  ControlThread := TControlThread.Create(True);

  ControlThread.MainFormHandle := MainFormHandle;
  ShowWindow(ControlThread.MainFormHandle, SW_HIDE);

  MinecraftIDStr := IntToStr(MinecraftID);
  LauncherIDStr := IntToStr(GetCurrentProcessID);

  // Используем ли 64х-битные защитники:
  Use64 := Is64BitWindows;
  ControlThread.Use64 := Use64;

  // Удаляем временные файлы:
  DeleteFile(Injector32Name);
  DeleteFile(Injector64Name);
  DeleteFile(HookLib32Name);
  DeleteFile(HookLib64Name);

  // Заполняем структуру хэндлов:
  ControlThread.Handles.Minecraft := MinecraftHandle;
  ControlThread.Handles.Injectors.x32 := INVALID_HANDLE_VALUE;
  ControlThread.Handles.Injectors.x64 := INVALID_HANDLE_VALUE;

  {$IFDEF USE_INJECTORS}
  // Настраиваем перехват:
  ControlThread.MappingObject := 0;
  FillChar(HookInfo, SizeOf(THookInfo), #0);
  HookInfo.ProtectedProcess := GetCurrentProcessID;
  HookInfo.InvalidateProcessID := INVALIDATE_PROCESS_ID;
  ControlThread.MappingObject := SetDefenceParameters(HookInfo, ControlThread.MappingObject);
  {$ENDIF}

  // Распаковываем и запускаем защитников:
  if not FileExists(Injector32Name) then
    ExtractRes('DEFENCE32', Injector32Name);

  if not FileExists(HookLib32Name) then
    ExtractRes('HOOKLIB32', HookLib32Name);

  StartProcess(
                Injector32Name + ' ' +
                '<login>' + Login + '</login>' +
                '<minecraft_id>' + MinecraftIDStr + '</minecraft_id>' +
                '<launcher_id>' + LauncherIDStr + '</launcher_id>' +
                '<primary_ip>' + PrimaryIP + '</primary_ip>' +
                '<secondary_ip>' + SecondaryIP + '</secondary_ip>' +
                '<port>' + IntToStr(ServerPort) + '</port>'
                {$IFDEF USE_INJECTORS}+ '<injectors>'{$ENDIF}
                {$IFDEF USE_WATCHDOG}+ '<wd>'{$ENDIF},
                ControlThread.Handles.Injectors.x32,
                ProcessID
               );

  if Use64 then
  begin
    if not FileExists(Injector64Name) then
      ExtractRes('DEFENCE64', Injector64Name);

    if not FileExists(HookLib64Name) then
      ExtractRes('HOOKLIB64', HookLib64Name);

    StartProcess(
                  Injector64Name + ' ' +
                  '<login>' + Login + '</login>' +
                  '<minecraft_id>' + MinecraftIDStr + '</minecraft_id>' +
                  '<launcher_id>' + LauncherIDStr + '</launcher_id>' +
                  '<primary_ip>' + PrimaryIP + '</primary_ip>' +
                  '<secondary_ip>' + SecondaryIP + '</secondary_ip>' +
                  '<port>' + IntToStr(ServerPort) + '</port>'
                  {$IFDEF USE_INJECTORS} + '<injectors>' {$ENDIF}
                  {$IFDEF USE_WATCHDOG} + '<wd>' {$ENDIF},
                  ControlThread.Handles.Injectors.x64,
                  ProcessID
                 );

  end;


  // Запускаем поток:
  ControlThread.FreeOnTerminate := True;
  ControlThread.Priority := tpLower;
  ControlThread.SendProc := SendProcPtr;
  ControlThread.Resume;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


{ TControlProcessesThread }

procedure TControlThread.Execute;
begin
  inherited;

  // Ждём, пока кто-либо закроется:
  if Use64 then
    WaitForMultipleObjects(3, @Handles, FALSE, INFINITE)
  else
    WaitForMultipleObjects(2, @Handles, FALSE, INFINITE);

  // Убиваем процесс майна:
  TerminateProcess(Handles.Minecraft, 0);

  // Ждём, пока закроются инъекторы:
  WaitForMultipleObjects(2, @Handles.Injectors, TRUE, 7000);

  // Убиваем процессы инъекторов:
  TerminateProcess(Handles.Injectors.x32, 0);
  TerminateProcess(Handles.Injectors.x64, 0);

  // Закрываем хэндлы:
  CloseHandle(Handles.Minecraft);
  CloseHandle(Handles.Injectors.x32);
  CloseHandle(Handles.Injectors.x64);

  DeleteFile(Injector32Name);
  DeleteFile(Injector64Name);
  DeleteFile(HookLib32Name);
  DeleteFile(HookLib64Name);

  {$IFDEF USE_INJECTORS}
  CloseFileMapping(MappingObject);
  {$ENDIF}

  Synchronize(SendDeauthMessage);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TControlThread.SendDeauthMessage;
begin
  SendProc;
  ShowWindow(Self.MainFormHandle, SW_SHOWNORMAL);
  SetForegroundWindow(Self.MainFormHandle);
end;



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Запуск маячка:
procedure StartBeacon(MinecraftHandle: THandle; Delay: LongWord; SendProcPtr: Pointer);
var
  BeaconThread: TBeaconThread;
begin
  BeaconThread := TBeaconThread.Create(True);
  BeaconThread.MCHandle := MinecraftHandle;
  BeaconThread.Interval := Delay;
  BeaconThread.SendProc := SendProcPtr;
  BeaconThread.FreeOnTerminate := True;
  BeaconThread.Priority := tpLower;
  BeaconThread.Resume;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


{ TBeaconThread }

procedure TBeaconThread.Execute;
begin
  inherited;
  while WaitForSingleObject(MCHandle, Interval) = WAIT_TIMEOUT do
  begin
    Synchronize(SendBeaconMessage);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TBeaconThread.SendBeaconMessage;
begin
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_LOWEST);
  SendProc;
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_NORMAL);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


end.

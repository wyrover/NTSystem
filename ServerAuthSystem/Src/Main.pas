unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ComCtrls, ScktComp, ExtCtrls, ShellAPI, OOPSocketsTCP,
  RegistryUtils, PipesAPI, BaseUtils, PlayersUtils, Grids, ValEdit,
  ProcessorUsage, ProcessAPI, Menus, MySQLSupport, IniFiles;

type
  TMainForm = class(TForm)
    PageControl: TPageControl;
    MainPage: TTabSheet;
    SocketConsolePage: TTabSheet;
    ServerConsolePage: TTabSheet;
    ServerPathButton: TButton;
    SelfPathButton: TButton;
    GroupBox1: TGroupBox;
    SaveSettingsButton: TButton;
    Label1: TLabel;
    JavaPathEdit: TEdit;
    Label2: TLabel;
    RAMEdit: TEdit;
    Label3: TLabel;
    JVMParamsEdit: TEdit;
    Label4: TLabel;
    ServerPathEdit: TEdit;
    Label5: TLabel;
    LauncherVersionEdit: TEdit;
    CheckMD5: TCheckBox;
    SaltedHash: TCheckBox;
    Label6: TLabel;
    ChecksumEdit: TEdit;
    SaltWatchDog: TCheckBox;
    Label7: TLabel;
    GlobalSaltEdit: TEdit;
    CheckHWIDOnLogin: TCheckBox;
    CheckHWIDOnReg: TCheckBox;
    WorkAsDistributor: TCheckBox;
    AllGranted: TRadioButton;
    LocalBase: TRadioButton;
    UseDistributor: TRadioButton;
    SocketConsole: TMemo;
    ServerConsole: TMemo;
    Label8: TLabel;
    SocketPortEdit: TEdit;
    ServerSocket: TServerSocket;
    StartSocketButton: TButton;
    StartServerButton: TButton;
    Label9: TLabel;
    IPLabel: TLabel;
    Label10: TLabel;
    SocketStatusLabel: TLabel;
    Label12: TLabel;
    ServerStatusLabel: TLabel;
    Label14: TLabel;
    RAMLabel: TLabel;
    Label16: TLabel;
    CPULabel: TLabel;
    Label18: TLabel;
    DistributorIPEdit: TEdit;
    Label19: TLabel;
    DistributorPortEdit: TEdit;
    DeletePlayersOnEnter: TCheckBox;
    AutorestartCheckbox: TCheckBox;
    CommandEdit: TEdit;
    SendCommandButton: TButton;
    TimeoutEdit: TEdit;
    PlayersList: TStringGrid;
    DeletePlayersOnTimer: TCheckBox;
    Label11: TLabel;
    Panel1: TPanel;
    Label13: TLabel;
    Label20: TLabel;
    PluginIPEdit: TEdit;
    Label21: TLabel;
    PluginPortEdit: TEdit;
    ShowDeauthMessages: TCheckBox;
    ShowBeaconMessages: TCheckBox;
    ShowPluginMessages: TCheckBox;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    ThreadsCountLabel: TLabel;
    ServerCPULabel: TLabel;
    HandlesCountLabel: TLabel;
    FlushServerMemory: TCheckBox;
    TabSheet1: TTabSheet;
    PlayersGrid: TStringGrid;
    PopupMenu: TPopupMenu;
    Kick: TMenuItem;
    Ban: TMenuItem;
    HWIDBan: TMenuItem;
    AddWhitelist: TMenuItem;
    RemoveWhitelist: TMenuItem;
    AddAuthList: TMenuItem;
    RemoveAuthList: TMenuItem;
    AddOperator: TMenuItem;
    Unban: TMenuItem;
    RemoveOperator: TMenuItem;
    AddAuthListWithoutTimer: TMenuItem;
    Label15: TLabel;
    PluginTimeoutEdit: TEdit;
    BanIP: TMenuItem;
    UnbanIP: TMenuItem;
    UseMySQL: TCheckBox;
    Label17: TLabel;
    LoginPassRequest: TEdit;
    Label25: TLabel;
    LoginMailRequest: TEdit;
    Label26: TLabel;
    InsertRequest: TEdit;
    Label27: TLabel;
    dbHostEdit: TEdit;
    Label28: TLabel;
    dbPortEdit: TEdit;
    Label29: TLabel;
    dbLoginEdit: TEdit;
    Label30: TLabel;
    dbPasswordEdit: TEdit;
    Label31: TLabel;
    dbBaseEdit: TEdit;
    SaveSettingsToFileButton: TButton;
    procedure SelfPathButtonClick(Sender: TObject);
    procedure ServerPathButtonClick(Sender: TObject);
    procedure SaveSettingsButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartSocketButtonClick(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure StartServerButtonClick(Sender: TObject);
    procedure CommandEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SendCommandButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SocketConsoleChange(Sender: TObject);
    procedure ServerConsoleChange(Sender: TObject);
    procedure PlayersGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlayersGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FillStringGrid;
    procedure KickClick(Sender: TObject);
    procedure BanClick(Sender: TObject);
    procedure UnbanClick(Sender: TObject);
    procedure HWIDBanClick(Sender: TObject);
    procedure AddWhitelistClick(Sender: TObject);
    procedure RemoveWhitelistClick(Sender: TObject);
    procedure AddAuthListClick(Sender: TObject);
    procedure RemoveAuthListClick(Sender: TObject);
    procedure AddOperatorClick(Sender: TObject);
    procedure RemoveOperatorClick(Sender: TObject);
    procedure AddAuthListWithoutTimerClick(Sender: TObject);
    procedure BanIPClick(Sender: TObject);
    procedure UnbanIPClick(Sender: TObject);
    procedure SaveSettingsToFileButtonClick(Sender: TObject);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ExceptionHandler(Sender: TObject; E: Exception);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

// Поток чтения консоли:
type
  TConsoleThread = class(TThread)
    protected
    ConsoleText: string;
    procedure Execute; override;
    procedure UpdateForm;
    procedure ServerTerminated;
  end;

// Поток контроля игроков:
type
  TPlayersControlThread = class(TThread)
    protected
    procedure Execute; override;
    procedure UpdatePlayersList;
  end;

// Поток мониторинга:
type
  TMonitoringThread = class(TThread)
    protected
    RAM: string;
    CPU: string;
    ThreadsCount: string;
    HandlesCount: string;
    ServerCPU: string;
    ServerCPUColor: TColor;
    CPUColor: TColor;
    procedure Execute; override;
    procedure UpdateForm;
  end;


type
  TMemoryStatusEx = record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: Int64;
    ullAvailPhys: Int64;
    ullTotalPageFile: Int64;
    ullAvailPageFile: Int64;
    ullTotalVirtual: Int64;
    ullAvailVirtual: Int64;
    ullAvailExtendedVirtual: Int64;
  end;
 
procedure GlobalMemoryStatusEx(var lpBuffer:TMemoryStatusEx); stdcall;
                  external kernel32 name 'GlobalMemoryStatusEx';

function EmptyWorkingSet(hProcess: THandle): BOOL; stdcall; external 'psapi.dll';


const
  RegistryPath: string = 'ServerAuthSystem';
  SettingsFile: string = 'config.ini';
  SettingsSection: string = 'Настройки обвязки';

var
  ServerStatus: Boolean = False;
  PipesInfo: TPipeInformation;
  CriticalSection: _RTL_CRITICAL_SECTION;

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

procedure TMainForm.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if E is ESocketError then Exit;
  MessageBox(Handle, PAnsiChar(E.Message), 'Ошибка!', MB_ICONERROR);;
end;

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

procedure TMainForm.FormCreate(Sender: TObject);
var
  TempString: string;
begin
  Application.OnException := ExceptionHandler;

  IPLabel.Caption := GetIP;

  PlayersGrid.PopupMenu := PopupMenu;

  with TMonitoringThread.Create(False) do
  begin
    Priority := tpLower;
    FreeOnTerminate := True;
  end;

  PlayersList.Cells[0, 0] := 'Игроки';
  PlayersList.Cells[1, 0] := 'Таймер';

  InitializeCriticalSection(CriticalSection);
  InitializeCriticalSection(PlayersCriticalSection);

  if not FileExists(SettingsFile) then
  begin
    JavaPathEdit.Text        := ReadStringFromRegistry(RegistryPath, 'JavaPath', 'C:\Program Files\Java\jre8\bin');
    RAMEdit.Text             := ReadStringFromRegistry(RegistryPath, 'RAM', '3072');
    ServerPathEdit.Text      := ReadStringFromRegistry(RegistryPath, 'ServerPath', 'D:\Minecraft\Spigot\Spigot.jar');
    ChecksumEdit.Text        := ReadStringFromRegistry(RegistryPath, 'MD5', 'e9960995974979445b03bc644b9e9853');
    SocketPortEdit.Text      := ReadStringFromRegistry(RegistryPath, 'Port', '65533');
    LauncherVersionEdit.Text := ReadStringFromRegistry(RegistryPath, 'LauncherVersion', '0');
    DistributorIPEdit.Text   := ReadStringFromRegistry(RegistryPath, 'DistributorIP', '127.0.0.1');
    DistributorPortEdit.Text := ReadStringFromRegistry(RegistryPath, 'DistributorPort', '65533');
    PluginIPEdit.Text        := ReadStringFromRegistry(RegistryPath, 'PluginIP', '127.0.0.1');
    PluginPortEdit.Text      := ReadStringFromRegistry(RegistryPath, 'PluginPort', '35533');
    GlobalSaltEdit.Text      := ReadStringFromRegistry(RegistryPath, 'GlobalSalt', 'Соль');
    JVMParamsEdit.Text       := ReadStringFromRegistry(RegistryPath, 'JVMParams', JVMParamsEdit.Text);

    dbHostEdit.Text       := ReadStringFromRegistry(RegistryPath, 'dbHost', dbHostEdit.Text);
    dbPortEdit.Text       := ReadStringFromRegistry(RegistryPath, 'dbPort', dbPortEdit.Text);
    dbLoginEdit.Text      := ReadStringFromRegistry(RegistryPath, 'dbLogin', dbLoginEdit.Text);
    dbPasswordEdit.Text   := ReadStringFromRegistry(RegistryPath, 'dbPassword', dbPasswordEdit.Text);
    dbBaseEdit.Text       := ReadStringFromRegistry(RegistryPath, 'dbBaseName', dbBaseEdit.Text);
    LoginPassRequest.Text := ReadStringFromRegistry(RegistryPath, 'LoginPassRequest', LoginPassRequest.Text);
    LoginMailRequest.Text := ReadStringFromRegistry(RegistryPath, 'LoginMailRequest', LoginMailRequest.Text);
    InsertRequest.Text    := ReadStringFromRegistry(RegistryPath, 'InsertRequest', InsertRequest.Text);

    CheckMD5.Checked             := ReadBooleanFromRegistry(RegistryPath, 'CheckMD5', False);
    SaltedHash.Checked           := ReadBooleanFromRegistry(RegistryPath, 'Salt', False);
    CheckHWIDOnLogin.Checked     := ReadBooleanFromRegistry(RegistryPath, 'LoginHWID', False);
    CheckHWIDOnReg.Checked       := ReadBooleanFromRegistry(RegistryPath, 'RegHWID', False);
    WorkAsDistributor.Checked    := ReadBooleanFromRegistry(RegistryPath, 'WorkAsDistributor', False);
    SaltWatchDog.Checked         := ReadBooleanFromRegistry(RegistryPath, 'SaltWatchDog', False);
    DeletePlayersOnEnter.Checked := ReadBooleanFromRegistry(RegistryPath, 'DeletePlayersOnEnter', False);
    DeletePlayersOnTimer.Checked := ReadBooleanFromRegistry(RegistryPath, 'DeletePlayersOnTimer', True);
    AutorestartCheckbox.Checked  := ReadBooleanFromRegistry(RegistryPath, 'Autorestart', False);
    ShowDeauthMessages.Checked   := ReadBooleanFromRegistry(RegistryPath, 'ShowDeauthMessages', False);
    ShowBeaconMessages.Checked   := ReadBooleanFromRegistry(RegistryPath, 'ShowBeaconMessages', False);
    ShowPluginMessages.Checked   := ReadBooleanFromRegistry(RegistryPath, 'ShowPluginMessages', False);
    FlushServerMemory.Checked    := ReadBooleanFromRegistry(RegistryPath, 'FlushServerMemory', False);
    UseMySQL.Checked             := ReadBooleanFromRegistry(RegistryPath, 'UseMySQL', False);

    TempString := ReadStringFromRegistry(RegistryPath, 'AuthMode', 'granted');
    AllGranted.Checked     := TempString = 'granted';
    LocalBase.Checked      := TempString = 'base';
    UseDistributor.Checked := TempString = 'use distributor';
  end
  else
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + SettingsFile) do
  begin
    JavaPathEdit.Text        := ReadString(SettingsSection, 'JavaPath', 'C:\Program Files\Java\jre8\bin');
    RAMEdit.Text             := ReadString(SettingsSection, 'RAM', '3072');
    ServerPathEdit.Text      := ReadString(SettingsSection, 'ServerPath', 'D:\Minecraft\Spigot\Spigot.jar');
    ChecksumEdit.Text        := ReadString(SettingsSection, 'MD5', 'e9960995974979445b03bc644b9e9853');
    SocketPortEdit.Text      := ReadString(SettingsSection, 'Port', '65533');
    LauncherVersionEdit.Text := ReadString(SettingsSection, 'LauncherVersion', '0');
    DistributorIPEdit.Text   := ReadString(SettingsSection, 'DistributorIP', '127.0.0.1');
    DistributorPortEdit.Text := ReadString(SettingsSection, 'DistributorPort', '65533');
    PluginIPEdit.Text        := ReadString(SettingsSection, 'PluginIP', '127.0.0.1');
    PluginPortEdit.Text      := ReadString(SettingsSection, 'PluginPort', '35533');
    GlobalSaltEdit.Text      := ReadString(SettingsSection, 'GlobalSalt', 'Соль');
    JVMParamsEdit.Text       := ReadString(SettingsSection, 'JVMParams', JVMParamsEdit.Text);

    dbHostEdit.Text       := ReadString(SettingsSection, 'dbHost', dbHostEdit.Text);
    dbPortEdit.Text       := ReadString(SettingsSection, 'dbPort', dbPortEdit.Text);
    dbLoginEdit.Text      := ReadString(SettingsSection, 'dbLogin', dbLoginEdit.Text);
    dbPasswordEdit.Text   := ReadString(SettingsSection, 'dbPassword', dbPasswordEdit.Text);
    dbBaseEdit.Text       := ReadString(SettingsSection, 'dbBaseName', dbBaseEdit.Text);
    LoginPassRequest.Text := ReadString(SettingsSection, 'LoginPassRequest', LoginPassRequest.Text);
    LoginMailRequest.Text := ReadString(SettingsSection, 'LoginMailRequest', LoginMailRequest.Text);
    InsertRequest.Text    := ReadString(SettingsSection, 'InsertRequest', InsertRequest.Text);

    CheckMD5.Checked             := ReadBool(SettingsSection, 'CheckMD5', False);
    SaltedHash.Checked           := ReadBool(SettingsSection, 'Salt', False);
    CheckHWIDOnLogin.Checked     := ReadBool(SettingsSection, 'LoginHWID', False);
    CheckHWIDOnReg.Checked       := ReadBool(SettingsSection, 'RegHWID', False);
    WorkAsDistributor.Checked    := ReadBool(SettingsSection, 'WorkAsDistributor', False);
    SaltWatchDog.Checked         := ReadBool(SettingsSection, 'SaltWatchDog', False);
    DeletePlayersOnEnter.Checked := ReadBool(SettingsSection, 'DeletePlayersOnEnter', False);
    DeletePlayersOnTimer.Checked := ReadBool(SettingsSection, 'DeletePlayersOnTimer', True);
    AutorestartCheckbox.Checked  := ReadBool(SettingsSection, 'Autorestart', False);
    ShowDeauthMessages.Checked   := ReadBool(SettingsSection, 'ShowDeauthMessages', False);
    ShowBeaconMessages.Checked   := ReadBool(SettingsSection, 'ShowBeaconMessages', False);
    ShowPluginMessages.Checked   := ReadBool(SettingsSection, 'ShowPluginMessages', False);
    FlushServerMemory.Checked    := ReadBool(SettingsSection, 'FlushServerMemory', False);
    UseMySQL.Checked             := ReadBool(SettingsSection, 'UseMySQL', False);

    TempString := ReadString(SettingsSection, 'AuthMode', 'granted');
    AllGranted.Checked     := TempString = 'granted';
    LocalBase.Checked      := TempString = 'base';
    UseDistributor.Checked := TempString = 'use distributor';
  end;

  FillStringGrid;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if ServerStatus then
  begin
    with PipesInfo do
    begin
      DestroyPipes(StdIn, WriteStdIn, StdOut, ReadStdOut);
      DestroyConsole(ProcessInfo.hProcess, ProcessInfo.hThread, True);
    end;
  end;
end;








//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//
//
//                           Функции сервера
//
//
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.StartServerButtonClick(Sender: TObject);
var
  IsSocketAlreadyOpened: Boolean;
begin
  case ServerStatus of
    False:
    begin
      ServerConsole.Clear;

      // Получаем статус сокета:
      IsSocketAlreadyOpened := ServerSocket.Active;

      // Если сокет запущен - выключаем для предотвращения наследования сокета:
      if IsSocketAlreadyOpened then ServerSocket.Close;

      EnterCriticalSection(CriticalSection);
      // Создаём новую консоль:
      if not CreatePipes(
                          nil,
                          PAnsiChar(
                            JavaPathEdit.Text + '\java.exe ' +
                            '-Xms' + RAMEdit.Text + 'm ' +
                            '-Xmx' + RAMEdit.Text + 'm ' +
                            JVMParamsEdit.Text + ' ' +
                            '-jar ' + ServerPathEdit.Text
                          ),
                          PAnsiChar(
                            ExtractFilePath(ServerPathEdit.Text)
                          ),
                          SW_HIDE,
                          REDIRECT_ALL,
                          PipesInfo
                         ) then
      begin
        LeaveCriticalSection(CriticalSection);

        // Если сокет был запущен - запускаем снова:
        if IsSocketAlreadyOpened then ServerSocket.Open;

        MessageBox(Handle, 'Не получилось запустить сервер!', 'Ошибка!', MB_ICONERROR);
        Exit;
      end;

      ServerStatus := True;
      LeaveCriticalSection(CriticalSection);

      // Если сокет был запущен - запускаем снова:
      if IsSocketAlreadyOpened then ServerSocket.Open;

      StartServerButton.Caption := 'Остановить сервер';
      ServerStatusLabel.Caption := 'Включен';
      ServerStatusLabel.Font.Color := clGreen;

      // Запускаем поток чтения консоли:
      with TConsoleThread.Create(False) do
      begin
        FreeOnTerminate := True;
        Priority := tpLower;
      end;
    end;


    True:
    with PipesInfo do
    begin
      EnterCriticalSection(CriticalSection);
      DestroyPipes(StdIn, WriteStdIn, StdOut, ReadStdOut);
      DestroyConsole(ProcessInfo.hProcess, ProcessInfo.hThread, True);
      ServerStatus := False;
      LeaveCriticalSection(CriticalSection);

      StartServerButton.Caption := 'Запустить сервер';
      ServerStatusLabel.Caption := 'Выключен';
      ServerStatusLabel.Font.Color := clMaroon;
    end;
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


{ TConsoleThread }

procedure TConsoleThread.Execute;
var
  StringLen: LongWord;
begin
  inherited;

  while WaitForSingleObject(PipesInfo.ProcessInfo.hProcess, 100) = WAIT_TIMEOUT do
  begin
    EnterCriticalSection(CriticalSection);
    ConsoleText := ReadConsole(PipesInfo.ReadStdOut);
    LeaveCriticalSection(CriticalSection);
    StringLen := Length(ConsoleText);
    if StringLen = 0 then Continue;

    // Удаляем перевод каретки в конце:
    Delete(ConsoleText, StringLen - 1, 2);
    if (Pos(#8, ConsoleText) = 0) and (Pos(#20, ConsoleText) = 0) then Synchronize(UpdateForm);
  end;

  // Клиент завершился, обрабатываем это событие:
  Synchronize(ServerTerminated);
end;

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

procedure TConsoleThread.UpdateForm;
begin
  MainForm.ServerConsole.Lines.Add(ConsoleText);
end;

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

procedure TConsoleThread.ServerTerminated;
begin
  if ServerStatus then
  begin
    // Если сервер непредвиденно завершился, закрываем хэндлы:
    with PipesInfo do
    begin
      EnterCriticalSection(CriticalSection);
      DestroyPipes(StdIn, WriteStdIn, StdOut, ReadStdOut);
      DestroyConsole(ProcessInfo.hProcess, ProcessInfo.hThread, True);
      ServerStatus := False;
      LeaveCriticalSection(CriticalSection);
    end;

    case MainForm.AutorestartCheckbox.Checked of
      True:
      with MainForm do
      begin
        StartServerButton.OnClick(MainForm);
      end;

      False:
      with MainForm do
      begin
        MessageBox(Handle, 'Непредвиденное завершение сервера!', 'Ошибка!', MB_ICONERROR);

        StartServerButton.Caption := 'Запустить сервер';
        ServerStatusLabel.Caption := 'Выключен';
        ServerStatusLabel.Font.Color := clMaroon;
      end;
    end;
  end;
end;

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//
//
//                           Функции сокета
//
//
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.StartSocketButtonClick(Sender: TObject);
var
  PlayersControlThread: TPlayersControlThread;
  SQLParams: TSQLParams;
  Error: string;
begin
  case ServerSocket.Active of
    False:
    begin
      SocketConsole.Clear;

      // Проверяем соединение с MySQL-сервером:
      if UseMySQL.Checked then
      begin
        if not IsMySQLInit then InitMySQL;

        SQLParams.dbHost := dbHostEdit.Text;
        SQLParams.dbPort := StrToInt(dbPortEdit.Text);
        SQLParams.dbUser := dbLoginEdit.Text;
        SQLParams.dbPassword := dbPasswordEdit.Text;
        SQLParams.dbBaseName := dbBaseEdit.Text;

        if not CheckConnection(SQLParams, Error) then
        begin
          MessageBox(Handle, PAnsiChar('Не удалось подключиться к MySQL-базе!' + #13#10 + 'Ошибка: ' + Error), 'Ошибка!', MB_ICONERROR);
          DeinitMySQL;
          Exit;
        end;
      end;

      // Открываем сокет:
      ServerSocket.Port := StrToInt(SocketPortEdit.Text);
      try
        ServerSocket.Open;
      except
        on E: Exception do
        begin
          MessageBox(Handle, PAnsiChar('Ошибка при запуске сокета:' + #13#10 + E.Message), 'Ошибка!', MB_ICONERROR);
          Exit;
        end;
      end;

      // Запускаем поток контроля игроков:
      PlayersControlThread := TPLayersControlThread.Create(False);
      PlayersControlThread.Priority := tpLower;
      PlayersControlThread.FreeOnTerminate := True;

      StartSocketButton.Caption := 'Остановить обвязку';
      SocketStatusLabel.Caption := 'Включен';
      SocketStatusLabel.Font.Color := clGreen;
    end;

    True:
    begin
      ServerSocket.Close;
      StartSocketButton.Caption := 'Запустить обвязку';
      SocketStatusLabel.Caption := 'Выключен';
      SocketStatusLabel.Font.Color := clMaroon;
    end;
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
const
  General    : string = 'Общая ошибка';
  Send       : string = 'Ошибка при отправке данных';
  Receive    : string = 'Ошибка при получении данных';
  Connect    : string = 'Ошибка при подключении';
  Disconnect : string = 'Ошибка при отключении';
  Accept     : string = 'Ошибка при принятии запроса от клиента';
  Lookup     : string = 'Ошибка при обзоре сети';
var
  ErrorString: string;
begin
  case ErrorEvent of
    eeGeneral    : ErrorString := General;
    eeSend       : ErrorString := Send;
    eeReceive    : ErrorString := Receive;
    eeConnect    : ErrorString := Connect;
    eeDisconnect : ErrorString := Disconnect;
    eeAccept     : ErrorString := Accept;
    eeLookup     : ErrorString := Lookup;
  else
    ErrorString := 'Неизвестная ошибка сети';
  end;

  // Пишем отчёт:
  SocketConsole.Lines.Add(
                          '[' + TimeToStr(Now) + '] Ошибка в сокете клиента ' + Socket.RemoteAddress + ':' + #13#10#13#10 +
                          '   ErrorEvent : ' + ErrorString + #13#10 +
                          '   ErrorCode  : ' + IntToStr(ErrorCode) + #13#10#13#10 +
                          '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
  );
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  LauncherVersion: string;
  Data: string;
  Action, Login, Password, Mail, Checksum, HWID: string;
  IsWatchDog: Boolean;
  T1, T2, Frequency: Int64;
  Response: string;

  UserInBase: Boolean;

  PluginCommand: string;
  ConnectionStatus: Boolean;

  Buffer: Pointer;
  hFile: THandle;
  Size: LongWord;

  SQLParams: TSQLParams;
  SQLInsertParams: TSQLInsertParams;
  SQLRequest: string;
const
  RESPONSE_SUCCESS:          string = '<response>success</response>';
  RESPONSE_BAD_LOGIN:        string = '<response>bad login</response>';
  RESPONSE_ALREADY_EXISTS:   string = '<response>already exists</response>';
  RESPONSE_BAD_GLOBAL_SALT:  string = '<response>salt fault</response>';
  RESPONSE_INCORRECT_DATA:   string = '<response>incorrect data</response>';
  RESPONSE_BANNED:           string = '<response>banned</response>';
  RESPONSE_BAD_CHECKSUM:     string = '<response>bad checksum</response>';
  RESPONSE_DISTRIBUTOR_FAIL: string = '<response>distributor connection fail</response';

  DistributorTimeout: LongWord = 3500;

  function BooleanToStr(Value: Boolean): string; inline;
  begin
    case Value of
      True: Result := 'TRUE';
      False: Result := 'FALSE';
    end;
  end;

begin
  QueryPerformanceFrequency(Frequency);
  QueryPerformanceCounter(T1);

  Data := Socket.ReceiveText;

  // Получаем данные:
  Action     := GetXMLParameter(Data, 'type');
  Login      := GetXMLParameter(Data, 'login');
  Password   := GetXMLParameter(Data, 'password');
  Mail       := GetXMLParameter(Data, 'mail');
  Checksum   := GetXMLParameter(Data, 'md5');
  HWID       := GetXMLParameter(Data, 'hwid');
  IsWatchDog := Pos('<wd>', Data) <> 0;

  // Проверяем глобальную соль:
  if Pos(GlobalSaltEdit.Text, Data) = 0 then
  begin
    if not IsWatchDog then
    begin
      try
        Socket.SendText(RESPONSE_BAD_GLOBAL_SALT + LauncherVersion);
      except
        on ESocketError do
        begin

          Socket.Close;
        end;
      end;

      // Пишем отчёт:
      SocketConsole.Lines.Add(
                              '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                              '   Type      : ' + UpperCase(Action) + #13#10 +
                              '   Login     : ' + Login + #13#10#13#10 +
                              'Ответили клиенту:' + #13#10 +
                              '   # BAD GLOBAL SALT' + #13#10#13#10 +
                              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
      );
    end
    else
    begin
      if SaltWatchDog.Checked then
      begin
        // Пишем отчёт:
        SocketConsole.Lines.Add(
                                '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                                ' # WATCHDOG:' + #13#10 +
                                '   Type      : ' + UpperCase(Action) + #13#10 +
                                '   Login     : ' + Login + #13#10#13#10 +
                                'Ответили клиенту:' + #13#10 +
                                '   # BAD GLOBAL SALT' + #13#10#13#10 +
                                '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
        );
      end;
    end;

    Socket.Close;

    // Завершаем счётчик производительности:
    QueryPerformanceCounter(T2);
    MainForm.Caption := 'Система управления сервером [Выполнено за: ' + FormatFloat('0.0000', (T2 - T1) / Frequency) + ']';
    Exit;
  end;


  // Проверяем на неверный запрос:
  if CheckSymbols(Login) or CheckSymbols(Mail) or (Length(Login) = 0) then
  begin
    Socket.SendText(RESPONSE_INCORRECT_DATA + LauncherVersion);

    // Пишем отчёт:
    SocketConsole.Lines.Add(
                            '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                            '   Type      : ' + UpperCase(Action) + #13#10 +
                            '   Login     : ' + Login + #13#10#13#10 +
                            'Ответили клиенту:' + #13#10 +
                            '   # INCORRECT DATA' + #13#10#13#10 +
                            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
    );

    Socket.Close;

    // Завершаем счётчик производительности:
    QueryPerformanceCounter(T2);
    MainForm.Caption := 'Система управления сервером [Выполнено за: ' + FormatFloat('0.0000', (T2 - T1) / Frequency) + ']';
    Exit;
  end;


// Все данные проверены, выполняем запрос:

  if UseMySQL.Checked then
  begin
    SQLInsertParams.Login := Login;
    SQLInsertParams.Password := Password;
    SQLInsertParams.Mail := Mail;
    SQLInsertParams.HWID := HWID;
    SQLInsertParams.Time := TimeToStr(Now);
    SQLInsertParams.Date := DateToStr(Now);

    SQLParams.dbHost := dbHostEdit.Text;
    SQLParams.dbPort := StrToInt(dbPortEdit.Text);
    SQLParams.dbUser := dbLoginEdit.Text;
    SQLParams.dbPassword := dbPasswordEdit.Text;
    SQLParams.dbBaseName := dbBaseEdit.Text;
  end;


  if Action = 'auth' then
  begin

    // Готовим строку с версией лаунчера:
    LauncherVersion := '<version>' + LauncherVersionEdit.Text + '</version>';

    UserInBase := False;

    // Проверяем пользователя на наличие в базе:
    if AllGranted.Checked then
      UserInBase := True;

    if LocalBase.Checked then
      if UseMySQL.Checked then
      begin
        SQLRequest := LoginPassRequest.Text;
        InsertParams(SQLRequest, SQLInsertParams);
        UserInBase := GetMySQLData(SQLParams, SQLRequest);
      end
      else
        UserInBase := IsLoginPasswordInBase(Login, Password);

    if UseDistributor.Checked then
    begin
      UserInBase := GetXMLParameter(
                                    SendDataAndReceiveText(
                                                           DistributorIPEdit.Text,
                                                           StrToInt(DistributorPortEdit.Text),
                                                           Data,
                                                           ConnectionStatus,
                                                           DistributorTimeout
                                                          ),
                                    'response'
                                    ) = 'success';

      // Если не удалось подключиться к распределителю:
      if not ConnectionStatus then
      begin
        Response := RESPONSE_DISTRIBUTOR_FAIL;
        Socket.SendText(Response);

        // Пишем отчёт:
        SocketConsole.Lines.Add(
                                '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                                '   Type      : AUTH -> DISTRIBUTOR' + #13#10 +
                                '   Login     : ' + Login + #13#10 +
                                '   Password  : ' + Password + #13#10#13#10 +
                                'Ответили клиенту:' + #13#10 +
                                '   # DISTRIBUTOR CONNECTION FAIL' + #13#10#13#10 +
                                '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
        );

        // Отключаем клиента:
        Socket.Close;

        // Завершаем счётчик производительности:
        QueryPerformanceCounter(T2);
        MainForm.Caption := 'Система управления сервером [Выполнено за: ' + FormatFloat('0.0000', (T2 - T1) / Frequency) + ']';
        Exit;
      end;

    end;


    if UserInBase then
      Response := RESPONSE_SUCCESS + LauncherVersion
    else
      Response := RESPONSE_BAD_LOGIN + LauncherVersion;

    if WorkAsDistributor.Checked then
    begin
      if IsFileExists('ServersList.xml') then
      begin
        hFile := GetFileHandle('ServersList.xml');
        Size := GetFileSize(hFile, nil);
        GetMem(Buffer, Size);
        if ReadFile(hFile, Buffer^, Size, Size, nil) then
        begin
          Response := Response + PAnsiChar(Buffer);
        end;
        FreeMem(Buffer);
        CloseHandle(hFile);
      end;
    end;

    Socket.SendText(Response);

    // Пишем отчёт:
    SocketConsole.Lines.Add(
                            '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                            '   Type      : AUTH' + #13#10 +
                            '   Login     : ' + Login + #13#10 +
                            '   Password  : ' + Password + #13#10#13#10 +
                            'Ответили клиенту:' + #13#10 +
                            '   # ' + UpperCase(GetXMLParameter(Response, 'response')) + #13#10#13#10 +
                            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
    );

  end;


  if Action = 'reg' then
  begin
    // Если используем распределитель - перенаправляем запрос ему и возвращаем ответ:
    if UseDistributor.Checked then
    begin
      Socket.SendText(
                      SendDataAndReceiveText(
                                             DistributorIPEdit.Text,
                                             StrToInt(DistributorPortEdit.Text),
                                             Data,
                                             ConnectionStatus,
                                             DistributorTimeout
                      )
                     );

      // Если не удалось подключиться к распределителю:
      if not ConnectionStatus then
      begin
        Response := RESPONSE_DISTRIBUTOR_FAIL;
        Socket.SendText(Response);

        // Пишем отчёт:
        SocketConsole.Lines.Add(
                                '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                                '   Type      : REG -> DISTRIBUTOR' + #13#10 +
                                '   Login     : ' + Login + #13#10 +
                                '   Password  : ' + Password + #13#10 +
                                '   Mail      : ' + Mail + #13#10 +
                                '   HWID      : ' + HWID + #13#10#13#10 +
                                'Ответили клиенту:' + #13#10 +
                                '   # DISTRIBUTOR CONNECTION FAIL' + #13#10#13#10 +
                                '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
        );

        // Отключаем клиента:
        Socket.Close;

        // Завершаем счётчик производительности:
        QueryPerformanceCounter(T2);
        MainForm.Caption := 'Система управления сервером [Выполнено за: ' + FormatFloat('0.0000', (T2 - T1) / Frequency) + ']';
        Exit;
      end;

    end
    else
    begin

      if UseMySQL.Checked then
      begin
        SQLRequest := LoginMailRequest.Text;
        InsertParams(SQLRequest, SQLInsertParams);
        UserInBase := GetMySQLData(SQLParams, SQLRequest);
      end
      else
        UserInBase := IsLoginMailInBase(Login, Mail);


      if UserInBase then
      begin
        Response := RESPONSE_ALREADY_EXISTS;
      end
      else
      begin
        if CheckHWIDOnLogin.Checked then
        begin
          if IsHWIDBanned(HWID) then
          begin
            Response := RESPONSE_BANNED;
          end
          else
          begin

            if UseMySQL.Checked then
            begin
              SQLRequest := InsertRequest.Text;
              InsertParams(SQLRequest, SQLInsertParams);
              SetMySQLData(SQLParams, SQLRequest);
            end
            else
              AddPlayerInBase(Login, Password, Mail);

            if not IsHWIDInPlayerBase(Login, HWID) then AddHWIDInPlayerBase(Login, HWID);
            Response := RESPONSE_SUCCESS;
          end;
        end
        else
        begin

          if UseMySQL.Checked then
          begin
            SQLRequest := InsertRequest.Text;
            InsertParams(SQLRequest, SQLInsertParams);
            SetMySQLData(SQLParams, SQLRequest);
          end
          else
            AddPlayerInBase(Login, Password, Mail);

          if not IsHWIDInPlayerBase(Login, HWID) then AddHWIDInPlayerBase(Login, HWID);
          Response := RESPONSE_SUCCESS;
        end;
      end;
    end;

    Socket.SendText(Response);

    // Пишем отчёт:
    SocketConsole.Lines.Add(
                            '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                            '   Type      : REG' + #13#10 +
                            '   Login     : ' + Login + #13#10 +
                            '   Password  : ' + Password + #13#10 +
                            '   Mail      : ' + Mail + #13#10 +
                            '   HWID      : ' + HWID + #13#10#13#10 +
                            'Ответили клиенту:' + #13#10 +
                            '   # ' + UpperCase(GetXMLParameter(Response, 'response')) + #13#10#13#10 +
                            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
    );

    // Заполняем список игроков в StringGrid'e:
    FillStringGrid;
  end;


  if Action = 'gameauth' then
  begin
    UserInBase := False;

    // Проверяем пользователя на наличие в базе:
    if AllGranted.Checked then
      UserInBase := True;

    if LocalBase.Checked then
      if UseMySQL.Checked then
      begin
        SQLRequest := LoginPassRequest.Text;
        InsertParams(SQLRequest, SQLInsertParams);
        UserInBase := GetMySQLData(SQLParams, SQLRequest);
      end
      else
        UserInBase := IsLoginPasswordInBase(Login, Password);

    if UseDistributor.Checked then
    begin
      UserInBase := GetXMLParameter(
                                    SendDataAndReceiveText(
                                                           DistributorIPEdit.Text,
                                                           StrToInt(DistributorPortEdit.Text),
                                                           GlobalSaltEdit.Text + '<type>auth</type><login>' + Login + '</login><password>' + Password + '</password>',
                                                           ConnectionStatus,
                                                           DistributorTimeout
                                                          ),
                                    'response'
                                    ) = 'success';

      // Если не удалось подключиться к распределителю:
      if not ConnectionStatus then
      begin
        Response := RESPONSE_DISTRIBUTOR_FAIL;
        Socket.SendText(Response);

        // Пишем отчёт:
        SocketConsole.Lines.Add(
                                '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                                '   Type      : GAMEAUTH -> DISTRIBUTOR' + #13#10 +
                                '   Login     : ' + Login + #13#10 +
                                '   Password  : ' + Password + #13#10#13#10 +
                                'Ответили клиенту:' + #13#10 +
                                '   # DISTRIBUTOR CONNECTION FAIL' + #13#10#13#10 +
                                '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
        );

        // Отключаем клиента:
        Socket.Close;

        // Завершаем счётчик производительности:
        QueryPerformanceCounter(T2);
        MainForm.Caption := 'Система управления сервером [Выполнено за: ' + FormatFloat('0.0000', (T2 - T1) / Frequency) + ']';
        Exit;
      end;
    end;




    if UserInBase then
    begin
      if not IsHWIDBanned(HWID) then
      begin
        if CheckMD5.Checked then
        begin
          if SaltedHash.Checked then
          begin
            if IsSaltedHashValid(ChecksumEdit.Text, Checksum) then
            begin
              if not IsHWIDInPlayerBase(Login, HWID) then AddHWIDInPlayerBase(Login, HWID);
              AddPlayer(Login, StrToInt(TimeoutEdit.Text));
              Response := RESPONSE_SUCCESS;
            end
            else
            begin
              Response := RESPONSE_BAD_CHECKSUM;
            end;
          end
          else
          begin
            if ChecksumEdit.Text = Checksum then
            begin
              if not IsHWIDInPlayerBase(Login, HWID) then AddHWIDInPlayerBase(Login, HWID);
              AddPlayer(Login, StrToInt(TimeoutEdit.Text));
              Response := RESPONSE_SUCCESS;
            end
            else
            begin
              Response := RESPONSE_BAD_CHECKSUM;
            end;
          end;
        end
        else
        begin
          if not IsHWIDInPlayerBase(Login, HWID) then AddHWIDInPlayerBase(Login, HWID);
          AddPlayer(Login, StrToInt(TimeoutEdit.Text));
          Response := RESPONSE_SUCCESS;
        end;
      end
      else
      begin
        Response := RESPONSE_BANNED;
      end;
    end
    else
    begin
      Response := RESPONSE_BAD_LOGIN;
    end;

    Socket.SendText(Response);

    // Пишем отчёт:
    SocketConsole.Lines.Add(
                            '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                            '   Type      : GAMEAUTH' + #13#10 +
                            '   Login     : ' + Login + #13#10 +
                            '   Password  : ' + Password + #13#10 +
                            '   Checksum  : ' + Checksum + #13#10 +
                            '   HWID      : ' + HWID + #13#10#13#10 +
                            'Ответили клиенту:' + #13#10 +
                            '   # ' + UpperCase(GetXMLParameter(Response, 'response')) + #13#10#13#10 +
                            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
    );
  end;


  if Action = 'beacon' then
  begin
    Response := RESPONSE_SUCCESS;

    if CheckMD5.Checked then
    begin
      if SaltedHash.Checked then
      begin
        if not IsSaltedHashValid(ChecksumEdit.Text, Checksum) then
        begin
          RemovePlayer(Login);
          Response := RESPONSE_BAD_CHECKSUM;

          // Посылаем плагину команду на удаление игрока с сервера:
          PluginCommand := GlobalSaltEdit.Text + '<type>kick</type><login>' + Login + '</login>';
          SendData(PluginIPEdit.Text, StrToInt(PluginPortEdit.Text), PluginCommand, 200);
        end;
      end
      else
      begin
        if Checksum <> ChecksumEdit.Text then
        begin
          RemovePlayer(Login);
          Response := RESPONSE_BAD_CHECKSUM;

          // Посылаем плагину команду на удаление игрока с сервера:
          PluginCommand := GlobalSaltEdit.Text + '<type>kick</type><login>' + Login + '</login>';
          SendData(PluginIPEdit.Text, StrToInt(PluginPortEdit.Text), PluginCommand, 200);
        end;
      end;
    end;

    Socket.SendText(Response);

    if ShowBeaconMessages.Checked then
      // Пишем отчёт:
      SocketConsole.Lines.Add(
                              '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                              '   Type      : BEACON' + #13#10 +
                              '   Login     : ' + Login + #13#10 +
                              '   Checksum  : ' + Checksum + #13#10#13#10 +
                              'Ответили клиенту:' + #13#10 +
                              '   # ' + UpperCase(GetXMLParameter(Response, 'response')) + #13#10#13#10 +
                              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
      );
  end;


  if Action = 'deauth' then
  begin
    RemovePlayer(Login);

    // Посылаем плагину команду на удаление игрока с сервера:
    PluginCommand := GlobalSaltEdit.Text + '<type>kick</type><login>' + Login + '</login>';
    SendData(PluginIPEdit.Text, StrToInt(PluginPortEdit.Text), PluginCommand, 200);

    if ShowDeauthMessages.Checked then
      // Пишем отчёт:
      if IsWatchDog then
        SocketConsole.Lines.Add(
                                '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                                ' # WATCHDOG:' + #13#10 +
                                '   Type      : DEAUTH' + #13#10 +
                                '   Login     : ' + Login + #13#10#13#10 +
                                '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
        )
      else
        SocketConsole.Lines.Add(
                                '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                                '   Type      : DEAUTH' + #13#10 +
                                '   Login     : ' + Login + #13#10#13#10 +
                                '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
        );


    FillStringGrid;
  end;


  if Action = 'login event' then
  begin
    if IsPlayerInList(Login) then
    begin
      Response := 'granted'
    end
    else
      Response := 'denied';

    Socket.SendText(Response);

    if ShowPluginMessages.Checked then
      // Пишем отчёт:
      SocketConsole.Lines.Add(
                              '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                              '   Type      : [NTPLAGUE] LOGIN EVENT' + #13#10 +
                              '   Login     : ' + Login + #13#10#13#10 +
                              'Ответили клиенту:' + #13#10 +
                              '   # ' + UpperCase(Response) + #13#10#13#10 +
                              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
      );

  end;


  if Action = 'join event' then
  begin
    AddPlayerToOnlineList(Login);
    FillStringGrid;

    if DeletePlayersOnEnter.Checked then RemovePlayer(Login);

    if ShowPluginMessages.Checked then
      // Пишем отчёт:
      SocketConsole.Lines.Add(
                              '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                              '   Type      : [NTPLAGUE] JOIN EVENT' + #13#10 +
                              '   Login     : ' + Login + #13#10#13#10 +
                              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
      );

  end;


  if Action = 'quit event' then
  begin
    if DeletePlayersOnEnter.Checked then RemovePlayer(Login);

    if ShowPluginMessages.Checked then
      // Пишем отчёт:
      SocketConsole.Lines.Add(
                              '[' + TimeToStr(Now) + '] Клиент ' + Socket.RemoteAddress + ' прислал данные:' + #13#10#13#10 +
                              '   Type      : [NTPLAGUE] QUIT EVENT' + #13#10 +
                              '   Login     : ' + Login + #13#10#13#10 +
                              '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -' + #13#10
      );

    RemovePlayerFromOnlineList(Login);
    FillStringGrid;
  end;


  // Отключаем клиента:
  Socket.Close;

  // Завершаем счётчик производительности:
  QueryPerformanceCounter(T2);
  MainForm.Caption := 'Система управления сервером [Выполнено за: ' + FormatFloat('0.0000', (T2 - T1) / Frequency) + ']';
end;



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -





//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


{ TPlayersControlThread }

procedure TPlayersControlThread.Execute;
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  inherited;

  while MainForm.ServerSocket.Active do
  begin
    EnterCriticalSection(PlayersCriticalSection);
    PlayersCount := Length(Players);

    if PlayersCount = 0 then
    begin
      LeaveCriticalSection(PlayersCriticalSection);
      Synchronize(UpdatePlayersList);
      Sleep(1000);
      Continue;
    end;

    I := 0;
    while I <= PlayersCount - 1 do
    begin
      if Players[I].RemainingTime = 0 then
      begin
        if MainForm.DeletePlayersOnTimer.Checked then
        begin
          Move(Players[PlayersCount - 1], Players[I], SizeOf(TPlayerInfo));
          SetLength(Players, PlayersCount - 1);
          Dec(PlayersCount);

          if PlayersCount = 0 then Break;
        end;
      end
      else
        if Players[I].RemainingTime > 0 then Dec(Players[I].RemainingTime);

      Inc(I);
    end;

    LeaveCriticalSection(PlayersCriticalSection);

    Synchronize(UpdatePlayersList);

    Sleep(1000);
  end;

  EnterCriticalSection(PlayersCriticalSection);
  SetLength(Players, 0);
  LeaveCriticalSection(PlayersCriticalSection);

  Synchronize(UpdatePlayersList);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TPlayersControlThread.UpdatePlayersList;
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  EnterCriticalSection(PlayersCriticalSection);

  PlayersCount := Length(Players);

  with MainForm do
  begin
    if PlayersCount > 0 then
    begin
      PlayersList.RowCount := PlayersCount + 1;

      for I := 0 to PlayersCount - 1 do
      begin
        PlayersList.Cells[0, I + 1] := Players[I].Name;
        PlayersList.Cells[1, I + 1] := IntToStr(Players[I].RemainingTime);
      end;
    end
    else
    begin
      PlayersList.RowCount := 2;
      PlayersList.Cells[0, 1] := 'Игроков нет';
      PlayersList.Cells[1, 1] := '0';
    end;
  end;

  LeaveCriticalSection(PlayersCriticalSection);
end;



//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//
//
//                     Второстепенный функционал
//
//
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH




procedure TMainForm.SaveSettingsButtonClick(Sender: TObject);
begin
  SaveStringToRegistry(RegistryPath, 'JavaPath', JavaPathEdit.Text);
  SaveStringToRegistry(RegistryPath, 'RAM', RAMEdit.Text);
  SaveStringToRegistry(RegistryPath, 'ServerPath', ServerPathEdit.Text);
  SaveStringToRegistry(RegistryPath, 'MD5', ChecksumEdit.Text);
  SaveStringToRegistry(RegistryPath, 'Port', SocketPortEdit.Text);
  SaveStringToRegistry(RegistryPath, 'LauncherVersion', LauncherVersionEdit.Text);
  SaveStringToRegistry(RegistryPath, 'DistributorIP', DistributorIPEdit.Text);
  SaveStringToRegistry(RegistryPath, 'DistributorPort', DistributorPortEdit.Text);
  SaveStringToRegistry(RegistryPath, 'PluginIP', PluginIPEdit.Text);
  SaveStringToRegistry(RegistryPath, 'PluginPort', PluginPortEdit.Text);
  SaveStringToRegistry(RegistryPath, 'JVMParams', JVMParamsEdit.Text);
  SaveStringToRegistry(RegistryPath, 'GlobalSalt', GlobalSaltEdit.Text);

  SaveStringToRegistry(RegistryPath, 'dbHost', dbHostEdit.Text);
  SaveStringToRegistry(RegistryPath, 'dbPort', dbPortEdit.Text);
  SaveStringToRegistry(RegistryPath, 'dbLogin', dbLoginEdit.Text);
  SaveStringToRegistry(RegistryPath, 'dbPassword', dbPasswordEdit.Text);
  SaveStringToRegistry(RegistryPath, 'dbBaseName', dbBaseEdit.Text);

  SaveStringToRegistry(RegistryPath, 'LoginPassRequest', LoginPassRequest.Text);
  SaveStringToRegistry(RegistryPath, 'LoginMailRequest', LoginMailRequest.Text);
  SaveStringToRegistry(RegistryPath, 'InsertRequest', InsertRequest.Text);


  SaveBooleanToRegistry(RegistryPath, 'CheckMD5', CheckMD5.Checked);
  SaveBooleanToRegistry(RegistryPath, 'Salt', SaltedHash.Checked);
  SaveBooleanToRegistry(RegistryPath, 'LoginHWID', CheckHWIDOnLogin.Checked);
  SaveBooleanToRegistry(RegistryPath, 'RegHWID', CheckHWIDOnReg.Checked);
  SaveBooleanToRegistry(RegistryPath, 'WorkAsDistributor', WorkAsDistributor.Checked);
  SaveBooleanToRegistry(RegistryPath, 'SaltWatchDog', SaltWatchDog.Checked);
  SaveBooleanToRegistry(RegistryPath, 'DeletePlayersOnEnter', DeletePlayersOnEnter.Checked);
  SaveBooleanToRegistry(RegistryPath, 'DeletePlayersOnTimer', DeletePlayersOnTimer.Checked);
  SaveBooleanToRegistry(RegistryPath, 'Autorestart', AutorestartCheckbox.Checked);
  SaveBooleanToRegistry(RegistryPath, 'ShowDeauthMessages', ShowDeauthMessages.Checked);
  SaveBooleanToRegistry(RegistryPath, 'ShowBeaconMessages', ShowBeaconMessages.Checked);
  SaveBooleanToRegistry(RegistryPath, 'ShowPluginMessages', ShowPluginMessages.Checked);
  SaveBooleanToRegistry(RegistryPath, 'FlushServerMemory', FlushServerMemory.Checked);
  SaveBooleanToRegistry(RegistryPath, 'UseMySQL', UseMySQL.Checked);

  if AllGranted.Checked then SaveStringToRegistry(RegistryPath, 'AuthMode', 'granted');
  if LocalBase.Checked then SaveStringToRegistry(RegistryPath, 'AuthMode', 'base');
  if UseDistributor.Checked then SaveStringToRegistry(RegistryPath, 'AuthMode', 'use distributor');

  MessageBox(Handle, 'Настройки сохранены в реестр!', 'Успешно!', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.SaveSettingsToFileButtonClick(Sender: TObject);
begin
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + SettingsFile) do
  begin
    WriteString(SettingsSection, 'JavaPath', JavaPathEdit.Text);
    WriteString(SettingsSection, 'RAM', RAMEdit.Text);
    WriteString(SettingsSection, 'ServerPath', ServerPathEdit.Text);
    WriteString(SettingsSection, 'MD5', ChecksumEdit.Text);
    WriteString(SettingsSection, 'Port', SocketPortEdit.Text);
    WriteString(SettingsSection, 'LauncherVersion', LauncherVersionEdit.Text);
    WriteString(SettingsSection, 'DistributorIP', DistributorIPEdit.Text);
    WriteString(SettingsSection, 'DistributorPort', DistributorPortEdit.Text);
    WriteString(SettingsSection, 'PluginIP', PluginIPEdit.Text);
    WriteString(SettingsSection, 'PluginPort', PluginPortEdit.Text);
    WriteString(SettingsSection, 'JVMParams', JVMParamsEdit.Text);
    WriteString(SettingsSection, 'GlobalSalt', GlobalSaltEdit.Text);

    WriteString(SettingsSection, 'dbHost', dbHostEdit.Text);
    WriteString(SettingsSection, 'dbPort', dbPortEdit.Text);
    WriteString(SettingsSection, 'dbLogin', dbLoginEdit.Text);
    WriteString(SettingsSection, 'dbPassword', dbPasswordEdit.Text);
    WriteString(SettingsSection, 'dbBaseName', dbBaseEdit.Text);

    WriteString(SettingsSection, 'LoginPassRequest', LoginPassRequest.Text);
    WriteString(SettingsSection, 'LoginMailRequest', LoginMailRequest.Text);
    WriteString(SettingsSection, 'InsertRequest', InsertRequest.Text);


    WriteBool(SettingsSection, 'CheckMD5', CheckMD5.Checked);
    WriteBool(SettingsSection, 'Salt', SaltedHash.Checked);
    WriteBool(SettingsSection, 'LoginHWID', CheckHWIDOnLogin.Checked);
    WriteBool(SettingsSection, 'RegHWID', CheckHWIDOnReg.Checked);
    WriteBool(SettingsSection, 'WorkAsDistributor', WorkAsDistributor.Checked);
    WriteBool(SettingsSection, 'SaltWatchDog', SaltWatchDog.Checked);
    WriteBool(SettingsSection, 'DeletePlayersOnEnter', DeletePlayersOnEnter.Checked);
    WriteBool(SettingsSection, 'DeletePlayersOnTimer', DeletePlayersOnTimer.Checked);
    WriteBool(SettingsSection, 'Autorestart', AutorestartCheckbox.Checked);
    WriteBool(SettingsSection, 'ShowDeauthMessages', ShowDeauthMessages.Checked);
    WriteBool(SettingsSection, 'ShowBeaconMessages', ShowBeaconMessages.Checked);
    WriteBool(SettingsSection, 'ShowPluginMessages', ShowPluginMessages.Checked);
    WriteBool(SettingsSection, 'FlushServerMemory', FlushServerMemory.Checked);
    WriteBool(SettingsSection, 'UseMySQL', UseMySQL.Checked);

    if AllGranted.Checked then WriteString(SettingsSection, 'AuthMode', 'granted');
    if LocalBase.Checked then WriteString(SettingsSection, 'AuthMode', 'base');
    if UseDistributor.Checked then WriteString(SettingsSection, 'AuthMode', 'use distributor');
  end;

  MessageBox(Handle, 'Настройки сохранены в файл config.ini', 'Успешно!', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.CommandEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    EnterCriticalSection(CriticalSection);
    WriteConsole(PipesInfo.WriteStdIn, CommandEdit.Text);
    LeaveCriticalSection(CriticalSection);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.SendCommandButtonClick(Sender: TObject);
begin
  EnterCriticalSection(CriticalSection);
  WriteConsole(PipesInfo.WriteStdIn, CommandEdit.Text);
  LeaveCriticalSection(CriticalSection);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.SelfPathButtonClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', '', '', '', SW_SHOWNORMAL);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.ServerPathButtonClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PAnsiChar(ExtractFilePath(ServerPathEdit.Text)), '', '', SW_SHOWNORMAL);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.SocketConsoleChange(Sender: TObject);
var
  I: LongWord;
  LinesCount: LongWord;
  Delta: Integer;
  Text: string;
  ConsoleText: string;
const
  MaxLines = 150;
begin
  LinesCount := SocketConsole.Lines.Count;

  if LinesCount > MaxLines then
  begin
    Delta := LinesCount - MaxLines;
    Text := '';

    for I := 0 to Delta - 1 do Text := Text + SocketConsole.Lines[I];

    ConsoleText := SocketConsole.Text;
    Delete(ConsoleText, 1, Length(Text));
    SocketConsole.Text := ConsoleText;
    SendMessage(SocketConsole.Handle, EM_LINESCROLL, 0, SocketConsole.Lines.Count - 1);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.ServerConsoleChange(Sender: TObject);
var
  I: LongWord;
  LinesCount: LongWord;
  Delta: Integer;
  Text: string;
  ConsoleText: string;
const
  MaxLines = 350;
begin
  LinesCount := ServerConsole.Lines.Count;

  if LinesCount > MaxLines then
  begin
    Delta := LinesCount - MaxLines;
    Text := '';

    for I := 0 to Delta - 1 do Text := Text + ServerConsole.Lines[I];

    ConsoleText := ServerConsole.Text;
    Delete(ConsoleText, 1, Length(Text));
    ServerConsole.Text := ConsoleText;
    SendMessage(ServerConsole.Handle, EM_LINESCROLL, 0, ServerConsole.Lines.Count - 1);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Рисуем заливку цветом:
procedure TMainForm.PlayersGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Login: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[ACol, ARow]);

  if ARow = PlayersGrid.Row then
    // Любая выделенная ячейка:
    PlayersGrid.Canvas.Brush.Color := RGB(121, 191, 255)
  else
    // Все остальные ячейки:
    if IsPlayerOnline(Login) then
      PlayersGrid.Canvas.Brush.Color := RGB(100, 255, 112)
    else
      PlayersGrid.Canvas.Brush.Color := RGB(255, 125, 120);
      //PlayersGrid.Canvas.Brush.Color := RGB(100, 255, 112);

  PlayersGrid.Canvas.FillRect(Rect);
  PlayersGrid.Canvas.TextOut(Rect.Left, Rect.Top, '  ' + Login);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Выделяем ячейки правой кнопкой мыши:
procedure TMainForm.PlayersGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  GridRect: TGridRect;
begin
  if Button = mbRight then
  begin
    GridRect.TopLeft := PlayersGrid.MouseCoord(X, Y);
    GridRect.BottomRight := PlayersGrid.MouseCoord(X, Y);
    PlayersGrid.Selection := GridRect;
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.FillStringGrid;
var
  BaseCount: LongWord;
  OnlineCount: LongWord;
  I: LongWord;
  Decrement: LongWord;
begin
  FillBasePlayers; // Получаем список игроков в базе

  BaseCount := Length(BasePlayers);
  OnlineCount := Length(OnlinePlayers);

  if (BaseCount = 0) and (OnlineCount = 0) then
  begin
    PlayersGrid.RowCount := 1;
    PlayersGrid.Cells[0, 0] := '  Игроков нет';
    PlayersGrid.Font.Name := 'Tahoma';
    Exit;
  end
  else
    PlayersGrid.Font.Name := 'Museo Slab 500';


  if OnlineCount > 0 then
  begin
    PlayersGrid.RowCount := OnlineCount;
    for I := 0 to OnlineCount - 1 do
    begin
      PlayersGrid.Cells[0, I] := '  ' + OnlinePlayers[I];
    end;

    if BaseCount = 0 then Exit;

    PlayersGrid.RowCount := BaseCount + OnlineCount;

    Decrement := 0;

    for I := 0 to BaseCount - 1 do
    begin
      if not IsPlayerOnline(BasePlayers[I]) then
      begin
        PlayersGrid.Cells[0, I + OnlineCount - Decrement] := '  ' + BasePlayers[I];
      end
      else
        Inc(Decrement); // Понял, да?
    end;

    if Decrement > 0 then
      PlayersGrid.RowCount := BaseCount + OnlineCount - Decrement;

  end
  else
  begin
    PlayersGrid.RowCount := BaseCount;
    for I := 0 to BaseCount - 1 do
      PlayersGrid.Cells[0, I] := '  ' + BasePlayers[I];

    Exit;
  end;
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.KickClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>kick</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' выкинут с сервера!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.BanClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>ban</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' забанен!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.UnbanClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>unban</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' успешно разбанен!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.BanIPClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>ban ip</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' забанен по IP!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.UnbanIPClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>unban ip</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' успешно разбанен по IP!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.HWIDBanClick(Sender: TObject);
var
  Login: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  BanPlayerHWIDs(Login);
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' успешно забанен по железу!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.AddWhitelistClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>add to whitelist</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' добавлен в белый лист!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.RemoveWhitelistClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>remove from whitelist</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' удалён из белого листа!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.AddAuthListClick(Sender: TObject);
var
  Login: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  AddPlayer(Login, StrToInt(TimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' добавлен в очередь на авторизацию!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.AddAuthListWithoutTimerClick(Sender: TObject);
var
  Login: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  AddPlayer(Login, -1);
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' добавлен в бессрочную очередь на авторизацию!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.RemoveAuthListClick(Sender: TObject);
var
  Login: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  RemovePlayer(Login);
  //MessageBox(Handle, PAnsiChar('Игрок ' + Login + ' удалён из очереди на авторизацию!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.AddOperatorClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>op</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('Игроку ' + Login + ' даны полномочия оператора!'), 'Успешно', MB_ICONASTERISK);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.RemoveOperatorClick(Sender: TObject);
var
  Login: string;
  IP: string;
  Port: Word;
  GlobalSalt: string;
begin
  Login := TrimLeft(PlayersGrid.Cells[0, PlayersGrid.Row]);
  IP := PluginIPEdit.Text;
  Port := StrToInt(PluginPortEdit.Text);
  GlobalSalt := GlobalSaltEdit.Text;
  SendData(IP, Port, GlobalSalt + '<type>deop</type><login>' + Login + '</login>', StrToInt(PluginTimeoutEdit.Text));
  //MessageBox(Handle, PAnsiChar('С игрока ' + Login + ' сняты полномочия оператора!'), 'Успешно', MB_ICONASTERISK);
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

{ TMonitoringThread }

procedure TMonitoringThread.Execute;
var
  Memory: TMemoryStatusEx;
  ProcessorsCount: Integer;
  I: LongWord;
  CPUUsages: PROCESSORS_USAGES;
  FullCPUUsage: Integer;
  MainCPUUsage: Integer;
  ProcessInfo: PROCESS_INFO;
  ServerCPULoading: Single;

  Accumulator: Byte;


begin
  inherited;
  InitProcessors; // Инициализируем процессоры
  ProcessorsCount := GetProcessorsCount;

  Accumulator := 0;

  while True do
  begin
    GetProcessorUsage(@CPUUsages);

    FullCPUUsage := 0;
    for I := 0 to ProcessorsCount - 1 do
    begin
      FullCPUUsage := FullCPUUsage + Round(100 - CPUUsages[i].IdleTime - CPUUsages[i].InterruptTime - CPUUsages[i].DPCTime);
    end;

    MainCPUUsage := FullCPUUsage div ProcessorsCount;
    if MainCPUUsage > 100 then MainCPUUsage := 100;
    if MainCPUUsage < 0 then MainCPUUsage := 0;

    if MainCPUUsage < 70 then
      CPUColor := RGB(0, 102, 204)
    else
      if (MainCPUUsage >= 70) and (MainCPUUsage < 90) then
        CPUColor := RGB(240, 186, 0)
      else
        if MainCPUUsage >= 90 then
          CPUColor := RGB(255, 0, 0);

    CPU := IntToStr(MainCPUUsage) + '%';

    Memory.dwLength := SizeOf(Memory);
    GlobalMemoryStatusEx(Memory);
    RAM := IntToStr(Memory.ullAvailPhys div 1048576) + ' Мб';

    GetProcessInfo(GetCurrentProcessID, ProcessInfo);
    ThreadsCount := IntToStr(ProcessInfo.ThreadsCount);
    HandlesCount := IntToStr(ProcessInfo.HandlesCount);


    if ServerStatus then
    begin
      GetProcessInfo(PipesInfo.ProcessInfo.dwProcessId, ProcessInfo);

      ServerCPULoading := GetProcessCPULoading(PipesInfo.ProcessInfo.dwProcessId, 850);

      if ServerCPULoading > 100 then ServerCPULoading := 100;
      if ServerCPULoading < 0 then ServerCPULoading := 0;

      ServerCPU := FormatFloat('0.00', ServerCPULoading) + '%';

      if ServerCPULoading < 70 then
        ServerCPUColor := RGB(0, 102, 204)
      else
        if (ServerCPULoading >= 70) and (ServerCPULoading < 90) then
          ServerCPUColor := RGB(240, 186, 0)
        else
          if ServerCPULoading >= 90 then
            ServerCPUColor := RGB(255, 0, 0);
    end
    else
    begin
      ServerCPU := '0%';
      ServerCPUColor := RGB(0, 102, 204);
      Sleep(1000);
    end;

    Synchronize(UpdateForm);

    Inc(Accumulator);

    // Чистим память:
    if Accumulator = 120 then
    begin
      Accumulator := 0;
      EmptyWorkingSet(GetCurrentProcess);

      if ServerStatus and MainForm.FlushServerMemory.Checked then
        EmptyWorkingSet(PipesInfo.ProcessInfo.hProcess);
    end;

  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMonitoringThread.UpdateForm;
begin
  with MainForm do
  begin
    RAMLabel.Caption := RAM;
    CPULabel.Font.Color := CPUColor;
    CPULabel.Caption := CPU;
    ServerCPULabel.Font.Color := ServerCPUColor;
    ServerCPULabel.Caption := ServerCPU;

    ThreadsCountLabel.Caption := ThreadsCount;
    HandlesCountLabel.Caption := HandlesCount;
  end;
end;

end.

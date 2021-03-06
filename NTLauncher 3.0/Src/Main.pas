﻿unit Main;

interface

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{
  LauncherSettings.pas - настройка лаунчера
  Definitions.inc - флаги условной компиляции
  LocalServersList.inc - локальный список серверов
}

{$I Definitions.inc}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  ExtCtrls, StdCtrls, ComCtrls, Graphics, Dialogs,
  ScktComp,  HTTPSend, BlckSock, ServerQuery,
  Additions, RegistryUtils, LauncherSettings, HashUtils, FileAPI, Perimeter, Defence,
  SkinSystem, HWID, MinecraftLauncher, MultiserverUtils,
  PostRequest, PNGImage,
  ShellAPI,  ProcessAPI, TlHelp32, PipesAPI,
  StringsAPI;

type
  TMainForm = class(TForm)
    ClientSocket: TClientSocket;
    LoginEdit: TEdit;
    PasswordEdit: TEdit;
    MailEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    AuthButton: TButton;
    RegLabel: TLabel;
    AutoLoginCheckbox: TCheckBox;
    RAMEdit: TEdit;
    JavaEdit: TEdit;
    MainLabel: TLabel;
    MainSizeOfFileLabel: TLabel;
    MainDownloadedLabel: TLabel;
    MainSpeedLabel: TLabel;
    MainRemainingTimeLabel: TLabel;
    AssetsLabel: TLabel;
    AssetsSizeOfFileLabel: TLabel;
    AssetsDownloadedLabel: TLabel;
    AssetsSpeedLabel: TLabel;
    AssetsRemainingTimeLabel: TLabel;
    GameButton: TButton;
    DownloadMainButton: TButton;
    DownloadAssetsButton: TButton;
    SkinImage: TImage;
    CloakImage: TImage;
    ServerListComboBox: TComboBox;
    ChooseSkinButton: TButton;
    UploadSkinButton: TButton;
    ChooseCloakButton: TButton;
    UploadCloakButton: TButton;
    OpenLauncherFolder: TButton;
    OpenClientFolder: TButton;
    MainPageControl: TPageControl;
    AuthSheet: TTabSheet;
    GameSheet: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    FreeRAMLabel: TLabel;
    DeauthLabel: TLabel;
    LauncherTitle: TLabel;
    MonitoringLabel: TLabel;
    TabSheet1: TTabSheet;
    CommandLineConsole: TMemo;
    ClientConsole: TMemo;
    DebugPageControl: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label7: TLabel;
    ChecksumEdit: TEdit;
    Label8: TLabel;
    MainpathEdit: TEdit;
    Label9: TLabel;
    MinepathEdit: TEdit;
    Label10: TLabel;
    ResponseEdit: TEdit;
    CalculateChecksumButton: TButton;
    GoToMainpathButton: TButton;
    GoToMinepathButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GameButtonClick(Sender: TObject);
    procedure RegLabelClick(Sender: TObject);
    procedure AuthButtonClick(Sender: TObject);
    procedure SetupConnect;
    procedure DownloadMainButtonClick(Sender: TObject);
    procedure DownloadAssetsButtonClick(Sender: TObject);
    procedure ServerListComboBoxSelect(Sender: TObject);
    procedure ChooseSkinButtonClick(Sender: TObject);
    procedure ChooseCloakButtonClick(Sender: TObject);
    procedure UploadSkinButtonClick(Sender: TObject);
    procedure UploadCloakButtonClick(Sender: TObject);
    procedure OpenLauncherFolderClick(Sender: TObject);
    procedure OpenClientFolderClick(Sender: TObject);
    // function CallProc(FunctionID: LongWord): Boolean; // Для шаблонизатора!
    procedure RegLabelMouseEnter(Sender: TObject);
    procedure RegLabelMouseLeave(Sender: TObject);
    procedure RegLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RegLabelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DeauthLabelMouseEnter(Sender: TObject);
    procedure DeauthLabelMouseLeave(Sender: TObject);
    procedure DeauthLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DeauthLabelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DeauthLabelClick(Sender: TObject);
    procedure FreeRAMLabelClick(Sender: TObject);
    procedure ClientConsoleChange(Sender: TObject);
    procedure CalculateChecksumButtonClick(Sender: TObject);
    procedure GoToMainpathButtonClick(Sender: TObject);
    procedure GoToMinepathButtonClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

// Массив событий для потоков загрузки клиентов:
var
  ArrayEvents: array [0..1] of THandle = (INVALID_HANDLE_VALUE, INVALID_HANDLE_VALUE);

const
  EVENT_MAIN   = 0;
  EVENT_ASSETS = 1;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Тип загружаемого архива:
const
  ARCHIVE_MAIN   = 0;
  ARCHIVE_ASSETS = 1;

const
  DOWNLOAD_SUCCESS         = 0;
  DOWNLOAD_ACTIVE          = 1;
  DOWNLOAD_UNPACKING       = 2;
  DOWNLOAD_WAITING         = 3;
  DOWNLOAD_FILE_NOT_EXISTS = 4;

type
  TDownloadArchiveThread = class(TThread)
    protected
    ArchiveType: Byte;

    URL: string;
    Destination: string;
    HTTPClient: THTTPSend;

    FileHandle: THandle;
    FileSize: Integer;
    Downloaded: Integer;
    Speed: Single;
    RemainingTime: Single;

    Status: Byte;

    StartTimeCounter: Int64;
    OldTimeCounter: Int64;
    PerformanceFrequency: Int64;

    Accumulator: Integer;

    PlayAfterDownloading: Boolean;

    procedure Execute; override;
    procedure OnSockStatus(Sender: TObject; Reason: THookSocketReason; const Value: string);
    procedure UpdateForm;
  end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Тип загружаемой картинки:
const
  IMAGE_SKIN  = 0;
  IMAGE_CLOAK = 1;

type
  TDownloadImageThread = class(TThread)
    protected
    ImageType: Byte;

    URL: string;
    HTTPClient: THTTPSend;
    procedure Execute; override;
    procedure UpdateForm;
  end;


// Константы типа соединения с сокетом:
const
  TYPE_AUTH     = 0;
  TYPE_REG      = 1;
  TYPE_GAMEAUTH = 2;
  TYPE_BEACON   = 3;
  TYPE_DEAUTH   = 4;

var
  TypeOfConnection: Byte = TYPE_AUTH;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$IFDEF MONITORING}
type
  TMonitoringThread = class(TThread)
    protected
    PrimaryIP: string;
    SecondaryIP: string;
    Port: Word;
    ServerInfo: TServerInfo;
    ServerActive: Boolean;
    procedure Execute; override;
    procedure UpdateCaption;
  end;
{$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$IFDEF DEBUG_MODE}
type
  TReadConsoleThread = class(TThread)
    protected
    ReadStdOut: THandle;
    MCHandle: THandle;
    ConsoleOutput: string;
    procedure Execute; override;
    procedure UpdateConsole;
  end;
{$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


var
  Mainpath: string; // Рабочая папка
  Minepath: string; // Папка с клиентом
  JavaPath: string; // Путь к Java

  // Переменные для хранения временного пути до скина и плаща для загрузки их на сайт:
  TempSkinPath: string;
  TempCloakPath: string;

  {$IFDEF MONITORING}
  // Поток мониторинга:
  MonitoringThread: TMonitoringThread;
  {$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{
procedure DoDoubleBuffering(Form: TForm);
var
  Component: TComponent;
begin
  Form.DoubleBuffered := True;
  for Component in Form do
    if (Component is TLabel) or
       (Component is TPanel) or
       (Component is TButton) or
       (Component is TImage) or
       (Component is TEdit) then TButton(Component).DoubleBuffered := True;
end;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.FormCreate(Sender: TObject);
{$IFDEF LAUNCH_PERIMETER}
var
  PerimeterSettings: TPerimeterSettings;
{$ENDIF}
begin
  //DoDoubleBuffering(MainForm);

  // Удаляем временные файлы:
  DeleteFile(Injector32Name);
  DeleteFile(Injector64Name);
  DeleteFile(HookLib32Name);
  DeleteFile(HookLib64Name);

  {$IFDEF AUTOUPDATE}
  // Удаляем старый лаунчер:
  DeleteDirectory('*.old');
  {$ENDIF}

  {$IFDEF LAUNCH_PERIMETER}
    FillChar(PerimeterSettings, SizeOf(PerimeterSettings), #0);
    PerimeterSettings.ResistanceType := ShutdownProcess;
    PerimeterSettings.CheckingsType := LazyROM + ASM_A + ASM_B + IDP + RDP + WINAPI_BP + ZwSIT + ZwQIP + ZwClose;
    PerimeterSettings.MessagesReceiverHandle := Handle;
    PerimeterSettings.MessageNumber := PERIMETER_MESSAGE_NUMBER;
    PerimeterSettings.Interval := 300;
    StartPerimeter(PerimeterSettings);
  {$ENDIF}

  // Читаем настройки из реестра:
  LoginEdit.Text := ReadStringFromRegistry(RegistryPath, 'Login', 'Player');
  PasswordEdit.Text := ReadStringFromRegistry(RegistryPath, 'Password', 'Player');
  RAMEdit.Text := ReadStringFromRegistry(RegistryPath, 'RAM', '1024');

  {$IFDEF CUSTOM_JAVA}
  JavaEdit.Text := '### CUSTOM JAVA ###';
  {$ELSE}
    {$IFDEF DETECT_JAVA_PATH}
    JavaEdit.Text := ReadStringFromRegistry(RegistryPath, 'Java', GetCurrentJavaPath);
    {$ELSE}
    JavaEdit.Text := ReadStringFromRegistry(RegistryPath, 'Java', 'C:\Program Files\Java\jre8\bin');
    {$ENDIF}
  {$ENDIF}

  AutoLoginCheckbox.Checked := ReadBooleanFromRegistry(RegistryPath, 'AutoLogin');


  {$IFDEF MULTISERVER}
  ServerListComboBox.Visible := True;
    {$IFDEF LOCAL_SERVERS_LIST}
    GetServerList(LocalServersList);
    SetLauncherSettings(0);
    {$ENDIF}
  {$ENDIF}

  // Создаём флажки-события для потоков загрузки:
  ArrayEvents[EVENT_MAIN] := CreateEvent(nil, TRUE, FALSE, nil);
  ArrayEvents[EVENT_ASSETS] := CreateEvent(nil, TRUE, FALSE, nil);
  SetEvent(ArrayEvents[EVENT_MAIN]);
  SetEvent(ArrayEvents[EVENT_ASSETS]);

  // Создаём основной путь и путь к клиенту:
  Mainpath := GetSpecialFolderPath(26) + MainFolder;
  Minepath := Mainpath;

  {$IFDEF DEBUG_MODE}
  MainpathEdit.Text := MainPath;
  MinepathEdit.Text := Minepath;
  {$ENDIF}

  {$IFDEF MONITORING}
  // Создаём поток мониторинга:
  MonitoringThread := TMonitoringThread.Create(True);
  MonitoringThread.FreeOnTerminate := True;
  MonitoringThread.Priority := tpLower;
  
  MonitoringThread.PrimaryIP := PrimaryIP;
  MonitoringThread.SecondaryIP := SecondaryIP;
  MonitoringThread.Port := StrToInt(GamePort);

  MonitoringLabel.Visible := True;
  {$ENDIF}

  // Если нет Assets'ов (например, клиент старых версий):
  if Length(AssetsAddress) = 0 then
  begin
    AssetsLabel.Visible              := False;
    DownloadAssetsButton.Visible     := False;
    AssetsSizeOfFileLabel.Visible    := False;
    AssetsDownloadedLabel.Visible    := False;
    AssetsSpeedLabel.Visible         := False;
    AssetsRemainingTimeLabel.Visible := False;
  end;

  // Если стоит автологин, то логинимся:
  TypeOfConnection := TYPE_AUTH;
  if AutoLoginCheckbox.Checked then
  begin
    AuthButton.OnClick(Self);
  end;


end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.AuthButtonClick(Sender: TObject);
begin
// Проверяем данные:
  // Логин:
  if Length(LoginEdit.Text) = 0 then
  begin
    MessageBox(Handle, 'Введите логин!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if CheckSymbols(LoginEdit.Text) then
  begin
    MessageBox(Handle, 'В логине есть запрещённые символы!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  // Пароль:
  if Length(PasswordEdit.Text) = 0 then
  begin
    MessageBox(Handle, 'Введите пароль!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  // Недопустимые символы в пароле не проверяем, т.к. он хэшируется.

  // Почта:
  if TypeOfConnection = TYPE_REG then
  begin
    if Length(MailEdit.Text) = 0 then
    begin
      MessageBox(Handle, 'Введите логин!', 'Ошибка!', MB_ICONERROR);
      Exit;
    end;

    if CheckSymbols(MailEdit.Text) then
    begin
      MessageBox(Handle, 'В логине есть запрещённые символы!', 'Ошибка!', MB_ICONERROR);
      Exit;
    end;

    if Pos('@', MailEdit.Text) = 0 then
    begin
      MessageBox(Handle, 'Введён некорректный адрес электронной почты!', 'Ошибка!', MB_ICONERROR);
      Exit;
    end;
  end;

  SetupConnect;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.GameButtonClick(Sender: TObject);
begin
  {$IFDEF CUSTOM_JAVA}
  JavaPath := Minepath + '\' + JavaDir + '\' + JavaApp;
  {$ELSE}
  JavaPath := JavaEdit.Text + '\' + JavaApp;
  {$ENDIF}

  if not FileExists(JavaPath) then
  begin
    MessageBox(Handle, PAnsiChar('Java-машина не найдена!' + #13#10 + 'Предполагаемый путь:' + #13#10 + JavaPath), 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  TypeOfConnection := TYPE_GAMEAUTH;
  SetupConnect;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Подключение к обвязке:
procedure TMainForm.SetupConnect;
begin
  // Настраиваем сокет на первичное подключение:
  ClientSocket.Host := PrimaryIP;
  ClientSocket.Port := ServerPort;

  try
    ClientSocket.Open;
  except
    ClientSocket.Close;

    // Не удалось подключиться по основному IP, пробуем запасной:
    try
      ClientSocket.Host := SecondaryIP;
      ClientSocket.Open;
    except
      ClientSocket.Close;
      if (TypeOfConnection = TYPE_AUTH) or (TypeOfConnection = TYPE_REG) or (TypeOfConnection = TYPE_GAMEAUTH) then
        MessageBox(
                    Handle,
                    PAnsiChar(
                               'Не удалось подключиться!' +#13#10#13#10 +
                               'Тип соединения: ' + IntToStr(TypeOfConnection) + #13#10#13#10 +
                               'Адрес: ' + ClientSocket.Host + ' : ' + IntToStr(ClientSocket.Port) + #13#10 +
                               '  PrimaryIP: ' + PrimaryIP + #13#10 +
                               '  SecondaryIP: ' + SecondaryIP + #13#10 +
                               '  ServerPort: ' + IntToStr(ServerPort) + #13#10 +
                               '  GamePort: ' + GamePort
                              ),
                    'Ошибка!',
                    MB_ICONERROR
                   );
    end;
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Маячок:
procedure BeaconThreadProc;
begin
  TypeOfConnection := TYPE_BEACON;
  MainForm.SetupConnect;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Деавторизация:
procedure DeauthThreadProc;
begin
  TypeOfConnection := TYPE_DEAUTH;
  MainForm.SetupConnect;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  WinSocketStream: TWinSocketStream;
  Buffer: array [0..65534] of Char;

  Received: string;
  Response: string;

  DownloadSkin, DownloadCloak: TDownloadImageThread;

  {$IFNDEF OLD_MINECRAFT}
  MCData: TMinecraftData;
  {$ELSE}
  MCData: TOldMinecraftData;
  {$ENDIF}
  MCProcessInfo: TMCProcessInfo;

  {$IFDEF AUTOUPDATE}
  HTTPSend: THTTPSend;
  LauncherName: string;
  {$ENDIF}

  CommandLine: string;
  {$IFDEF DEBUG_MODE}
  ConsoleThread: TReadConsoleThread;
  {$ENDIF}
begin
  // Создаём поток для обработки ответа от сервера:
  WinSocketStream := TWinSocketStream.Create(ClientSocket.Socket, 3000);

  // Отправляем сообщение:
  case TypeOfConnection of
    TYPE_AUTH:
      ClientSocket.Socket.SendText(
                                    GlobalSalt +
                                    '<type>auth</type>' +
                                    '<login>' + LoginEdit.Text + '</login>' +
                                    '<password>' + HashPassword(PasswordEdit.Text) + '</password>'
                                   );

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

    TYPE_REG:
      ClientSocket.Socket.SendText(
                                    GlobalSalt +
                                    '<type>reg</type>' +
                                    '<login>' + LoginEdit.Text + '</login>' +
                                    '<password>' + HashPassword(PasswordEdit.Text) + '</password>' +
                                    '<mail>' + MailEdit.Text + '</mail>' +
                                    '<hwid>' + GetHWID + '</hwid>'
                                   );

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

    TYPE_GAMEAUTH:
      ClientSocket.Socket.SendText(
                                    GlobalSalt +
                                    '<type>gameauth</type>' +
                                    '<login>' + LoginEdit.Text + '</login>' +
                                    '<password>' + HashPassword(PasswordEdit.Text) + '</password>' +
                                    '<md5>' + GetGameHash(Minepath, MineJarFolder, LibrariesFolder) + '</md5>' +
                                    '<hwid>' + GetHWID + '</hwid>'
                                   );

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

    TYPE_BEACON:
      ClientSocket.Socket.SendText(
                                    GlobalSalt +
                                    '<type>beacon</type>' +
                                    '<login>' + LoginEdit.Text + '</login>' +
                                    '<md5>' + GetGameHash(Minepath, MineJarFolder, LibrariesFolder) + '</md5>'
                                   );

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

    TYPE_DEAUTH:
      ClientSocket.Socket.SendText(
                                    GlobalSalt +
                                    '<type>deauth</type>' +
                                    '<login>' + LoginEdit.Text + '</login>'
                                   );

  end;


//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -


  // Ждём ответ:
  if WinSocketStream.WaitForData(WinSocketStream.TimeOut) then
  begin
    WinSocketStream.Read(Buffer, 65535);
    Received := Buffer;

    {$IFDEF DEBUG_MODE}
    ResponseEdit.Text := Received;
    {$ENDIF}

    // Проверяем версию лаунчера:
    if TypeOfConnection = TYPE_AUTH then
    begin
      if StrToInt(GetXMLParameter(Received, 'version')) <> LauncherVersion then
      begin
        {$IFDEF AUTOUPDATE}
        if MessageBox(Handle, 'Неверная версия лаунчера!' + #13#10 + 'Хотите обновить прямо сейчас?', 'Есть новая версия!', MB_ICONQUESTION + MB_YESNO) = IDYES then
        begin
          HTTPSend := THTTPSend.Create;
          if not HTTPSend.HTTPMethod('GET', LauncherAddress) then
          begin
            MessageBox(Handle, 'Ошибка при загрузке новой версии!' + #13#10 + 'Перезапустите лаунчер и попробуйте снова!', 'Ошибка!', MB_ICONERROR);
            ExitProcess(0);
          end;
          LauncherName := ExtractFileName(Application.ExeName);
          RenameFile(LauncherName, LauncherName + '.old');
          HTTPSend.Document.SaveToFile(LauncherName);
          FreeAndNil(HTTPSend);
          WinExec(PAnsiChar(LauncherName), SW_SHOWNORMAL);
          ExitProcess(0);
        end
        else
        begin
          MessageBox(Handle, 'Для игры обновите лаунчер!', 'Ошибка!', MB_ICONERROR);
          ExitProcess(0);
        end;
        {$ELSE}
        MessageBox(Handle, 'Неверная версия лаунчера!' + #13#10 + 'Скачайте новую версию!', 'Ошибка!', MB_ICONERROR);
        FreeAndNil(WinSocketStream);
        ClientSocket.Close;
        ExitProcess(0);
        {$ENDIF}
      end;
    end;

    // С версией всё нормально, идём дальше:
    Response := GetXMLParameter(Received, 'response');

    
    if Response = 'salt fault' then
      MessageBox(Handle, 'Неверная глобальная соль!', 'Ошибка!', MB_ICONERROR);


    if Response = 'incorrect data' then
      MessageBox(Handle, 'Запрещённые символы!', 'Ошибка!', MB_ICONERROR);


    if Response = 'bad login' then
      MessageBox(Handle, 'Неверный логин или пароль!', 'Ошибка!', MB_ICONERROR);


    if Response = 'already exists' then
      MessageBox(Handle, 'Пользователь уже есть в базе!', 'Ошибка!', MB_ICONERROR);


    if Response = 'distributor connection fail' then
      MessageBox(Handle, 'Не удалось подключиться к распределителю через обвязку!', 'Ошибка!', MB_ICONERROR);


    if Response = 'banned' then
      MessageBox(Handle, 'Вас забанили, идите нахуй!', 'тЫЫ = СЛИЛСЯ!', MB_ICONERROR);


    if Response = 'bad checksum' then
    begin
      // Очищаем папку с игрой:
      FlushGameFolder(Minepath, MineJarFolder, LibrariesFolder);

      if Length(AssetsAddress) > 0 then
        if not DirectoryExists(Minepath + '\assets') then
          DownloadAssetsButton.OnClick(GameButton);

      DownloadMainButton.OnClick(GameButton);
    end;


    if Response = 'success' then case TypeOfConnection of
      TYPE_AUTH:
      begin
        // Меняем панель на панель ЛК:
        MainPageControl.TabIndex := 1;

        // Чистим изображения скина и плаща:
        ClearImage(SkinImage);
        ClearImage(CloakImage);

        // Загружаем скин и плащ:
        DownloadSkin := TDownloadImageThread.Create(True);
        DownloadSkin.ImageType := IMAGE_SKIN;
        DownloadSkin.URL := SkinDownloadAddress + '/' + LoginEdit.Text + '.png';
        DownloadSkin.FreeOnTerminate := True;
        DownloadSkin.Priority := tpNormal;
        DownloadSkin.Resume;

        DownloadCloak := TDownloadImageThread.Create(True);
        DownloadCloak.ImageType := IMAGE_CLOAK;
        DownloadCloak.URL := CloakDownloadAddress + '/' + LoginEdit.Text + '.png';
        DownloadCloak.FreeOnTerminate := True;
        DownloadCloak.Priority := tpNormal;
        DownloadCloak.Resume;

        // Если включена мультисерверность, обрабатываем список серверов:
        {$IFDEF MULTISERVER}
          {$IFNDEF LOCAL_SERVERS_LIST}
            GetServerList(Received);
          {$ENDIF}
          FillServerComboBox(ServerListComboBox);
        {$ENDIF}

        {$IFDEF MONITORING}
        // Запускаем мониторинг:
        MonitoringThread.Resume;
        {$ENDIF}

        // Получаем количество свободной оперативки:
        FreeRAMLabel.Caption := IntToStr(GetFreeMemory) + ' Мб';

        // Сохраняем настройки в реестре:
        SaveStringToRegistry(RegistryPath, 'Login', LoginEdit.Text);
        SaveStringToRegistry(RegistryPath, 'Password', PasswordEdit.Text);
        SaveBooleanToRegistry(RegistryPath, 'AutoLogin', AutoLoginCheckbox.Checked);
      end;

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

      TYPE_REG:
      begin
        MessageBox(Handle, 'Успешная регистрация!', 'Успешно!', MB_ICONASTERISK);
        RegLabel.OnClick(Sender);
      end;

//  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

      TYPE_GAMEAUTH:
      begin
        FillChar(MCData, SizeOf(MCData), #0);
        MCData.Minepath := Minepath;
        MCData.Java := JavaPath;
        MCData.JVMParams := JVMParams;
        MCData.Xms := RAMEdit.Text;
        MCData.Xmx := RAMEdit.Text;
        MCData.NativesPath := Minepath + '\' + NativesPath;
        MCData.CP := GetGameFileList(Minepath, MineJarFolder, LibrariesFolder);
        MCData.MainClass := MainClass;

        {$IFNDEF OLD_MINECRAFT}
        MCData.LogonInfo := '--username ' + MainForm.LoginEdit.Text
                            {$IFDEF SERVER_AUTOCONNECT}
                            + ' ' +
                            '--server ' + ClientSocket.Host + ' ' +
                            '--port ' + GamePort
                            {$ENDIF};
        {$ELSE}
        MCData.LogonInfo := MainForm.LoginEdit.Text;
        {$ENDIF}

        {$IFNDEF OLD_MINECRAFT}
        MCData.GameVersion := GameVersion;
        MCData.GameDir := Minepath;
        MCData.AssetsDir := Minepath + '\' + AssetsFolder;
        MCData.AssetIndex := AssetIndex;
        {$ENDIF}

        MCData.TweakClass := TweakClass;



        // Сохраняем настройки в реестре:
        SaveStringToRegistry(RegistryPath, 'RAM', RAMEdit.Text);
        SaveStringToRegistry(RegistryPath, 'Java', JavaEdit.Text);

        // Запускаем игру:
        {$IFNDEF OLD_MINECRAFT}
        CommandLine := ExecuteMinecraft(MCData, MCProcessInfo);
        {$ELSE}
        CommandLine := ExecuteMinecraftOld(MCData, MCProcessInfo);
        {$ENDIF}

        CommandLineConsole.Clear;
        ClientConsole.Clear;

        CommandLineConsole.Text := CommandLine;

        {$IFDEF DEBUG_MODE}
        ConsoleThread := TReadConsoleThread.Create(True);
        ConsoleThread.MCHandle := MCProcessInfo.Handle;
        ConsoleThread.ReadStdOut := MCProcessInfo.ReadStdOut;
        ConsoleThread.Resume;
        {$ENDIF}

        {$IFDEF CONTROL_PROCESSES}
        // Запускаем защиту процессов:
        StartDefence(MCProcessInfo.Handle, MainForm.Handle, LoginEdit.Text, MCProcessInfo.ID, @DeauthThreadProc);
        {$ENDIF}

        {$IFDEF BEACON}
        // Запускаем маячок:
        StartBeacon(MCProcessInfo.Handle, BeaconDelay, @BeaconThreadProc);
        {$ENDIF}

        {$IFDEF EURISTIC_DEFENCE}
        // Запускаем поиск параллельных клиентов:
        StartEuristicDefence(MCProcessInfo.Handle, MCProcessInfo.ID, EuristicDelay);
        {$ENDIF}
      end;
    end;
  end;


  FreeAndNil(WinSocketStream);
  ClientSocket.Close;
end;



//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//
//           Второстепенный функционал: скины, плащи, доп. кнопки
//
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.ServerListComboBoxSelect(Sender: TObject);
var
  Index: LongWord;
  AssetsState: Boolean;
begin
  Index := ServerListComboBox.ItemIndex;

  Minepath := Mainpath + '\' + Servers[Index].Folder;
  SetLauncherSettings(Index);

  {$IFDEF DEBUG_MODE}
  MainpathEdit.Text := MainPath;
  MinepathEdit.Text := Minepath;
  {$ENDIF}

  {$IFDEF MONITORING}
  // Переключаем сервер для мониторинга:
  MonitoringThread.PrimaryIP := PrimaryIP;
  MonitoringThread.SecondaryIP := SecondaryIP;
  MonitoringThread.Port := StrToInt(GamePort);
  {$ENDIF}

  AssetsState := Length(AssetsAddress) > 0;
  AssetsLabel.Visible              := AssetsState;
  DownloadAssetsButton.Visible     := AssetsState;
  AssetsSizeOfFileLabel.Visible    := AssetsState;
  AssetsDownloadedLabel.Visible    := AssetsState;
  AssetsSpeedLabel.Visible         := AssetsState;
  AssetsRemainingTimeLabel.Visible := AssetsState;
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.UploadCloakButtonClick(Sender: TObject);
var
  Data: Pointer;
  Size: LongWord;
begin
  if TempCloakPath = '' then
  begin
    MessageBox(Handle, 'Плащ не выбран!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if not FileExists(TempCloakPath) then
  begin
    MessageBox(Handle, 'Плащ не найден!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  Data := nil;
  Size := 0;

  AddPOSTField(Data, Size, 'user', LoginEdit.Text);
  AddPOSTFile(Data, Size, 'cloak', LoginEdit.Text, TempCloakPath, 'image/png');
  if HTTPPost(CloakUploadAddress, Data, Size) = 'OK' then
    MessageBox(Handle, 'Плащ успешно установлен!', 'Успех!', MB_ICONASTERISK)
  else
    MessageBox(Handle, 'Плащ не установлен!', 'Ошибка!', MB_ICONERROR);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.UploadSkinButtonClick(Sender: TObject);
var
  Data: Pointer;
  Size: LongWord;
begin
  if TempSkinPath = '' then
  begin
    MessageBox(Handle, 'Скин не выбран!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  if not FileExists(TempSkinPath) then
  begin
    MessageBox(Handle, 'Скин не найден!', 'Ошибка!', MB_ICONERROR);
    Exit;
  end;

  Data := nil;
  Size := 0;

  AddPOSTField(Data, Size, 'user', LoginEdit.Text);
  AddPOSTFile(Data, Size, 'skin', LoginEdit.Text, TempSkinPath, 'image/png');
  if HTTPPost(SkinUploadAddress, Data, Size) = 'OK' then
    MessageBox(Handle, 'Скин успешно установлен!', 'Успех!', MB_ICONASTERISK)
  else
    MessageBox(Handle, 'Скин не установлен!', 'Ошибка!', MB_ICONERROR);
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.ChooseSkinButtonClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  MemoryStream: TMemoryStream;
begin
  // Выбираем скин:
  TempSkinPath := '';
  OpenDialog := TOpenDialog.Create(MainForm);
  OpenDialog.Filter := 'PNG|*.png';
  OpenDialog.Execute(Handle);
  TempSkinPath := OpenDialog.FileName;
  FreeAndNil(OpenDialog);

  if TempSkinPath = '' then Exit;

  // Рисуем скин:
  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(TempSkinPath);
  DrawSkin(MemoryStream, SkinImage);
  FreeAndNil(MemoryStream);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.ChooseCloakButtonClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  MemoryStream: TMemoryStream;
begin
  // Выбираем плащ:
  TempCloakPath := '';
  OpenDialog := TOpenDialog.Create(MainForm);
  OpenDialog.Filter := 'PNG|*.png';
  OpenDialog.Execute(Handle);
  TempCloakPath := OpenDialog.FileName;
  FreeAndNil(OpenDialog);

  if TempCloakPath = '' then Exit;

  // Рисуем плащ:
  MemoryStream := TMemoryStream.Create;
  MemoryStream.LoadFromFile(TempCloakPath);
  DrawSkin(MemoryStream, CloakImage);
  FreeAndNil(MemoryStream);
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.DownloadMainButtonClick(Sender: TObject);
var
  DownloadMain: TDownloadArchiveThread;
begin
  GameButton.Visible := False;
  DownloadMainButton.Visible := False;

  DownloadMain := TDownloadArchiveThread.Create(True);
  DownloadMain.FreeOnTerminate := True;
  DownloadMain.Priority := tpNormal;
  DownloadMain.ArchiveType := ARCHIVE_MAIN;
  DownloadMain.URL := ClientAddress;
  DownloadMain.Destination := Minepath + '\' + ClientTempArchiveName;
  DownloadMain.PlayAfterDownloading := Sender = GameButton;
  ResetEvent(ArrayEvents[EVENT_MAIN]);
  DownloadMain.Resume;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.DownloadAssetsButtonClick(Sender: TObject);
var
  DownloadAssets: TDownloadArchiveThread;
begin
  GameButton.Visible := False;
  DownloadAssetsButton.Visible := False;

  DownloadAssets := TDownloadArchiveThread.Create(True);
  DownloadAssets.FreeOnTerminate := True;
  DownloadAssets.Priority := tpNormal;
  DownloadAssets.ArchiveType := ARCHIVE_ASSETS;
  DownloadAssets.URL := AssetsAddress;
  DownloadAssets.Destination := Minepath + '\' + AssetsTempArchiveName;
  DownloadAssets.PlayAfterDownloading := False;
  ResetEvent(ArrayEvents[EVENT_ASSETS]);
  DownloadAssets.Resume;
end;

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//                      Загрузка клиента, скинов и плащей
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


function GetURLSize(URL: string): Cardinal;
var
  HTTPClient: THTTPSend;
  I: LongWord;
  TempStr: string;
begin
  Result := 0;
  HTTPClient := THTTPSend.Create;

  if HTTPClient.HTTPMethod('HEAD', URL) then
  begin
    for I := 0 to HTTPClient.Headers.Count - 1 do
    begin
      if Pos('content-length', LowerCase(HTTPClient.Headers[I])) <> 0 then
      begin
        TempStr:= copy(HTTPClient.Headers[I], 16, Length(HTTPClient.Headers[I]) - 15);
        Result := StrToInt(TempStr) + Length(HTTPClient.Headers.Text);
        Break;
      end;
    end;
  end;

  FreeAndNil(HTTPClient);
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


{ TDownloadArchiveThread }

procedure TDownloadArchiveThread.Execute;
var
  WrittenBytes: LongWord;
begin
  inherited;

  Downloaded := 0;
  Accumulator := 0;

  // Получаем размер файла на сервере:
  FileSize := GetURLSize(URL);

  // Если файла нет, то выходим:
  if FileSize = 0 then
  begin
    // Сбрасываем флажок:
    case ArchiveType of
      ARCHIVE_MAIN: SetEvent(ArrayEvents[EVENT_MAIN]);
      ARCHIVE_ASSETS: SetEvent(ArrayEvents[EVENT_ASSETS]);
    end;

    Status := DOWNLOAD_FILE_NOT_EXISTS;
    Synchronize(UpdateForm);
    Exit;
  end;

  // Засекаем время:
  QueryPerformanceFrequency(PerformanceFrequency);
  QueryPerformanceCounter(OldTimeCounter);
  StartTimeCounter := OldTimeCounter;

  // Создаём временный файл:
  CreatePath(ExtractFilePath(Destination));
  FileHandle := CreateFile(Destination, CREATE_ALWAYS);

  // Скачиваем файл:
  HTTPClient := THTTPSend.Create;
  HTTPClient.Sock.OnStatus := OnSockStatus;
  HTTPClient.HTTPMethod('GET', URL);

  // Сохраняем итоговый файл и освобождаем память:
{
  HTTPClient.Document.SaveToFile(Destination);
}
  WriteFile(FileHandle, HTTPClient.Document.Memory^, HTTPClient.Document.Size, WrittenBytes, nil);
  CloseHandle(FileHandle);
  FreeAndNil(HTTPClient);

  // Распаковываем архив:
  Status := DOWNLOAD_UNPACKING;
  Synchronize(UpdateForm);
  UnpackFile(Destination, ExtractFilePath(Destination));
  DeleteFile(Destination);

  // Посылаем сигнал ожидания:
  Status := DOWNLOAD_WAITING;
  Synchronize(UpdateForm);

  // Сбрасываем флажок:
  case ArchiveType of
    ARCHIVE_MAIN: SetEvent(ArrayEvents[EVENT_MAIN]);
    ARCHIVE_ASSETS: SetEvent(ArrayEvents[EVENT_ASSETS]);
  end;

  // Ждём второй поток:
  WaitForMultipleObjects(2, @ArrayEvents[0], TRUE, INFINITE);

  Status := DOWNLOAD_SUCCESS;
  Synchronize(UpdateForm);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TDownloadArchiveThread.OnSockStatus(Sender: TObject;
  Reason: THookSocketReason; const Value: string);
var
  NewTimeCounter: Int64;
  TickDownloaded: Int64;
  MiddleSpeed: Single;
  WrittenBytes: LongWord;
begin


  if Reason = HR_ReadCount then
  begin
    TickDownloaded := StrToInt(Value);
    Downloaded := Downloaded + TickDownloaded;

    Accumulator := Accumulator + TickDownloaded;

    // Рассчитываем данные после каждого полученного мегабайта:
    if Accumulator > 1048576 then
    begin
      QueryPerformanceCounter(NewTimeCounter);
      Speed := (Accumulator * PerformanceFrequency) / (NewTimeCounter - OldTimeCounter);
      MiddleSpeed := (Downloaded * PerformanceFrequency) / (NewTimeCounter - StartTimeCounter);
      Speed := (Speed + MiddleSpeed) / 2;
      RemainingTime := (FileSize - Downloaded) / Speed;

      Status := DOWNLOAD_ACTIVE;
      Synchronize(UpdateForm);

      OldTimeCounter := NewTimeCounter;
      Accumulator := 0;

      // Сохраняем скачанные данные в файл:
      WriteFile(FileHandle, HTTPClient.Document.Memory^, HTTPClient.Document.Size, WrittenBytes, nil);
      HTTPClient.Document.Clear;
    end;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TDownloadArchiveThread.UpdateForm;
begin
  case Status of
    DOWNLOAD_FILE_NOT_EXISTS:
      MessageBox(MainForm.Handle, PChar('Файл ' + URL + ' не существует!'), 'Ошибка!', MB_ICONERROR);

    DOWNLOAD_ACTIVE:
    begin
      case ArchiveType of
        ARCHIVE_MAIN:
        with MainForm do
        begin
          MainSizeOfFileLabel.Caption := 'Размер файла: ' + IntToStr(FileSize div 1048576) + ' Мб';
          MainDownloadedLabel.Caption := 'Загружено: ' + IntToStr(Downloaded div 1048576) + ' Мб';
          MainSpeedLabel.Caption := 'Скорость: ' + FormatFloat('0.00', Speed / 1024) + ' Кб/сек';
          MainRemainingTimeLabel.Caption := 'Осталось: ' + FormatFloat('0.00', RemainingTime) + ' сек';
        end;

        ARCHIVE_ASSETS:
        with MainForm do
        begin
          AssetsSizeOfFileLabel.Caption := 'Размер файла: ' + IntToStr(FileSize div 1048576) + ' Мб';
          AssetsDownloadedLabel.Caption := 'Загружено: ' + IntToStr(Downloaded div 1048576) + ' Мб';
          AssetsSpeedLabel.Caption := 'Скорость: ' + FormatFloat('0.00', Speed / 1024) + ' Кб/сек';
          AssetsRemainingTimeLabel.Caption := 'Осталось: ' + FormatFloat('0.00', RemainingTime) + ' сек';
        end;
      end;
    end;

    DOWNLOAD_UNPACKING:
    begin
      case ArchiveType of
        ARCHIVE_MAIN:
        with MainForm do
        begin
          MainSizeOfFileLabel.Caption := 'Размер файла: Распаковка...';
          MainDownloadedLabel.Caption := 'Загружено: Распаковка...';
          MainSpeedLabel.Caption := 'Скорость: 0 Кб/сек';
          MainRemainingTimeLabel.Caption := 'Осталось: 0 сек';
        end;

        ARCHIVE_ASSETS:
        with MainForm do
        begin
          AssetsSizeOfFileLabel.Caption := 'Размер файла: Распаковка...';
          AssetsDownloadedLabel.Caption := 'Загружено: Распаковка...';
          AssetsSpeedLabel.Caption := 'Скорость: 0 Кб/сек';
          AssetsRemainingTimeLabel.Caption := 'осталось: 0 сек';
        end;
      end;
    end;

    DOWNLOAD_WAITING:
    begin
      case ArchiveType of
        ARCHIVE_MAIN:
        with MainForm do
        begin
          MainSizeOfFileLabel.Caption := 'Размер файла: Ожидание...';
          MainDownloadedLabel.Caption := 'Загружено: Ожидание...';
          MainSpeedLabel.Caption := 'Скорость: 0 Кб/сек';
          MainRemainingTimeLabel.Caption := 'Осталось: 0 сек';
        end;

        ARCHIVE_ASSETS:
        with MainForm do
        begin
          AssetsSizeOfFileLabel.Caption := 'Размер файла: Ожидание...';
          AssetsDownloadedLabel.Caption := 'Загружено: Ожидание...';
          AssetsSpeedLabel.Caption := 'Скорость: 0 Кб/сек';
          AssetsRemainingTimeLabel.Caption := 'осталось: 0 сек';
        end;
      end;
    end;

    DOWNLOAD_SUCCESS:
    begin
      case ArchiveType of
        ARCHIVE_MAIN:
        with MainForm do
        begin
          MainSizeOfFileLabel.Caption := 'Размер файла: 0 Мб';
          MainDownloadedLabel.Caption := 'Загружено: 0 Мб';
          MainSpeedLabel.Caption := 'Скорость: 0 Кб/сек';
          MainRemainingTimeLabel.Caption := 'Осталось: 0 сек';

          DownloadMainButton.Visible := True;
        end;

        ARCHIVE_ASSETS:
        with MainForm do
        begin
          AssetsSizeOfFileLabel.Caption := 'Размер файла: 0 Мб';
          AssetsDownloadedLabel.Caption := 'Загружено: 0 Мб';
          AssetsSpeedLabel.Caption := 'Скорость: 0 Кб/сек';
          AssetsRemainingTimeLabel.Caption := 'Осталось: 0 сек';

          DownloadAssetsButton.Visible := True;
        end;
      end;

      MainForm.GameButton.Visible := True;

      if PlayAfterDownloading then MainForm.GameButton.OnClick(MainForm);

    end;
  end;
end;

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

{ TDownloadImageThread }

procedure TDownloadImageThread.Execute;
const
  PNGSignature: Cardinal = $474E5089;
begin
  inherited;
  HTTPClient := THTTPSend.Create;
  HTTPClient.HTTPMethod('GET', URL);

  // Если мы хоть что-то скачали, то проверяем сигнатуру:
  if HTTPClient.Document.Size > 0 then
  begin
    // Если этот файл - PNG, то рисуем скин или плащ:
    if Cardinal(HTTPClient.Document.Memory^) = PNGSignature then
    begin
      Synchronize(UpdateForm);
    end;
  end;

  FreeAndNil(HTTPClient);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TDownloadImageThread.UpdateForm;
begin
  case ImageType of
    IMAGE_SKIN: DrawSkin(HTTPClient.Document, MainForm.SkinImage);
    IMAGE_CLOAK: DrawCloak(HTTPClient.Document, MainForm.CloakImage);
  end;
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.OpenClientFolderClick(Sender: TObject);
begin
  CreatePath(Minepath);
  ShellExecute(Handle, nil, PAnsiChar(Minepath), nil, nil, SW_SHOWNORMAL);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.OpenLauncherFolderClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, '', nil, nil, SW_SHOWNORMAL);
end;

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


function EmptyWorkingSet(Handle: THandle): Boolean; stdcall; external 'psapi.dll';

procedure TMainForm.FreeRAMLabelClick(Sender: TObject);
var
  ProcessList: TProcessList;
  ProcessHandle: THandle;
  ProcessesCount: LongWord;
  I: LongWord;
  OldRAM, NewRAM, Delta: Int64;
begin
  OldRAM := GetFreeMemory;

  GetProcessList(ProcessList);
  ProcessesCount := Length(ProcessList);

  for I := 0 to ProcessesCount - 1 do
  begin
    ProcessHandle := ProcessIDtoHandle(ProcessList[I].ProcessID);
    if ProcessHandle = INVALID_HANDLE_VALUE then Continue;
    EmptyWorkingSet(ProcessHandle);
    CloseHandle(ProcessHandle);
  end;

  NewRAM := GetFreeMemory;
  Delta := NewRAM - OldRAM;

  MessageBox(
              Handle,
              PAnsiChar(
              'Память очищена!' + #13#10 + #13#10 +
              ' - Было: ' + IntToStr(OldRAM) + ' Мб' + #13#10 +
              ' - Стало: ' + IntToStr(NewRAM) + ' Мб' + #13#10 +
              ' - Разница: ' + IntToStr(Delta) + ' Мб'
              ),
              'Успешно!',
              MB_ICONASTERISK
             );
end;



//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//                               Мониторинг
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

{$IFDEF MONITORING}

{ TMonitoringThread }

procedure TMonitoringThread.Execute;
begin
  inherited;

  while True do
  begin
    // Пробуем основной IP:
    ServerActive := GetServerInfo(PrimaryIP, Port, ServerInfo, 120);

    // Если основной недоступен - стучимся в запасной:
    if not ServerActive then
      ServerActive := GetServerInfo(SecondaryIP, Port, ServerInfo, 120);

    Synchronize(UpdateCaption);
    Sleep(1000);
  end;

end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMonitoringThread.UpdateCaption;
begin
  with MainForm do
  begin
    if ServerActive then
    begin
      with ServerInfo do
        MonitoringLabel.Caption := 'Играют: ' + CurrentPlayers + ' из ' + MaxPlayers;

      MonitoringLabel.Font.Color := clBlack;
    end
    else
    begin
      MonitoringLabel.Caption := 'Сервер выключен!';
      MonitoringLabel.Font.Color := clMaroon;
    end;
  end;
end;

{$ENDIF}

//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
//
//
//
//                     Обработка дизайна формы
//
//
//
//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH






procedure TMainForm.RegLabelClick(Sender: TObject);
begin
  case TypeOfConnection of
    TYPE_AUTH:
    begin
      TypeOfConnection := TYPE_REG;

      // Выставляем окно для регистрации:
      MailEdit.Visible := True;
      Label3.Visible := True;
      AuthButton.Caption := 'Зарегистрироваться';
      RegLabel.Caption := 'Авторизация';
    end;

    TYPE_REG:
    begin
      TypeOfConnection := TYPE_AUTH;

      // Выставляем окно для авторизации:
      MailEdit.Visible := False;
      Label3.Visible := False;
      AuthButton.Caption := 'Авторизоваться';
      RegLabel.Caption := 'Регистрация';
    end;
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.RegLabelMouseEnter(Sender: TObject);
begin
  RegLabel.Font.Color := clRed;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.RegLabelMouseLeave(Sender: TObject);
begin
  RegLabel.Font.Color := clHotLight;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.RegLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RegLabel.Font.Style := RegLabel.Font.Style - [fsUnderline];
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.RegLabelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RegLabel.Font.Style := RegLabel.Font.Style + [fsUnderline];
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH


procedure TMainForm.DeauthLabelClick(Sender: TObject);
begin
  {$IFDEF MONITORING}
  MonitoringThread.Suspend;
  {$ENDIF}
  
  MainPageControl.TabIndex := 0;
  SaveBooleanToRegistry(RegistryPath, 'AutoLogin', False);

  TypeOfConnection := TYPE_AUTH;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.DeauthLabelMouseEnter(Sender: TObject);
begin
  DeauthLabel.Font.Color := clRed;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.DeauthLabelMouseLeave(Sender: TObject);
begin
  DeauthLabel.Font.Color := clHotLight;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.DeauthLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DeauthLabel.Font.Style := DeauthLabel.Font.Style - [fsUnderline];
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure TMainForm.DeauthLabelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DeauthLabel.Font.Style := DeauthLabel.Font.Style + [fsUnderline];
end;


//HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

{

const
  ID_AUTH = 0;
  ID_GAME = 1;
  ID_AUTOLOGIN = 2;
  ID_SELF_FOLDER = 3;
  ID_GAME_FOLDER = 4;
  ID_CHOOSE_SKIN = 5;
  ID_UPLOAD_SKIN = 6;
  ID_CHOOSE_CLOAK = 7;
  ID_UPLOAD_CLOAK = 8;
  ID_DOWNLOAD_MAIN = 9;
  ID_DOWNLOAD_ASSETS = 10;
  ID_CHOOSE_SERVER = 11;


function TMainForm.CallProc(FunctionID: LongWord): Boolean;
begin
  Result := True;
  case FunctionID of
    ID_AUTH: AuthButton.Click;
    ID_GAME: GameButton.Click;
    ID_AUTOLOGIN: AutoLoginCheckbox.OnClick(Self);
    ID_SELF_FOLDER: OpenLauncherFolder.Click;
    ID_GAME_FOLDER: OpenClientFolder.Click;
    ID_CHOOSE_SKIN: ChooseSkinButton.Click;
    ID_UPLOAD_SKIN: UploadSkinButton.Click;
    ID_CHOOSE_CLOAK: ChooseCloakButton.Click;
    ID_UPLOAD_CLOAK: UploadCloakButton.Click;
    ID_DOWNLOAD_MAIN: DownloadMainButton.Click;
    ID_DOWNLOAD_ASSETS: DownloadAssetsButton.Click;
    ID_CHOOSE_SERVER: ServerListComboBox.OnSelect(Self);
  else
    Result := False;
  end;
end;

}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Ограничение на число строк в TMemo:
procedure TMainForm.ClientConsoleChange(Sender: TObject);
var
  I: LongWord;
  LinesCount: LongWord;
  Delta: Integer;
  Text: string;
  ConsoleText: string;
const
  MaxLines = 1024;
begin
  LinesCount := ClientConsole.Lines.Count;

  if LinesCount > MaxLines then
  begin
    Delta := LinesCount - MaxLines;
    Text := '';

    for I := 0 to Delta - 1 do Text := Text + ClientConsole.Lines[I];

    ConsoleText := ClientConsole.Text;
    Delete(ConsoleText, 1, Length(Text));
    ClientConsole.Text := ConsoleText;
    SendMessage(ClientConsole.Handle, EM_LINESCROLL, 0, ClientConsole.Lines.Count - 1);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$IFDEF DEBUG_MODE}

{ TReadConsoleThread }

procedure TReadConsoleThread.Execute;
var
  StringLen: LongWord;
begin
  inherited;
  repeat
    ConsoleOutput := ReadConsole(ReadStdOut);
    StringLen := Length(ConsoleOutput);
    if StringLen = 0 then Continue;

    // Удаляем перевод каретки в конце:
    //Delete(ConsoleOutput, StringLen - 1, 2);

    SimpleReplaceParam(ConsoleOutput, #10, #13#10);
    Synchronize(UpdateConsole);
  until WaitForSingleObject(MCHandle, 2) <> WAIT_TIMEOUT;

  CloseHandle(ReadStdOut);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

                                 
procedure TReadConsoleThread.UpdateConsole;
begin
  MainForm.ClientConsole.Lines.Add(ConsoleOutput);
end;

{$ENDIF}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure TMainForm.CalculateChecksumButtonClick(Sender: TObject);
begin
  ChecksumEdit.Text := GetGameHash(Minepath, MineJarFolder, LibrariesFolder);
end;


procedure TMainForm.GoToMainpathButtonClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(MainpathEdit.Text), nil, nil, SW_SHOWNORMAL);
end;


procedure TMainForm.GoToMinepathButtonClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(MinepathEdit.Text), nil, nil, SW_SHOWNORMAL);
end;


end.

unit MinecraftLauncher;

interface

uses
  Windows, Classes, cHash, SysUtils, StringsAPI, Additions, PipesAPI;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{$I Definitions.inc}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

type
  TMinecraftData = record
    Minepath: string;
    Java: string;
    JVMParams: string;
    Xms: string;
    Xmx: string;
    NativesPath: string;
    CP: string;
    MainClass: string;
    PreTweakClass: string;
    LogonInfo: string;
    GameVersion: string;
    GameDir: string;
    AssetsDir: string;
    AssetIndex: string;
    TweakClass: string;
  end;

type
  TOldMinecraftData = record
    Minepath: string;
    Java: string;
    JVMParams: string;
    Xms: string;
    Xmx: string;
    NativesPath: string;
    CP: string;
    MainClass: string;
    PreTweakClass: string;
    LogonInfo: string;
    TweakClass: string;
  end;

type
  TMCProcessInfo = record
    Handle: THandle;
    ID: LongWord;
    ReadStdOut: THandle;
  end;

function ExecuteMinecraft(MinecraftData: TMinecraftData; out MCProcessInfo: TMCProcessInfo): string;
function ExecuteMinecraftOld(MinecraftData: TOldMinecraftData; out MCProcessInfo: TMCProcessInfo): string;
procedure LoadFileToMemory(FilePath: PAnsiChar; out Size: LongWord; out FilePtr: Pointer);
procedure GetFileList(Dir, Pattern: string; var FileList: string);
procedure GetFolderChecksum(Dir, Pattern: string; var Checksum: string);
function GetGameHash(const RootDirectory, MineJarFolder, LibrariesFolder: string): string;
function GetGameFileList(const RootDirectory, MineJarFolder, LibrariesFolder: string): string; inline;
procedure GetGameFileListAndHash(const RootDirectory, MineJarFolder, LibrariesFolder: string; var FileList, SummaryHash: string); inline;
procedure FlushGameFolder(const Minepath, MineJarFolder, LibrariesFolder: string); inline;

implementation


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Запуск Minecraft:
function ExecuteMinecraft(MinecraftData: TMinecraftData; out MCProcessInfo: TMCProcessInfo): string;
var
  lpDirectory, lpFile, lpParameters: PANSIChar;

  StartupInfo: _STARTUPINFOA;
  ProcessInfo: _PROCESS_INFORMATION;
  CommandLine: string;
  {$IFDEF DEBUG_MODE}
  PipeInformation: TPipeInformation;
  {$ENDIF}
begin
  with MinecraftData do
  begin
    lpDirectory := PAnsiChar(MinePath);
    lpFile := PAnsiChar(Java);
    lpParameters := PAnsiChar(
                               '-Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true ' +
                               '-Xms' + Xms + 'm ' +
                               '-Xmx' + Xmx + 'm ' +
                               JVMParams + ' ' +
                               '-Djava.library.path="' + NativesPath + '" ' +
                               '-cp "' + CP + '" ' +
                               MainClass + ' ' +
                               LogonInfo + ' ' +
                               TweakClass + ' ' +
                               '--version ' + GameVersion + ' ' +
                               '--gameDir ' + GameDir + ' ' +
                               '--assetsDir ' + AssetsDir + ' ' +
                               '--assetIndex ' + AssetIndex + ' ' +
                               '--uuid 00000000-0000-0000-0000-000000000000 ' +
                               '--accessToken [] ' +
                               '--userProperties [] ' +
                               '--userType legacy '
                              );
  end;

  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  FillChar(ProcessInfo, SizeOf(ProcessInfo), #0);
  FillChar(MCProcessInfo, SizeOf(MCProcessInfo), #0);

  StartupInfo.wShowWindow := SW_SHOWNORMAL;
  StartupInfo.cb := SizeOf(StartupInfo);

  CommandLine := lpFile + ' ' + lpParameters;

  {$IFNDEF DEBUG_MODE}
    CreateProcess(nil, PAnsiChar(CommandLine), nil, nil, TRUE, 0, nil, lpDirectory, StartupInfo, ProcessInfo);
    CloseHandle(ProcessInfo.hThread);
    MCProcessInfo.Handle := ProcessInfo.hProcess;
    MCProcessInfo.ID     := ProcessInfo.dwProcessId;
  {$ELSE}
    CreatePipes(nil, PAnsiChar(CommandLine), lpDirectory, SW_SHOWNORMAL, REDIRECT_OUTPUT, PipeInformation);
    CloseHandle(PipeInformation.ProcessInfo.hThread);
    MCProcessInfo.Handle     := PipeInformation.ProcessInfo.hProcess;
    MCProcessInfo.ID         := PipeInformation.ProcessInfo.dwProcessId;
    MCProcessInfo.ReadStdOut := PipeInformation.ReadStdOut;
  {$ENDIF}


  {$IFDEF DEBUG_MODE}
  SimpleReplaceParam(CommandLine, ';', #13#10);
  SimpleReplaceParam(CommandLine, '"', #13#10);
  SimpleReplaceParam(CommandLine, ' -', #13#10'-');
  {$ENDIF}
  Result := CommandLine;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Запуск Minecraft до 1.5.2 включительно:
function ExecuteMinecraftOLD(MinecraftData: TOldMinecraftData; out MCProcessInfo: TMCProcessInfo): string;
var
  lpDirectory, lpFile, lpParameters: PANSIChar;

  StartupInfo: _STARTUPINFOA;
  ProcessInfo: _PROCESS_INFORMATION;
  CommandLine: string;

  {$IFDEF DEBUG_MODE}
  PipeInformation: TPipeInformation;
  {$ENDIF}
begin
  with MinecraftData do
  begin
    lpDirectory := PAnsiChar(Minepath);
    lpFile := PAnsiChar(Java);
    lpParameters := PAnsiChar(
                               '-Dfml.ignoreInvalidMinecraftCertificates=true -Dfml.ignorePatchDiscrepancies=true ' +
                               '-Xms' + Xms + 'm ' +
                               '-Xmx' + Xmx + 'm ' +
                               JVMParams + ' ' +
                               '-Djava.library.path="' + NativesPath + '" ' +
                               '-cp "' + CP + '" ' +
                               MainClass + ' ' +
                               TweakClass + ' ' +
                               LogonInfo + ' '
                              );

  end;

  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  FillChar(ProcessInfo, SizeOf(ProcessInfo), #0);

  StartupInfo.wShowWindow := SW_SHOWNORMAL;
  StartupInfo.cb := SizeOf(StartupInfo);

  CommandLine := lpFile + ' ' + lpParameters;

  {$IFNDEF DEBUG_MODE}
    CreateProcess(nil, PAnsiChar(CommandLine), nil, nil, TRUE, 0, nil, lpDirectory, StartupInfo, ProcessInfo);
    CloseHandle(ProcessInfo.hThread);
    MCProcessInfo.Handle := ProcessInfo.hProcess;
    MCProcessInfo.ID     := ProcessInfo.dwProcessId;
  {$ELSE}
    CreatePipes(nil, PAnsiChar(CommandLine), lpDirectory, SW_SHOWNORMAL, REDIRECT_OUTPUT, PipeInformation);
    CloseHandle(PipeInformation.ProcessInfo.hThread);
    MCProcessInfo.Handle     := PipeInformation.ProcessInfo.hProcess;
    MCProcessInfo.ID         := PipeInformation.ProcessInfo.dwProcessId;
    MCProcessInfo.ReadStdOut := PipeInformation.ReadStdOut;
  {$ENDIF}

  {$IFDEF DEBUG_MODE}
  SimpleReplaceParam(CommandLine, ';', #13#10);
  SimpleReplaceParam(CommandLine, '"', #13#10);
  SimpleReplaceParam(CommandLine, ' -', #13#10'-');
  {$ENDIF}

  Result := CommandLine;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure LoadFileToMemory(FilePath: PAnsiChar; out Size: LongWord; out FilePtr: Pointer);
var
  hFile: THandle;
  BytesRead: LongWord;
begin
  hFile := CreateFile(
                       FilePath,
                       GENERIC_READ,
                       FILE_SHARE_READ,
                       nil,
                       OPEN_EXISTING,
                       FILE_ATTRIBUTE_NORMAL,
                       0
                      );

  Size := GetFileSize(hFile, nil);
  GetMem(FilePtr, Size);
  ReadFile(hFile, FilePtr^, Size, BytesRead, nil);
  CloseHandle(hFile);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Получение списка всех файлов и суммарного хэша:
procedure GetGameFileListAndHash(const RootDirectory, MineJarFolder, LibrariesFolder: string; var FileList, SummaryHash: string); inline;
begin
  FileList := GetGameFileList(RootDirectory, MineJarFolder, LibrariesFolder);
  SummaryHash := GetGameHash(RootDirectory, MineJarFolder, LibrariesFolder);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Добавляйте сюда свои папки через GetFileList, если файлы из них нужно вставить в строку запуска:
function GetGameFileList(const RootDirectory, MineJarFolder, LibrariesFolder: string): string; inline;
var
  FileList: string;
begin
  GetFileList(RootDirectory + '\' + MineJarFolder + '\', '*.jar', FileList);

  if Length(LibrariesFolder) > 0 then
    GetFileList(RootDirectory + '\' + LibrariesFolder + '\', '*.jar', FileList);

  Result := FileList;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Добавляйте сюда свои папки через GetFolderChecksum, если их нужно проверять:
function GetGameHash(const RootDirectory, MineJarFolder, LibrariesFolder: string): string;
var
  SummaryHash: string;
  {$IFDEF SALTED_HASH}
  Salt: string;
  {$ENDIF}
begin
  GetFolderChecksum(RootDirectory + '\' + MineJarFolder + '\', '*.jar', SummaryHash);
  if Length(LibrariesFolder) > 0 then
    GetFolderChecksum(RootDirectory + '\' + LibrariesFolder + '\', '*.jar', SummaryHash);

  GetFolderChecksum(RootDirectory + '\mods\', '*.jar', SummaryHash);
  GetFolderChecksum(RootDirectory + '\mods\', '*.zip', SummaryHash);

  Result := MD5DigestToHex(CalcMD5(SummaryHash));

  {$IFDEF SALTED_HASH}
  Randomize;
  Salt := LowerCase(IntToHex(Random($FF), 2));
  Result := Salt + MD5DigestToHex(CalcMD5(Result + Salt));
  {$ENDIF}
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Добавляйте сюда свои папки для удаления при перекачивании клиента:
procedure FlushGameFolder(const Minepath, MineJarFolder, LibrariesFolder: string); inline;
begin
  DeleteDirectory(Minepath + '\' + MineJarFolder);

  if Length(LibrariesFolder) > 0 then
    DeleteDirectory(Minepath + '\' + LibrariesFolder);

  DeleteDirectory(Minepath + '\mods');
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure GetFileList(Dir, Pattern: string; var FileList: string);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(Dir + '*', faDirectory, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      begin
        GetFileList(Dir + SearchRec.Name + '\', Pattern, FileList);
      end;
    until FindNext(SearchRec) <> 0;
  end;
  FindClose(SearchRec);

  if FindFirst(Dir + Pattern, faAnyFile xor faDirectory, SearchRec) = 0 then
  begin
    repeat
      FileList := FileList + Dir + SearchRec.Name + ';';
    until FindNext(SearchRec) <> 0;
  end;
  FindClose(SearchRec);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure GetFolderChecksum(Dir, Pattern: string; var Checksum: string);
var
  SearchRec: TSearchRec;

  Size: LongWord;
  FilePtr: pointer;
begin
  if FindFirst(Dir + '*', faDirectory, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      begin
        GetFolderChecksum(Dir + SearchRec.Name + '\', Pattern, Checksum);
      end;
    until FindNext(SearchRec) <> 0;
  end;
  FindClose(SearchRec);

  if FindFirst(Dir + Pattern, faAnyFile xor faDirectory, SearchRec) = 0 then
  begin
    repeat
      LoadFileToMemory(PAnsiChar(Dir + SearchRec.Name), Size, FilePtr);
      Checksum := Checksum + MD5DigestToHex(CalcMD5(FilePtr^, Size));
      FreeMem(FilePtr);
    until FindNext(SearchRec) <> 0;
  end;
  FindClose(SearchRec);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


end.

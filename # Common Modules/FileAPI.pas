unit FileAPI;

interface

uses
  Windows, ShFolder, ShellAPI;

function CreateFile(const FileName: string; CreatingFlag: LongWord = OPEN_ALWAYS; CreatePathIfNotExists: Boolean = True): THandle; overload;
{
  Создаёт или открывает файл и возвращает хэндл на него.

  CreatingFlag:
    CREATE_ALWAYS - всегда создавать файл
    CREATE_NEW - создавать, только если файл не существует, а если существует - возвращать ошибку
    OPEN_ALWAYS - если файл существует - открывает, если нет - создаёт и открывает
    OPEN_EXISTING - открывает, только если файл существует
    TRUNCATE_EXISTING - открывает и стирает содержимое
	
  CreatePathIfNotExists:
    True - создавать иерархию каталогов пути к файлу
	False - не создавать папки 
}

function GetFileSize(const FileName: string): LongWord; overload;
{
  Получает размер файла
}

function LoadFileToMemory(const FileName: string): Pointer;
{
  Загружает файл в память
}

function DeleteDirectory(Directory: string): Boolean;
{
  Удаляет папку вместе с файлами (поддерживаются маски, например *.exe)
}

function GetSpecialFolderPath(Folder: Integer): string;
{
  Получает пути, описанные в переменных среды (CSIDL_*)
}

const  
  CSIDL_APPDATA          = 26;
  CSIDL_DRIVES           = 17; // Мой компьютер
  CSIDL_SYSTEM           = 37; // C:\Windows\System32
  CSIDL_WINDOWS          = 36; // C:\Windows
  CSIDL_BITBUCKET        = 10; // Корзина

  CSIDL_COOKIES          = 33;
  CSIDL_DESKTOP          = 0;
  CSIDL_FONTS            = 20;
  CSIDL_HISTORY          = 34;
  CSIDL_INTERNET         = 1;
  CSIDL_INTERNET_CACHE   = 32;
  CSIDL_COMMON_STARTMENU = 22;
  CSIDL_STARTMENU        = 11;
  CSIDL_LOCAL_APPDATA    = 28;
  CSIDL_ADMINTOOLS       = 48;    


procedure CreatePath(EndDir: string);
{
  Создаёт иерархию каталогов до конечного каталога включительно.
  Допускаются разделители: "\" и "/"
}

function ExtractFileDir(Path: string): string;
{
  Извлекает путь к файлу. Допускаются разделители: "\" и "/"
}

function ExtractFileName(Path: string): string;
{
  Извлекает имя файла. Допускаются разделители: "\" и "/"
}

function ExtractHost(Path: string): string;
{
  Извлекает имя хоста из сетевого адреса.
  http://site.ru/folder/script.php  -->  site.ru
}

function ExtractObject(Path: string): string;
{
  Извлекает имя объекта из сетевого адреса:
  http://site.ru/folder/script.php  -->  folder/script.php
}

implementation

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Процедуры работы с файловой системой и адресами:
// Допускаются разделители "\" и "/"

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function CreateFile(const FileName: string; CreatingFlag: LongWord = OPEN_ALWAYS; CreatePathIfNotExists: Boolean = True): THandle; overload;
begin
  if CreatePathIfNotExists then CreatePath(ExtractFileDir(FileName) + '\');

  Result := Windows.CreateFile(
                                PChar(FileName),
                                GENERIC_READ or GENERIC_WRITE,
                                FILE_SHARE_READ or FILE_SHARE_WRITE,
                                nil,
                                CreatingFlag,
                                FILE_ATTRIBUTE_NORMAL,
                                0
                               );

end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function GetFileSize(const FileName: string): LongWord; overload;
var
  hFile: THandle;
begin
  hFile := CreateFile(FileName);
  Result := Windows.GetFileSize(hFile, nil);
  CloseHandle(hFile);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function LoadFileToMemory(const FileName: string): Pointer;
var
  hFile: THandle;
  FileSize: LongWord;
  ReadBytes: LongWord;
begin
  Result := nil;
  hFile := CreateFile(FileName);
  
  if hFile <> 0 then
  begin
    FileSize := Windows.GetFileSize(hFile, nil);
    GetMem(Result, FileSize);

    ReadFile(hFile, Result^, FileSize, ReadBytes, nil);
    CloseHandle(hFile);
  end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function DeleteDirectory(Directory: string): Boolean;
var
  FileOpStruct: TSHFileOpStruct;
begin
  ZeroMemory(@FileOpStruct, SizeOf(FileOpStruct));
  with FileOpStruct do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(Directory + #0);
  end;
  Result := ShFileOperation(FileOpStruct) = 0;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function GetSpecialFolderPath(Folder: Integer): string;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array [0..MAX_PATH] of Char;
begin
  if SUCCEEDED(SHGetFolderPath(0, Folder, 0, SHGFP_TYPE_CURRENT, @Path[0])) then
    Result := Path
  else
    Result := '';
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Создаёт иерархию папок до конечной указанной папки включительно:
procedure CreatePath(EndDir: string);
var
  I: LongWord;
  PathLen: LongWord;
  TempPath: string;
begin
  PathLen := Length(EndDir);
  if (EndDir[PathLen] = '\') or (EndDir[PathLen] = '/') then Dec(PathLen);
  TempPath := Copy(EndDir, 0, 3);
  for I := 4 to PathLen do
  begin
    if (EndDir[I] = '\') or (EndDir[I] = '/') then CreateDirectory(PAnsiChar(TempPath), nil);
    TempPath := TempPath + EndDir[I];
  end;
  CreateDirectory(PAnsiChar(TempPath), nil);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Получает каталог, в котором лежит файл:
function ExtractFileDir(Path: string): string;
var
  I: LongWord;
  PathLen: LongWord;
begin
  PathLen := Length(Path);
  I := PathLen;
  while (I <> 0) and (Path[I] <> '\') and (Path[I] <> '/') do Dec(I);
  Result := Copy(Path, 0, I);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Получает имя файла:
function ExtractFileName(Path: string): string;
var
  I: LongWord;
  PathLen: LongWord;
begin
  PathLen := Length(Path);
  I := PathLen;
  while (Path[I] <> '\') and (Path[I] <> '/') and (I <> 0) do Dec(I);
  Result := Copy(Path, I + 1, PathLen - I);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Извлекает имя хоста:
// http://site.ru/folder/script.php  -->  site.ru
function ExtractHost(Path: string): string;
var
  I: LongWord;
  PathLen: LongWord;
begin
  PathLen := Length(Path);
  I := 8; // Длина "http://"
  while (I <= PathLen) and (Path[I] <> '\') and (Path[I] <> '/') do Inc(I);
  Result := Copy(Path, 8, I - 8);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Извлекает имя объекта:
// http://site.ru/folder/script.php  -->  folder/script.php
function ExtractObject(Path: string): string;
var
  I: LongWord;
  PathLen: LongWord;
begin
  PathLen := Length(Path);
  I := 8;
  while (I <= PathLen) and (Path[I] <> '\') and (Path[I] <> '/') do Inc(I);
  Result := Copy(Path, I + 1, PathLen - I);
end;


end.

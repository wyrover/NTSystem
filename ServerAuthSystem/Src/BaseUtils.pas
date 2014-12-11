unit BaseUtils;

interface

function GetXMLParameter(const Data, Param: string): string; inline;
function CheckSymbols(Input: string): Boolean; inline;
function IsSaltedHashValid(const NonSaltedHash, SaltedHash: string): Boolean;
function IsLoginMailInBase(const Login, Mail: string): Boolean;
function IsLoginPasswordInBase(const Login, Password: string): Boolean;
function IsLoginInBase(const Login: string): Boolean;
procedure AddPlayerInBase(const Login, Password, Mail: string);
function IsHWIDInPlayerBase(const Login, HWID: string): Boolean;
procedure AddHWIDInPlayerBase(const Login, HWID: string);
function IsHWIDBanned(const HWID: string): Boolean;
procedure BanPlayerHWIDs(const Login: string);

function GetFileHandle(const FileName: string): THandle; inline;
function IsFileExists(const FileName: string): Boolean; inline;


implementation

uses
  Windows, SysUtils, cHash;

const
  BaseName: string = 'Base.dat';
  HWIDFolder: string = 'Players HWIDs';
  HWIDPostfix: string = '_HWID.dat';
  BannedHWIDsBaseName: string = 'Banned HWIDs.dat';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function GetXMLParameter(const Data, Param: string): string; inline;
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


// Проверка на запрещённые символы:
function CheckSymbols(Input: string): Boolean; inline;
var
  C: Char;
begin
  Result := False;
  for C in Input do
    if C in ['/', '\', ':', '?', '|', '*', '"', '<', '>', ' '] then
    begin
      Result := True;
      Exit;
    end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsSaltedHashValid(const NonSaltedHash, SaltedHash: string): Boolean; inline;
var
  Salt: string;
begin
  Salt := Copy(SaltedHash, 1, 2);
  Result := Salt + MD5DigestToHex(CalcMD5(NonSaltedHash + Salt)) = SaltedHash;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function GetFileHandle(const FileName: string): THandle; inline;
begin
  Result := CreateFile(
                        PAnsiChar(FileName),
                        GENERIC_READ or GENERIC_WRITE,
                        FILE_SHARE_READ or FILE_SHARE_WRITE,
                        nil,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        0
                       );

end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsFileExists(const FileName: string): Boolean; inline;
var
  lpReOpenBuff: _OFSTRUCT;
begin
  FillChar(lpReOpenBuff, SizeOf(lpReOpenBuff), #0);
  lpReOpenBuff.cBytes := SizeOf(lpReOpenBuff);

  Result := OpenFile(PAnsiChar(FileName), lpReOpenBuff, OF_EXIST) = 1;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure CreateNewFile(const FileName: string); inline;
var
  hFile: THandle;
begin
  hFile := CreateFile(
                       PAnsiChar(FileName),
                       GENERIC_READ or GENERIC_WRITE,
                       FILE_SHARE_READ or FILE_SHARE_WRITE,
                       nil,
                       CREATE_ALWAYS,
                       FILE_ATTRIBUTE_NORMAL,
                       0
                      );
  CloseHandle(hFile);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsLoginMailInBase(const Login, Mail: string): Boolean;
var
  hFile: THandle;
  Size: LongWord;
  Buffer: Pointer;
  LoweredBuffer: string;
  ReadBytes: LongWord;
begin
  if not IsFileExists(BaseName) then CreateNewFile(BaseName);

  hFile := GetFileHandle(BaseName);
  Size := GetFileSize(hFile, nil);

  GetMem(Buffer, Size + 2);
  FillChar(Buffer^, Size + 2, #0);

  ReadFile(hFile, Buffer^, Size, ReadBytes, nil);

  CloseHandle(hFile);

  LoweredBuffer := LowerCase(PAnsiChar(Buffer));

  Result := (Pos('<login>' + LowerCase(Login) + '</login>', LoweredBuffer) + Pos('<mail>' + LowerCase(Mail) + '</mail>', LoweredBuffer)) <> 0;
  FreeMem(Buffer);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsLoginPasswordInBase(const Login, Password: string): Boolean;
var
  hFile: THandle;
  Size: LongWord;
  Buffer: Pointer;
  LoweredBuffer: string;
  ReadBytes: LongWord;
begin
  if not IsFileExists(BaseName) then CreateNewFile(BaseName);

  hFile := GetFileHandle(BaseName);
  Size := GetFileSize(hFile, nil);

  GetMem(Buffer, Size + 2);
  FillChar(Buffer^, Size + 2, #0);

  ReadFile(hFile, Buffer^, Size, ReadBytes, nil);

  CloseHandle(hFile);

  LoweredBuffer := LowerCase(PAnsiChar(Buffer));

  Result := Pos('<login>' + LowerCase(Login) + '</login><password>' + LowerCase(Password) + '</password>', LoweredBuffer) <> 0;
  FreeMem(Buffer);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsLoginInBase(const Login: string): Boolean;
var
  hFile: THandle;
  Size: LongWord;
  Buffer: Pointer;
  LoweredBuffer: string;
  ReadBytes: LongWord;
begin
  if not IsFileExists(BaseName) then CreateNewFile(BaseName);

  hFile := GetFileHandle(BaseName);
  Size := GetFileSize(hFile, nil);

  GetMem(Buffer, Size + 2);
  FillChar(Buffer^, Size + 2, #0);

  ReadFile(hFile, Buffer^, Size, ReadBytes, nil);

  CloseHandle(hFile);

  LoweredBuffer := LowerCase(PAnsiChar(Buffer));

  Result := Pos('<login>' + LowerCase(Login) + '</login>', LoweredBuffer) <> 0;
  FreeMem(Buffer);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure AddPlayerInBase(const Login, Password, Mail: string);
var
  hFile: THandle;
  Size: LongWord;
  WriteBytes: LongWord;
  TempStr: string;
begin
  if not IsFileExists(BaseName) then CreateNewFile(BaseName);

  hFile := GetFileHandle(BaseName);

  TempStr := '<login>' + Login + '</login><password>' + Password + '</password><mail>' + Mail + '</mail>' + #13#10;

  Size := Length(TempStr);

  SetFilePointer(hFile, 0, nil, FILE_END);
  WriteFile(hFile, TempStr[1], Size, WriteBytes, nil);
  CloseHandle(hFile);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsHWIDInPlayerBase(const Login, HWID: string): Boolean;
var
  hFile: THandle;
  Size: LongWord;
  Buffer: Pointer;
  ReadBytes: LongWord;
  FileName: string;
begin
  FileName := HWIDFolder + '\' + Login + HWIDPostfix;
  if not DirectoryExists(HWIDFolder) then CreateDirectory(PAnsiChar(HWIDFolder), nil);
  if not IsFileExists(FileName) then CreateNewFile(FileName);

  hFile := GetFileHandle(FileName);
  Size := GetFileSize(hFile, nil);

  GetMem(Buffer, Size + 2);
  FillChar(Buffer^, Size + 2, #0);

  ReadFile(hFile, Buffer^, Size, ReadBytes, nil);

  CloseHandle(hFile);

  Result := (Pos('<hwid>' + HWID + '</hwid>', PAnsiChar(Buffer))) <> 0;
  FreeMem(Buffer);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure AddHWIDInPlayerBase(const Login, HWID: string);
var
  hFile: THandle;
  Size: LongWord;
  WriteBytes: LongWord;
  TempStr: string;
  FileName: string;
begin
  FileName := HWIDFolder + '\' + Login + HWIDPostfix;
  if not DirectoryExists(HWIDFolder) then CreateDirectory(PAnsiChar(HWIDFolder), nil);
  if not IsFileExists(FileName) then CreateNewFile(FileName);

  hFile := GetFileHandle(FileName);
  TempStr := '<login>' + Login + '</login><hwid>' + HWID + '</hwid>' + #13#10;

  Size := Length(TempStr);

  SetFilePointer(hFile, 0, nil, FILE_END);
  WriteFile(hFile, TempStr[1], Size, WriteBytes, nil);

  CloseHandle(hFile);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsHWIDBanned(const HWID: string): Boolean;
var
  hFile: THandle;
  Size: LongWord;
  Buffer: Pointer;
  ReadBytes: LongWord;
begin
  if not IsFileExists(BannedHWIDsBaseName) then CreateNewFile(BannedHWIDsBaseName);

  hFile := GetFileHandle(BannedHWIDsBaseName);
  Size := GetFileSize(hFile, nil);

  GetMem(Buffer, Size + 2);
  FillChar(Buffer^, Size + 2, #0);

  ReadFile(hFile, Buffer^, Size, ReadBytes, nil);

  CloseHandle(hFile);

  Result := (Pos('<hwid>' + HWID + '</hwid>', PAnsiChar(Buffer))) <> 0;
  FreeMem(Buffer);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure BanPlayerHWIDs(const Login: string);
var
  hFile: THandle;
  Size: LongWord;
  ReadBytes, WriteBytes: LongWord;
  FileName: string;
  Buffer: Pointer;
begin
  FileName := HWIDFolder + '\' + Login + HWIDPostfix;
  if not DirectoryExists(HWIDFolder) then CreateDirectory(PAnsiChar(HWIDFolder), nil);
  if not IsFileExists(FileName) then Exit;

  hFile := GetFileHandle(FileName);
  Size := GetFileSize(hFile, nil);

  GetMem(Buffer, Size + 2);
  FillChar(Buffer^, Size + 2, #0);
  ReadFile(hFile, Buffer^, Size, ReadBytes, nil);
  CloseHandle(hFile);

  if not IsFileExists(BannedHWIDsBaseName) then CreateNewFile(BannedHWIDsBaseName);
  hFile := GetFileHandle(BannedHWIDsBaseName);

  SetFilePointer(hFile, 0, nil, FILE_END);
  WriteFile(hFile, Buffer^, Size, WriteBytes, nil);
  CloseHandle(hFile);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


end.

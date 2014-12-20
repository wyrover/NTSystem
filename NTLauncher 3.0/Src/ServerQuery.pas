unit ServerQuery;

interface

uses
  Windows, SysUtils, WinSock;


type
  TServerInfo = record
    MOTD: string;
    MaxPlayers: string;
    CurrentPlayers: string;
  end;

function DNStoIP(Host: string): string;
function GetServerInfo(const IP: string; const Port: Word; out ServerInfo: TServerInfo; const Timeout: Word = 0): Boolean;


implementation


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


// Константы для CodePage:
const
  CP_ACP                   = 0;             { default to ANSI code page }
  CP_OEMCP                 = 1;             { default to OEM  code page }
  CP_MACCP                 = 2;             { default to MAC  code page }
  CP_THREAD_ACP            = 3;             { current thread's ANSI code page }
  CP_SYMBOL                = 42;            { SYMBOL translations }
  CP_UTF7                  = 65000;         { UTF-7 translation }
  CP_UTF8                  = 65001;         { UTF-8 translation }


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Unicode -> ANSI:
function WideStringToString(const WideStringToConversion: WideString; CodePage: Word): AnsiString;
var
  L: Integer;
begin
  if WideStringToConversion = '' then
    Result := ''
  else
  begin
    L := WideCharToMultiByte(
                              CodePage,
                              WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
                              @WideStringToConversion[1],
                              -1,
                              nil,
                              0,
                              nil,
                              nil
                            );

    SetLength(Result, L - 1);

    if L > 1 then
      WideCharToMultiByte(
                           CodePage,
                           WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
                           @WideStringToConversion[1],
                           -1,
                           @Result[1],
                           L - 1,
                           nil,
                           nil
                         );
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function DNStoIP(Host: string): string;
var
  HostEnt: PHostEnt;
begin
  Result := '';
  HostEnt := GetHostByName(PAnsiChar(Host));
  if HostEnt = nil then Exit;
  Result := inet_ntoa(PInAddr(HostEnt^.h_addr_list^)^);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function GetServerInfo(const IP: string; const Port: Word; out ServerInfo: TServerInfo; const Timeout: Word = 0): Boolean;
var
  ClientSocket: TSocket;
  SockAddr: TSockAddr;

  NonBlockingMode: Integer;
  FDSetW: TFDSet;
  FDSetE: TFDSet;
  TimeVal: TTimeVal;

  Data: Word;
  Size: LongWord;

  Buffer: Pointer;

  WideResponse: WideString;
  Response: string;

  StringLen: LongWord;
  Position: LongWord;

  I: LongWord;
const
  BufferSize: LongWord = 1024;

begin
  Result := False;
  FillChar(ServerInfo, SizeOf(ServerInfo), #0);

  // Пытаемся установить соединение:
  ClientSocket := Socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
  if ClientSocket = INVALID_SOCKET then
  begin
    Shutdown(ClientSocket, SD_BOTH);
    CloseSocket(ClientSocket);
    Exit;
  end;

  // Структура с информацией о подключении:
  FillChar(SockAddr, SizeOf(TSockAddr), 0);
  SockAddr.sin_family := AF_INET;
  SockAddr.sin_port := htons(Port);
  SockAddr.sin_addr.S_addr := inet_addr(PAnsiChar(DNStoIP(IP)));

  // Пытаемся подключиться:
  if Timeout > 0 then
  begin
    NonBlockingMode := 1;
    IoCtlSocket(ClientSocket, FIONBIO, NonBlockingMode);
    if Connect(ClientSocket, SockAddr, SizeOf(TSockAddr)) <> 0 then
    begin
      FD_ZERO(FDSetW);
      FD_ZERO(FDSetE);
      FD_SET(ClientSocket, FDSetW);
      FD_SET(ClientSocket, FDSetE);
      TimeVal.tv_sec := Timeout div 1000;
      TimeVal.tv_usec := (Timeout mod 1000) * 1000;
      Select(0, nil, @FDSetW, @FDSetE, @TimeVal);
      if not FD_ISSET(ClientSocket, FDSetW) then
      begin
        Shutdown(ClientSocket, SD_BOTH);
        CloseSocket(ClientSocket);
        Exit;
      end;
    end;
    NonBlockingMode := 0;
    IoCtlSocket(ClientSocket, FIONBIO, NonBlockingMode);
  end
  else
  begin
    if Connect(ClientSocket, SockAddr, SizeOf(TSockAddr)) = 0 then
    begin
      Shutdown(ClientSocket, SD_BOTH);
      CloseSocket(ClientSocket);
      Exit;
    end;
  end;


  // Посылаем данные:
  Data := $01FE;
  Send(ClientSocket, Data, 2, 0);


  // Ждём ответ:
  GetMem(Buffer, BufferSize);
  FillChar(Buffer^, BufferSize, #0);

  Size := LongWord(Recv(ClientSocket, Buffer^, BufferSize, 0));

  // Закрываем соединение:
  Shutdown(ClientSocket, SD_BOTH);
  CloseSocket(ClientSocket);

  if (Size = LongWord(SOCKET_ERROR)) or (Size = 0) then
  begin
    FreeMem(Buffer);
    Exit;
  end;

  // Блок получили, можно парсить:
  Result := True;

// Для начала переведём наш блок в ANSI:

  // Нуль-терминаторы переведём в $A7 (аналог запроса $FE):
  I := 0;
  while I < Size do
  begin
    if Word(Pointer((LongWord(Buffer) + I))^) = 0 then
      Word(Pointer((LongWord(Buffer) + I))^) := Word(Pointer((LongWord(Buffer) + I))^) or $00A7;
    Inc(I, 2);
  end;

  WideResponse := PWideChar(Buffer);
  FreeMem(Buffer);
  Response := WideStringToString(WideResponse, CP_ACP);

// Выделяем нужные блоки:

  // Получаем максимальное количество игроков:
  StringLen := Length(Response);
  Position := LastDelimiter(#$A7, Response);
  ServerInfo.MaxPlayers := Copy(Response, Position + 1, StringLen - Position);

  // Удаляем скопированную строку:
  Response := Copy(Response, 1, Position - 1);

  // Получаем количество игроков на сервере в данный момент:
  StringLen := Length(Response);
  Position := LastDelimiter(#$A7, Response);
  ServerInfo.CurrentPlayers := Copy(Response, Position + 1, StringLen - Position);

  // Удаляем скопированную строку:
  Response := Copy(Response, 1, Position - 1);

  // Получаем MOTD:
  StringLen := Length(Response);
  ServerInfo.MOTD := Copy(Response, 3, StringLen - 2);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function InitWinSock: Integer;
var
  WSAData: TWSAData;
begin
  Result := WSAStartup($202, WSAData);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


initialization
begin
  InitWinSock;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


finalization
begin
  WSACleanup;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


end.

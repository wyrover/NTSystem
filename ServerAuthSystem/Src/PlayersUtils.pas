unit PlayersUtils;

interface

uses
  Windows, SysUtils, BaseUtils, Classes;

// Авторизационная структура:
type
  TPlayerInfo = record
    Name: string;
    RemainingTime: Integer;
  end;

var
  // Игроки в очереди на авторизацию:
  Players: array of TPlayerInfo;

  // Игроки на сервере:
  OnlinePlayers: array of string;

  // Игроки в базе:
  BasePlayers: array of string;

  PlayersCriticalSection: _RTL_CRITICAL_SECTION;

procedure AddPlayer(const Login: string; const RemainingTime: Integer);
procedure RemovePlayer(const Login: string);
function IsPlayerInList(const Player: string): Boolean;

procedure AddPlayerToOnlineList(const Login: string);
procedure RemovePlayerFromOnlineList(const Login: string);
function IsPlayerOnline(const Login: string): Boolean;
procedure FillBasePlayers;

implementation

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure AddPlayer(const Login: string; const RemainingTime: Integer);
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  EnterCriticalSection(PlayersCriticalSection);
  PlayersCount := Length(Players);

  // Проверяем, нет ли игрока в списке:
  if PlayersCount > 0 then
    for I := 0 to PlayersCount - 1 do
      if Players[I].Name = Login then
      begin
        Players[I].RemainingTime := RemainingTime;
        LeaveCriticalSection(PlayersCriticalSection);
        Exit;
      end;

  SetLength(Players, PlayersCount + 1);
  Players[PlayersCount].Name := Login;
  Players[PlayersCount].RemainingTime := RemainingTime;
  LeaveCriticalSection(PlayersCriticalSection);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure RemovePlayer(const Login: string);
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  EnterCriticalSection(PlayersCriticalSection);
  PlayersCount := Length(Players);

  if PlayersCount = 0 then
  begin
    LeaveCriticalSection(PlayersCriticalSection);
    Exit;
  end;

  for I := 0 to PlayersCount - 1 do
  begin
    if Players[I].Name = Login then
    begin
      Players[I] := Players[PlayersCount - 1];
      //Move(Players[PlayersCount - 1], Players[I], SizeOf(TPlayerInfo));
      SetLength(Players, PlayersCount - 1);
      Break;
    end;
  end;

  LeaveCriticalSection(PlayersCriticalSection);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsPlayerInList(const Player: string): Boolean;
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  Result := False;

  EnterCriticalSection(PlayersCriticalSection);
  PlayersCount := Length(Players);
  if PlayersCount > 0 then
    for I := 0 to PlayersCount - 1 do
    begin
      if Players[I].Name = Player then
      begin
        LeaveCriticalSection(PlayersCriticalSection);
        Result := True;
        Exit;
      end;
    end;
  LeaveCriticalSection(PlayersCriticalSection);
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure AddPlayerToOnlineList(const Login: string);
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  PlayersCount := Length(OnlinePlayers);

  if PlayersCount > 0 then
    for I := 0 to PlayersCount - 1 do
      if OnlinePlayers[I] = Login then Exit;

  SetLength(OnlinePlayers, PlayersCount + 1);
  OnlinePlayers[PlayersCount] := Login;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure RemovePlayerFromOnlineList(const Login: string);
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  PlayersCount := Length(OnlinePlayers);

  if PlayersCount = 0 then Exit;

  for I := 0 to PlayersCount - 1 do
    if OnlinePlayers[I] = Login then
    begin
      OnlinePlayers[I] := OnlinePlayers[PlayersCount - 1];
      SetLength(OnlinePlayers, PlayersCount - 1);
      Exit;
    end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function IsPlayerOnline(const Login: string): Boolean;
var
  PlayersCount: LongWord;
  I: LongWord;
begin
  PlayersCount := length(OnlinePlayers);
  Result := False;

  if PlayersCount = 0 then Exit;

  for I := 0 to PlayersCount - 1 do
    if OnlinePlayers[I] = Login then
    begin
      Result := True;
      Exit;
    end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure FillBasePlayers;
var
  StringList: TStringList;
  PlayersCount: LongWord;
  I: LongWord;
begin
  StringList := TStringList.Create;

  if not IsFileExists('Base.dat') then
  begin
    SetLength(BasePlayers, 0);
    FreeAndNil(StringList);
    Exit;
  end;

  StringList.LoadFromFile('Base.dat');
  PlayersCount := StringList.Count;
  SetLength(BasePlayers, PlayersCount);

  if PlayersCount > 0 then
    for I := 0 to PlayersCount - 1 do
      BasePlayers[I] := GetXMLParameter(StringList[I], 'login');

  FreeAndNil(StringList);
end;


end.

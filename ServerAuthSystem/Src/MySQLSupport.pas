unit MySQLSupport;

interface

uses
  MySQL;

type
  TSQLParams = record
    dbHost: string;
    dbPort: Word;
    dbUser: string;
    dbPassword: string;
    dbBaseName: string;
  end;

type
  TSQLInsertParams = record
    Login: string;
    Password: string;
    Mail: string;
    HWID: string;
    Time: string;
    Date: string;
  end;


var
  IsMySQLInit: Boolean = False;

procedure InsertParams(var Request: string; const SQLInsertParams: TSQLInsertParams);

procedure InitMySQL;
procedure DeinitMySQL;
function CheckConnection(MySQLParams: TSQLParams; out Error: string): Boolean;

function GetMySQLData(MySQLParams: TSQLParams; Request: string): Boolean;
procedure SetMySQLData(MySQLParams: TSQLParams; Request: string);

implementation


procedure ReplaceParam(var Source: string; const Param, ReplacingString: string); inline;
var
  StartPos: LongWord;
begin
  StartPos := Pos(Param, Source);
  while StartPos <> 0 do
  begin
    Delete(Source, StartPos, Length(Param));
    Insert(ReplacingString, Source, StartPos);
    StartPos := Pos(Param, Source);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure InsertParams(var Request: string; const SQLInsertParams: TSQLInsertParams);
begin
  with SQLInsertParams do
  begin
    ReplaceParam(Request, '$login', Login);
    ReplaceParam(Request, '$password', Password);
    ReplaceParam(Request, '$mail', Mail);
    ReplaceParam(Request, '$hwid', HWID);
    ReplaceParam(Request, '$time', Time);
    ReplaceParam(Request, '$date', Date);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure InitMySQL;
begin
  LibMySQL_Fast_Load(nil);
  IsMySQLInit := True;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure DeinitMySQL;
begin
  IsMySQLInit := False;
  LibMySQL_Free;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function CheckConnection(MySQLParams: TSQLParams; out Error: string): Boolean;
var
  Connect: PMYSQL;
begin
  Result := False;
  with MySQLParams do
  begin
    Connect := MySQL_Init(nil);
    if Connect = nil then
    begin
      Error := MySQL_Error(Connect);
      MySQL_Close(Connect);
      Exit;
    end;

    if MySQL_Real_Connect(Connect, PAnsiChar(dbHost), PAnsiChar(dbUser), PAnsiChar(dbPassword), PAnsiChar(dbBaseName), dbPort, nil, 0) = nil then
    begin
      Error := MySQL_Error(Connect);
      MySQL_Close(Connect);
      Exit;
    end;

    Error := '';
    MySQL_Close(Connect);
    Result := True;
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function GetMySQLData(MySQLParams: TSQLParams; Request: string): Boolean;
var
  Connect: PMYSQL;
  SQLResult: PMYSQL_RES;
  //Error: PAnsiChar;
begin
  Result := false;

  with MySQLParams do
  begin
    Connect := MySQL_Init(nil);
    if MySQL_Real_Connect(Connect, PAnsiChar(dbHost), PAnsiChar(dbUser), PAnsiChar(dbPassword), PAnsiChar(dbBaseName), dbPort, nil, 0) = nil then
    begin
      //Error := MySQL_Error(Connect);
      MySQL_Close(Connect);
      Exit;
    end;

    // Проверяем, есть ли игрок в базе:
    MySQL_Query(Connect, PAnsiChar('SELECT COUNT(*) AS NUM ' + Request));
    SQLResult := MySQL_Store_Result(Connect);

    // Если в базе есть такой игрок:
    if SQLResult <> nil then
      Result := MySQL_Fetch_Row(SQLResult)[0] = '1';

    MySQL_Close(Connect);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure SetMySQLData(MySQLParams: TSQLParams; Request: string);
var
  Connect: PMYSQL;
  //Error: PAnsiChar;
begin
  with MySQLParams do
  begin
    Connect := MySQL_Init(nil);
    if MySQL_Real_Connect(Connect, PAnsiChar(dbHost), PAnsiChar(dbUser), PAnsiChar(dbPassword), PAnsiChar(dbBaseName), dbPort, nil, 0) = nil then
    begin
      //Error := MySQL_Error(Connect);
      Exit;
    end;

    // Добавляем игрока в базу:
    MySQL_Query(Connect, PAnsiChar(Request));

    MySQL_Close(Connect);
  end;
end;

end.

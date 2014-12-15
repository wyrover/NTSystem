unit StringsAPI;

interface

const
  METHOD_SIMPLE    = 0; // Простая замена
  METHOD_SELECTIVE = 1; // Замена, если параметр не содержится в строке,
                        // образующей заменяющую последовательность

procedure SimpleReplaceParam(var Source: string; const Param, ReplacingString: string);
procedure SelectiveReplaceParam(var Source: string; const Param, ReplacingString: string);
function ReplaceParam(const Source, Param, ReplacingString: string; Method: LongWord = METHOD_SIMPLE): string;

{
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  * Simple - простой метод:
  Source          = aFFabFFabc
  Param           = ab
  ReplacingString = abc

  Result = aFFabcFFabcc

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  * Selective - избирательный метод:
  Source          = aFFabFFabc
  Param           = ab
  ReplacingString = abc

  Result = aFFabcFFabc - крайняя последовательность такая же, как
                         заменяющая строка (abc), поэтому её не трогаем

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

implementation


procedure SimpleReplaceParam(var Source: string; const Param, ReplacingString: string);
var
  SourceLength: Integer;
  ParamLength: Integer;
  ReplacingStrLength: Integer;

  StartPos: Integer;
  NewPos: Integer;

  TempStr: string;
begin
  SourceLength := Length(Source);
  ParamLength := Length(Param);
  ReplacingStrLength := Length(ReplacingString);
  
  NewPos := 1;

  StartPos := Pos(Param, Source);
  while StartPos <> 0 do
  begin
    StartPos := StartPos + NewPos - 1;
    Delete(Source, StartPos, ParamLength);
    Insert(ReplacingString, Source, StartPos);

    NewPos := StartPos + ReplacingStrLength;
    SourceLength := SourceLength + (ReplacingStrLength - ParamLength);

    TempStr := Copy(Source, NewPos, SourceLength - NewPos + 1);
    StartPos := Pos(Param, TempStr);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


procedure SelectiveReplaceParam(var Source: string; const Param, ReplacingString: string);
var
  SourceLength: Integer;
  ParamLength: Integer;
  ReplacingStrLength: Integer;

  StartPos: Integer;
  NewPos: Integer;

  ParamPosInReplacingString: Integer;
  LeftDelta, RightDelta: Integer;
  ParamEnvironment: string;
  TempStr: string;
begin
  SourceLength := Length(Source);
  ParamLength := Length(Param);
  ReplacingStrLength := Length(ReplacingString);

  LeftDelta := 1;
  RightDelta := ReplacingStrLength;

  ParamPosInReplacingString := Pos(Param, ReplacingString);
  if ParamPosInReplacingString <> 0 then
  begin
    LeftDelta := ParamPosInReplacingString - 1;
    RightDelta := ReplacingStrLength - ParamPosInReplacingString;
    {
      Начало строки: Pos - LeftDelta
      Конец строки: Pos + RightDelta
    }
  end;

  NewPos := 1;

  StartPos := Pos(Param, Source);
  while StartPos <> 0 do
  begin
    // Вычисляем абсолютное смещение:
    StartPos := StartPos + NewPos - 1;

    // Получаем окружение параметра:
    if (StartPos - LeftDelta > 0) and (StartPos + RightDelta <= SourceLength) then
    begin
      ParamEnvironment := Copy(Source, StartPos - LeftDelta, ReplacingStrLength);
      if ParamEnvironment = ReplacingString then
      begin
        NewPos := StartPos + RightDelta + 1;

        if NewPos > SourceLength then Exit;

        TempStr := Copy(Source, NewPos, SourceLength - NewPos + 1);
        StartPos := Pos(Param, TempStr);
        Continue;
      end;
    end;

    Delete(Source, StartPos, ParamLength);
    Insert(ReplacingString, Source, StartPos);
    NewPos := StartPos + ReplacingStrLength;
    SourceLength := SourceLength + (ReplacingStrLength - ParamLength);

    TempStr := Copy(Source, NewPos, SourceLength - NewPos + 1);
    StartPos := Pos(Param, TempStr);
  end;
end;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


function ReplaceParam(const Source, Param, ReplacingString: string; Method: LongWord = METHOD_SIMPLE): string;
begin
  Result := Source;

  case Method of
    METHOD_SIMPLE:    SimpleReplaceParam(Result, Param, ReplacingString);
    METHOD_SELECTIVE: SelectiveReplaceParam(Result, Param, ReplacingString);
  end;
end;

end.

unit ksListingUnit;

(*

   Этот модуль предназначен для упрощения процедур вывода пользовательских
данных из таблиц или последовательности строковых данных, содержащих
значения различных типов, — будь то для тестирования алгоритмов при работе
приложения или для вывода информации в файл отчета.

   This module is designed to facilitate the procedures for outputting
user data from tables or a sequence of string data containing values o​f
various types for testing algorithms when running an application or
outputting information to a report file.

*)

interface

uses
  System.Math, System.SysUtils, System.Classes, System.StrUtils,
  System.Generics.Collections,  System.TypInfo, System.Types,

  ComObj, ActiveX, ShlObj, ClipBrd, Winapi.Windows
  ;

resourcestring

  RS_PRM_INP_ERR     = 'Input parameters are not correct';

const  COL_MAX_LEN = 225;

type

 TDelimiters = packed record
   // для заполнения пустот внутри столбцов
   // to fill the gaps inside the columns
   SpaceDelimiter,
   // символ разделитель между столбцами
   // separator character between columns
   ColumnsDelimiter,
   // для заполения линии подчеркивания
   // to fill the underline line
   UnderlineChar,
   // для отделения префикса от строки
   // to separate the prefix from the string
   PrefixDelimiuter,
   // левая скобка для обрамления строки
   // left bracket to enclose a string
   LeftBracket,
   // правая скобка для выделения строкеи
   // right bracket for line breaks
   RighrBracket
              :Char;
   // Определяет наличие разделителя после префикса
   // Determines whether there is a separator after the prefix
   UsePrefixDelimiter :boolean;
   // безусловное ограничение длинны строки шириной столбца
   // unconditional limitation of the row length by the column width
   MaxColLen
             :byte;

   constructor Create(const ASpaceDelimiter,
                        AColumnsDelimiter,
                        AUnderlineChar,
                        APrefixDelimiuter,
                        ALeftBracket, ARighrBracket
                                  : Char;
                      const AUsePrefixDelimiter :boolean;
                      const AMaxColLen :Byte = COL_MAX_LEN);
 end;

var

(*
  Предопределенный и инициализируемый в данном модуле текущий формат
  символов-разделителей строк и столбцоов пользовательских данных,
  используемый _() функциями

  The current format of row and column separator characters for user data,
  predefined and initialized in this module, used by the _() functions
*)
 _D :TDelimiters;

type

(*
Чистая структура для настройки, диагностики и вывода пользовательских данных
в символьном виде как для одного столбца, так и составной строки листинга

A clean structure for customization, diagnostics, and output of user data
in symbolic form for both a single column and a composite listing row
*)
  TFormatHolder = packed record
    // ширина столбца, вычисляемая при создании объекта TFormatHolder
    // the column width calculated when the TFormatHolder object is created
    Wid :Byte;
    case FF : TFloatFormat of
      ffExponent: (
        DigExp : Byte;
        DecExp : Byte;
      );
      ffFixed, ffGeneral, ffNumber, ffCurrency: (
        Dig : Byte;
        Dec : Byte;
      );
  end;

var

(*
Предопределенный и инициализируемый в данном модуле текущий формат вывода
пользовательских данных, используемый всеми функциями _()

The current user data output format, predefined and initialized in this module,
used by all _() functions
*)

  _F :TFormatHolder;

(*
Предопределенные и инициализируемые в модуле наиболее популярные форматы
для использования или присвоения текущему в коде, например _F := _F10E2;

The most popular formats are predefined and initialized in the module
for use or assignment to the current one in the code,
for example, _F := _F10E2;
*)

  f12v10, f12v8, f12v3,
  f8v3,   f8v4,
  f6v1,   f6v3,

  f10e2,  f8e2
          :TFormatHolder;

(*
  f12v10 := TFormatHolder.Create( ffFixed, 12, 10);
  f12v8  := TFormatHolder.Create( ffFixed, 12,  8);
  f12v3  := TFormatHolder.Create( ffFixed, 12,  3);

  f8v4   := TFormatHolder.Create( ffFixed, 8,   4);
  f8v3   := TFormatHolder.Create( ffFixed, 8,   3);

  f6v1  := TFormatHolder.Create( ffFixed,     6,  1);  // Angles in deg
  f6v3  := TFormatHolder.Create( ffFixed,     6,  3);  // Angles in rad

  f10e2  := TFormatHolder.Create( ffExponent, 10, 2);
  f8e2   := TFormatHolder.Create( ffExponent,  8, 2);
*)

type

(*
Хелпер с точной логикой, валидацией и расчётом ширины столбца

Helper with precise logic, validation, and column width calculation
*)

  TFormatHelper = record helper for TFormatHolder
  public
    // Константы верификации, изолированы внутри типа
    // Verification сonstants, isolated within a type
    const MaxDoublFigs = 15;
    const MaxDoubleDig = 12;
    const MaxDoubleDec = 12;
    const MaxExpFigs   = 4;
    //
    class function Create(const FloatFormat: TFloatFormat;
                          const ADig, ADec: Byte): TFormatHolder; static;
    // log about object
    function ToString: string;
  end;

(*
  Функция рулетка для контроля количества символов в выводимой строке.

  Roulette function for controlling the number of characters in the output line.
*)
  function Roulette(const Count :word): string;


(*
  Функция принимают строку и возвращает строку, окруженную любыми скобками.

  The function takes a string and returns the string surrounded by any parentheses.
*)
  function _B(const AStr :string; const ABrk :string = '<>') :string;

(*
  Функции принимают строку и желаемую ширину столбца.
  Если длина строки не превышает ширину столбца и COL_MAX_LEN,
  то возвращает отцентрированную строку, занимающую штрину столбца.

  The functions take a row and the desired column width.
  If the row length does not exceed the column width and COL_MAX_LEN,
  This returns a centered string that occupies the column's line.
*)

function _L(const AStr: string; const AColumnWidth: word): string; //    влево
function _C(const AStr: string; const AColumnWidth: word): string; // по центру
function _R(const AStr: string; const AColumnWidth: word): string; //    вправо

(*
  Добавляет к строке листинга префикс, выравненный по правому краю и
  добавляет  справа от префикса символ разделитель _D.Tab

  Adds a right-aligned prefix to the listing string and
  adds the _D.Tab separator character to the right of the prefix.
*)
function _P(const InpStr :string;
            const PrefWidth :byte; const Pref :string; out wid :word) :string;

(*
  Переопределенные функции для преобразования простых типов данныхв строку
  в соответствии с текущим форматом _F, для ширины стобца _Wid
  или в соответствии с указанным форматом FH, при необходимости

  Overridden functions for converting simple data types to strings
  according to the current _F format, for the column width _Wid
  or according to the specified FH format, if necessary
*)
function _V(const val: Boolean): string; overload;
function _V(const val: Boolean; const FH :TFormatHolder): string; overload;

function _V(const val: Single): string; overload;
function _V(const val: Single; const FH :TFormatHolder): string; overload;

function _V(const val: Double  ): string; overload;
function _V(const val: Double; const FH :TFormatHolder): string; overload;

function _V(const val: Extended): string; overload;
function _V(const val: Extended; const FH :TFormatHolder): string; overload;
(*  пользователь может доопределить свои типы: $,.. *)
(* the user can define his own types: $,.. *)

(*  Составные регулярные типы данных / Composite regular data types   *)
function _V(const arr: Array of Double): string; overload;
function _V(const arr: Array of Double; const FH :TFormatHolder): string; overload;


type

(*
  Функция для листинга заголовка переменной типа TDateTime. Использует свой формат.

  A function for listing the header of a TDateTime variable. Uses its own format.
*)
  TDateTimeHelper = record helper for TDateTime
    class function Head(out wid: Word) :string; static;
  end;

(*
  Функция для листинга переменной типа TDateTime. Использует свой формат.

  A function for listing a TDateTime variable. Uses its own format.
*)
function _V(const DateTime :TDateTime): string; overload;

function _V(const val :word) :string; overload;
function _V(const arr: Array of Word): string; overload;    // _D.Col, +

function _V(const val :Integer) :string; overload;
function _V(const arr: Array of Integer): string; overload; // _D.Col, +

(*
  Нумерация заголовков [0 .. count - 1] для регулярных типов
  в соответствии с текущим форматом _F, _D.Tab для ширины стобца _Wid

  Header numbering [0 .. count - 1] for regular types
  according to the current format _F, _D.Tab for column width _Wid
*)
function _H(const AColumns :Integer; out TotalLen: Word;
            const FirstAndLastDelimiters :boolean = false): string; overload;

function _H(const AColumns :Integer; const FH :TFormatHolder;
              out TotalLen: Word;
            const FirstAndLastDelimiters :boolean = false): string; overload;

(* Наименования заголовков предоставляемым списком строк
   Header names provided by the list of strings *)
function _H(const ArrStr: Array of string; out TotalLen:Word;
            const ColumnWidth :word = 0;
            const FirstAndLastDelimiters :boolean = false): string; overload;

function _H(const ArrStr: Array of string;
            const FH :TFormatHolder; out TotalLen :Word;
            const FirstAndLastDelimiters :boolean = false): string; overload;

(*
  функция для подчеркивания в лдистинге строк из регулярных типов
  шириной _F.Wid с учетолм длинны префикса PrefWid, есои он есть

  A function for underlining strings of regular types in ledger editing
  width _F.Wid, taking into account the length of the PrefWid prefix, if present
*)
function _E(const AColumns :Integer;  const PrefWid :integer;
            const FirstAndLastDelimiters :boolean = false): string; overload;

(*
  функция для подчеркивания в лдистинге строк с заданным количеством символов,
  ASymbols, которое определятеся длинной суммарного заголовка строки _H
*)
function _E(const ASymbols :Integer): string; overload;

(*
  Функция для финальноой или промежуточной сборки каждой строки листинга
  из уже верифицированныйх строк столбцов (без проверки дпустимой ширины),
  с функцией вставки разделителей между столбцами в соответствии с
  текущими параметрами _D

  A function for final or intermediate assembly of each listing row
  from already verified column rows (without validation), with the function
  of inserting separators between columns according to the _tab,_lin :Char
  parameters

*)

(*
  Для сборки строки из стандартных параметров следует использовать комбинацию
  To assemble a string from standard parameters, you should use a combination

    _U( [_V(), _V(), .. _V()], Width)

  В этом случае будет учтен текущий формат _F или набор предопределенных
  форматов типа f12v8
  In this case, the current _F format or a set of predefined formats such as
  f12v8 will be taken into account.
*)

// Move using option of _U()

function _U(const ArrStr :array of string;
            out TotalLen :Word; const ColumnWidth :word = 0;
            const FirstAndLastDelimiters :boolean = false) :string;

implementation

function Roulette(const Count :word): string;
var i :word;
begin
  for i := 1 to count do result := result + IntToStr(i mod 10);
  result := _B(result) + ' : Roulette';
end;

function _B(const AStr :string; const ABrk :string = '<>') :string;
begin
  result := concat( abrk[1], astr, abrk[2]);
end;


function _U(const ArrStr :array of string;
            out TotalLen :Word; const ColumnWidth :word = 0;
            const FirstAndLastDelimiters :boolean = false) :string;
var
  Item, ItemCount, SepLen, CharsToCopy: integer;
  P: PChar;
  TmpStr: string; // Локальный буфер для защиты временных строк от удаления
begin
  ItemCount := Length(ArrStr);
  if (ItemCount <= 0) then
  begin
    TotalLen := 0;
    Exit('');
  end;

  SepLen := Length(_D.ColumnsDelimiter);

  // 1. ТОЧНЫЙ РАСЧЕТ ДЛИНЫ СТРОКИ (В СИМВОЛАХ)
  if ColumnWidth > 0 then
    // Ветка фиксированной ширины: каждая колонка занимает ровно ColumnWidth символов
    TotalLen := ColumnWidth * ItemCount
  else
  begin
    // Ветка динамической ширины: суммируем реальные длины строк
    TotalLen := 0;
    for Item := 0 to ItemCount - 1 do
      Inc(TotalLen, Length(ArrStr[Item]));
  end;

  // Добавляем длину разделителей между колонками
  Inc(TotalLen, SepLen * (ItemCount - 1));

  // Добавляем длину крайних разделителей, если они включены
  if FirstAndLastDelimiters then
    Inc(TotalLen, SepLen * 2);

  // Выделяем память под итоговую строку ровно один раз
  SetLength(Result, TotalLen);
  P := PChar(Result);

  // Вспомогательная процедура для безопасного копирования строк через Move
  // и ПРАВИЛЬНОГО сдвига указателя P (на количество символов!)
  var WriteStr := procedure(const S: string)
  begin
    if S <> '' then
    begin
      Move(PChar(S)^, P^, Length(S) * SizeOf(Char));
      Inc(P, Length(S)); // Сдвиг указателя НА КОЛИЧЕСТВО СИМВОЛОВ, Delphi сам учтет SizeOf(Char)
    end;
  end;

  // 2. СБОРКА И ЗАПИСЬ СТРОКИ

  // Пишем левый разделитель
  if FirstAndLastDelimiters then
    WriteStr(_D.ColumnsDelimiter);

  if ColumnWidth > 0 then
  begin
    // --- ВЕТКА: Фиксированная ширина колонок ---
    for Item := 0 to ItemCount - 1 do
    begin
      if Item > 0 then
        WriteStr(_D.ColumnsDelimiter); // Разделитель между колонками

      // Вызываем форматирование, сохраняем в TmpStr для безопасности
      TmpStr := _R(ArrStr[Item], ColumnWidth);
      WriteStr(TmpStr);
    end;
  end
  else
  begin
    // --- ВЕТКА: Собственная (динамическая) ширина колонок ---
    for Item := 0 to ItemCount - 1 do
    begin
      if Item > 0 then
        WriteStr(_D.ColumnsDelimiter); // Разделитель между колонками

      // Здесь передаем реальную длину строки в символах
      TmpStr := _R(ArrStr[Item], Length(ArrStr[Item]));
      WriteStr(TmpStr);
    end;
  end;

  // Пишем правый разделитель
  if FirstAndLastDelimiters then
    WriteStr(_D.ColumnsDelimiter);
end;


function _V(const val :word) :string;
begin
  result := _R( IntToStr(val), 6);  // 0..65535;
end;

function _V(const arr: Array of Word): string; overload;
var
  i :Word;
begin
  result := '';
  if length(arr) > 0 then
  for i := 0 to length(arr) - 1
    do result := Concat( result, _D.ColumnsDelimiter, _V(arr[i]) );
end;


function _V(const val: Boolean): string; overload;
begin
  result := _R( BoolToStr( val, true), _F.Wid);
end;

function _V(const val: Boolean; const FH :TFormatHolder): string; overload;
begin
  result := _R( BoolToStr( val, true), FH.Wid);
end;


function _V(const val :Integer) :string; overload;
begin
  result := _R( IntToStr(val), 12); // -2147483648..2147483647;
end;

function _V(const arr: Array of Integer): string; overload;
var
  i :Word;
begin
  result := '';

  if length(arr) > 0 then
  for i := 0 to length(arr) - 1
    do result := Concat( result, _D.ColumnsDelimiter, _V(arr[i]) );
end;


function _V(const val: Double): string;
begin
  case _F.FF of
  ffFixed:
  Result := _R( FloatToStrF(val,ffFixed,_F.Dig,_F.Dec), _F.Wid);
  ffExponent:
  Result := _R( FloatToStrF(val,ffExponent,_F.DigExp,_F.DecExp),_F.Wid);
  end;
end;

function _V(const val: Double; const FH :TFormatHolder): string;
begin
  case FH.FF of
  ffFixed:
  Result := _R( FloatToStrF(val,ffFixed, FH.Dig, FH.Dec), FH.Wid);
  ffExponent:
  Result := _R( FloatToStrF(val,ffExponent, FH.DigExp, FH.DecExp), FH.Wid);
  end;
end;


function _V(const val: Single): string;
begin
  case _F.FF of
  ffFixed:
  Result := _R( FloatToStrF(val,ffFixed,_F.Dig,_F.Dec), _F.Wid);
  ffExponent:
  Result := _R( FloatToStrF(val,ffExponent,_F.DigExp,_F.DecExp),_F.Wid);
  end;
end;

function _V(const val: Single; const FH :TFormatHolder): string;
begin
  case FH.FF of
  ffFixed:
  Result := _R( FloatToStrF(val,ffFixed, FH.Dig, FH.Dec), FH.Wid);
  ffExponent:
  Result := _R( FloatToStrF(val,ffExponent,FH.DigExp,FH.DecExp),FH.Wid);
  end;
end;


function _V(const val: Extended): string;
begin
case _F.FF of
  ffFixed:
  Result := _R( FloatToStrF(val,ffFixed,_F.Dig,_F.Dec), _F.Wid);
  ffExponent:
  Result := _R( FloatToStrF(val,ffExponent,_F.DigExp,_F.DecExp),_F.Wid);
end;
end;

function _V(const val: Extended; const FH :TFormatHolder): string;
begin
case FH.FF of
  ffFixed:
  Result := _R( FloatToStrF(val,ffFixed, FH.Dig, FH.Dec),  FH.Wid);
  ffExponent:
  Result := _R( FloatToStrF(val,ffExponent, FH.DigExp, FH.DecExp), FH.Wid);
end;
end;


function _V(const arr: Array of Double): string; overload;
var
  i,n :integer;
begin
  result := '';
  n := length(arr);
  if n <= 0 then Exit;
  result := _V(arr[0]);
  if n <= 1 then Exit;
  for i := 1 to length(arr) - 1
    do result := Concat( result, _D.ColumnsDelimiter, _V(arr[i]));
end;

function _V(const arr: Array of Double; const FH :TFormatHolder): string; overload;
var
  i,n :integer;
begin
  result := '';
  n := length(arr);
  if n <= 0 then Exit;
  result := _V(arr[0], FH);
  if n <= 1 then Exit;
  for i := 1 to length(arr) - 1
    do result := Concat( result, _D.ColumnsDelimiter, _V(arr[i], FH));
end;

function _V(const DateTime :TDateTime): string;
begin
  Result := _R( FormatDateTime('dd.MM.yyyy HH:mm:ss.zzz', DateTime), 24);
end;


function _H(const AColumns :Integer; out TotalLen :Word;
            const FirstAndLastDelimiters :boolean): string; overload;
var
  i :integer;
  ArrStr :Array of string;
begin
  result := '';
  if AColumns <= 0 then Exit;
  SetLength( ArrStr, AColumns);
  for i := 0 to AColumns - 1 do ArrStr[i] := _R( IntTostr(i), _F.Wid);
  Result := _U( ArrStr, TotalLen, _F.Wid, FirstAndLastDelimiters);
  SetLength( ArrStr, 0);
end;

function _H(const AColumns :Integer; const FH :TFormatHolder;
            out TotalLen :Word;
            const FirstAndLastDelimiters :boolean): string; overload;
var
  i :integer;
  ArrStr :Array of string;
begin
  Result := '';
  if AColumns <= 0 then Exit;
  SetLength( ArrStr, AColumns);
  for i := 0 to AColumns - 1 do ArrStr[i] := _R( IntTostr(i), FH.Wid);
  Result := _U( ArrStr, TotalLen, FH.Wid, FirstAndLastDelimiters);
  SetLength( ArrStr, 0);
end;

function _H(const ArrStr: Array of string; out TotalLen :Word;    // == _U()
            const ColumnWidth :word;
            const FirstAndLastDelimiters :boolean): string; overload;
begin
  Result := _U( ArrStr, TotalLen, ColumnWidth, FirstAndLastDelimiters);
end;


function _H(const ArrStr: Array of string; const FH :TFormatHolder;
            out TotalLen :Word;
            const FirstAndLastDelimiters :boolean): string; overload;
begin
  Result := _U( ArrStr, TotalLen, FH.Wid, FirstAndLastDelimiters);
end;


function _E(const AColumns :Integer; const PrefWid :integer;
            const FirstAndLastDelimiters :boolean): string; overload;
var
  i, TotalLen, SepLen :integer;
begin
  result := '';
  if AColumns < 1 then exit;
  // Calc TotalLen
  SepLen   := Length( _D.UnderlineChar);
  TotalLen := PrefWid + (AColumns * _F.Wid) * SepLen + (Acolumns - 1) * SepLen;
  if FirstAndLastDelimiters then TotalLen := ToTalLen + 2 * SepLen;
  // assigne
  result := StringOfChar( Char(_D.UnderlineChar), TotalLen);
end;

function _E(const ASymbols :Integer): string; overload;
begin
  result := StringOfChar( _D.UnderlineChar, ASymbols);
end;


function _R(const AStr: string; const AColumnWidth: word): string;
begin
  if (AColumnWidth > _D.MaxColLen) then raise Exception('_R : ' + RS_PRM_INP_ERR);
  // Если реальная длина строки превышает заказанную ширину колонки
  // If the actual row length exceeds the ordered column width
  if Length(astr) > AColumnWidth + 1
  then
    // Вместо падения теста заполняем всю ширину колонки звездочками
    // Instead of falling dough, we fill the entire width of the column with stars
    Result := Concat(_D.SpaceDelimiter, StringOfChar('*', AColumnWidth-1))
  else
    // Если всё хорошо — выполняем стандартное правое выравнивание пробелами
    // If everything is ok, we perform standard right alignment with spaces.
    Result := Concat(
      StringOfChar(_D.SpaceDelimiter, AColumnWidth - Length(astr)), astr);
end;

function _L(const AStr: string; const AColumnWidth: word): string;
begin
  if (AColumnWidth > _D.MaxColLen) then raise Exception('_L : '+RS_PRM_INP_ERR);
  // Если реальная длина строки превышает заказанную ширину колонки
  // If the actual row length exceeds the ordered column width
  if (Length(astr) > AColumnWidth)
  then
    // Вместо падения теста заполняем всю ширину колонки звездочками
    // Instead of falling dough, we fill the entire width of the column with stars
    Result := Concat( StringOfChar('*', AColumnWidth-1), _D.SpaceDelimiter)
  else
    // Если всё хорошо — выполняем стандартное правое выравнивание пробелами
    // If everything is ok, we perform standard right alignment with spaces.
    Result := Concat(
      astr, StringOfChar(_D.SpaceDelimiter,AColumnWidth - Length(astr)) );
end;

function _C(const AStr: string; const AColumnWidth: word): string;
var
  LeftSpace, RightSpace :Byte;
begin
  if (AColumnWidth > _D.MaxColLen) then raise Exception('_C : ' + RS_PRM_INP_ERR);
  // Если реальная длина строки превышает заказанную ширину колонки
  // If the actual row length exceeds the ordered column width
  if Length(astr) > AColumnWidth
  then
    // Вместо падения теста заполняем всю ширину колонки звездочками
    // Instead of falling dough, we fill the entire width of the column with stars
    Result := Concat( _D.SpaceDelimiter,
                      StringOfChar('*', AColumnWidth-2),
                      _D.SpaceDelimiter )
  else begin
    // Если всё хорошо — выполняем стандартное правое выравнивание пробелами
    // If everything is ok, we perform standard right alignment with spaces.
    LeftSpace  := (AColumnWidth - Length(astr)) div 2;
    RightSpace := (AColumnWidth - Length(astr)) - LeftSpace;
    Result := Concat( StringOfChar(_D.SpaceDelimiter,LeftSpace),  astr,
                      StringOfChar(_D.SpaceDelimiter,RightSpace) );
  end;
end;

function _P(const InpStr :string; const PrefWidth :byte;
                                  const Pref :string; out wid :word) :string;
begin
  result := _L( Pref, PrefWidth);
  if _D.UsePrefixDelimiter then result := concat(result, _D.PrefixDelimiuter);
  result := concat( result, InpStr);
  wid := length(result);
end;

{ TDoublFormatHelper }

class function TFormatHelper.Create(const FloatFormat: TFloatFormat;
                                      const ADig, ADec: Byte): TFormatHolder;
begin
  // Полностью очищаем память структуры
  // Clearing the structure's memory completely
  FillChar(Result, SizeOf(Result), 0);
  Result.FF := FloatFormat;
  case FloatFormat of

    ffExponent:
    begin
      // Исправлено: ADig управляет общей/мантиссной частью, ADec
      // управляет дробной экспоненты
      // Fixed: ADig controls the common/mantissa part, ADec
      // controls the fractional exponent

      Result.DigExp := System.Math.Min( ADig, MaxDoubleDig);
      Result.DecExp := System.Math.Min( ADec, MaxExpFigs);
      // Точная формула рассчета ширины с учётом запаса
      // The exact formula for calculating the width taking into account the reserve
      Result.Wid    := Result.DecExp + Result.DigExp + 5;
    end;

    ffFixed:
    begin
      // Бизнес-защита от некорректных параметров
      // Business protection from incorrect parameters
      if (ADig - ADec) < 2 then
        raise Exception.Create('GetDblFormat : ' + rs_PRM_INP_ERR);
      Result.Dig := System.Math.Min(ADig, MaxDoubleDig);
      Result.Dec := System.Math.Min(ADec, MaxDoubleDec);
      // Формула рассчета ширины для фиксированной точки
      // Formula for calculating the width for a fixed point
      Result.Wid := Result.Dig + 3;
    end;

    ffNumber, ffCurrency, ffGeneral:
    begin
      // Блокируем пока еще неиспользуемые форматы
      // We block formats that are not yet used
      raise Exception.Create('GetDblFormat : ' + rs_PRM_INP_ERR);
    end;
  end;
end;

function TFormatHelper.ToString: string;
begin
  case Self.FF of
    ffFixed:
      Result :=
      Format('[Fixed] Wid: %d, Dig: %d, Dec: %d',
              [Self.Wid, Self.Dig, Self.Dec]);
    ffExponent:
      Result :=
        Format('[Exponent] Wid: %d, DigExp: %d, DecExp: %d',
                [Self.Wid, Self.DigExp, Self.DecExp]);
    else
      Result := rs_PRM_INP_ERR;
  end;
end;

{ TDelimiters }

constructor TDelimiters.Create( const ASpaceDelimiter, AColumnsDelimiter,
                     AUnderlineChar,APrefixDelimiuter,
                     ALeftBracket, ARighrBracket: Char;
                     const AUsePrefixDelimiter :boolean; const AMaxColLen: Byte);
begin
  // Полностью очищаем память структуры
  // Clearing the structure's memory completely
  FillChar(Self, SizeOf(Self), 0);
  //
  SpaceDelimiter   := ASpaceDelimiter;
  ColumnsDelimiter := AColumnsDelimiter;
  UnderlineChar    := AUnderlineChar;
  LeftBracket      := ALeftBracket;
  RighrBracket     := ARighrBracket;
  MaxColLen        := AMaxColLen;
end;

{ TDateTimeHelper }

class function TDateTimeHelper.Head(out wid: Word): string;
begin
  result := _D.ColumnsDelimiter +_U( [ _R('Дата',10), _R('Время',12)], wid);
  wid := Length(result);
end;

initialization

(*
  Текущий набор разделителей части строки и обрамляющих скобок
  The current set of structure part separators and framing brackets
*)
 _D := TDelimiters.Create(' ',' ','-',' ','<','>', true,COL_MAX_LEN);

(*
  Создание экземпляроа предопределенных форматов вывода для _() функций
  Instantiating predefined output formats for _() functions
*)
 f12v10 := TFormatHolder.Create( ffFixed,   12, 10);
 f12v8 := TFormatHolder.Create( ffFixed,    12,  8);
 f12v3 := TFormatHolder.Create( ffFixed,    12,  3);

 f8v4  := TFormatHolder.Create( ffFixed,     8,  4);
 f8v3  := TFormatHolder.Create( ffFixed,     8,  3);

 f6v1  := TFormatHolder.Create( ffFixed,     6,  1);  // Angles
 f6v3  := TFormatHolder.Create( ffFixed,     6,  3);  // Angles

 f10e2 := TFormatHolder.Create( ffExponent, 10, 2);
 f8e2  := TFormatHolder.Create( ffExponent,  8, 2);

(*
  Cсылка (экземпляр) текущего формата, который используют _() функции.
  Cсылку при необходимости можно многократно перопределять в коде
  или использовать любой из определенный и инициализированных форматов
  напрямую.

  A reference (instance) of the current format used by _() functions.
  The reference can be redefined multiple times in code, if necessary,
  or any of the defined and initialized formats can be used directly.
*)
  _F := f12v8;

end.

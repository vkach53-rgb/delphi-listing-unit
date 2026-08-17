var
  ColumnWidth, PrefWidth, OutWid,OutWid1,OutWid2,OutWid3,
  wid1, wid2, i, col, row, count: Word;
  tmp, CodeText :string;
  //
  JDay: TksJDay;   dt :TDateTime;   Sphere:  TVectSphere;
  ArrD, ArrV, ArrR :Array of Double;   HArr, RHarr,VHarr :Array of String;
begin

  CodeText := '''
  // _out(..) выводит строки на терминал;
  // The _out(..) function prints strings to the terminal.

  // _R, _С, _L,    _B('word') = <word>
  // преобразования входной строки в столбец заданной ширины с выравниванием
  // converting an input row into a column of a given width with alignment

  _out( _B( _L('Word', ColumnWidth)));
  _out( Roulette( ColumnWidth));
  _out( _B( _C('Word', ColumnWidth)));
  _out( Roulette( ColumnWidth));
  _out( _B( _R('Word', ColumnWidth)));
  _out( Roulette( ColumnWidth));

  // implicit message about exceeding the declared column width
  // неявное сообщение о превышении заявленной ширины столбца
  __out( _B(_L( 'The line is too long', ColumnWidth) ) );
   _out( _B(_C( 'The line is too long', ColumnWidth) ) );
   _out( _B(_R( 'The line is too long', ColumnWidth) ) );
   _out( Roulette( ColumnWidth));
  ''';
  __out( PrintSlide(CodeText));
  //
  ColumnWidth := 12;
  _out('ColumnWidth = '+IntToStr(ColumnWidth));
  _out( _B(_L('Word', ColumnWidth)));
  _out( Roulette( ColumnWidth));
  _out( _B(_C('Word', ColumnWidth)));
  _out( Roulette( ColumnWidth));
  // implicit message about exceeding the declared column width
  // неявное сообщение о превышении заявленной ширины столбца
  __out( _B(_L( 'The line is too long', ColumnWidth) ) );
   _out( _B(_C( 'The line is too long', ColumnWidth) ) );
   _out( _B(_R( 'The line is too long', ColumnWidth) ) );
   _out( Roulette( ColumnWidth));
  _out( EndSlide);

  CodeText := '''
  PrefWidth := 12;
  _out( _B(_P( 'Alice in Wonderland', PrefWidth, 'Prefix:', OutWid1)) );
  _out( Roulette( PrefWidth) );
  ''';
  _out( PrintSlide(CodeText));
  //
  PrefWidth := 12;
  _out( _B(_P( 'Alice in Wonderland', PrefWidth, 'Prefix:', OutWid1)) );
  _out( Roulette( PrefWidth) );
  //
  _out( EndSlide);

  CodeText := '''
  Функции _V( Value): string  и  _V( Value, FormatHolder): string

  _F := f12v8;
  _out( _B(_V(pi)));
  _out( _B(_V(2=2)));
  _out( _B(_V(pi, f10e2)));

  _F := f10e2;
  _out( _B(_V(pi)));
  _out( _B(_V(pi, f12v8)));
  ''';
  //
  __out( PrintSlide(CodeText));
  //
  _F := f12v8;   __out('_F := f12v8 = ' + _F.ToString);
  _out( _B(_V(pi)));
  _out( _B(_V(2=2)));

  _out( Roulette( _F.Wid));
  _out( _B(_V(pi, f10e2)));
  _out( Roulette( f10e2.Wid));

  _F := f10e2;   __out('_F := f10e2 = ' + _F.ToString);
  _out( _B(_V(pi)));
  _out( Roulette( _F.Wid));
  _out('f12v8 = ' + f12v8.ToString);
  _out( _B(_V(pi, f12v8)));
  _out( Roulette( f12v8.Wid));
  //
  _out( EndSlide);

  CodeText := '''
  Массивы стандартных регулярныых типов _F  с заголовками:

  ArrD := [random, random, random, random, random];
  HArr := ['X', 'Y', 'Z', 'V', 'W'];

  __out( _H( HArr, OutWid1, _F.Wid));
   _out( _H( length(ArrD), OutWid1));
   _out( _E( OutWid1));
   _out( _V( ArrD));
   _out( _E( OutWid1));
  ''';
  __out( PrintSlide(CodeText));
  ArrD  := [random, random, random, random, random];
  HArr := ['X', 'Y', 'Z', 'V', 'W'];
  _F := f8v4;   __out('_F := f8v4 = ' + _F.ToString);
  __out( _H( HArr, OutWid1, _F.Wid));
   _out( _H( length(ArrD), OutWid1));
   _out( _E( OutWid1));
   _out( _V( ArrD));
   _out( _E( OutWid1));
   _out( EndSlide);

  CodeText := '''
  _F := f12v8;
  ''';
  __out( PrintSlide(CodeText));
  _F := f12v8;   __out('_F := f12v8 = ' + _F.ToString);
  __out( _H( HArr, OutWid1, _F.Wid));
   _out( _H( length(ArrD), OutWid1));
   _out( _E( OutWid1));
   _out( _V( ArrD));
   _out( _E( OutWid1));
   _out( EndSlide);

  CodeText := '''
  _F := f10e2;
  ''';
  __out( PrintSlide(CodeText));
  _F := f10e2;   __out('_F := f10e2 = ' + _F.ToString);
  __out( _H( HArr, OutWid1, _F.Wid));
   _out( _H( length(ArrD), OutWid1));
   _out( _E( OutWid1));
   _out( _V( ArrD));
   _out( _E( OutWid1));
   _out( EndSlide);

  CodeText := '''
  __out( _H( length(ArrD), f8v4, OutWid1));
   _out( _E( OutWid1));
   _out( _V( ArrD, f8v4));
   _out( _E( OutWid1));
  ''';
  __out( PrintSlide(CodeText));
  __out('f8v4 = ' + f8v4.ToString);

  __out( _H( length(ArrD), f8v4, OutWid1));
   _out( _E( OutWid1));
   _out( _V( ArrD, f8v4));
   _out( _E( OutWid1));
   _out( EndSlide);

  // Matrix
  count := 5;
  var ar2 :array of Array of Double;
  SetLength(ar2,count,count);
  for col := 0 to count-1 do for row := 0 to count-1 do ar2[col,row] := random;

  CodeText := '''
  Random Matrix 4 x 4 :

  PrefWidth := 9;
  __out( _P( _H( count, OutWid1), PrefWidth, 'row \ col', OutWid1));
   _out( _E( OutWid1));
  for i := 0 to 4 do
   _out( _P( _V( ar2[i]), PrefWidth, IntToStr(i), OutWid1) );
   _out( _E( OutWid1));
  ''';
  __out( PrintSlide(CodeText));
  _F := f8v4;
  PrefWidth := 9;
  __out('_F := f8v4 = ' + f8v4.ToString);
  __out( _P( _H( count, OutWid1), PrefWidth, 'row \ col', OutWid1));
   _out( _E( OutWid1));
  for i := 0 to 4 do
   _out( _P( _V( ar2[i]), PrefWidth, IntToStr(i), OutWid1) );
   _out( _E( OutWid1));
   _out( EndSlide);

  CodeText := '''
  Same Matrix 4 x 4 :
  _F := f10e2;
  Same Code
  ''';
  __out( PrintSlide(CodeText));
  _F := f10e2;
  __out('_F := f10e2 = ' + _F.ToString);
  __out( _P( _H( Count, OutWid1), PrefWidth, 'row \ col', OutWid1));
   _out( _E( OutWid1));
  for i := 0 to 4 do
   _out( _P( _V( ar2[i]),  PrefWidth, IntToStr(i), OutWid1) );
   _out( _E( OutWid1));
   _out( EndSlide);

  CodeText := '''
  Collect strings with alignment or not
  _U( ArrayOfString, OutWid, ColumnWidth = 0);


  ColumnWidth := 10;
   _D.ColumnsDelimiter := '|';
  __out( _U( ['Цветы','Животные','Птицы','Рыбы'], OutWid1, ColumnWidth, true));
   _out( _E( OutWid1));
   _out( _U( ['ромашка','лошадь','орел','сазан'], OutWid1, ColumnWidth, true) );
   _out( _U( ['василёк','корова','сокол','пескарь'], OutWid1, ColumnWidth, true) );
   _out( _U( ['пион','овца','голубь','форель'],  OutWid1, ColumnWidth, true) );
   _out( _E( OutWid1));
   _D.ColumnsDelimiter := ' ';
  ''';
  __out( PrintSlide(CodeText));

  ColumnWidth := 10;
   _D.ColumnsDelimiter := '|';
  __out( _U( ['Цветы','Животные','Птицы','Рыбы'], OutWid1, ColumnWidth, true));
   _out( _E( OutWid1));
   _out( _U( ['ромашка','лошадь','орел','сазан'], OutWid1, ColumnWidth, true) );
   _out( _U( ['василёк','корова','сокол','пескарь'], OutWid1, ColumnWidth, true) );
   _out( _U( ['пион','овца','голубь','форель'],  OutWid1, ColumnWidth, true) );
   _out( _E( OutWid1));
   _D.ColumnsDelimiter := ' ';
   _out( EndSlide);

  CodeText := '''
  Составные объекты разных типов занают параметры своего отображения и должны
  иметь свои внутренние функции ToString:string; и Header(Out Wid: word):string;
  которые могут быть написаны с использованием _() функций

  JDay := Now;
  __out( TksJDay.EpochHead(OutWid1));
  _out( _E(OutWid1));
  _out( JDay.EpochToStr);
  _out( _E(OutWid1));

  ''';
  __out( PrintSlide(CodeText));
  JDay := Now;
  __out( TksJDay.EpochHead(OutWid1));
  _out( _E(OutWid1));
  _out( JDay.EpochToStr);
  _out( _E(OutWid1));
  _out( EndSlide);

  CodeText := '''
  __out( Sphere.Header(OutWid));
  _out( _E( OutWid1));
  _out( Sphere.ToString);
  _out( _E( OutWid1));
  ''';
  __out( PrintSlide(CodeText));
  Sphere.Teta := DegToRad(90.0);
  Sphere.Fi := DegToRad(270.0);
  Sphere.DistKm := 1234.56789;

  __out( Sphere.Header(OutWid1));
  _out( _E( OutWid1));
  _out( Sphere.ToString);
  _out( _E( OutWid1));
  _out( EndSlide);

  CodeText := '''
  Обьединение нескольких нерегулярных составных типов данных на примере двух
  типов JDay и Sphere, рассмотренных в предыдущих слайдах :

  __out( _U( [TksJDay.EpochHead(wid1), Sphere.Header(wid2)], OutWid) );
   _out( _E( OutWid));
   _out( _U( [JDay.EpochToStr, Sphere.ToString], OutWid1) );
   _out( _E( OutWid));
  ''';
  __out( PrintSlide(CodeText));
  __out( _U( [TksJDay.EpochHead(wid1), Sphere.Header(wid2)], OutWid) );
   _out( _E( OutWid));
   _out( _U( [JDay.EpochToStr, Sphere.ToString], OutWid1) );
   _out( _E( OutWid));
   _out( EndSlide);

  CodeText := '''
  Обьединение нерегулярных и регулярных составных типов данных на примере
  типов JDay и вектора состояния StateVectors :

  JDay := Now;
  RHarr := ['X,km', 'Y,km', 'Z,km'];
  VHarr := ['Vx,km/sec', 'Vy,km/sec', 'Vz,km/sec'];
  __out( _U( [JDay.EpochHead(i),_H(RHarr,i,_F.Wid),_H(VHarr,i,_F.Wid)], OutWid));
   _out( _E( OutWid));
  for i in [0..4] do begin
    JDay := JDay + 1/24;
    _out( _U( [JDay.EpochToStr, _V(ArrR), _V(ArrV)], OutWid));
  end;
   _out( _E( OutWid));
  ''';
  __out( PrintSlide(CodeText));
  _F := f8v4;   __out('_F := f8v4 = ' + _F.ToString);

  JDay := Now;
  RHarr := ['X,km', 'Y,km', 'Z,km'];
  VHarr := ['Vx,km/sec', 'Vy,km/sec', 'Vz,km/sec'];

  __out( _U( [JDay.EpochHead(i),_H(RHarr,i,_F.Wid),_H(VHarr,i,_F.Wid)], OutWid));
   _out( _E( OutWid));
  for i in [0..4] do begin
    ArrR  := [random*1000, random*1000, random*1000];   //   [ Km ]
    ArrV  := [random*100,  random*10,   random*5];      //   [ Km/sec ]
    JDay := JDay + 1;
    _out( _U( [JDay.EpochToStr, _V(ArrR), _V(ArrV)], OutWid));
  end;
   _out( _E( OutWid));

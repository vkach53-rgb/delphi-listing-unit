# ksListingUnit — A lightweight DSL-compiler for ASCII tables for Delphi 

A high-performance micro-engine for generating structured text logs and reports in unit and integration tests. Eliminates overhead from RTTI, Variant, and constant memory allocations, operating at the level of low-level compiler optimizations.

## 🚀 Key features 
* **DSL-syntax:** The string generation code visually repeats the structure of the future table.
* **Separation of logic:** Specialized `_H()` header and `_U()` / `_V()` string collectors isolate the rendering context.
* **Alignment Control:** Explicit control of cell geometry using alignment functions (e.g. `_L()` for left margin).
* **High performance:** The resulting string size is calculated before assembly. Memory is allocated once via `SetLength`, and data is transferred via a system instruction. `Move`.
* **Layout Protection:** When the column width limit is exceeded, the data is automatically replaced with asterisks `***`, preventing the ASCII layout from being corrupted in the CI/CD console.
* **Terminal output:** The shell builtin `_out()` allows you to instantly send collected structures to the console. In the author's test code _out() := Tmemo.List.Add(..).

## 🛠 Architectural syntax
* `_H([...])` — table header and title collector.
* `_U([...])` / `_V([...])` — information string collectors.
* `_L(Value, Width)` — formatting a cell with left alignment.
* `Object.Head(out TotalWid), Object.ToString` — User-written methods for any their own objects (optionaly with using _() functions) allow objects to be used in logging with DSL-compiler.

## 📋 Demo test log with comments

You don't need to run external demo utilities. Below is the actual module execution log. You can copy any line of code from the comments below and run it in a terminal shell to instantly verify that the algorithm is working correctly.

===============================================
SAMPLE TEST LOG OF THE ksListingUnit.pas MODULE
===============================================

┌===========================<   C O D E   S L I D E  >=========================┐

Combining irregular and regular composite data types using the JDay and StateVectors types as an example:

_F := f8v4 = [Fixed] Wid: 11, Dig: 8, Dec: 4
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

├───────────────────────────<   R E S U L T   >────────────────────────────────┘

      Date         Time        X,km        Y,km        Z,km   Vx,km/sec   Vy,km/sec   Vz,km/sec
-----------------------------------------------------------------------------------------------
2026.08.17 12:13:21,643    436,4252    655,7992    298,3716     73,4130      7,4932      4,3346
2026.08.18 12:13:21,643    211,1897    704,3548    231,7073     43,8070      8,7770      0,8201
2026.08.19 12:13:21,643    531,7001    777,5719    928,1710     95,7533      0,8701      4,5092
2026.08.20 12:13:21,643    334,0488    139,1963    904,1536     26,9034      2,6387      3,4506
2026.08.21 12:13:21,643    330,8887    578,5963    768,2703     38,0767      5,5612      1,0420
-----------------------------------------------------------------------------------------------
└───────────────────────────<   E N D   S L I D E   >──────────────────────────┘
 

## ⏱ Under-the-hood implementation

Unlike the standard `S := S + A + '|' + B` approach, which results in constant memory reallocations by the Delphi manager, `ksListingUnit` performs the operation in a single pass:
1. The exact length of the resulting string is calculated, taking into account separators.
2. A single block of memory is allocated.
3. Data is copied directly via `Move()`.

This ensures maximum speed of generating heavy logs in loaded integration tests.








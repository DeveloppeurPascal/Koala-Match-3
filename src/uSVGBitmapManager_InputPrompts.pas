(* C2PP
  ***************************************************************************

  Koala Match 3
  Copyright (c) 2025-2026 Patrick PREMARTIN

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://koalamatch3.gamolf.fr/

  Project site :
  https://github.com/DeveloppeurPascal/Koala-Match-3

  ***************************************************************************
  File last update : 2026-06-18T19:36:29.409+02:00
  Signature : a8c93200e637dd10f744f4f3cd1d65f2f41e9ac8
  ***************************************************************************
*)

unit uSVGBitmapManager_InputPrompts;

interface

uses
  FMX.Graphics,
  USVGInputPrompts,
  USVGIconesKolopach,
  USVGKoalas;

/// <summary>
/// Returns a bitmap from a SVG Input Prompt images (from Kenney.nl)
/// </summary>
function getBitmapFromSVG(const Index: TSVGInputPromptsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;

/// <summary>
/// Returns a bitmap from a SVG Icones images (from Kolopach - Fotolia.com)
/// </summary>
/// <remarks>
/// Images : Fotolia_55252771, Fotolia_55252817, Fotolia_55252819, Fotolia_55252823, Fotolia_55252825
/// </remarks>
function getBitmapFromSVG(const Index: TSVGIconesKolopachIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;

/// <summary>
/// Returns a bitmap from a SVG Fruits images (from Kolopach - Fotolia.com)
/// </summary>
/// <remarks>
/// Images : Fotolia_47056077
/// </remarks>
function getBitmapFromSVG(const Index: TSVGKoalasIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;

implementation

uses
  Olf.Skia.SVGToBitmap;

function getBitmapFromSVG(const Index: TSVGInputPromptsIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGInputPrompts.Tag,
    round(width), round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGIconesKolopachIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGIconesKolopach.Tag,
    round(width), round(height), BitmapScale);
end;

function getBitmapFromSVG(const Index: TSVGKoalasIndex;
  const width, height: single; const BitmapScale: single): tbitmap; overload;
begin
  result := TOlfSVGBitmapList.Bitmap(ord(Index) + TSVGKoalas.Tag, round(width),
    round(height), BitmapScale);
end;

procedure RegisterSVGImages;
begin
  TSVGInputPrompts.Tag := TOlfSVGBitmapList.AddItem(SVGInputPrompts);
  TSVGIconesKolopach.Tag := TOlfSVGBitmapList.AddItem(SVGIconesKolopach);
  TSVGKoalas.Tag := TOlfSVGBitmapList.AddItem(SVGKoalas);
end;

initialization

RegisterSVGImages;

end.

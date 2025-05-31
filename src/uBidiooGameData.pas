(* C2PP
  ***************************************************************************

  Koala Match 3

  Copyright 2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  ***************************************************************************
  File last update : 2025-05-31T13:13:46.000+02:00
  Signature : 736a4598c97a0fd19d35e08e1bcb1e5fca46c0ee
  ***************************************************************************
*)

unit uBidiooGameData;

interface

uses
  System.Classes,
  uGameData,
  cMatch3Game;

Const
  CDefaultColCount = 7;
  CDefaultRowCount = 5;

Type
  TBidiooGridCell = integer;
  TBidiooGrid = array of array of TBidiooGridCell;

  TBidiooGameData = class(TGameData)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CGameDataVersion = 1;

  var
    /// <summary>
    /// Contains the current game grid (each cell correspond to the SVG ID of
    /// used images)
    /// </summary>
    FGameGrid: TBidiooGrid;
    FRowCount: byte;
    FColCount: byte;
    procedure SetColCount(const Value: byte);
    procedure SetRowCount(const Value: byte);
  protected
    function GetFilePath: string;
  public
    property ColCount: byte read FColCount write SetColCount;
    property RowCount: byte read FRowCount write SetRowCount;
    procedure InitGameGrid;
    class function Current: TBidiooGameData;
    constructor Create; override;
    procedure SaveToStream(const AStream: TStream); override;
    procedure LoadFromStream(const AStream: TStream); override;
    procedure GameGridToScreenGrid(const Match3: TcadMatch3Game);
    procedure ScreenGridToGameGrid(const Match3: TcadMatch3Game);
    procedure Clear; override;
    procedure PauseGame; override;
    procedure StopGame; override;
    procedure Load;
  end;

implementation

{ TBidiooGameData }

uses
  System.IOUtils,
  System.SysUtils,
  uBidiooConfig,
  uConfig;

procedure TBidiooGameData.Clear;
begin
  inherited;
  InitGameGrid;
end;

constructor TBidiooGameData.Create;
begin
  inherited;
  FColCount := CDefaultColCount;
  FRowCount := CDefaultRowCount;
  InitGameGrid;
end;

class function TBidiooGameData.Current: TBidiooGameData;
begin
  result := DefaultGameData<TBidiooGameData>;
end;

procedure TBidiooGameData.GameGridToScreenGrid(const Match3: TcadMatch3Game);
var
  Col, Row: byte;
begin
  for Col := 0 to FColCount - 1 do
    for Row := 0 to FRowCount - 1 do
      Match3.Grid[Col + 1, Row + 1] := FGameGrid[Col, Row];
end;

function TBidiooGameData.GetFilePath: string;
begin
  result := tpath.Combine(path, 'bidioo-' + ord(tconfig.Current.PlayMode)
    .ToString + '-' + ord(tconfig.Current.GraphicMode).ToString + '.game');
end;

procedure TBidiooGameData.InitGameGrid;
var
  Col, Row: byte;
begin
  SetLength(FGameGrid, FColCount);
  for Col := 0 to FColCount - 1 do
  begin
    SetLength(FGameGrid[Col], FRowCount);
    for Row := 0 to FRowCount - 1 do
      FGameGrid[Col][Row] := CEmptyItem;
  end;
end;

procedure TBidiooGameData.Load;
begin
  if tfile.Exists(GetFilePath) then
    try
      LoadFromFile(GetFilePath);
      FIsPaused := NbLives > 0;
    except
      Clear;
    end
  else
    Clear;
end;

procedure TBidiooGameData.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  Col, Row: byte;
  CellValue: TBidiooGridCell;
begin
  inherited;

  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  if (sizeof(FColCount) <> AStream.read(FColCount, sizeof(FColCount))) then
    raise exception.Create('Wrong File format !');

  if (sizeof(FRowCount) <> AStream.read(FRowCount, sizeof(FRowCount))) then
    raise exception.Create('Wrong File format !');

  InitGameGrid;

  for Col := 0 to FColCount - 1 do
    for Row := 0 to FRowCount - 1 do
      if (sizeof(CellValue) <> AStream.read(CellValue, sizeof(CellValue))) then
        raise exception.Create('Wrong File format !')
      else
        FGameGrid[Col, Row] := CellValue;
end;

procedure TBidiooGameData.PauseGame;
begin
  inherited;
  SaveToFile(GetFilePath);
end;

procedure TBidiooGameData.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  Col, Row: byte;
begin
  inherited;
  VersionNum := CGameDataVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));

  AStream.Write(FColCount, sizeof(FColCount));
  AStream.Write(FRowCount, sizeof(FRowCount));

  for Col := 0 to FColCount - 1 do
    for Row := 0 to FRowCount - 1 do
      AStream.Write(FGameGrid[Col, Row], sizeof(FGameGrid[Col, Row]));
end;

procedure TBidiooGameData.ScreenGridToGameGrid(const Match3: TcadMatch3Game);
var
  Col, Row: byte;
begin
  for Col := 0 to FColCount - 1 do
    for Row := 0 to FRowCount - 1 do
      FGameGrid[Col, Row] := Match3.Grid[Col + 1, Row + 1];
end;

procedure TBidiooGameData.SetColCount(const Value: byte);
begin
  FColCount := Value;
end;

procedure TBidiooGameData.SetRowCount(const Value: byte);
begin
  FRowCount := Value;
end;

procedure TBidiooGameData.StopGame;
begin
  inherited;
  if tfile.Exists(GetFilePath) then
    tfile.Delete(GetFilePath);
end;

initialization

TBidiooGameData.Current.Load;

end.

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
  File last update : 2025-05-31T13:01:26.000+02:00
  Signature : 8859b766945e6650bf67dd78f17ede0a3d826ae3
  ***************************************************************************
*)

unit cMatch3Game;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects;

const
  CEmptyItem = 255;
  CDestroyAnimationNbFrames = 10;
  CMoveTilesAnimationNbFrames = 10;

type
{$SCOPEDENUMS ON}
  TMatch3GamePhase = (None, FillFirstLineAndMove, PlayerChoice, CheckMatch3);
  TMatch3Direction = (Up, Right, Down, Left);

  TOnMatch3Event = procedure(const Nb, Item: integer) of object;
  TOnMatch3Proc = reference to procedure(const Nb, Item: integer);
  TOnMoveButNoMatch3Event = procedure of object;
  TOnMoveButNoMatch3Proc = reference to procedure;

  TDestroyedCell = class
  private
    FCol: byte;
    FCellType: integer;
    FRow: byte;
    FNbFrames: integer;
    procedure SetCellType(const Value: integer);
    procedure SetCol(const Value: byte);
    procedure SetRow(const Value: byte);
    procedure SetNbFrames(const Value: integer);
  protected
  public
    property Col: byte read FCol write SetCol;
    property Row: byte read FRow write SetRow;
    property CellType: integer read FCellType write SetCellType;
    property NbFrames: integer read FNbFrames write SetNbFrames;
    constructor Create;
  end;

  TDestroyedCellsList = class(TObjectList<TDestroyedCell>)
  private
  protected
  public
    procedure AddCellToDestroy(const ACol, ARow: byte;
      const ACelltype: integer);
  end;

  TGridCell = record
  private
    FDestCol: byte;
    FDestRow: byte;
    FCol: byte;
    FRow: byte;
    FCellType: integer;
    FMoveNbFrames: integer;
    FMoveCurrentFrame: integer;
    procedure SetCol(const Value: byte);
    procedure SetDestCol(const Value: byte);
    procedure SetDestRow(const Value: byte);
    procedure SetRow(const Value: byte);
    procedure SetCellType(const Value: integer);
    procedure SetMoveNbFrames(const Value: integer);
    procedure SetMoveCurrentFrame(const Value: integer);
  public
    property Col: byte read FCol write SetCol;
    property Row: byte read FRow write SetRow;
    property DestCol: byte read FDestCol write SetDestCol;
    property DestRow: byte read FDestRow write SetDestRow;
    property CellType: integer read FCellType write SetCellType;
    property MoveNbFrames: integer read FMoveNbFrames write SetMoveNbFrames;
    property MoveCurrentFrame: integer read FMoveCurrentFrame
      write SetMoveCurrentFrame;
    procedure Initialize(const ACol, ARow: byte; const ACelltype: integer);
    procedure GoToCell(const ADestCol, ADestRow: byte);
    function IsMoving: boolean;
  end;

  TcadMatch3Game = class(TFrame)
    GameLoop: TTimer;
    GameScene: TImage;
    procedure GameLoopTimer(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure GameSceneMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure GameSceneMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure GameSceneMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure GameSceneMouseLeave(Sender: TObject);
  private
    FNbRow: integer;
    FNbCol: integer;
    FBackgroundColor: TAlphaColor;
    FSelectedBackgroundColor: TAlphaColor;
    FOnMoveButNoMatch3Event: TOnMoveButNoMatch3Event;
    FOnMatch3Event: TOnMatch3Event;
    FOnMoveButNoMatch3Proc: TOnMoveButNoMatch3Proc;
    FOnMatch3Proc: TOnMatch3Proc;
    FUseMatchDirection: boolean;
    procedure SetItems(Index: integer; const Value: string);
    procedure SetNbCol(const Value: integer);
    procedure SetNbRow(const Value: integer);
    procedure SetBackgroundColor(const Value: TAlphaColor);
    procedure SetSelectedBackgroundColor(const Value: TAlphaColor);
    procedure SetOnMatch3Event(const Value: TOnMatch3Event);
    procedure SetOnMatch3Proc(const Value: TOnMatch3Proc);
    procedure SetOnMoveButNoMatch3Event(const Value: TOnMoveButNoMatch3Event);
    procedure SetOnMoveButNoMatch3Proc(const Value: TOnMoveButNoMatch3Proc);
    function GetGrid(Col, Row: byte): integer;
    procedure SetGrid(Col, Row: byte; const Value: integer);
    procedure SetUseMatchDirection(const Value: boolean);
  protected
    FIsInitialized: boolean;
    FGrid: array of array of TGridCell;
    FStatus: TMatch3GamePhase;
    FNeedARepaint: boolean;
    FSelectedCol, FSelectedRow: integer;
    FPaintedBlocSize: integer;
    FIsMouseDown: boolean;
    FCheckMatch3AfterUserMove: boolean;
    FSVGListId: integer;
    FMatch3Direction: TMatch3Direction;
    FDestroyedCellsList: TDestroyedCellsList;
    procedure Repaint(const Force: boolean = false);
    function MoveItems: boolean;
    function FillFirstLine: boolean;
    function HadAMatch3: boolean;
  public
    property NbCol: integer read FNbCol write SetNbCol;
    property NbRow: integer read FNbRow write SetNbRow;
    property SVGItems[Index: integer]: string write SetItems;
    /// <summary>
    /// Access to the CellType of grid cells
    /// </summary>
    property Grid[Col, Row: byte]: integer read GetGrid write SetGrid;
    property UseMatchDirection: boolean read FUseMatchDirection
      write SetUseMatchDirection;
    property BackgroundColor: TAlphaColor read FBackgroundColor
      write SetBackgroundColor;
    property SelectedBackgroundColor: TAlphaColor read FSelectedBackgroundColor
      write SetSelectedBackgroundColor;
    property OnMatch3Event: TOnMatch3Event read FOnMatch3Event
      write SetOnMatch3Event;
    property OnMatch3Proc: TOnMatch3Proc read FOnMatch3Proc
      write SetOnMatch3Proc;
    property OnMoveButNoMatch3Event: TOnMoveButNoMatch3Event
      read FOnMoveButNoMatch3Event write SetOnMoveButNoMatch3Event;
    property OnMoveButNoMatch3Proc: TOnMoveButNoMatch3Proc
      read FOnMoveButNoMatch3Proc write SetOnMoveButNoMatch3Proc;
    procedure Clear;
    procedure Initialize;
    procedure StartGame;
    procedure StopGame;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure FitInParent;
  end;

implementation

{$R *.fmx}

uses
  System.Math,
  Olf.Skia.SVGToBitmap;

{ TcadMatch3Game }

procedure TcadMatch3Game.AfterConstruction;
begin
  inherited;
  GameLoop.Enabled := True;
end;

procedure TcadMatch3Game.Clear;
begin
  FIsInitialized := false;
  FNbCol := 7;
  FNbRow := 5;
  if FSVGListId > 0 then
    TOlfSVGBitmapList.DeleteList(FSVGListId);
  FSVGListId := TOlfSVGBitmapList.AddAList;
  SetLength(FGrid, 0);
  FStatus := TMatch3GamePhase.None;
  FNeedARepaint := false;
  FBackgroundColor := TAlphaColors.Darkslategrey;
  FSelectedBackgroundColor := TAlphaColors.Lightslategrey;
  FSelectedCol := 0;
  FSelectedRow := 0;
  FPaintedBlocSize := 0;
  FIsMouseDown := false;
  FCheckMatch3AfterUserMove := false;
  FMatch3Direction := TMatch3Direction.Down; // from top to bottom by default
end;

constructor TcadMatch3Game.Create(AOwner: TComponent);
begin
  inherited;
  FDestroyedCellsList := TDestroyedCellsList.Create;
  FOnMoveButNoMatch3Event := nil;
  FOnMoveButNoMatch3Proc := nil;
  FOnMatch3Event := nil;
  FOnMatch3Proc := nil;
  FSVGListId := -1;
  FUseMatchDirection := false;
  Clear;
end;

destructor TcadMatch3Game.Destroy;
begin
  FDestroyedCellsList.Free;
  inherited;
end;

function TcadMatch3Game.FillFirstLine: boolean;
var
  Col, Row: integer;
begin
  result := false;
  case FMatch3Direction of
    TMatch3Direction.Up:
      for Col := 1 to FNbCol do
        if FGrid[Col][FNbRow].CellType = CEmptyItem then
        begin
          FGrid[Col][FNbRow].CellType :=
            random(min(5, TOlfSVGBitmapList.Count(FSVGListId)));
          result := True;
        end;
    TMatch3Direction.Right:
      for Row := 1 to FNbRow do
        if FGrid[1][Row].CellType = CEmptyItem then
        begin
          FGrid[1][Row].CellType :=
            random(min(5, TOlfSVGBitmapList.Count(FSVGListId)));
          result := True;
        end;
    TMatch3Direction.Down:
      for Col := 1 to FNbCol do
        if FGrid[Col][1].CellType = CEmptyItem then
        begin
          FGrid[Col][1].CellType :=
            random(min(5, TOlfSVGBitmapList.Count(FSVGListId)));
          result := True;
        end;
    TMatch3Direction.Left:
      for Row := 1 to FNbRow do
        if FGrid[FNbCol][Row].CellType = CEmptyItem then
        begin
          FGrid[FNbCol][Row].CellType :=
            random(min(5, TOlfSVGBitmapList.Count(FSVGListId)));
          result := True;
        end;
  end;
end;

procedure TcadMatch3Game.FitInParent;
var
  W, H: Single;
  BlocSize: integer;
begin
  if (parent is TControl) then
  begin
    W := (parent as TControl).Width / FNbCol;
    H := (parent as TControl).Height / FNbRow;
  end
  else if (parent is TCustomForm) then
  begin
    W := (parent as TCustomForm).Width / FNbCol;
    H := (parent as TCustomForm).Height / FNbRow;
  end
  else
    exit;

  if (W < H) then
    BlocSize := trunc(W)
  else
    BlocSize := trunc(H);

  BeginUpdate;
  try
    Width := BlocSize * FNbCol;
    Height := BlocSize * FNbRow;
  finally
    EndUpdate;
  end;
  FNeedARepaint := True;
end;

procedure TcadMatch3Game.FrameResized(Sender: TObject);
begin
  Repaint(True);
end;

procedure TcadMatch3Game.GameLoopTimer(Sender: TObject);
var
  HasMoved, HasFilled: boolean;
begin
  if FDestroyedCellsList.Count > 0 then
    FNeedARepaint := True
  else
    case FStatus of
      TMatch3GamePhase.FillFirstLineAndMove:
        begin
          HasMoved := MoveItems;
          HasFilled := FillFirstLine;
          if HasMoved or HasFilled then
            FNeedARepaint := True
          else
          begin
            FCheckMatch3AfterUserMove := false;
            FStatus := TMatch3GamePhase.CheckMatch3;
          end;
        end;
      TMatch3GamePhase.PlayerChoice:
        ;
      TMatch3GamePhase.CheckMatch3:
        if HadAMatch3 then
          FStatus := TMatch3GamePhase.FillFirstLineAndMove
        else
        begin
          if FCheckMatch3AfterUserMove then
          begin
            if assigned(FOnMoveButNoMatch3Event) then
              FOnMoveButNoMatch3Event;
            if assigned(FOnMoveButNoMatch3Proc) then
              FOnMoveButNoMatch3Proc;
          end;
          FStatus := TMatch3GamePhase.PlayerChoice;
        end;
    end;
  Repaint;
end;

procedure TcadMatch3Game.GameSceneMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  Col, Row: integer;
  SwapItem: integer;
begin
  if FStatus <> TMatch3GamePhase.PlayerChoice then
    exit;

  FIsMouseDown := True;

  Col := trunc(X / FPaintedBlocSize) + 1;
  Row := trunc(Y / FPaintedBlocSize) + 1;

  if (Col = FSelectedCol) and (Row = FSelectedRow) then
  begin // Unselect current selected item
    FSelectedCol := 0;
    FSelectedRow := 0;
    FNeedARepaint := True;
  end
  else if (FSelectedCol > 0) and (FSelectedRow > 0) and
    (((Col in [FSelectedCol - 1, FSelectedCol + 1]) and (Row = FSelectedRow)) or
    ((Row in [FSelectedRow - 1, FSelectedRow + 1]) and (Col = FSelectedCol)))
  then
  begin // Clicked on an adjacent item, try to swap them

    // TODO : test if the movement is allowed to have a classic behaviour

    // Move even if no match-3 is available
    SwapItem := FGrid[Col][Row].CellType;
    FGrid[Col][Row].CellType := FGrid[FSelectedCol][FSelectedRow].CellType;
    FGrid[FSelectedCol][FSelectedRow].CellType := SwapItem;
    if FUseMatchDirection then
    begin
      if Col = FSelectedCol - 1 then
        FMatch3Direction := TMatch3Direction.Left
      else if Col = FSelectedCol + 1 then
        FMatch3Direction := TMatch3Direction.Right
      else if Row = FSelectedRow - 1 then
        FMatch3Direction := TMatch3Direction.Up
      else
        FMatch3Direction := TMatch3Direction.Down;
    end;
    FSelectedCol := 0;
    FSelectedRow := 0;
    FNeedARepaint := True;
    FCheckMatch3AfterUserMove := True;
    FStatus := TMatch3GamePhase.CheckMatch3;
  end
  else
  begin // Select a new item
    FSelectedCol := Col;
    FSelectedRow := Row;
    FNeedARepaint := True;
  end;
end;

procedure TcadMatch3Game.GameSceneMouseLeave(Sender: TObject);
begin
  FIsMouseDown := false;
end;

procedure TcadMatch3Game.GameSceneMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
var
  Col, Row: integer;
  SwapItem: integer;
begin
  if not FIsMouseDown then
    exit;

  if FStatus <> TMatch3GamePhase.PlayerChoice then
    exit;

  Col := trunc(X / FPaintedBlocSize) + 1;
  Row := trunc(Y / FPaintedBlocSize) + 1;

  if (FSelectedCol > 0) and (FSelectedRow > 0) and
    (((Col in [FSelectedCol - 1, FSelectedCol + 1]) and (Row = FSelectedRow)) or
    ((Row in [FSelectedRow - 1, FSelectedRow + 1]) and (Col = FSelectedCol)))
  then
  begin // Clicked on an adjacent item, try to swap them

    // TODO : test if the movement is allowed to have a classic behaviour

    // Move even if no match-3 is available (manage a lives number)
    SwapItem := FGrid[Col][Row].CellType;
    FGrid[Col][Row].CellType := FGrid[FSelectedCol][FSelectedRow].CellType;
    FGrid[FSelectedCol][FSelectedRow].CellType := SwapItem;
    if FUseMatchDirection then
    begin
      if Col = FSelectedCol - 1 then
        FMatch3Direction := TMatch3Direction.Left
      else if Col = FSelectedCol + 1 then
        FMatch3Direction := TMatch3Direction.Right
      else if Row = FSelectedRow - 1 then
        FMatch3Direction := TMatch3Direction.Up
      else
        FMatch3Direction := TMatch3Direction.Down;
    end;
    FSelectedCol := 0;
    FSelectedRow := 0;
    FNeedARepaint := True;
    FCheckMatch3AfterUserMove := True;
    FStatus := TMatch3GamePhase.CheckMatch3;
    FIsMouseDown := false;
  end;
end;

procedure TcadMatch3Game.GameSceneMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  FIsMouseDown := false;
end;

function TcadMatch3Game.GetGrid(Col, Row: byte): integer;
begin
  result := FGrid[Col][Row].CellType;
end;

function TcadMatch3Game.HadAMatch3: boolean;
  function NbItems(const Col, Row: integer; const Item: integer): integer;
  begin
    if (FGrid[Col][Row].CellType = Item) then
    begin
      FGrid[Col][Row].CellType := FGrid[Col][Row].CellType +
        TOlfSVGBitmapList.Count(FSVGListId);
      result := 1 + NbItems(Col - 1, Row, Item) + NbItems(Col + 1, Row, Item) +
        NbItems(Col, Row - 1, Item) + NbItems(Col, Row + 1, Item);
    end
    else
      result := 0;
  end;
  procedure ResetItems(const Col, Row: integer);
  begin
    if (FGrid[Col][Row].CellType <> CEmptyItem) and
      (FGrid[Col][Row].CellType >= TOlfSVGBitmapList.Count(FSVGListId)) then
    begin
      FGrid[Col][Row].CellType := FGrid[Col][Row].CellType -
        TOlfSVGBitmapList.Count(FSVGListId);
      ResetItems(Col - 1, Row);
      ResetItems(Col + 1, Row);
      ResetItems(Col, Row - 1);
      ResetItems(Col, Row + 1);
    end;
  end;
  procedure DestroyItems(const Col, Row: integer);
  begin
    if (FGrid[Col][Row].CellType <> CEmptyItem) and
      (FGrid[Col][Row].CellType >= TOlfSVGBitmapList.Count(FSVGListId)) then
    begin
      FDestroyedCellsList.AddCellToDestroy(Col, Row, FGrid[Col][Row].CellType -
        TOlfSVGBitmapList.Count(FSVGListId));
      FGrid[Col][Row].CellType := CEmptyItem;
      DestroyItems(Col - 1, Row);
      DestroyItems(Col + 1, Row);
      DestroyItems(Col, Row - 1);
      DestroyItems(Col, Row + 1);
    end;
  end;

var
  Col, Row: integer;
  CellType: integer;
  Nb: integer;
begin
  result := false;
  for Col := 1 to NbCol do
    for Row := 1 to NbRow do
      if (FGrid[Col][Row].CellType < TOlfSVGBitmapList.Count(FSVGListId)) and
        (((FGrid[Col + 1][Row].CellType = FGrid[Col][Row].CellType) and
        (FGrid[Col + 2][Row].CellType = FGrid[Col][Row].CellType)) or
        ((FGrid[Col][Row + 1].CellType = FGrid[Col][Row].CellType) and
        (FGrid[Col][Row + 2].CellType = FGrid[Col][Row].CellType))) then
      begin
        CellType := FGrid[Col][Row].CellType;
        Nb := NbItems(Col, Row, CellType);
        if Nb < 3 then
          ResetItems(Col, Row)
        else
        begin
          result := True;
          FNeedARepaint := True;
          if assigned(FOnMatch3Event) then
            FOnMatch3Event(Nb, CellType);
          if assigned(FOnMatch3Proc) then
            FOnMatch3Proc(Nb, CellType);
          DestroyItems(Col, Row);
        end;
      end;
end;

procedure TcadMatch3Game.Initialize;
var
  Col, Row: integer;
begin
  FIsInitialized := True;

  if FNbCol < 5 then
    raise Exception.Create('Need at least 5 columns.');

  if FNbRow < 5 then
    raise Exception.Create('Need at least 5 rows.');

  if (TOlfSVGBitmapList.Count(FSVGListId) < 5) then
    raise Exception.Create('Need at least 5 items.');

  SetLength(FGrid, FNbCol + 2);
  for Col := 0 to FNbCol + 1 do
  begin
    SetLength(FGrid[Col], FNbRow + 2);
    for Row := 0 to FNbRow + 1 do
      // TODO : use a different item value for borders and empty cell if needed
      FGrid[Col][Row].Initialize(Col, Row, CEmptyItem);
  end;

  FSelectedCol := 0;
  FSelectedRow := 0;

  FNeedARepaint := True;
  FStatus := TMatch3GamePhase.None;
  Repaint;
end;

function TcadMatch3Game.MoveItems: boolean;
  function DoMoveCell(const Col, Row, VCol, VRow: integer): boolean;
  begin
    if (FGrid[Col][Row].CellType = CEmptyItem) then
      result := false
    else if (FGrid[Col][Row].IsMoving) then
    begin
      if (FGrid[Col][Row].MoveCurrentFrame >= FGrid[Col][Row].MoveNbFrames) then
      begin
        FGrid[Col + VCol][Row + VRow].CellType := FGrid[Col][Row].CellType;
        FGrid[Col][Row].CellType := CEmptyItem;
        FGrid[Col][Row].DestCol := Col;
        FGrid[Col][Row].DestRow := Row;
      end;
      result := True;
    end
    else if (FGrid[Col + VCol][Row + VRow].CellType = CEmptyItem) or
      FGrid[Col + VCol][Row + VRow].IsMoving then
    begin
      FGrid[Col][Row].GoToCell(Col + VCol, Row + VRow);
      result := True;
    end
    else
      result := false;
  end;

var
  Col, Row: integer;
begin
  result := false;
  case FMatch3Direction of
    TMatch3Direction.Up:
      for Col := 1 to FNbCol do
        for Row := 2 to FNbRow do
          result := DoMoveCell(Col, Row, 0, -1) or result;
    TMatch3Direction.Right:
      for Row := 1 to FNbRow do
        for Col := FNbCol - 1 downto 1 do
          result := DoMoveCell(Col, Row, +1, 0) or result;
    TMatch3Direction.Down:
      for Col := 1 to FNbCol do
        for Row := FNbRow - 1 downto 1 do
          result := DoMoveCell(Col, Row, 0, +1) or result;
    TMatch3Direction.Left:
      for Row := 1 to FNbRow do
        for Col := 2 to FNbCol do
          result := DoMoveCell(Col, Row, -1, 0) or result;
  end;
end;

procedure TcadMatch3Game.Repaint(const Force: boolean);
var
  Col, Row: integer;
  X, Y: Single;
  W, H: Single;
  BMPCanvas: TCanvas;
  SelectedBackgroundBrush: TBrush;
  BMP: TBitmap;
  Dest: TRectF;
  i: integer;
begin
  if not FIsInitialized then
    exit;

  if FNeedARepaint or Force then
  begin
    FNeedARepaint := false;

    SelectedBackgroundBrush := TBrush.Create(TBrushKind.Solid,
      FSelectedBackgroundColor);
    try
      GameScene.BeginUpdate;
      try
        // Calculate bitmap real size in pixels
        W := GameScene.Width / FNbCol;
        H := GameScene.Height / FNbRow;
        if (W < H) then
          FPaintedBlocSize := trunc(W)
        else
          FPaintedBlocSize := trunc(H);
        GameScene.Bitmap.SetSize
          (trunc(FPaintedBlocSize * FNbCol * GameScene.Bitmap.BitmapScale),
          trunc(FPaintedBlocSize * FNbRow * GameScene.Bitmap.BitmapScale));

        // Draw the items on the bitmap
        BMPCanvas := GameScene.Bitmap.Canvas;
        BMPCanvas.BeginScene;
        try
          // Clear the game backgound
          BMPCanvas.Clear(FBackgroundColor);

          // Draw the elements in the grid
          for Col := 1 to FNbCol do
            for Row := 1 to FNbRow do
            begin
              // change the coordinates for moving elements
              if FGrid[Col][Row].IsMoving then
              begin
                X := Col - 1 + (FGrid[Col][Row].DestCol - Col) * FGrid[Col][Row]
                  .MoveCurrentFrame / FGrid[Col][Row].MoveNbFrames;
                Y := Row - 1 + (FGrid[Col][Row].DestRow - Row) * FGrid[Col][Row]
                  .MoveCurrentFrame / FGrid[Col][Row].MoveNbFrames;
                FGrid[Col][Row].MoveCurrentFrame :=
                  FGrid[Col][Row].MoveCurrentFrame + 1;
              end
              else
              begin
                X := Col - 1;
                Y := Row - 1;
              end;

              // calculate the element area
              Dest := TRectF.Create(X * FPaintedBlocSize, Y * FPaintedBlocSize,
                X * FPaintedBlocSize + FPaintedBlocSize,
                Y * FPaintedBlocSize + FPaintedBlocSize);

              // draw the background for the selected element
              if (Col = FSelectedCol) and (Row = FSelectedRow) then
                BMPCanvas.FillRect(Dest, 1, SelectedBackgroundBrush);

              // draw the element image
              if FGrid[Col][Row].CellType < TOlfSVGBitmapList.Count(FSVGListId)
              then
              begin
                BMP := TOlfSVGBitmapList.Bitmap(FSVGListId,
                  FGrid[Col][Row].CellType, FPaintedBlocSize, FPaintedBlocSize,
                  3, 3, 3, 3, GameScene.Bitmap.BitmapScale);
                try
                  BMPCanvas.DrawBitmap(BMP, BMP.BoundsF, Dest, 1);
                finally
                end;
              end;
            end;

          // Draw the animated destroyed elements
          for i := FDestroyedCellsList.Count - 1 downto 0 do
            if FDestroyedCellsList[i].NbFrames > 0 then
            begin
              FDestroyedCellsList[i].NbFrames := FDestroyedCellsList[i]
                .NbFrames - 1;
              if FDestroyedCellsList[i].NbFrames mod 2 = 0 then
              begin
                X := FDestroyedCellsList[i].Col - 1;
                Y := FDestroyedCellsList[i].Row - 1;
                Dest := TRectF.Create(X * FPaintedBlocSize,
                  Y * FPaintedBlocSize, X * FPaintedBlocSize + FPaintedBlocSize,
                  Y * FPaintedBlocSize + FPaintedBlocSize);
                BMP := TOlfSVGBitmapList.Bitmap(FSVGListId,
                  FDestroyedCellsList[i].CellType, FPaintedBlocSize,
                  FPaintedBlocSize, 3, 3, 3, 3, GameScene.Bitmap.BitmapScale);
                try
                  BMPCanvas.DrawBitmap(BMP, BMP.BoundsF, Dest, 1);
                finally
                end;
              end;
            end
            else
              FDestroyedCellsList.Delete(i);
        finally
          BMPCanvas.EndScene;
        end;
      finally
        GameScene.EndUpdate;
      end;
    finally
      SelectedBackgroundBrush.Free;
    end;
  end;
end;

procedure TcadMatch3Game.SetBackgroundColor(const Value: TAlphaColor);
begin
  FBackgroundColor := Value;
end;

procedure TcadMatch3Game.SetGrid(Col, Row: byte; const Value: integer);
begin
  FGrid[Col][Row].CellType := Value;
end;

procedure TcadMatch3Game.SetItems(Index: integer; const Value: string);
begin
  TOlfSVGBitmapList.AddItemAt(FSVGListId, index, Value);
end;

procedure TcadMatch3Game.SetNbCol(const Value: integer);
begin
  FNbCol := Value;
end;

procedure TcadMatch3Game.SetNbRow(const Value: integer);
begin
  FNbRow := Value;
end;

procedure TcadMatch3Game.SetOnMatch3Event(const Value: TOnMatch3Event);
begin
  FOnMatch3Event := Value;
end;

procedure TcadMatch3Game.SetOnMatch3Proc(const Value: TOnMatch3Proc);
begin
  FOnMatch3Proc := Value;
end;

procedure TcadMatch3Game.SetOnMoveButNoMatch3Event
  (const Value: TOnMoveButNoMatch3Event);
begin
  FOnMoveButNoMatch3Event := Value;
end;

procedure TcadMatch3Game.SetOnMoveButNoMatch3Proc
  (const Value: TOnMoveButNoMatch3Proc);
begin
  FOnMoveButNoMatch3Proc := Value;
end;

procedure TcadMatch3Game.SetSelectedBackgroundColor(const Value: TAlphaColor);
begin
  FSelectedBackgroundColor := Value;
end;

procedure TcadMatch3Game.SetUseMatchDirection(const Value: boolean);
begin
  FUseMatchDirection := Value;
end;

procedure TcadMatch3Game.StartGame;
begin
  FNeedARepaint := True;
  FStatus := TMatch3GamePhase.FillFirstLineAndMove;
  GameLoop.Enabled := True;
end;

procedure TcadMatch3Game.StopGame;
begin
  FStatus := TMatch3GamePhase.None;
  GameLoop.Enabled := false;
end;

{ TDestroyedCell }

constructor TDestroyedCell.Create;
begin
  inherited;
  FCol := 0;
  FRow := 0;
  FCellType := -1;
  FNbFrames := CDestroyAnimationNbFrames;
end;

procedure TDestroyedCell.SetCellType(const Value: integer);
begin
  FCellType := Value;
  // TODO : change NbFrames depending on the destroy animation for this CellType
end;

procedure TDestroyedCell.SetCol(const Value: byte);
begin
  FCol := Value;
end;

procedure TDestroyedCell.SetNbFrames(const Value: integer);
begin
  FNbFrames := Value;
end;

procedure TDestroyedCell.SetRow(const Value: byte);
begin
  FRow := Value;
end;

{ TDestroyedCellsList }

procedure TDestroyedCellsList.AddCellToDestroy(const ACol, ARow: byte;
  const ACelltype: integer);
var
  Cell: TDestroyedCell;
begin
  Cell := TDestroyedCell.Create;
  Cell.Col := ACol;
  Cell.Row := ARow;
  Cell.CellType := ACelltype;
  add(Cell);
end;

{ TGridCell }

procedure TGridCell.GoToCell(const ADestCol, ADestRow: byte);
begin
  FDestCol := ADestCol;
  FDestRow := ADestRow;
  FMoveNbFrames := CMoveTilesAnimationNbFrames;
  FMoveCurrentFrame := 0;
end;

procedure TGridCell.Initialize(const ACol, ARow: byte;
  const ACelltype: integer);
begin
  FCol := ACol;
  FDestCol := FCol;
  FRow := ARow;
  FDestRow := FRow;
  FCellType := ACelltype;
  FMoveNbFrames := 0;
  FMoveCurrentFrame := 0;
end;

function TGridCell.IsMoving: boolean;
begin
  result := (FCol <> FDestCol) or (FRow <> FDestRow);
end;

procedure TGridCell.SetCellType(const Value: integer);
begin
  FCellType := Value;
end;

procedure TGridCell.SetCol(const Value: byte);
begin
  FCol := Value;
end;

procedure TGridCell.SetDestCol(const Value: byte);
begin
  FDestCol := Value;
end;

procedure TGridCell.SetDestRow(const Value: byte);
begin
  FDestRow := Value;
end;

procedure TGridCell.SetMoveCurrentFrame(const Value: integer);
begin
  FMoveCurrentFrame := Value;
end;

procedure TGridCell.SetMoveNbFrames(const Value: integer);
begin
  FMoveNbFrames := Value;
end;

procedure TGridCell.SetRow(const Value: byte);
begin
  FRow := Value;
end;

end.

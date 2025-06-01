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
  File last update : 2025-06-01T10:45:26.000+02:00
  Signature : 73c0cee996b6dd9275d310183c48c9788b94abe9
  ***************************************************************************
*)

unit uSceneGame;

interface

uses
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
  _ScenesAncestor,
  cMatch3Game,
  FMX.Layouts,
  Olf.FMX.TextImageFrame,
  cImageButton,
  USVGIconesKolopach;

type
  TGameScene = class(T__SceneAncestor)
    lGameZone: TLayout;
    cadMatch3Game1: TcadMatch3Game;
    lScoreAndBonus: TLayout;
    txtScore: TOlfFMXTextImageFrame;
    lScore: TLayout;
    flBonus: TFlowLayout;
    procedure lGameZoneResized(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure lScoreResized(Sender: TObject);
    procedure flBonusResized(Sender: TObject);
  private
    procedure SetNbLives(const Value: cardinal);
    procedure SetScore(const Value: cardinal);
    function GetNbLives: cardinal;
    function GetScore: cardinal;
  protected
    procedure ClearBonusLayout;
    procedure RepaintBonusLayout;
    function AddBonus(const BonusType: TSVGIconesKolopachIndex)
      : TbtnImageButton;
    procedure RemoveBonus(const BonusType: TSVGIconesKolopachIndex);
    function GetBonus(const BonusType: TSVGIconesKolopachIndex)
      : TbtnImageButton;
    procedure DoPause(Sender: TObject);
    procedure DoMusicOnOff(Sender: TObject);
    procedure DoSoundsOnOff(Sender: TObject);
  public
    procedure AfterConstruction; override;
    property Score: cardinal read GetScore write SetScore;
    property NbLives: cardinal read GetNbLives write SetNbLives;
    procedure ShowScene; override;
    procedure HideScene; override;
  end;

implementation

{$R *.fmx}

uses
  System.Math,
  uScene,
  uConsts,
  USVGKoalas,
  uBidiooGameData,
  uUIElements,
  Gamolf.RTL.UIElements,
  Gamolf.RTL.Joystick,
  Gamolf.FMX.MusicLoop,
  uSoundEffects,
  uConfig,
  udmAdobeStock_257147901;

{ TGameScene }

function TGameScene.AddBonus(const BonusType: TSVGIconesKolopachIndex)
  : TbtnImageButton;
begin
  result := GetBonus(BonusType);
  if not assigned(result) then
  begin
    result := TbtnImageButton.Create(self);
    result.Parent := flBonus;
    result.Kind := BonusType;
    result.ShowNumber := true;
  end;
end;

procedure TGameScene.AfterConstruction;
begin
  inherited;
  txtScore.BeginUpdate;
  try
    txtScore.Font := dmAdobeStock_257147901.ImageList;
    txtScore.AutoSize := true;
    txtScore.Text := '0';
  finally
    txtScore.EndUpdate;
  end;
end;

procedure TGameScene.ClearBonusLayout;
begin
  while flBonus.ChildrenCount > 0 do
    flBonus.Children[0].free;
end;

procedure TGameScene.FrameResized(Sender: TObject);
begin
  lScoreAndBonus.BeginUpdate;
  try
    lScoreAndBonus.Align := TAlignLayout.bottom;
    lScoreAndBonus.height := 200;
    if lScoreAndBonus.height > height / 5 then
      lScoreAndBonus.height := height / 5;
  finally
    lScoreAndBonus.EndUpdate;
  end;
  lScore.height := lScoreAndBonus.height / 2 - lScore.Margins.Top -
    lScore.Margins.bottom;
  flBonus.height := lScoreAndBonus.height / 2 - flBonus.Margins.Top -
    flBonus.Margins.bottom;
end;

function TGameScene.GetBonus(const BonusType: TSVGIconesKolopachIndex)
  : TbtnImageButton;
var
  i: integer;
begin
  result := nil;
  for i := 0 to flBonus.ChildrenCount - 1 do
    if (flBonus.Children[i] is TbtnImageButton) and
      ((flBonus.Children[i] as TbtnImageButton).Kind = BonusType) then
    begin
      result := flBonus.Children[i] as TbtnImageButton;
      break;
    end;
end;

function TGameScene.GetNbLives: cardinal;
begin
  result := TBidiooGameData.Current.NbLives;
end;

function TGameScene.GetScore: cardinal;
begin
  result := TBidiooGameData.Current.Score;
end;

procedure TGameScene.DoMusicOnOff(Sender: TObject);
begin
  if TMusicLoop.Current.IsPlaying then
    TMusicLoop.Current.Stop
  else
    TMusicLoop.Current.Play;
  GetBonus(TSVGIconesKolopachIndex.Music).IsPressed :=
    TMusicLoop.Current.IsPlaying;
end;

procedure TGameScene.DoPause(Sender: TObject);
begin
  cadMatch3Game1.StopGame;
  TBidiooGameData.Current.ScreenGridToGameGrid(cadMatch3Game1);
  TBidiooGameData.DefaultGameData.PauseGame;
  TScene.Current := TSceneType.Home;
end;

procedure TGameScene.DoSoundsOnOff(Sender: TObject);
begin
  TConfig.Current.SoundEffectsOnOff := not TConfig.Current.SoundEffectsOnOff;
  if not TConfig.Current.SoundEffectsOnOff then
    TSoundEffects.Current.StopAll;
  GetBonus(TSVGIconesKolopachIndex.Micro).IsPressed :=
    TConfig.Current.SoundEffectsOnOff;
end;

procedure TGameScene.flBonusResized(Sender: TObject);
begin
  RepaintBonusLayout;
end;

procedure TGameScene.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TGameScene.lGameZoneResized(Sender: TObject);
begin
  cadMatch3Game1.FitInParent;
end;

procedure TGameScene.lScoreResized(Sender: TObject);
begin
  txtScore.refresh;
end;

procedure TGameScene.RemoveBonus(const BonusType: TSVGIconesKolopachIndex);
var
  btn: TbtnImageButton;
begin
  btn := GetBonus(BonusType);
  if assigned(btn) then
    btn.free;
end;

procedure TGameScene.RepaintBonusLayout;
var
  i: integer;
  h: single;
begin
  h := min(flBonus.height, 100);
  for i := 0 to flBonus.ChildrenCount - 1 do
    if (flBonus.Children[i] is TbtnImageButton) and
      ((flBonus.Children[i] as TbtnImageButton).height <> h) then
      with (flBonus.Children[i] as TbtnImageButton) do
      begin
        BeginUpdate;
        try
          width := h;
          height := h;
        finally
          EndUpdate;
          Repaint;
        end;
      end;
end;

procedure TGameScene.SetNbLives(const Value: cardinal);
begin
  TBidiooGameData.Current.NbLives := Value;
  AddBonus(TSVGIconesKolopachIndex.Coeur).Number :=
    TBidiooGameData.Current.NbLives;
end;

procedure TGameScene.SetScore(const Value: cardinal);
begin
  TBidiooGameData.Current.Score := Value;
  txtScore.Text := Score.ToString;
end;

procedure TGameScene.ShowScene;
const
  CDefaultBlocSize = 256;
var
  item: TUIElement;
  i: integer;
begin
  inherited;

  TUIItemsList.Current.NewLayout;
  item := TUIItemsList.Current.AddUIItem(
    procedure(const Sender: TObject)
    begin // TODO : appeler directement GoPause() une fois TUIElements corrigé
      DoPause(Sender);
    end);
  item.KeyShortcuts.Add(vkEscape, #0, []);
  item.KeyShortcuts.Add(vkHardwareBack, #0, []);
  item.GamePadButtons := [TJoystickButtons.X];
  item.TagObject := self;

  cadMatch3Game1.Clear;
  cadMatch3Game1.NbCol := TBidiooGameData.Current.ColCount;
  cadMatch3Game1.NbRow := TBidiooGameData.Current.RowCount;
  cadMatch3Game1.BackgroundColor := TAlphaColors.Darkblue;
  cadMatch3Game1.SelectedBackgroundColor := TAlphaColors.Darkslateblue;
  for i := 0 to TSVGKoalas.Count - 1 do
    cadMatch3Game1.SVGItems[i] := TSVGKoalas.SVG(i);
  cadMatch3Game1.width := cadMatch3Game1.NbCol * CDefaultBlocSize;
  cadMatch3Game1.height := cadMatch3Game1.NbRow * CDefaultBlocSize;
  cadMatch3Game1.FitInParent;
  cadMatch3Game1.Initialize;
  cadMatch3Game1.OnMatch3Proc := procedure(const Nb, item: integer)
    begin
      Score := Score + trunc(Nb * item);
      TSoundEffects.Play(TSoundEffectType.CaseEnMoins);
    end;
  cadMatch3Game1.OnMoveButNoMatch3Proc := procedure
    begin
      if TBidiooGameData.Current.NbLives < 1 then
      begin
        TBidiooGameData.Current.StopGame;
        TScene.Current := TSceneType.GameOver;
      end
      else
      begin
        NbLives := NbLives - 1;
        TSoundEffects.Play(TSoundEffectType.PerteDUneVie);
      end;
    end;

  ClearBonusLayout;
  // Pause Button
  with AddBonus(TSVGIconesKolopachIndex.Pause) do
  begin
    ShowNumber := false;
    OnClick := DoPause;
  end;
  // Music On/Off button
  // with AddBonus(TSVGIconesKolopachIndex.Music) do
  // begin
  // IsPressedButton := true;
  // IsPressed := TMusicLoop.Current.IsPlaying;
  // ShowNumber := false;
  // OnClick := DoMusicOnOff;
  // end;
  // Sound On/Off button
  // with AddBonus(TSVGIconesKolopachIndex.Micro) do
  // begin
  // IsPressedButton := true;
  // IsPressed := TConfig.Current.SoundEffectsOnOff;
  // ShowNumber := false;
  // OnClick := DoSoundsOnOff;
  // end;
  // Nb Lives
  with AddBonus(TSVGIconesKolopachIndex.Coeur) do
  begin
    OnClick := nil;
    HitTest := false;
  end;
  // TODO : charger les boutons des bonus disponibles dans la partie en cours
  RepaintBonusLayout;

  Score := TBidiooGameData.Current.Score;
  NbLives := TBidiooGameData.Current.NbLives;
  TBidiooGameData.Current.GameGridToScreenGrid(cadMatch3Game1);

  cadMatch3Game1.StartGame;
end;

initialization

TScene.RegisterScene<TGameScene>(TSceneType.Game);

TConfig.Current.BeginUpdate;
try
  TConfig.Current.BackgroundMusicOnOff := false;
  TConfig.Current.SoundEffectsOnOff := false;
finally
  TConfig.Current.EndUpdate;
end;

end.

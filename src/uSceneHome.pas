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
  File last update : 2026-06-18T19:36:29.417+02:00
  Signature : 5104c28460b026dcdfd1b1b22fdd827e0e79a504
  ***************************************************************************
*)

unit uSceneHome;

interface

// TODO : agrandir le titre du jeu si la taille de l'écran le permet
// TODO : augmenter la marge entre les boutons de menu si la taille de l'écran le permet (et adapter la taille de leur conteneur)
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
  FMX.Layouts,
  _ButtonsAncestor,
  cImageButton,
  cGameTitle;

type
  THomeScene = class(T__SceneAncestor)
    FlowLayout1: TFlowLayout;
    btnPlay: TbtnImageButton;
    btnScores: TbtnImageButton;
    FlowLayoutBreak1: TFlowLayoutBreak;
    btnOptions: TbtnImageButton;
    btnCredits: TbtnImageButton;
    btnQuit: TbtnImageButton;
    cadGameTitle1: TcadGameTitle;
    Layout1: TLayout;
    procedure btnCreditsClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure btnScoresClick(Sender: TObject);
  private
  public
    procedure ShowScene; override;
    procedure HideScene; override;
  end;

implementation

{$R *.fmx}

uses
  uScene,
  uConsts,
  USVGIconesKolopach,
  uUIElements,
  uBidiooGameData;

procedure THomeScene.btnCreditsClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Credits;
end;

procedure THomeScene.btnOptionsClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Options;
end;

procedure THomeScene.btnPlayClick(Sender: TObject);
begin
  if TBidiooGameData.Current.IsPaused then
    TBidiooGameData.Current.ContinueGame
  else
    TBidiooGameData.Current.StartANewGame;
  TScene.Current := TSceneType.Game;
end;

procedure THomeScene.btnQuitClick(Sender: TObject);
begin
  TScene.Current := TSceneType.Exit;
end;

procedure THomeScene.btnScoresClick(Sender: TObject);
begin
  TScene.Current := TSceneType.HallOfFame;
end;

procedure THomeScene.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure THomeScene.ShowScene;
begin
  inherited;
  TUIItemsList.Current.NewLayout;
  TUIItemsList.Current.AddQuit;

  btnPlay.Kind := TSVGIconesKolopachIndex.Drapeau;
  btnScores.Kind := TSVGIconesKolopachIndex.Podium;
  btnOptions.Kind := TSVGIconesKolopachIndex.Engrenage;
  btnOptions.visible := false; // TODO : à compléter
  btnCredits.Kind := TSVGIconesKolopachIndex.Info;
{$IF Defined(IOS) or Defined(ANDROID)}
  btnQuit.visible := false;
{$ELSE}
  btnQuit.Kind := TSVGIconesKolopachIndex.Eteindre;
{$ENDIF}
end;

initialization

TScene.RegisterScene<THomeScene>(TSceneType.Home);

end.

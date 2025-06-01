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
  File last update : 2025-06-01T10:37:28.000+02:00
  Signature : a328ccd9dbfb85d1076284753256259863015eb1
  ***************************************************************************
*)

program KoalaMatch3;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  fMain in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\fMain.pas' {frmMain},
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  u_urlOpen in '..\lib-externes\librairies\src\u_urlOpen.pas',
  uConsts in 'uConsts.pas',
  Olf.RTL.Language in '..\lib-externes\librairies\src\Olf.RTL.Language.pas',
  Olf.RTL.CryptDecrypt in '..\lib-externes\librairies\src\Olf.RTL.CryptDecrypt.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  Olf.Skia.SVGToBitmap in '..\lib-externes\librairies\src\Olf.Skia.SVGToBitmap.pas',
  uDMAboutBox in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uDMAboutBox.pas' {AboutBox: TDataModule},
  uDMAboutBoxLogoStorrage in 'uDMAboutBoxLogoStorrage.pas' {dmAboutBoxLogo: TDataModule},
  uTxtAboutLicense in '..\lib-externes\Bidioo-v2-Delphi\src\uTxtAboutLicense.pas',
  uTxtAboutDescription in 'uTxtAboutDescription.pas',
  Gamolf.FMX.HelpBar in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.HelpBar.pas',
  Gamolf.FMX.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.GamepadDetected in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.GamepadDetected.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Helpers in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Helpers.pas',
  Gamolf.RTL.Joystick.Mac in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Scores.pas',
  Gamolf.RTL.UIElements in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.UIElements.pas',
  iOSapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas',
  uTranslate in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uTranslate.pas',
  uConfig in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uConfig.pas',
  _ScenesAncestor in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\_ScenesAncestor.pas' {__SceneAncestor: TFrame},
  uScene in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uScene.pas',
  uUIElements in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uUIElements.pas',
  uGameData in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uGameData.pas',
  Olf.RTL.Streams in '..\lib-externes\librairies\src\Olf.RTL.Streams.pas',
  Olf.RTL.Maths.Conversions in '..\lib-externes\librairies\src\Olf.RTL.Maths.Conversions.pas',
  uBackgroundMusic in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uBackgroundMusic.pas',
  uSoundEffects in '..\lib-externes\Bidioo-v2-Delphi\src\uSoundEffects.pas',
  USVGInputPrompts in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\assets\kenney_nl\InputPrompts\USVGInputPrompts.pas',
  uDMGameControllerCenter in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uDMGameControllerCenter.pas' {DMGameControllerCenter: TDataModule},
  uSVGBitmapManager_InputPrompts in 'uSVGBitmapManager_InputPrompts.pas',
  uDMHelpBarManager in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\uDMHelpBarManager.pas' {HelpBarManager: TDataModule},
  _ButtonsAncestor in '..\lib-externes\Gamolf-FMX-Game-Starter-Kit\src\_ButtonsAncestor.pas' {__ButtonAncestor: TFrame},
  uSceneBackground in '..\_PRIVATE\assets\AdobeStock\GameBackground\uSceneBackground.pas' {SceneBackground: TFrame},
  uSceneHome in 'uSceneHome.pas' {HomeScene: TFrame},
  uSceneGame in 'uSceneGame.pas' {GameScene: TFrame},
  cImageButton in '..\lib-externes\Bidioo-v2-Delphi\src\cImageButton.pas' {btnImageButton: TFrame},
  USVGIconesKolopach in '..\_PRIVATE\assets\Fotolia\icones.fotolia\IconesKolopach\USVGIconesKolopach.pas',
  cGameTitle in 'cGameTitle.pas' {cadGameTitle: TFrame},
  Olf.FMX.TextImageFrame in '..\lib-externes\librairies\src\Olf.FMX.TextImageFrame.pas' {OlfFMXTextImageFrame: TFrame},
  cDialogBox in '..\_PRIVATE\assets\NicheEmpire\303-OTO-Ultimate-Marketing-Graphics-Collection-NE\cDialogBox.pas' {cadDialogBox: TFrame},
  uSceneOptions in '..\lib-externes\Bidioo-v2-Delphi\src\uSceneOptions.pas' {OptionsScene: TFrame},
  uSceneTutoriel in '..\lib-externes\Bidioo-v2-Delphi\src\uSceneTutoriel.pas' {TutorielScene: TFrame},
  uSceneGameOver in '..\lib-externes\Bidioo-v2-Delphi\src\uSceneGameOver.pas' {GameOverScene: TFrame},
  uSceneHallOfFame in '..\lib-externes\Bidioo-v2-Delphi\src\uSceneHallOfFame.pas' {HallOfFameScene: TFrame},
  uSceneCredits in '..\lib-externes\Bidioo-v2-Delphi\src\uSceneCredits.pas' {CreditsScene: TFrame},
  uBidiooScores in '..\lib-externes\Bidioo-v2-Delphi\src\uBidiooScores.pas',
  udmAdobeStock_257147901 in '..\_PRIVATE\assets\AdobeStock\AdobeStock_257147901\udmAdobeStock_257147901.pas' {dmAdobeStock_257147901: TDataModule},
  udmAdobeStock_257148021 in '..\_PRIVATE\assets\AdobeStock\AdobeStock_257148021\udmAdobeStock_257148021.pas' {dmAdobeStock_257148021: TDataModule},
  USVGKoalas in '..\_PRIVATE\assets\AdobeStock\Koalas\Koalas\USVGKoalas.pas',
  udmAdobeStock_244537511 in '..\_PRIVATE\assets\AdobeStock\AdobeStock_244537511\udmAdobeStock_244537511.pas' {dmAdobeStock_244537511: TDataModule},
  uBidiooConfig in '..\lib-externes\Bidioo-v2-Delphi\src\uBidiooConfig.pas',
  uBidiooGameData in '..\lib-externes\Bidioo-v2-Delphi\src\uBidiooGameData.pas',
  cMatch3Game in '..\lib-externes\Bidioo-v2-Delphi\src\cMatch3Game.pas' {cadMatch3Game: TFrame};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDMGameControllerCenter, DMGameControllerCenter);
  Application.CreateForm(TdmAdobeStock_257147901, dmAdobeStock_257147901);
  Application.CreateForm(TdmAdobeStock_257148021, dmAdobeStock_257148021);
  Application.CreateForm(TdmAdobeStock_244537511, dmAdobeStock_244537511);
  Application.Run;
end.

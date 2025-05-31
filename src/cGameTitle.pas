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
  File last update : 2025-05-31T12:34:04.000+02:00
  Signature : 0f02088817bde333de61904a1725ecebc4aed7ba
  ***************************************************************************
*)

unit cGameTitle;

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
  Olf.FMX.TextImageFrame,
  FMX.Effects;

type
  TcadGameTitle = class(TFrame)
    txtGameTitle: TOlfFMXTextImageFrame;
    GlowEffect1: TGlowEffect;
    procedure FrameResized(Sender: TObject);
  private
  public
    procedure AfterConstruction; override;
  end;

implementation

{$R *.fmx}

uses
  uConsts,
  udmAdobeStock_244537511;

procedure TcadGameTitle.AfterConstruction;
begin
  inherited;
  txtGameTitle.BeginUpdate;
  try
    txtGameTitle.Font := dmAdobeStock_244537511.ImageList;
    txtGameTitle.AutoSize := true;
    txtGameTitle.Text := CAboutGameTitle;
  finally
    txtGameTitle.EndUpdate;
  end;
end;

procedure TcadGameTitle.FrameResized(Sender: TObject);
begin
  txtGameTitle.Refresh;
end;

end.

unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    cd: TColorDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CLine: TShape;
    CPoint: TShape;
    TrackBar1: TTrackBar;
    Button1: TButton;
    procedure CLineMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CPointMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
 uses unit1;
{$R *.dfm}

procedure TForm3.CLineMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if not Cd.Execute then exit;
 options.LineColor := cd.Color;
 Cline.Brush.Color := cd.Color;
end;

procedure TForm3.CPointMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if not Cd.Execute then exit;
 options.PointColor := cd.Color;
 Cpoint.Brush.Color := cd.Color;
end;

procedure TForm3.TrackBar1Change(Sender: TObject);
begin
 options.PointSize := TrackBar1.Position;

end;

procedure TForm3.Button1Click(Sender: TObject);
begin
form3.Hide;
end;

end.

unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TZoom = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Slider: TTrackBar;
    cbSrediste: TCheckBox;
    Image1: TImage;
    Timer1: TTimer;
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Zoom: TZoom;
  C: TCanvas;

implementation

{$R *.dfm}


procedure TZoom.FormResize(Sender: TObject);
begin
 Panel1.Left:=(Zoom.ClientWidth Div 2) - Panel1.Width div 2;
 Panel1.Top:=(Zoom.ClientHeight Div 2) - Panel1.Height div 2;
 Image1.Picture:=nil;
 C.Handle:=GetDC(GetDesktopWindow);
end;

procedure TZoom.Timer1Timer(Sender: TObject);
var
 Srect,Drect,PosForme:TRect;
 iWidth,iHeight,DmX,DmY:Integer;
 iTmpX,iTmpY:Real;
 Kursor:TPoint;
begin
 If not IsIconic(Application.Handle) then
  begin
   GetCursorPos(Kursor);
   PosForme := Rect( Zoom.Left,Zoom.Top,Zoom.Left+Zoom.Width,Zoom.Top+Zoom.Height);
   if not PtInRect(PosForme,Kursor) then
    begin
     if Panel1.Visible=True  then Panel1.Visible:=False;
     if Image1.Visible=False then Image1.Visible:=True;

     iWidth :=Image1.Width;
     iHeight:=Image1.Height;

     Drect:=Rect(0,0,iWidth,iHeight);
     iTmpX:=iWidth  / (Slider.Position * 4);
     iTmpY:=iHeight / (Slider.Position * 4);

     Srect:=Rect(Kursor.x,Kursor.y,Kursor.x,Kursor.y);
     InflateRect(Srect,Round(iTmpX),Round(iTmpY));
     // move Srect if outside visible area of the screen
     if Srect.Left<0 then OffsetRect(Srect,-Srect.Left,0);
     if Srect.Top <0 then OffsetRect(Srect,0,-Srect.Top);

     if Srect.Right >Screen.Width  then OffsetRect(Srect,  -(Srect.Right-Screen.Width)  ,0);
     if Srect.Bottom>Screen.Height then OffsetRect(Srect,0,-(Srect.Bottom-Screen.Height)  );


       Image1.Canvas.CopyRect(Drect,C,Srect);

     if cbSrediste.Checked=True then
      begin // show crosshair

       with Image1.Canvas do
        begin
       Image1.Canvas.Pen.Style := psDashDotDot;
       Image1.Canvas.Pen.Mode  := pmNot;

         DmX := Slider.Position * 2 * (Kursor.X-Srect.Left);
         DmY := Slider.Position * 2 * (Kursor.Y-Srect.Top);
       	 MoveTo(DmX - (iWidth div 4),DmY); // -
   	     LineTo(DmX + (iWidth div 4),DmY); // -

         MoveTo(DmX,DmY - (iHeight div 4)); // |
       	 LineTo(DmX,DmY + (iHeight div 4)); // |
        end; // with image1.Canvas
      end; // show crosshair

    end // Cursor not inside form
   else
    begin  // cursor inside form
     if Panel1.Visible=False then Panel1.Visible:=True;
     if Image1.Visible=True then Image1.Visible:=False;
    end;
 end; // IsIconic

end;

procedure TZoom.FormCreate(Sender: TObject);
begin
timer1.Enabled :=false;
     C:=TCanvas.Create;
timer1.Enabled :=true;

end;

end.

unit Unit1;
{$Warnings off}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, Menus, ExtCtrls, ToolWin, ComCtrls, StdCtrls, ImgList;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    SaveasV2G1: TMenuItem;
    opd: TOpenPictureDialog;
    sd: TSaveDialog;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    CrateNewPolygon1: TMenuItem;
    cd: TColorDialog;
    ToolButton1: TToolButton;
    OpenV2G1: TMenuItem;
    od: TOpenDialog;
    ClearPolygon1: TMenuItem;
    PolyList: TComboBox;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ImageList1: TImageList;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    N1: TMenuItem;
    New1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Close1: TMenuItem;
    ToolButton8: TToolButton;
    Aboutme: TMenuItem;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ShowZoom1: TMenuItem;
    Options1: TMenuItem;
    Configure1: TMenuItem;
    PointList: TComboBox;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    HideUnSecelted: TToolButton;
    Savetobitmap1: TMenuItem;
    Clean1: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    pb2: TPaintBox;
    Splitter1: TSplitter;
    pb1: TPaintBox;
    Shape1: TShape;
    ToolButton13: TToolButton;
    Help2: TMenuItem;
    About: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure SaveasV2G1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CrateNewPolygon1Click(Sender: TObject);
    procedure pb1DblClick(Sender: TObject);
    procedure pb1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ToolButton1Click(Sender: TObject);
    procedure OpenV2G1Click(Sender: TObject);
    procedure ClearPolygon1Click(Sender: TObject);
    procedure PolyListSelect(Sender: TObject);
    procedure PolyListDropDown(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure AboutmeClick(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ShowZoom1Click(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure PointListDropDown(Sender: TObject);
    procedure pb1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pb1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Savetobitmap1Click(Sender: TObject);
    procedure Clean1Click(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Help2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  TPolygon  = Record
   Vertex   : Array of TPoint;
   Color    : Integer;
  end;

const
  V2GFilter = 'Vector 2d Graphic by SVSD_VAL|*.v2g';
  BmpFilter = 'Bitmap *.bmp|*.bmp';
  VCount    = 'VertexCount: ';
  MoveMode  = 'Move Mode: ';
var
  Form1: TForm1;
  PreBuffer,
  ImageBuffer,
  PolygonBuffer : TBitmap;

  Options : Record
    LineColor,
    PointColor,
    PointSize : Integer;
  end;

  Poly    : Array of TPolygon;
  CurPoly : Integer;
  MPOS    : TPOint;
  Epsilon : Integer = 2;
  Move,
  MoveAll : boolean;


implementation

uses Unit2, Unit3;

{$R *.dfm}
Function Key(K:word):boolean;
begin
result :=false;
 if GetForegroundWindow = form1.Handle then
 Result := GetAsyncKeyState( k ) <> 0;
end;

Procedure UpdatePolyList;
var i : integer;
begin
 Form1.PolyList.Clear;
 for i := 0 to length(Poly)-1 do
 Form1.PolyList.Items.Add('Poly№'+inttostr(i)+' v: '+inttostr(length(poly[i].vertex)));
 Form1.PolyList.ItemIndex :=0;
end;

Procedure UpdatePointList;
var i : integer;
begin
 Form1.PointList.Clear;
 If (CurPoly <0) or (Length(Poly) = 0) or (length(poly[curpoly].Vertex) =0) then exit;
 with Poly[curpoly] do
 for i := 0 to length(Vertex)-1 do
 Form1.PointList.Items.Add('Point№'+inttostr(i) + ' ( ' +inttostr(vertex[i].x)+'x'+inttostr(vertex[i].y)+ ' )');
end;


Procedure AddVertex(X,Y:Integer; FindEqual:boolean);
var i,s1,s2 : integer;
begin
  If (CurPoly <0) or (Length(Poly) = 0) then exit;
  i := Length ( Poly[CurPoly].Vertex );
    SetLength ( Poly[CurPoly].Vertex , i + 1);

                Poly[CurPoly].Vertex[i].X := x;
                Poly[CurPoly].Vertex[i].Y := Y;

    if FindEqual then
      For s1 := 0 to length(poly) -1 do with poly[s1] do
      for s2 := 0 to length(Vertex)-1 do
       if  (abs(vertex[s2].x - x) <= Epsilon) and
           (abs(vertex[s2].y - y) <= Epsilon) then
           begin
                Poly[CurPoly].Vertex[i].X := vertex[s2].x;
                Poly[CurPoly].Vertex[i].Y := vertex[s2].y;
                exit;
           end;

end;

Procedure DeleteLastVertex;
begin
  If (CurPoly <0) or (Length(Poly) = 0) then exit;
  if length(poly[curpoly].Vertex) >0 then
  Setlength(poly[curpoly].Vertex, High(poly[curpoly].Vertex));
end;


Procedure DeleteV0;
var i : integer;
label loop;
begin

 loop:
 For i := 0 to Length(poly)-1 do
 if length(poly[i].Vertex) = 0 then
 begin
  Poly[i] := Poly[High(Poly)];
  Setlength(poly, High(Poly));
  goto loop;
 end;
end;

Function GetVertexAtPos(X,Y:Integer):Integer;
const epsilon = 1;
var i : integer;
begin
  If (CurPoly <0) or (Length(Poly) = 0) or (length(poly[curpoly].Vertex) =0) then exit;

  with poly[curpoly] do
  for i := 0 to length(Vertex) -1 do
  if (abs(Vertex[i].X - X) <= Epsilon) and
     (abs(Vertex[i].y - y) <= Epsilon) then
     begin
      result:=i;
      exit;
     end;
  result := -1;
end;

Procedure MoveVertex(X,Y:Integer; all:boolean);
var i,i2 : integer;
begin
if not all then
  begin
    If (CurPoly <0) or (Length(Poly) = 0) or (length(poly[curpoly].Vertex) =0) then exit;
    with poly[curpoly] do
    for i := 0 to length(Vertex) -1 do
      begin
       Vertex[i].x := Vertex[i].x +x;
       Vertex[i].y := Vertex[i].y +y;
      end;
  end
      else
  for i := 0 to length(poly) -1 do
  with poly[i] do
  for i2:= 0 to length(Vertex) -1 do
  begin
   Vertex[i2].x := Vertex[i2].x +x;
   Vertex[i2].y := Vertex[i2].y +y;
  end;
end;


procedure TForm1.Open1Click(Sender: TObject);
begin
if not opd.Execute then exit;
 ImageBuffer.LoadFromFile(opd.FileName);
 PB1.Width := ImageBuffer.Width;
 PB2.Width := ImageBuffer.Width;
 PolygonBuffer.Width := ImageBuffer.Width;
 PolygonBuffer.Height:= ImageBuffer.Height;
 PreBuffer.Width     := ImageBuffer.Width ;
 PreBuffer.Height    := ImageBuffer.Height ;
// Form1.ClientWidth :=ImageBuffer.Width*2+15;
// zoom.Show;
end;

procedure TForm1.SaveasV2G1Click(Sender: TObject);
var
 f: File of byte;
 i,i2:integer;
begin
 sd.Filter := V2GFilter;

if not sd.Execute then exit;
 sd.FileName := ChangeFileExt(sd.FileName,'.v2g');

 AssignFile (F , Sd.FileName );
 ReWrite(F, Sd.FileName );

 DeleteV0;


 I := Length(Poly);
 BlockWrite ( F, I , 4 );
 For i := 0 to Length(poly)-1 do
 begin
  i2 := Length(Poly[i].Vertex);
  BlockWrite ( F, i2 , 4 );

  For i2 := 0 to Length(Poly[i].Vertex) -1 do
  begin
  BlockWrite ( F, Poly[i].Vertex[i2].x , 2 );
  BlockWrite ( F, Poly[i].Vertex[i2].y , 2 );
  end;

  BlockWrite ( F, Poly[i].Color ,4 );
 end;


 CloseFile(f);
end;

procedure TForm1.OpenV2G1Click(Sender: TObject);
var
 f: File of byte;
 i,i2:integer;
 MaxW,MaxH:Integer;
begin
if not od.Execute then exit;
 AssignFile ( F , od.FileName );
 Reset(F, od.FileName );


 maxw:=0;
 maxh:=0;

 BlockRead ( F, I , 4 );
 SetLength(Poly , i);
 For i := 0 to Length(poly)-1 do
 begin
  BlockRead ( F, i2 , 4 );
  SetLength ( Poly[i].Vertex, I2);

    For i2 := 0 to Length(Poly[i].Vertex) -1 do
    begin
      BlockRead ( F, Poly[i].Vertex[i2].x , 2 );
      BlockRead ( F, Poly[i].Vertex[i2].y , 2 );

      if Poly[i].Vertex[i2].x > maxw then maxw := Poly[i].Vertex[i2].x;
      if Poly[i].Vertex[i2].y > maxh then maxh := Poly[i].Vertex[i2].y;
    end;

  BlockRead ( F, Poly[i].Color ,4 );
 end;
 CloseFile(f);


 if PolygonBuffer.Width  < maxw then PolygonBuffer.Width  := maxw;
 if PolygonBuffer.Height < maxh then PolygonBuffer.Height := maxh;
 PB2.Width := PolygonBuffer.Width;

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := False;
  ImageBuffer    := TBitmap.Create;
  PolygonBuffer  := TBitmap.Create;
  PreBuffer      := TBitmap.Create;
  Timer1.Enabled := True;


  Options.LineColor := CLWhite;
  Options.PointColor:= CLWhite;
  Options.PointSize := 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i , i2 : Integer;
   vc:integer;
begin

 BitBlt(PreBuffer.Canvas.Handle,0,0,ImageBuffer.Width,ImageBuffer.Height,ImageBuffer.Canvas.Handle,0,0,SrcCopy);

        PreBuffer.Canvas.Pen.Color := CLWhite;


  For i := 0 to length(poly)-1 do
  with poly[i] do
  begin
    if HideUnSecelted.Down then
    if (curpoly <> i) then continue;

    PreBuffer.Canvas.Pen.Color := Options.LineColor;
    PreBuffer.Canvas.Pen.Width := 1;
    PreBuffer.Canvas.Brush.Style := BSClear;
    PreBuffer.Canvas.Polygon(Poly[i].Vertex);

    PreBuffer.Canvas.Pen.Width := 2;
    PreBuffer.Canvas.Pen.Color := Options.PointColor;
    PreBuffer.Canvas.Brush.Style := bsSolid;

    For i2 := 0 to length(Vertex)-1 do
    begin
     PreBuffer.Canvas.Ellipse(Vertex[i2].x-Options.PointSize,Vertex[i2].y-Options.PointSize, Vertex[i2].x+Options.PointSize,Vertex[i2].y+Options.PointSize)
    end;
  end;



   PolygonBuffer.Canvas.Brush.Color :=rgb(54,54,54);
   PolygonBuffer.Canvas.Pen.Color   :=rgb(54,54,54);
   PolygonBuffer.Canvas.Rectangle(0,0,PolygonBuffer.width, PolygonBuffer.height);

  vc :=0;
  For i := 0 to length(poly)-1 do
  with poly[i] do
  begin
    PolygonBuffer.Canvas.Pen.Width := 1;
    if PolyList.ItemIndex = i then
    PolygonBuffer.Canvas.Pen.Color   :=RGB(127+random(128), 127+random(128), 127+random(128)) else
    PolygonBuffer.Canvas.Pen.Color   :=Color;
    PolygonBuffer.Canvas.Brush.Color :=Color;
    PolygonBuffer.Canvas.Polygon(Vertex);

    if (PolyList.ItemIndex = i) then
    if (PointList.ItemIndex < length(vertex)) and
       (PointList.ItemIndex > -1) then
    begin
     i2 := PointList.ItemIndex;
    PolygonBuffer.Canvas.Ellipse(Vertex[ i2 ].x-Options.PointSize,Vertex[i2].y-Options.PointSize, Vertex[i2].x+Options.PointSize,Vertex[i2].y+Options.PointSize)
    end;
     vc := vc + Length(Vertex);
  end;


  BitBlt(Pb1.Canvas.Handle,0,0,PreBuffer.Width,PreBuffer.Height,PreBuffer.Canvas.Handle,0,0,SrcCopy);
  BitBlt(pb2.Canvas.Handle,0,0,PolygonBuffer.Width,PolygonBuffer.Height,PolygonBuffer.Canvas.Handle,0,0,SrcCopy);

  statusbar1.Panels.Items[0].Text := VCount + inttostr(vc);
  statusbar1.Panels.Items[1].Text := MoveMode + BoolToStr(MoveALL);

  if Key( vk_shift ) and key( vk_space ) then
  begin
    MoveAll := not MoveAll;
    panel1.setfocus;
  end;

  if moveall then
  begin

  if Key( vk_up    ) then  MoveVertex( 0,-1, key(vk_control));
  if Key( vk_down  ) then  MoveVertex( 0, 1, key(vk_control));
  if Key( vk_left  ) then  MoveVertex(-1, 0, key(vk_control));
  if Key( vk_right ) then  MoveVertex( 1, 0, key(vk_control));

  end;

end;

procedure TForm1.CrateNewPolygon1Click(Sender: TObject);
begin
  CurPoly := Length(Poly);
          SetLength(Poly, CurPoly + 1);
          Poly[CurPoly].Color := Cd.Color;
end;

procedure TForm1.pb1DblClick(Sender: TObject);
begin
  AddVertex(mpos.x,mpos.y, GetAsyncKeyState(vk_control) <> 0 );
end;

procedure TForm1.pb1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var get:TPoint;
begin
  mpos.X :=x;
  mpos.y :=y;
  get.x  :=x;
  get.y  :=y;
  if get.X > imagebuffer.width  then get.X := imagebuffer.Width;
  if get.Y > imagebuffer.Height then get.Y := imagebuffer.Height;
  if key( ord('C') ) then
   Shape1.Brush.Color := ImageBuffer.Canvas.Pixels[get.X,get.y];

  If (CurPoly <0) or (Length(Poly) = 0) or (length(poly[curpoly].Vertex) =0) then exit;

  if move then
  begin
   poly[curpoly].Vertex[ PointList.ItemIndex ].X := x;
   poly[curpoly].Vertex[ PointList.ItemIndex ].y := y;
  end;




end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
if not cd.Execute then exit;
  If (CurPoly <0) or (Length(Poly) = 0) then exit;
  Poly[CurPoly].Color := Cd.Color;
end;


procedure TForm1.ClearPolygon1Click(Sender: TObject);
begin
  If (CurPoly <0) or (Length(Poly) = 0) then exit;
  SetLength(Poly[CurPoly].Vertex ,0);
  ToolButton9.Click;
end;

procedure TForm1.PolyListSelect(Sender: TObject);
begin
 CurPoly := PolyList.ItemIndex;
 if CurPoly > high(Poly) then UpdatePolyList;
 UpdatePointList;
end;

procedure TForm1.PolyListDropDown(Sender: TObject);
var i : integer;
begin
 i := polylist.ItemIndex;
  UpdatePolyList;
 polylist.ItemIndex := i;

end;

procedure TForm1.ToolButton3Click(Sender: TObject);
var
 P : TPolygon;
begin
  If (CurPoly <1) or (Length(Poly) = 0) then exit;

 P := Poly[ CurPoly-1 ];
      Poly[ CurPoly-1 ] := Poly[ CurPoly ];
      Poly[ CurPoly   ] := p;
    UpdatePolyList;
    PolyList.ItemIndex := CurPoly-1;
               CurPoly := CurPoly-1;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
var
 P : TPolygon;
begin
  If (CurPoly <0) or (Length(Poly) = 0) or (CurPoly = high(poly)) then exit;

 P := Poly[ CurPoly+1 ];
      Poly[ CurPoly+1 ] := Poly[ CurPoly ];
      Poly[ CurPoly ]   := p;
    UpdatePolyList;
    PolyList.ItemIndex := CurPoly+1;
               CurPoly := CurPoly+1;

end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin
 DeleteLastVertex;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
 Poly := Nil;
 OpenV2G1.Click;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  If (CurPoly <0) or (Length(Poly) = 0) then exit;
  Poly[CurPoly]:= Poly[High(Poly)];
  Setlength(poly, High(Poly));
  ToolButton9.Click;
end;

procedure TForm1.AboutmeClick(Sender: TObject);
begin
  application.MessageBox('demo editor for ZephyrGL'
                         +#13+#10+'site :http://svsd.mirgames.ru'
                         +#13+#10+'icq : 223-725-915'
                         +#13+#10+'jabber: svsd_val@jabber.sibnet.ru'
                         +#13+#10+'mail: svsd_val@sibnet.ru / valdim_05@mail.ru'
                         , 'Vector Graphic Editor by SVSD_VAL');
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
PolyList.ItemIndex :=-1;
PointList.Clear;
CurPoly:=-1;
end;

procedure TForm1.ShowZoom1Click(Sender: TObject);
begin
Zoom.Show;
end;

procedure TForm1.Configure1Click(Sender: TObject);
begin
 Form3.show;
 Form3.Left := Left + (ClientWidth - form3.Width) div 2;
 Form3.top := top + (Clientheight - form3.height) div 2;
end;

procedure TForm1.PointListDropDown(Sender: TObject);
begin
UpdatePointList;
end;

procedure TForm1.pb1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if GetAsynckeystate( vk_shift ) = 0 then exit;

PointList.ItemIndex := GetVertexAtPos(X,Y);
Move := PointList.ItemIndex <> -1;
end;

procedure TForm1.pb1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
move :=false;
end;

procedure TForm1.Savetobitmap1Click(Sender: TObject);
begin
 ToolButton9.Click;
 sd.Filter := BMPFilter;
if not sd.Execute then exit;
 sd.FileName := ChangeFileExt(sd.FileName,'.bmp');
 polygonbuffer.SaveToFile(sd.filename);

end;

procedure TForm1.Clean1Click(Sender: TObject);
var i : integer;
begin
  for i := 0 to length(poly) -1 do
  with poly[i] do
  if length(vertex) > 0 then
  if (vertex[0].X = vertex[ high ( vertex ) ].X) and
     (vertex[0].Y = vertex[ high ( vertex ) ].Y) then
     SetLength(Vertex, High(Vertex));

end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cd.Color := shape1.Brush.Color;
end;

procedure TForm1.Help2Click(Sender: TObject);
begin
 application.MessageBox(
           'Как работать с редактором:'
 +#13+#10+ '0: Открываем картинку'
 +#13+#10+ '1: Жмём правую кнопку мышки и выбираем : Create New Polygon'
 +#13+#10+ '2: Двойной клик на левой картинке в том месте где хотим добавить точку'
 +#13+#10+ '3: Таким образом ставив точки обводим нужный силуэт'
 +#13+#10+ '4: И далее повторяем пункты с 1 по 3'
 +#13+#10
 +#13+#10+ 'Чтоб подвинуть точку:'
 +#13+#10+ '1 :выбираем полигон'
 +#13+#10+ '2 :жмём Shift и левою кнопку на точку и двигаем её'
 +#13+#10
 +#13+#10+ 'Чтоб установить цвет полигона'
 +#13+#10+ ' есть специальная кнопка в тулсбаре :D'
 +#13+#10+ '---------'
 +#13+#10+ 'Дальше думаю сами разберётесь'

 ,'v2g by svsd_val');
end;

end.

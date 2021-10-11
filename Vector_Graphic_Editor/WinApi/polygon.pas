unit Polygon;
{$Warnings off}
Interface
uses windows,objects;


type

  TPolygon  = Record
   Vertex   : Array of TPoint;
   Color    : Integer;
  end;

  PPolygonImage = ^TPolygonImage;
  TPolygonImage = Record
   Width,
   Height   : Integer;
   Poly     : Array of TPolygon;
  end;

Function LoadV2G( FileName:String) : PPolygonImage;
Procedure RenderV2G(V2G : PPolygonImage); overload;
Procedure RenderV2G(X,Y:Integer; Scale:Single; V2G : PPolygonImage);overload;

Function LoadV2Gsmall(const FileNAme :String): PPolyGonImage;
Procedure SaveV2Gsmall(V2G: PPolyGonImage ; const FileNAme :String);

Implementation

Function LoadV2G( FileName:String) : PPolygonImage;
var
 f    : File of byte;
 i,i2 : integer;
begin
 AssignFile ( F , FileName );
 Reset(F );

 New(Result);
 With Result^ do
 begin

     Width:=0;
     Height:=0;

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

            if Poly[i].Vertex[i2].x > Width  then Width  := Poly[i].Vertex[i2].x;
            if Poly[i].Vertex[i2].y > Height then Height := Poly[i].Vertex[i2].y;
          end;

        BlockRead ( F, Poly[i].Color ,4 );
       end;
     CloseFile(f);

 end;

end;

Procedure SaveV2Gsmall(V2G: PPolyGonImage ; const FileNAme :String);
var
 F : File of byte;
 i,i2:Integer;
 w,h : single;
 P   : TPoint;
begin
 AssignFile (F , FileName );
 ReWrite(F );

 With V2G^ do
 begin
 w := 1 / Width ;
 h := 1 / height;

   BlockWrite ( F, Width , 2 );
   BlockWrite ( F, Height, 2 );

                   I := Length(Poly);
   BlockWrite ( F, I , 2 );
   For i := 0 to Length(poly)-1 do
   begin
                    i2 := Length(Poly[i].Vertex);
    BlockWrite ( F, i2 , 2 );

    For i2 := 0 to Length(Poly[i].Vertex) -1 do
    begin
                      P.X := Round(Poly[i].Vertex[i2].x * W *255);
                      P.Y := Round(Poly[i].Vertex[i2].Y * H *255);
      BlockWrite ( F, P.X , 1 );
      BlockWrite ( F, P.Y , 1 );
    end;

    BlockWrite ( F, Poly[i].Color ,4 );
   end;
 end;


 CloseFile(f);
end;

Function LoadV2Gsmall(const FileNAme :String): PPolyGonImage;
var
 F : File of byte;
 i,i2:Word;
 w : single;
begin
 AssignFile (F , FileName );
 Reset      (F);

 New(Result);

 With Result^ do
 begin
   BlockRead ( F, Width , 2 );
   BlockRead ( F, Height, 2 );
 w := 1 / 255 ;

     BlockRead ( F, I , 2 );
     SetLength ( Poly , i);
     For i := 0 to Length(poly)-1 do
     begin
      BlockRead ( F, i2 , 2 );
      SetLength ( Poly[i].Vertex, I2);

          For i2 := 0 to Length(Poly[i].Vertex) -1 do
          begin
            BlockRead ( F, Poly[i].Vertex[i2].x , 1 );
            BlockRead ( F, Poly[i].Vertex[i2].y , 1 );
               Poly[i].Vertex[i2].x := Round( Poly[i].Vertex[i2].x * w * Width);
               Poly[i].Vertex[i2].y := Round( Poly[i].Vertex[i2].y * w * Height);
          end;

        BlockRead ( F, Poly[i].Color ,4 );
       end;


 end;


 CloseFile(f);
end;


Procedure RenderV2G(V2G : PPolygonImage); overload
var
 i :integer;
begin
  With V2g^ do
   for i := 0 to length(poly)-1 do  with poly[i] do
   begin
     buffer.SetPen(0,1,color);
     buffer.SetBrush(0,0,color);
     buffer.Polygon(vertex);
   end;

end;


Procedure RenderV2G(X,Y:Integer; Scale:single; V2G : PPolygonImage);
var
 i , i2 :integer;
 verts  :array of TPoint;
begin
  With V2g^ do
  begin
   for i := 0 to length(poly)-1 do  with poly[i] do
   begin

     setlength(verts, length(vertex));
     for i2 := 0 to length(vertex)-1 do
     begin
      verts[i2].x := round(vertex[i2].x * Scale)+x;
      verts[i2].y := round(vertex[i2].y * Scale)+y;
     end;

     buffer.SetPen(0,1,color);
     buffer.SetBrush(0,0,color);
     buffer.Polygon(verts);
   end;

  end;
     setlength(verts, 0);

end;


end.

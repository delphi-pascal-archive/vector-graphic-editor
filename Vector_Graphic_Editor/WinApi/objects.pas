Unit Objects;
{$Warnings off}
interface

Uses Windows, FastDib;

Var
d           : DEVMODE;                   // ����� ������ (��� �������� ���������� � ��)
WndClass    : TWndClass;                 // ����� ���� ( ����� , ������ � ��)
msg         : TMsg;                      // ��������� � ����
h_Wnd       : HWND;                      // ������ ���� (����� ��� � �����)
h_DC        : HDC;                       // ������ ���������

Buffer      : TFastDIB;

Width       : Integer = 640;             // ������ ����
Height      : Integer = 480;             // ������ ����
BPP         : Integer = 16;              // ������� �����
Done        : boolean;                   // ��������� �� ������ ��������� ?

FPS,
FPS_Time,
FPS_Count,
FrameTime,                               // ������� 1 ����� (��� ������������� �� FPS)
LastTime    : Integer;                   // ��������� ����� �����
Loaded      : boolean;                   // ��������� �� �� �� ��� ��� ����� (�������� �����/����� � ��)
keys        : Array[0..255] of Boolean;  // ����� � ��� �������� ��� ������� ������

Procedure InitBuffer;
Procedure PresentBuffer;
Procedure ClearBuffer(CLR:Integer);
implementation

Procedure InitBuffer;
begin
    Buffer         := TFastDIB.create;
    Buffer.SetSize(Width,Height,24);
end;

Procedure ClearBuffer;
begin
    buffer.SetBrush(0,0,clr);
    buffer.SetPen(0,1,clr);
    buffer.Rectangle(0,0,buffer.Width ,buffer.Height );
end;

Procedure PresentBuffer;
begin
    BitBlt(H_DC,0,0,Buffer.Width,Buffer.Height, buffer.hDC,0,0,SrcCopy);
end;

end.
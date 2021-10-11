Unit Objects;
{$Warnings off}
interface

Uses Windows, FastDib;

Var
d           : DEVMODE;                   // Режим экрана (для устаноки разрешения и тп)
WndClass    : TWndClass;                 // Класс окна ( стиль , бордюр и тд)
msg         : TMsg;                      // Сообщения к окну
h_Wnd       : HWND;                      // Хендел окна (номер его у винды)
h_DC        : HDC;                       // Канвас программы

Buffer      : TFastDIB;

Width       : Integer = 640;             // Щирена окна
Height      : Integer = 480;             // Высота окна
BPP         : Integer = 16;              // Глубина цвета
Done        : boolean;                   // Закончена ли работа программы ?

FPS,
FPS_Time,
FPS_Count,
FrameTime,                               // Скорост 1 кадра (для независимости от FPS)
LastTime    : Integer;                   // Последнее время кадра
Loaded      : boolean;                   // Загрузили ли мы то что нам нужно (например звуки/карты и тд)
keys        : Array[0..255] of Boolean;  // Здесь у нас хранятся все нажатые кнопки

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
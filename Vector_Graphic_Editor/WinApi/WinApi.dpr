program Setup;
{$Warnings Off}
uses
  Windows, messages,objects,polygon;

const
      Class_Name     = 'Patcher';
      Wnd_name       = 'Vector Grapgics by svsd_val';

var
    img : array [0..3] of PPolygonImage;
    f   : record
      X,Y:Integer;
    end;

function IntToStr(Num : Integer) : String;
begin
  Str(Num, result);
end;


procedure Init;
begin
    Width := 400;
    Height:= 400;

    InitBuffer;
    Img[0] := LoadV2G('..\batman3_2_.v2g');

// Уменьшение размера файла в 2 раза за счёт ухучшения точности (практически незаметна на картинках 512х512 и вообще не отличается ничем при 255х255)
//    SaveV2Gsmall(img[0], 'batman3_2_.v2s');
//    img[3] := LoadV2Gsmall('batman3_2_.v2s');

    Img[1] := LoadV2G('..\batman4.v2g');
    Img[2] := LoadV2G('..\player_2.v2g');

end;

Procedure Draw;
begin
     ClearBuffer(0);


     RenderV2G(0,00, abs(Sin(GetTickCount*0.00005))*6, img[1]);
     RenderV2G(img[0]);

     RenderV2G( f.x , f.y, (0.1+ abs(Cos(GetTickCount*0.0002))*0.2) , img[2]);

     buffer.SetBrush(0,1,0);
//     buffer.
     buffer.SetTransparent(true);
       buffer.SetTextColor(rgb(255,255,255));
       buffer.TextOut(0,0,'FPS: '+ IntToStr(fps) + ' | '+ inttostr(img[0]^.Width) );
     buffer.SetTransparent(false);

     PresentBuffer;

     f.y := f.y -1;
     if f.y < -100 then
     begin
      f.x := random(width-50);
      f.y := height;
     end;

end;

Procedure Update;
begin
      if (keys[VK_ESCAPE]) then
        Done := True;
end;



function WndProc(hWnd: HWND; Msg: UINT;  wParam: WPARAM;  lParam: LPARAM): LRESULT; stdcall;
begin
  case (Msg) of
    WM_CLOSE: PostQuitMessage(0);
    WM_KEYDOWN:
      begin
        keys[wParam] := True;
        Result := 0;
      end;
    WM_KEYUP:
      begin
        keys[wParam] := False;
        Result := 0;
      end;
    WM_LBUTTONDOWN:   // Left mouse button down
      begin
//        if (LOWORD(lParam) >=13 ) AND (LOWORD(lParam) <=200) then  { X range }
      end;
    else
    begin
      Result := DefWindowProc(hWnd, Msg, wParam, lParam);
      Exit;
    end;
  end;
end;


procedure KillWnd();
begin
  ReleaseDC(h_Wnd, h_DC);
  DestroyWindow(h_Wnd);
  UnRegisterClass(Class_Name, hInstance);
  hInstance := cardinal(Nil);
end;


function CreateWnd(Width, Height : Integer; Fullscreen : Boolean) : Boolean;
var
  wndClass         : TWndClass;     // Window class
  dwStyle          : DWORD;         // Window styles
  dwExStyle        : DWORD;         // Extended window styles
  h_Instance       : HINST;         // Current instance
  hPos, vPos       : Integer;
  rect             : TRect;
begin
  h_Instance := GetModuleHandle(nil);       //Grab An Instance For Our Window
  ZeroMemory(@wndClass, SizeOf(wndClass));  // Clear the window class structure

  with wndClass do                    // Set up the window class
  begin
    style         := CS_HREDRAW or    // Redraws entire window if length changes
                     CS_VREDRAW or    // Redraws entire window if height changes
                     CS_OWNDC;        // Unique device context for the window
    lpfnWndProc   := @WndProc;        // Set the window procedure to our func WndProc
    hInstance     := h_Instance;
    hCursor       := LoadCursor(0, IDC_ARROW);
    lpszClassName := Class_Name;
  end;

  RegisterClass(wndClass);

    dwStyle := WS_OVERLAPPEDWINDOW or     // Creates an overlapping window
               WS_CLIPCHILDREN or         // Doesn't draw within child windows
               WS_CLIPSIBLINGS;           // Doesn't draw within sibling windows

  dwExStyle  := WS_EX_APPWINDOW or   // Top level window
                WS_EX_WINDOWEDGE or WS_EX_DLGMODALFRAME;    // Border with a raised edge
  // Attempt to create the actual window
  h_Wnd := CreateWindowEx(dwExStyle,      // Extended window styles
                          Class_Name,     // Class name
                          wnd_name  ,     // Window title (caption)
                          dwStyle,        // Window styles
                          0, 0,     // Window Position
                          Width, Height,  // Size of window
                          0,              // No parent window
                          0,              // No menu
                          h_Instance,     // Instance
                          nil);           // Pass nothing to WM_CREATE
  h_DC := GetDC(h_Wnd);

//  GetWindowRect(h_wnd,rect);
  // Get screen center and coordinates to position window in the center
  hPos := GetDeviceCaps(GetDC(0), HORZRES);  // Screen width
  vPos := GetDeviceCaps(GetDC(0), VERTRES);  // Screen Height
  hPos := (hPos - Width ) DIV 2;
  vPos := (vPos - Height ) DIV 2;

  Rect.Left   := 0;
  Rect.Top    := 0;
  Rect.Right  := width;
  Rect.Bottom := Height;

  AdjustWindowRect(Rect, dwStyle, False);
  with Rect do
    MoveWindow(h_Wnd, hpos, vpos, Right - Left, Bottom - Top, False);

  ShowWindow(h_Wnd, SW_SHOW);
  SetForegroundWindow(h_Wnd);
  SetFocus(h_Wnd);

  Result := True;
end;


{--------------------------------------------------------------------}
{  Main message loop for the application                             }
{--------------------------------------------------------------------}
function SetupWin(hInstance : HINST; hPrevInstance : HINST) : Boolean; stdcall;
var
  msg : TMsg;
begin
  Done   :=FALSE;
  Result :=FALSE;


  Init;
  // Perform application initialization:
  if not CreateWnd(WIDTH, HEIGHT, FALSE) then Exit;


  // Main message loop:
  while not(Done) do
  begin
    if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then // Check if there is a message for this window
    begin
      if (msg.message = WM_QUIT) then     // If WM_QUIT message received then we are done
        Done := True
      else
      begin                               // Else translate and dispatch the message to this window
        TranslateMessage(msg);
        DispatchMessage(msg);
      end;
    end
    else
    begin
      Draw;
      Update;

      FrameTime := LastTime - GetTickCount;
      LastTime  := GetTickCount;

      inc(fps_count);
      if fps_time < GetTickCount then
       begin
         fps_time := gettickcount +500;
         fps:=fps_count*2;
         fps_count:=0;
       end;
    end;
  end;

  KillWnd();
  result  :=Done;
end;

begin
  if not SetupWin(hInstance, hPrevInst) then  Exit;
end.

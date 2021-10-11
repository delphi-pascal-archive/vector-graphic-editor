object Form3: TForm3
  Left = 432
  Top = 182
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 117
  ClientWidth = 228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Line Color :'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 57
    Height = 13
    Caption = 'Point Color :'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 50
    Height = 13
    Caption = 'Point Size:'
  end
  object CLine: TShape
    Left = 72
    Top = 8
    Width = 17
    Height = 17
    OnMouseDown = CLineMouseDown
  end
  object CPoint: TShape
    Left = 72
    Top = 32
    Width = 17
    Height = 17
    OnMouseDown = CPointMouseDown
  end
  object TrackBar1: TTrackBar
    Left = 72
    Top = 56
    Width = 150
    Height = 21
    Min = 1
    Position = 1
    TabOrder = 0
    ThumbLength = 10
    OnChange = TrackBar1Change
  end
  object Button1: TButton
    Left = 144
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
  object cd: TColorDialog
    Left = 8
    Top = 72
  end
end

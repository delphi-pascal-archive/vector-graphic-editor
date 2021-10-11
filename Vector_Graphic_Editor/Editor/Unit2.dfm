object Zoom: TZoom
  Left = 934
  Top = 338
  Width = 208
  Height = 234
  Caption = 'Zoom'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 200
    Height = 200
    Align = alClient
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 150
    Height = 137
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 8
      Top = 8
      Width = 133
      Height = 69
      Caption = ' Zoom factor '
      TabOrder = 0
      object Label1: TLabel
        Left = 12
        Top = 48
        Width = 14
        Height = 13
        Caption = '2 x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 44
        Top = 48
        Width = 14
        Height = 13
        Caption = '4 x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 76
        Top = 48
        Width = 14
        Height = 13
        Caption = '6 x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 105
        Top = 48
        Width = 14
        Height = 13
        Caption = '8 x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Slider: TTrackBar
        Left = 9
        Top = 16
        Width = 115
        Height = 33
        Max = 4
        Min = 1
        PageSize = 1
        Position = 1
        TabOrder = 0
      end
    end
    object cbSrediste: TCheckBox
      Left = 8
      Top = 84
      Width = 109
      Height = 21
      Caption = 'Show crosshair'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 25
    OnTimer = Timer1Timer
    Left = 88
    Top = 8
  end
end

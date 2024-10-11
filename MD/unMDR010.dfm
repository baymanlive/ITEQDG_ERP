inherited FrmMDR010: TFrmMDR010
  Caption = 'FrmMDR010'
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 45
    Top = 64
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  inherited ToolBar: TToolBar
    inherited btn_print: TToolButton
      OnClick = btn_printClick
    end
  end
  object Memo1: TMemo [3]
    Left = 45
    Top = 90
    Width = 250
    Height = 500
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = #26032#32048#26126#39636
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
end

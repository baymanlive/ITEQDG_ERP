inherited FrmMPST090_Export: TFrmMPST090_Export
  Left = 441
  Top = 318
  Width = 569
  Height = 282
  Caption = #23566#20986#25490#31243'Excel'#36039#26009
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 451
    Height = 251
  end
  object GroupBox1: TGroupBox [1]
    Left = 0
    Top = 0
    Width = 451
    Height = 251
    Align = alClient
    TabOrder = 1
    object chb_mpst090_dgccl: TCheckBox
      Left = 45
      Top = 40
      Width = 97
      Height = 13
      Caption = #26481#33694' CCL'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object chb_mpst090_dgpp: TCheckBox
      Left = 45
      Top = 77
      Width = 97
      Height = 13
      Caption = #26481#33694' PP'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object chb_mpst090_gzccl: TCheckBox
      Left = 45
      Top = 114
      Width = 97
      Height = 13
      Caption = #24291#24030' CCL'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chb_mpst090_gzpp: TCheckBox
      Left = 45
      Top = 152
      Width = 97
      Height = 13
      Caption = #24291#24030' PP'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object ProgressBar1: TProgressBar
      Left = 43
      Top = 189
      Width = 150
      Height = 17
      TabOrder = 4
    end
  end
end

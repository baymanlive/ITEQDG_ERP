inherited FrmMPST040_confirm: TFrmMPST040_confirm
  Top = 103
  Width = 500
  Height = 400
  Caption = #20986#36008#34920#30906#35469
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 374
    Height = 362
  end
  inherited PCL: TPageControl
    Width = 374
    Height = 362
    inherited TabSheet1: TTabSheet
      object lblindate: TLabel
        Left = 71
        Top = 96
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'lblindate'
      end
      object Label2: TLabel
        Left = 116
        Top = 128
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object Dtp1: TDateTimePicker
        Left = 115
        Top = 92
        Width = 100
        Height = 21
        Date = 42429.000000000000000000
        Time = 42429.000000000000000000
        TabOrder = 0
        OnChange = Dtp1Change
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25552#31034#20449#24687
      ImageIndex = 1
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 366
        Height = 334
        Align = alClient
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end

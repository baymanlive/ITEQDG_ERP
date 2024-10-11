inherited FrmMPST040_Indate: TFrmMPST040_Indate
  Width = 500
  Height = 400
  ActiveControl = Dtp1
  Caption = #26032#22686#20986#36008#34920
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 382
    Height = 373
  end
  inherited PCL: TPageControl
    Width = 382
    Height = 373
    inherited TabSheet1: TTabSheet
      object lblindate: TLabel
        Left = 88
        Top = 84
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'lblindate'
      end
      object Dtp1: TDateTimePicker
        Left = 132
        Top = 80
        Width = 100
        Height = 21
        Date = 42429.000000000000000000
        Time = 42429.000000000000000000
        TabOrder = 0
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

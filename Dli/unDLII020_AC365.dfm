inherited FrmDLII020_AC365: TFrmDLII020_AC365
  Left = 614
  Top = 312
  Width = 550
  Height = 365
  Caption = #26041#27491#20986#36008#36039#26009#19978#20659
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 432
    Height = 336
    inherited btn_ok: TBitBtn
      Top = 40
    end
    inherited btn_quit: TBitBtn
      Top = 70
    end
    object BitBtn1: TBitBtn
      Left = 10
      Top = 10
      Width = 90
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  inherited PCL: TPageControl
    Width = 432
    Height = 336
    inherited TabSheet1: TTabSheet
      object Label1: TLabel
        Tag = 1
        Left = 104
        Top = 30
        Width = 32
        Height = 13
        Caption = 'Label1'
      end
      object Memo1: TMemo
        Left = 104
        Top = 48
        Width = 200
        Height = 180
        ImeName = #23567#29436#27627
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 416
        Height = 298
        Align = alClient
        ImeName = #23567#29436#27627
        TabOrder = 0
      end
    end
  end
end

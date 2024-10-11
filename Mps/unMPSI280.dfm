inherited FrmMPSI280: TFrmMPSI280
  Caption = 'FrmMPSI280'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object Urate_lower: TLabel
          Left = 23
          Top = 13
          Width = 59
          Height = 13
          Alignment = taRightJustify
          Caption = 'Urate_lower'
        end
        object Urate_upper: TLabel
          Left = 23
          Top = 43
          Width = 59
          Height = 13
          Alignment = taRightJustify
          Caption = 'Urate_upper'
        end
        object DBEdit1: TDBEdit
          Left = 85
          Top = 10
          Width = 121
          Height = 21
          DataField = 'Urate_lower'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 85
          Top = 40
          Width = 121
          Height = 21
          DataField = 'Urate_upper'
          DataSource = DS
          TabOrder = 1
        end
        object Lock: TDBCheckBox
          Left = 85
          Top = 70
          Width = 97
          Height = 17
          Caption = 'Lock'
          DataField = 'Lock'
          DataSource = DS
          TabOrder = 2
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        Height = 412
        object Iuser: TLabel
          Left = 33
          Top = 13
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 187
          Top = 13
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 33
          Top = 43
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 187
          Top = 43
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object DBEdit21: TDBEdit
          Left = 85
          Top = 10
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit22: TDBEdit
          Left = 245
          Top = 10
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit23: TDBEdit
          Left = 85
          Top = 40
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit24: TDBEdit
          Left = 245
          Top = 40
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Mdate'
          DataSource = DS
          Enabled = False
          TabOrder = 3
        end
      end
    end
  end
end

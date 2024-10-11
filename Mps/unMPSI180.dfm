inherited FrmMPSI180: TFrmMPSI180
  Caption = 'FrmMPSI180'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object Custno: TLabel
          Left = 62
          Top = 68
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Caption = 'Custno'
          FocusControl = DBMemo1
        end
        object ad: TLabel
          Left = 85
          Top = 318
          Width = 11
          Height = 13
          Alignment = taRightJustify
          Caption = 'ad'
        end
        object GroupId: TLabel
          Left = 55
          Top = 38
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Caption = 'GroupId'
          FocusControl = DBEdit1
        end
        object MaxQty: TLabel
          Left = 56
          Top = 348
          Width = 40
          Height = 13
          Alignment = taRightJustify
          Caption = 'MaxQty'
        end
        object LockMonth: TLabel
          Tag = 1
          Left = 460
          Top = 44
          Width = 56
          Height = 13
          Caption = 'LockMonth'
          FocusControl = DBMemo2
        end
        object DBMemo1: TDBMemo
          Left = 100
          Top = 65
          Width = 300
          Height = 240
          DataField = 'Custno'
          DataSource = DS
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object DBEdit2: TDBEdit
          Left = 100
          Top = 315
          Width = 300
          Height = 21
          DataField = 'ad'
          DataSource = DS
          TabOrder = 3
        end
        object DBEdit1: TDBEdit
          Left = 100
          Top = 35
          Width = 121
          Height = 21
          DataField = 'GroupId'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit3: TDBEdit
          Left = 100
          Top = 345
          Width = 120
          Height = 21
          DataField = 'MaxQty'
          DataSource = DS
          TabOrder = 5
        end
        object isthin: TDBCheckBox
          Left = 334
          Top = 342
          Width = 65
          Height = 17
          Caption = 'isthin'
          DataField = 'isthin'
          DataSource = DS
          TabOrder = 4
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
        object DBMemo2: TDBMemo
          Left = 460
          Top = 65
          Width = 300
          Height = 240
          DataField = 'LockMonth'
          DataSource = DS
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        Height = 412
        object Iuser: TLabel
          Left = 38
          Top = 38
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 192
          Top = 38
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 38
          Top = 68
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 192
          Top = 68
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object DBEdit8: TDBEdit
          Left = 90
          Top = 35
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit9: TDBEdit
          Left = 250
          Top = 35
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit10: TDBEdit
          Left = 90
          Top = 65
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit11: TDBEdit
          Left = 250
          Top = 65
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

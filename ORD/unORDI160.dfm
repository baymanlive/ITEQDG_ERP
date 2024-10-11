inherited FrmORDI160: TFrmORDI160
  Left = 303
  Caption = 'FrmORDI160'
  ClientHeight = 547
  ClientWidth = 973
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 94
    Top = 231
    Width = 78
    Height = 13
    Caption = #23458#25142#29986#21697#25551#36848
  end
  inherited ToolBar: TToolBar
    Width = 973
  end
  inherited PnlBottom: TPanel
    Top = 517
    Width = 973
  end
  inherited Panel1: TPanel
    Width = 973
  end
  inherited PCL: TPageControl
    Width = 973
    Height = 473
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        Width = 965
        Height = 445
        object Bu: TLabel
          Left = 104
          Top = 9
          Width = 52
          Height = 13
          Caption = #29151#36939#20013#24515
        end
        object CustNo: TLabel
          Left = 104
          Top = 34
          Width = 52
          Height = 13
          Caption = #23458#25142#20195#34399
        end
        object CustDesc: TLabel
          Left = 11
          Top = 111
          Width = 78
          Height = 13
          Caption = #23458#25142#29986#21697#25551#36848
        end
        object ItemCodeA: TLabel
          Left = 99
          Top = 167
          Width = 52
          Height = 13
          Caption = #24288#20839#26009#34399
        end
        object ItemDescA: TLabel
          Left = 52
          Top = 191
          Width = 104
          Height = 13
          Caption = #24288#20839#23458#25142#21697#21517#35215#26684
        end
        object Lb_CustName: TLabel
          Left = 364
          Top = 45
          Width = 60
          Height = 13
          Caption = '                    '
        end
        object lbl_CustDemo: TLabel
          Left = 104
          Top = 71
          Width = 52
          Height = 13
          Caption = #23458#25142#31684#20363
        end
        object PP: TLabel
          Left = 182
          Top = 61
          Width = 14
          Height = 13
          Caption = 'PP'
        end
        object CCL: TLabel
          Left = 182
          Top = 85
          Width = 23
          Height = 13
          Caption = 'CCL'
        end
        object CustItemCode: TLabel
          Left = 79
          Top = 143
          Width = 78
          Height = 13
          Caption = #23458#25142#29986#21697#26009#34399
        end
        object DBEdit1: TDBEdit
          Left = 178
          Top = 6
          Width = 162
          Height = 21
          DataField = 'Bu'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 178
          Top = 32
          Width = 162
          Height = 21
          DataField = 'CustNo'
          DataSource = DS
          TabOrder = 1
          OnExit = DBEdit2Exit
        end
        object DBEdit3: TDBEdit
          Left = 91
          Top = 107
          Width = 616
          Height = 21
          Color = clYellow
          DataField = 'CustDesc'
          DataSource = DS
          TabOrder = 2
        end
        object DBEdit4: TDBEdit
          Left = 178
          Top = 165
          Width = 530
          Height = 21
          DataField = 'ItemCodeA'
          DataSource = DS
          TabOrder = 3
          OnExit = DBEdit4Exit
        end
        object DBEdit5: TDBEdit
          Left = 178
          Top = 190
          Width = 530
          Height = 21
          DataField = 'ItemDescA'
          DataSource = DS
          TabOrder = 4
        end
        object Edit3: TEdit
          Left = 209
          Top = 57
          Width = 498
          Height = 21
          Color = clLime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #26032#32048#26126#39636
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 5
        end
        object Edit4: TEdit
          Left = 209
          Top = 82
          Width = 498
          Height = 21
          Color = clLime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #26032#32048#26126#39636
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 6
        end
        object DBEdit8: TDBEdit
          Left = 179
          Top = 140
          Width = 530
          Height = 21
          DataField = 'CustItemCode'
          DataSource = DS
          TabOrder = 7
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 218
          Width = 965
          Height = 227
          Align = alBottom
          Caption = #20854#20182#20449#24687
          TabOrder = 8
          object tc_ocn16: TLabel
            Left = 13
            Top = 24
            Width = 43
            Height = 13
            Caption = 'tc_ocn16'
          end
          object tc_ocn19: TLabel
            Left = 13
            Top = 58
            Width = 43
            Height = 13
            Caption = 'tc_ocn19'
          end
          object tc_ocn09: TLabel
            Left = 13
            Top = 92
            Width = 43
            Height = 13
            Caption = 'tc_ocn09'
          end
          object tc_ocn10: TLabel
            Left = 13
            Top = 126
            Width = 43
            Height = 13
            Caption = 'tc_ocn10'
          end
          object tc_ocn08: TLabel
            Left = 184
            Top = 24
            Width = 43
            Height = 13
            Caption = 'tc_ocn08'
          end
          object tc_ocn04: TLabel
            Left = 184
            Top = 58
            Width = 43
            Height = 13
            Caption = 'tc_ocn04'
          end
          object tc_ocn05: TLabel
            Left = 184
            Top = 92
            Width = 43
            Height = 13
            Caption = 'tc_ocn05'
          end
          object tc_ocn11: TLabel
            Left = 184
            Top = 126
            Width = 43
            Height = 13
            Caption = 'tc_ocn11'
          end
          object tc_ocn20: TLabel
            Left = 348
            Top = 24
            Width = 43
            Height = 13
            Caption = 'tc_ocn20'
          end
          object tc_ocn21: TLabel
            Left = 348
            Top = 58
            Width = 43
            Height = 13
            Caption = 'tc_ocn21'
          end
          object ta_ocn01: TLabel
            Left = 348
            Top = 92
            Width = 43
            Height = 13
            Caption = 'ta_ocn01'
          end
          object ta_ocn02: TLabel
            Left = 348
            Top = 126
            Width = 43
            Height = 13
            Caption = 'ta_ocn02'
          end
          object tc_ocn14: TLabel
            Left = 13
            Top = 160
            Width = 43
            Height = 13
            Caption = 'tc_ocn14'
          end
          object tc_ocn06: TLabel
            Left = 505
            Top = 24
            Width = 43
            Height = 13
            Caption = 'tc_ocn06'
          end
          object tc_ocn07: TLabel
            Left = 505
            Top = 58
            Width = 43
            Height = 13
            Caption = 'tc_ocn07'
          end
          object tc_ocn18: TLabel
            Left = 13
            Top = 194
            Width = 43
            Height = 13
            Caption = 'tc_ocn18'
          end
          object DBEdit9: TDBEdit
            Left = 76
            Top = 20
            Width = 57
            Height = 21
            DataField = 'tc_ocn16'
            DataSource = DS
            TabOrder = 0
          end
          object DBEdit10: TDBEdit
            Left = 76
            Top = 54
            Width = 57
            Height = 21
            DataField = 'tc_ocn19'
            DataSource = DS
            TabOrder = 1
          end
          object DBEdit11: TDBEdit
            Left = 76
            Top = 88
            Width = 57
            Height = 21
            DataField = 'tc_ocn09'
            DataSource = DS
            TabOrder = 2
          end
          object DBEdit12: TDBEdit
            Left = 76
            Top = 122
            Width = 57
            Height = 21
            DataField = 'tc_ocn10'
            DataSource = DS
            TabOrder = 3
          end
          object DBEdit13: TDBEdit
            Left = 244
            Top = 20
            Width = 57
            Height = 21
            DataField = 'tc_ocn08'
            DataSource = DS
            TabOrder = 4
          end
          object DBEdit14: TDBEdit
            Left = 244
            Top = 54
            Width = 57
            Height = 21
            DataField = 'tc_ocn04'
            DataSource = DS
            TabOrder = 5
          end
          object DBEdit15: TDBEdit
            Left = 244
            Top = 88
            Width = 57
            Height = 21
            DataField = 'tc_ocn05'
            DataSource = DS
            TabOrder = 6
          end
          object DBEdit16: TDBEdit
            Left = 244
            Top = 122
            Width = 57
            Height = 21
            DataField = 'tc_ocn11'
            DataSource = DS
            TabOrder = 7
          end
          object DBEdit17: TDBEdit
            Left = 408
            Top = 20
            Width = 57
            Height = 21
            DataField = 'tc_ocn20'
            DataSource = DS
            TabOrder = 8
          end
          object DBEdit18: TDBEdit
            Left = 408
            Top = 54
            Width = 57
            Height = 21
            DataField = 'tc_ocn21'
            DataSource = DS
            TabOrder = 9
          end
          object DBEdit19: TDBEdit
            Left = 408
            Top = 88
            Width = 57
            Height = 21
            DataField = 'ta_ocn01'
            DataSource = DS
            TabOrder = 10
          end
          object DBEdit20: TDBEdit
            Left = 408
            Top = 122
            Width = 57
            Height = 21
            DataField = 'ta_ocn02'
            DataSource = DS
            TabOrder = 11
          end
          object DBEdit21: TDBEdit
            Left = 76
            Top = 159
            Width = 556
            Height = 21
            DataField = 'tc_ocn14'
            DataSource = DS
            TabOrder = 12
          end
          object DBEdit22: TDBEdit
            Left = 565
            Top = 20
            Width = 57
            Height = 21
            DataField = 'tc_ocn06'
            DataSource = DS
            TabOrder = 13
          end
          object DBEdit23: TDBEdit
            Left = 565
            Top = 54
            Width = 57
            Height = 21
            DataField = 'tc_ocn07'
            DataSource = DS
            TabOrder = 14
          end
          object DBEdit24: TDBEdit
            Left = 76
            Top = 193
            Width = 570
            Height = 21
            DataField = 'tc_ocn18'
            DataSource = DS
            TabOrder = 15
          end
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        Width = 729
        Height = 439
        object MuserA: TLabel
          Left = 52
          Top = 12
          Width = 52
          Height = 13
          Caption = #29151#36939#20013#24515
        end
        object MDateA: TLabel
          Left = 56
          Top = 48
          Width = 52
          Height = 13
          Caption = #29151#36939#20013#24515
        end
        object DBEdit6: TDBEdit
          Left = 120
          Top = 12
          Width = 133
          Height = 21
          DataField = 'MUserA'
          DataSource = DS
          ReadOnly = True
          TabOrder = 0
        end
        object DBEdit7: TDBEdit
          Left = 120
          Top = 47
          Width = 133
          Height = 21
          DataField = 'MDateA'
          DataSource = DS
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
  end
  inherited ImageList1: TImageList
    Left = 825
  end
end

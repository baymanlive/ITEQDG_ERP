inherited FrmORDI170: TFrmORDI170
  Left = 491
  Top = 175
  Caption = 'FrmORDI170'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    inherited btn_insert: TToolButton
      Enabled = False
      Visible = False
    end
    inherited btn_delete: TToolButton
      Enabled = False
      Visible = False
    end
    inherited btn_copy: TToolButton
      Enabled = False
      Visible = False
    end
    object ToolButton1: TToolButton
      Left = 594
      Top = 0
      Caption = #37325#26032#25291#36681
      ImageIndex = 26
      OnClick = ToolButton1Click
    end
  end
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object Bu: TLabel
          Left = 104
          Top = 40
          Width = 52
          Height = 13
          Caption = #29151#36939#20013#24515
        end
        object CustNo: TLabel
          Left = 104
          Top = 74
          Width = 52
          Height = 13
          Caption = #23458#25142#20195#34399
        end
        object CustDesc: TLabel
          Left = 75
          Top = 167
          Width = 78
          Height = 13
          Caption = #23458#25142#29986#21697#25551#36848
        end
        object ItemCodeB: TLabel
          Left = 104
          Top = 231
          Width = 52
          Height = 13
          Caption = #24288#20839#26009#34399
        end
        object ItemDescB: TLabel
          Left = 52
          Top = 266
          Width = 104
          Height = 13
          Caption = #24288#20839#23458#25142#21697#21517#35215#26684
        end
        object Lb_CustName: TLabel
          Left = 364
          Top = 76
          Width = 70
          Height = 13
          Caption = 'Lb_CustName'
        end
        object lbl_CustDemo: TLabel
          Left = 104
          Top = 108
          Width = 52
          Height = 13
          Caption = #23458#25142#31684#20363
        end
        object PP: TLabel
          Left = 192
          Top = 108
          Width = 14
          Height = 13
          Caption = 'PP'
        end
        object CCL: TLabel
          Left = 192
          Top = 132
          Width = 23
          Height = 13
          Caption = 'CCL'
        end
        object CustItemCode: TLabel
          Left = 79
          Top = 197
          Width = 78
          Height = 13
          Caption = #23458#25142#29986#21697#26009#34399
        end
        object DBEdit1: TDBEdit
          Left = 188
          Top = 39
          Width = 162
          Height = 21
          DataField = 'Bu'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 188
          Top = 74
          Width = 162
          Height = 21
          DataField = 'CustNo'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 194
          Top = 167
          Width = 645
          Height = 21
          Color = clLime
          DataField = 'CustDesc'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit4: TDBEdit
          Left = 194
          Top = 231
          Width = 651
          Height = 21
          DataField = 'ItemCodeB'
          DataSource = DS
          TabOrder = 3
        end
        object DBEdit5: TDBEdit
          Left = 194
          Top = 264
          Width = 655
          Height = 21
          DataField = 'ItemDescB'
          DataSource = DS
          TabOrder = 4
        end
        object Edit3: TEdit
          Left = 219
          Top = 104
          Width = 620
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
          Left = 219
          Top = 130
          Width = 620
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
          Left = 194
          Top = 199
          Width = 650
          Height = 21
          DataField = 'CustItemCode'
          DataSource = DS
          TabOrder = 7
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        object MuserB: TLabel
          Left = 63
          Top = 23
          Width = 52
          Height = 13
          Caption = #29151#36939#20013#24515
        end
        object MDateB: TLabel
          Left = 64
          Top = 56
          Width = 52
          Height = 13
          Caption = #29151#36939#20013#24515
        end
        object DBEdit7: TDBEdit
          Left = 131
          Top = 55
          Width = 133
          Height = 21
          DataField = 'MdateB'
          DataSource = DS
          Enabled = False
          ReadOnly = True
          TabOrder = 0
        end
        object DBEdit6: TDBEdit
          Left = 132
          Top = 20
          Width = 133
          Height = 21
          DataField = 'MuserB'
          DataSource = DS
          Enabled = False
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
  end
end

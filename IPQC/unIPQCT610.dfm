inherited FrmIPQCT610: TFrmIPQCT610
  Caption = 'FrmIPQCT610'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_conf: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_conf'
      ImageIndex = 60
      OnClick = btn_confClick
    end
  end
  inherited pnl: TPanel
    Left = 260
    Width = 703
    inherited Panel2: TPanel
      Width = 703
      Height = 215
      inherited pnltop: TPanel
        Width = 699
        Height = 211
        object ad: TLabel
          Left = 61
          Top = 13
          Width = 11
          Height = 13
          Alignment = taRightJustify
          Caption = 'ad'
        end
        object ver: TLabel
          Left = 252
          Top = 13
          Width = 15
          Height = 13
          Alignment = taRightJustify
          Caption = 'ver'
        end
        object ConfUser: TLabel
          Left = 25
          Top = 138
          Width = 47
          Height = 13
          Alignment = taRightJustify
          Caption = 'ConfUser'
        end
        object Confdate: TLabel
          Left = 224
          Top = 138
          Width = 43
          Height = 13
          Alignment = taRightJustify
          Caption = 'Confdate'
        end
        object iuser: TLabel
          Left = 49
          Top = 163
          Width = 23
          Height = 13
          Alignment = taRightJustify
          Caption = 'iuser'
        end
        object idate: TLabel
          Left = 245
          Top = 163
          Width = 22
          Height = 13
          Alignment = taRightJustify
          Caption = 'idate'
        end
        object muser: TLabel
          Left = 42
          Top = 188
          Width = 30
          Height = 13
          Alignment = taRightJustify
          Caption = 'muser'
        end
        object mdate: TLabel
          Left = 238
          Top = 188
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = 'mdate'
        end
        object imgConf: TImage
          Left = 594
          Top = 10
          Width = 32
          Height = 32
          AutoSize = True
          Picture.Data = {
            055449636F6E0000010001002020100000000000E80200001600000028000000
            2000000040000000010004000000000080020000000000000000000000000000
            0000000000000000000080000080000000808000800000008000800080800000
            80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
            FFFFFF0000000000000999999999000000000000000000009999999999999999
            0000000000000009999900000000099990000000000009999000000000000009
            9990000000009999000000000000000099990000000099000000000000000000
            0099000000099000000000000000000000099000009990000000000000000000
            0009990000990000000000009900000000009900099000000000000099999999
            9000099009900000009909909900999900000990990000000099999099009900
            0000009999000000009909909999999900000099990000000099099099009900
            0000009999000000009909909999999900000099990000000999099999009900
            0000009999000000009999999999999990000099990000000099000099009999
            0000009999000000009900990999900000000099990000000009900990990099
            0000009999000000000990099999999990000099099000000999999990990099
            0000099009900000000099000099900000000990009900000000000000000000
            0000990000999000000000000000000000099900000990000000000000000000
            0009900000009900000000000000000000990000000099990000000000000000
            9999000000000999900000000000000999900000000000099999000000000999
            9000000000000000999999999999999900000000000000000009999999990000
            00000000FFE00FFFFF0000FFFE0FF87FF87FFE1FF0FFFF0FF3FFFFCFE7FFFFE7
            C7FFFFE3CFFF3FF39FFF00799FC930F93FC133FC3FC900FC3FC933FC3FC900FC
            3F8833FC3FC0007C3FCF30FC3FCC87FC3FE64CFC3FE6007C9F804CF99FF3C7F9
            CFFFFFF3C7FFFFE3E7FFFFE7F3FFFFCFF0FFFF0FF87FFE1FFE0FF87FFF0000FF
            FFE00FFF}
          Visible = False
        end
        object sg1: TLabel
          Left = 55
          Top = 38
          Width = 17
          Height = 13
          Alignment = taRightJustify
          Caption = 'sg1'
        end
        object sg2: TLabel
          Left = 250
          Top = 38
          Width = 17
          Height = 13
          Alignment = taRightJustify
          Caption = 'sg2'
        end
        object sg3: TLabel
          Left = 440
          Top = 38
          Width = 17
          Height = 13
          Alignment = taRightJustify
          Caption = 'sg3'
        end
        object cz1: TLabel
          Left = 56
          Top = 63
          Width = 16
          Height = 13
          Alignment = taRightJustify
          Caption = 'cz1'
        end
        object cz2: TLabel
          Left = 251
          Top = 63
          Width = 16
          Height = 13
          Alignment = taRightJustify
          Caption = 'cz2'
        end
        object cz3: TLabel
          Left = 441
          Top = 63
          Width = 16
          Height = 13
          Alignment = taRightJustify
          Caption = 'cz3'
        end
        object Niandu: TLabel
          Left = 37
          Top = 88
          Width = 35
          Height = 13
          Alignment = taRightJustify
          Caption = 'Niandu'
        end
        object Xidu: TLabel
          Left = 243
          Top = 88
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = 'Xidu'
        end
        object CL: TLabel
          Left = 441
          Top = 88
          Width = 15
          Height = 13
          Alignment = taRightJustify
          Caption = 'CL'
        end
        object br: TLabel
          Left = 445
          Top = 113
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'br'
        end
        object remark: TLabel
          Left = 38
          Top = 113
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Caption = 'remark'
        end
        object DBEdit1: TDBEdit
          Left = 75
          Top = 10
          Width = 100
          Height = 21
          DataField = 'ad'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit5: TDBEdit
          Left = 270
          Top = 10
          Width = 290
          Height = 21
          DataField = 'ver'
          DataSource = DS
          TabOrder = 1
        end
        object DBEdit2: TDBEdit
          Left = 75
          Top = 135
          Width = 100
          Height = 21
          Color = clInfoBk
          DataField = 'ConfUser'
          DataSource = DS
          Enabled = False
          TabOrder = 13
        end
        object DBEdit3: TDBEdit
          Left = 270
          Top = 135
          Width = 290
          Height = 21
          Color = clInfoBk
          DataField = 'Confdate'
          DataSource = DS
          Enabled = False
          TabOrder = 14
        end
        object DBEdit7: TDBEdit
          Left = 75
          Top = 160
          Width = 100
          Height = 21
          Color = clInfoBk
          DataField = 'iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 15
        end
        object DBEdit8: TDBEdit
          Left = 270
          Top = 160
          Width = 290
          Height = 21
          Color = clInfoBk
          DataField = 'idate'
          DataSource = DS
          Enabled = False
          TabOrder = 16
        end
        object DBEdit9: TDBEdit
          Left = 75
          Top = 185
          Width = 100
          Height = 21
          Color = clInfoBk
          DataField = 'muser'
          DataSource = DS
          Enabled = False
          TabOrder = 17
        end
        object DBEdit10: TDBEdit
          Left = 270
          Top = 185
          Width = 290
          Height = 21
          Color = clInfoBk
          DataField = 'mdate'
          DataSource = DS
          Enabled = False
          TabOrder = 18
        end
        object DBEdit4: TDBEdit
          Left = 75
          Top = 35
          Width = 100
          Height = 21
          DataField = 'sg1'
          DataSource = DS
          TabOrder = 2
        end
        object DBEdit6: TDBEdit
          Left = 270
          Top = 35
          Width = 100
          Height = 21
          DataField = 'sg2'
          DataSource = DS
          TabOrder = 3
        end
        object DBEdit11: TDBEdit
          Left = 460
          Top = 35
          Width = 100
          Height = 21
          DataField = 'sg3'
          DataSource = DS
          TabOrder = 4
        end
        object DBEdit12: TDBEdit
          Left = 75
          Top = 60
          Width = 100
          Height = 21
          DataField = 'cz1'
          DataSource = DS
          TabOrder = 5
        end
        object DBEdit13: TDBEdit
          Left = 270
          Top = 60
          Width = 100
          Height = 21
          DataField = 'cz2'
          DataSource = DS
          TabOrder = 6
        end
        object DBEdit14: TDBEdit
          Left = 460
          Top = 60
          Width = 100
          Height = 21
          DataField = 'cz3'
          DataSource = DS
          TabOrder = 7
        end
        object DBEdit15: TDBEdit
          Left = 75
          Top = 85
          Width = 100
          Height = 21
          DataField = 'Niandu'
          DataSource = DS
          TabOrder = 8
        end
        object DBEdit16: TDBEdit
          Left = 270
          Top = 85
          Width = 100
          Height = 21
          DataField = 'Xidu'
          DataSource = DS
          TabOrder = 9
        end
        object DBEdit17: TDBEdit
          Left = 459
          Top = 85
          Width = 100
          Height = 21
          DataField = 'CL'
          DataSource = DS
          TabOrder = 10
        end
        object DBEdit18: TDBEdit
          Left = 458
          Top = 110
          Width = 100
          Height = 21
          DataField = 'br'
          DataSource = DS
          TabOrder = 12
        end
        object DBEdit19: TDBEdit
          Left = 75
          Top = 110
          Width = 295
          Height = 21
          DataField = 'remark'
          DataSource = DS
          TabOrder = 11
        end
      end
    end
    inherited DBGridEh2: TDBGridEh
      Top = 215
      Width = 703
      Height = 236
      Columns = <
        item
          Alignment = taCenter
          Color = clInfoBk
          DynProps = <>
          EditButtons = <>
          FieldName = 'sno'
          Footers = <>
          ReadOnly = True
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'item'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'listpno'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'kg'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'keep'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'diff'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'istext'
          Footers = <>
          Title.Alignment = taCenter
        end>
    end
  end
  inherited DBGridEh1: TDBGridEh
    Width = 260
    OnCellClick = DBGridEh1CellClick
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ad'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'ver'
        Footers = <>
      end
      item
        Alignment = taCenter
        DynProps = <>
        EditButtons = <>
        FieldName = 'conf'
        Footers = <>
      end>
  end
  inherited PopupMenu1: TPopupMenu
    object N2011: TMenuItem [1]
      Caption = #25554#20837
      OnClick = N2011Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 792
    Top = 16
  end
end

inherited FrmDLIT730: TFrmDLIT730
  Caption = 'FrmDLIT730'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    object btn_conf: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = #30906#35469
      ImageIndex = 60
      OnClick = btn_confClick
    end
  end
  inherited pnl: TPanel
    inherited Panel2: TPanel
      Height = 165
      inherited pnltop: TPanel
        Height = 161
        object cno: TLabel
          Left = 65
          Top = 43
          Width = 17
          Height = 13
          Alignment = taRightJustify
          Caption = 'cno'
          FocusControl = DBEdit1
        end
        object cdate: TLabel
          Left = 59
          Top = 13
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = 'cdate'
          FocusControl = DBEdit1
        end
        object imgConf: TImage
          Left = 458
          Top = 10
          Width = 32
          Height = 32
          AutoSize = True
          Picture.Data = {
            055449636F6E0000010001002020100000000000E80200001600000028000000
            2000000040000000010004000000000080020000000000000000000000000000
            0000000000000000000080000080000000808000800000008000800080800000
            C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
            FFFFFF0000000000000099999999000000000000000000000999999999999990
            0000000000000009999900000000999990000000000000999000000000000009
            9900000000000999000000000000000099900000000099000000000000000000
            0099000000099000000000000000000000099000009990000000000000000000
            0009990000990000000000000000000000009900099000000099000999000099
            0000099009900000099999900990099900000990099000000999009900999990
            0000099099000099009900099009900000000099990000099099000099009900
            0000009999000000999900000990999000000099990000009999999999999900
            0000009999000000099990990099900000000099990000000999000990099000
            0000009999000009999900009909990000000099990000000099990099999000
            0000009909900000009909999999000000000990099000000099000009999990
            0000099009900000009900000990000000000990009900000099000099900000
            0000990000999000000000000000000000099900000990000000000000000000
            0009900000009900000000000000000000990000000009990000000000000000
            9990000000000099900000000000000999000000000000099999000000009999
            9000000000000000099999999999999000000000000000000000999999990000
            00000000FFF00FFFFF8001FFFE0FF07FFC7FFE3FF8FFFF1FF3FFFFCFE7FFFFE7
            C7FFFFE3CFFFFFF39FCE3CF99F8198F99F8CC1F93CCE67FC3E4F33FC3F0F91FC
            3F0003FC3F84C7FC3F8E67FC3E0F23FC3FC307FC9FC80FF99FCF81F99FCF9FF9
            CFCF1FF3C7FFFFE3E7FFFFE7F3FFFFCFF8FFFF1FFC7FFE3FFE0FF07FFF8001FF
            FFF00FFF}
          Visible = False
        end
        object Remark: TLabel
          Left = 43
          Top = 73
          Width = 38
          Height = 13
          Alignment = taRightJustify
          Caption = 'Remark'
          FocusControl = DBEdit2
        end
        object Iuser: TLabel
          Left = 33
          Top = 103
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 242
          Top = 103
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 33
          Top = 133
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 242
          Top = 133
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object Custno: TLabel
          Left = 262
          Top = 13
          Width = 34
          Height = 13
          Alignment = taRightJustify
          Caption = 'Custno'
          FocusControl = DBEdit3
        end
        object Custshort: TLabel
          Left = 251
          Top = 43
          Width = 46
          Height = 13
          Alignment = taRightJustify
          Caption = 'Custshort'
          FocusControl = DBEdit8
        end
        object DBEdit1: TDBEdit
          Left = 85
          Top = 40
          Width = 120
          Height = 21
          DataField = 'cno'
          DataSource = DS
          TabOrder = 1
        end
        object DBDateTimeEditEh1: TDBDateTimeEditEh
          Left = 85
          Top = 10
          Width = 121
          Height = 21
          DataField = 'cdate'
          DataSource = DS
          DynProps = <>
          EditButtons = <>
          Kind = dtkDateEh
          ParentShowHint = False
          TabOrder = 0
          Visible = True
        end
        object DBEdit2: TDBEdit
          Left = 85
          Top = 70
          Width = 365
          Height = 21
          DataField = 'Remark'
          DataSource = DS
          TabOrder = 2
        end
        object DBEdit4: TDBEdit
          Left = 85
          Top = 100
          Width = 120
          Height = 21
          Hint = #24115#34399
          Color = clInfoBk
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 3
        end
        object DBEdit5: TDBEdit
          Left = 300
          Top = 100
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clInfoBk
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 7
        end
        object DBEdit6: TDBEdit
          Left = 85
          Top = 130
          Width = 120
          Height = 21
          Hint = #24115#34399
          Color = clInfoBk
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 4
        end
        object DBEdit7: TDBEdit
          Left = 300
          Top = 130
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clInfoBk
          DataField = 'Mdate'
          DataSource = DS
          Enabled = False
          TabOrder = 8
        end
        object DBEdit3: TDBEdit
          Left = 299
          Top = 10
          Width = 150
          Height = 21
          DataField = 'Custno'
          DataSource = DS
          TabOrder = 5
        end
        object DBEdit8: TDBEdit
          Left = 300
          Top = 40
          Width = 150
          Height = 21
          DataField = 'Custshort'
          DataSource = DS
          TabOrder = 6
        end
      end
    end
    inherited DBGridEh2: TDBGridEh
      Top = 165
      Height = 286
      OnEditButtonClick = DBGridEh2EditButtonClick
      Columns = <
        item
          ButtonStyle = cbsEllipsis
          DynProps = <>
          EditButtons = <>
          FieldName = 'lot'
          Footers = <>
        end
        item
          Color = clInfoBk
          DynProps = <>
          EditButtons = <>
          FieldName = 'place'
          Footers = <>
          ReadOnly = True
        end
        item
          Color = clInfoBk
          DynProps = <>
          EditButtons = <>
          FieldName = 'area'
          Footers = <>
          ReadOnly = True
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'remark'
          Footers = <>
        end>
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cdate'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'cno'
        Footers = <>
      end>
  end
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
  inherited CDS2: TClientDataSet
    AfterOpen = CDS2AfterOpen
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 756
    Top = 12
  end
end

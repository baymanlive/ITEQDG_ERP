inherited FrmSysI030: TFrmSysI030
  Caption = 'FrmSysI030'
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    ButtonWidth = 73
    object btn_copyright: TToolButton
      Left = 594
      Top = 0
      AutoSize = True
      Caption = 'btn_copyright'
      ImageIndex = 1
      OnClick = btn_copyrightClick
    end
  end
  inherited pnl: TPanel
    inherited Panel2: TPanel
      Height = 115
      object lblsys: TLabel [0]
        Tag = 1
        Left = 450
        Top = 40
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'lblsys'
      end
      inherited pnltop: TPanel
        Width = 423
        Height = 111
        Align = alLeft
        object userid: TLabel
          Left = 43
          Top = 13
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = 'userid'
        end
        object username: TLabel
          Left = 26
          Top = 38
          Width = 46
          Height = 13
          Alignment = taRightJustify
          Caption = 'username'
        end
        object password: TLabel
          Left = 26
          Top = 63
          Width = 46
          Height = 13
          Alignment = taRightJustify
          Caption = 'password'
        end
        object wk_no: TLabel
          Left = 39
          Top = 88
          Width = 33
          Height = 13
          Alignment = taRightJustify
          Caption = 'wk_no'
        end
        object depart: TLabel
          Left = 258
          Top = 14
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = 'depart'
        end
        object room: TLabel
          Left = 261
          Top = 38
          Width = 26
          Height = 13
          Alignment = taRightJustify
          Caption = 'room'
        end
        object title: TLabel
          Left = 270
          Top = 63
          Width = 17
          Height = 13
          Alignment = taRightJustify
          Caption = 'title'
        end
        object DBEdit1: TDBEdit
          Left = 75
          Top = 10
          Width = 121
          Height = 21
          DataField = 'userid'
          DataSource = DS
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 75
          Top = 35
          Width = 121
          Height = 21
          DataField = 'username'
          DataSource = DS
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 75
          Top = 60
          Width = 121
          Height = 21
          DataField = 'password'
          DataSource = DS
          PasswordChar = '*'
          TabOrder = 2
        end
        object DBEdit4: TDBEdit
          Left = 75
          Top = 85
          Width = 121
          Height = 21
          DataField = 'wk_no'
          DataSource = DS
          TabOrder = 3
        end
        object DBEdit5: TDBEdit
          Left = 290
          Top = 10
          Width = 121
          Height = 21
          DataField = 'depart'
          DataSource = DS
          TabOrder = 4
        end
        object DBEdit6: TDBEdit
          Left = 290
          Top = 35
          Width = 121
          Height = 21
          DataField = 'room'
          DataSource = DS
          TabOrder = 5
        end
        object DBEdit7: TDBEdit
          Left = 290
          Top = 60
          Width = 121
          Height = 21
          DataField = 'title'
          DataSource = DS
          TabOrder = 6
        end
        object not_use: TDBCheckBox
          Left = 290
          Top = 85
          Width = 97
          Height = 17
          Caption = 'not_use'
          DataField = 'not_use'
          DataSource = DS
          TabOrder = 7
          ValueChecked = 'True'
          ValueUnchecked = 'False'
        end
      end
      object cbb: TComboBox
        Left = 450
        Top = 60
        Width = 150
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbbChange
      end
    end
    inherited DBGridEh2: TDBGridEh
      Top = 115
      Height = 336
      Columns = <
        item
          Color = clInfoBk
          DynProps = <>
          EditButtons = <>
          FieldName = 'ProcId'
          Footers = <>
          ReadOnly = True
        end
        item
          Color = clInfoBk
          DynProps = <>
          EditButtons = <>
          FieldName = 'ProcName'
          Footers = <>
          ReadOnly = True
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_visible'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_new'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_edit'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_delete'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_copy'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_garbage'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_conf'
          Footers = <>
        end
        item
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_check'
          Footers = <>
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_query'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_print'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_export'
          Footers = <>
          Title.Alignment = taCenter
        end
        item
          Alignment = taCenter
          DynProps = <>
          EditButtons = <>
          FieldName = 'R_rptDesign'
          Footers = <>
          Title.Alignment = taCenter
        end>
    end
  end
  inherited DBGridEh1: TDBGridEh
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'userid'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'username'
        Footers = <>
      end>
  end
  inherited PopupMenu1: TPopupMenu
    object N1: TMenuItem
      Caption = '-'
    end
    object NX: TMenuItem
      Caption = #27402#38480
      object X201: TMenuItem
        Caption = #26597#35426#27402#38480
        OnClick = X201Click
      end
      object X202: TMenuItem
        Caption = #20840#37096#26597#35426
        OnClick = X202Click
      end
      object NX0: TMenuItem
        Caption = '-'
      end
      object X203: TMenuItem
        Caption = #27492#31558#36984#20013
        OnClick = X203Click
      end
      object X204: TMenuItem
        Caption = #27492#31558#21462#28040
        OnClick = X204Click
      end
      object NX1: TMenuItem
        Caption = '-'
      end
      object X205: TMenuItem
        Caption = #20840#37096#36984#20013
        OnClick = X205Click
      end
      object X206: TMenuItem
        Caption = #20840#37096#21462#28040
        OnClick = X206Click
      end
    end
  end
end

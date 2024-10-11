inherited FrmMPST110_Dtp: TFrmMPST110_Dtp
  Left = 406
  Top = 317
  Width = 1134
  Height = 619
  Caption = #23566#20986#37325#24037#21934
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 1016
    Top = 65
    Height = 527
    object btn_export_rpt: TBitBtn
      Left = 10
      Top = 71
      Width = 90
      Height = 25
      Caption = 'btn_export_rpt'
      TabOrder = 2
      OnClick = btn_export_rptClick
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 1126
    Height = 65
    Align = alTop
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 1124
      Height = 63
      Align = alClient
      TabOrder = 0
      object Indate: TLabel
        Left = 24
        Top = 28
        Width = 52
        Height = 13
        Caption = #20986#36008#26085#26399
      end
      object lCategory: TLabel
        Left = 256
        Top = 27
        Width = 52
        Height = 13
        Caption = #29289#26009#39006#21029
      end
      object dtp1: TDateTimePicker
        Left = 93
        Top = 23
        Width = 135
        Height = 21
        Date = 44519.398622118050000000
        Time = 44519.398622118050000000
        TabOrder = 0
      end
      object cmbCategory: TComboBox
        Left = 320
        Top = 23
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'ALL'
        OnSelect = cmbCategorySelect
        Items.Strings = (
          'ALL'
          'PP'
          'CCL')
      end
      object GroupBox3: TGroupBox
        Left = 494
        Top = 9
        Width = 339
        Height = 41
        TabOrder = 2
        object cbkE: TCheckBox
          Left = 16
          Top = 16
          Width = 50
          Height = 17
          Caption = 'E'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbkT: TCheckBox
          Left = 68
          Top = 16
          Width = 50
          Height = 17
          Caption = 'T'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object cbkB: TCheckBox
          Left = 121
          Top = 16
          Width = 50
          Height = 17
          Caption = 'B'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object cbkR: TCheckBox
          Left = 174
          Top = 16
          Width = 50
          Height = 17
          Caption = 'R'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object cbkN: TCheckBox
          Left = 227
          Top = 16
          Width = 50
          Height = 17
          Caption = 'N'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object cbkM: TCheckBox
          Left = 280
          Top = 16
          Width = 50
          Height = 17
          Caption = 'M'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
      end
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 65
    Width = 1016
    Height = 527
    Align = alClient
    TabOrder = 2
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 1014
      Height = 525
      Align = alClient
      Caption = #27880#65306#24050#23566#20986#30340#35352#37636#40664#35469#27161#35672#28858' Y'#65292#19981#20877#23566#20986
      TabOrder = 0
      object DBGridEh1: TDBGridEh
        Left = 2
        Top = 15
        Width = 1010
        Height = 508
        Align = alClient
        DataSource = DS
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 0
        OnDrawColumnCell = DBGridEh1DrawColumnCell
        Columns = <
          item
            Checkboxes = False
            DynProps = <>
            EditButtons = <>
            FieldName = 'export_flg'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custshort'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Stime'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Remark5'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'W_qty'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Notcount1'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'W_pno'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Remark4'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Remark'
            Footers = <>
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Custorderno'
            Footers = <>
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object DS: TDataSource
    Left = 512
    Top = 201
  end
end

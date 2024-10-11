inherited FrmMPST012_Stck: TFrmMPST012_Stck
  Left = 240
  Top = 285
  Width = 1319
  Height = 568
  Caption = 'FrmMPST012_Stck'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 1201
    Height = 537
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 1201
    Height = 537
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 1
      Top = 339
      Width = 1199
      Height = 5
      Cursor = crVSplit
      Align = alBottom
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 1199
      Height = 338
      Align = alClient
      TabOrder = 0
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 1197
        Height = 48
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 19
          Top = 14
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = #29289#20214#32232#34399#65306
        end
        object edit1: TEdit
          Left = 88
          Top = 10
          Width = 177
          Height = 21
          Hint = #29289#21697#26009#34399
          TabOrder = 0
        end
        object CheckBoxE: TCheckBox
          Left = 276
          Top = 11
          Width = 33
          Height = 17
          Caption = 'E'
          TabOrder = 1
        end
        object CheckBoxT: TCheckBox
          Left = 310
          Top = 11
          Width = 33
          Height = 17
          Caption = 'T'
          TabOrder = 2
        end
        object CheckBoxB: TCheckBox
          Left = 344
          Top = 11
          Width = 33
          Height = 17
          Caption = 'B'
          TabOrder = 3
        end
        object CheckBoxR: TCheckBox
          Left = 378
          Top = 11
          Width = 33
          Height = 17
          Caption = 'R'
          TabOrder = 4
        end
        object CheckBoxP: TCheckBox
          Left = 414
          Top = 11
          Width = 33
          Height = 17
          Caption = 'P'
          TabOrder = 5
        end
        object CheckBoxQ: TCheckBox
          Left = 450
          Top = 11
          Width = 33
          Height = 17
          Caption = 'Q'
          TabOrder = 6
        end
        object CheckBoxM: TCheckBox
          Left = 486
          Top = 11
          Width = 33
          Height = 17
          Caption = 'M'
          TabOrder = 7
        end
        object CheckBoxN: TCheckBox
          Left = 522
          Top = 11
          Width = 33
          Height = 17
          Caption = 'N'
          TabOrder = 8
        end
        object CheckBox1: TCheckBox
          Left = 560
          Top = 11
          Width = 33
          Height = 17
          Caption = '1'
          TabOrder = 9
        end
        object CheckBox2: TCheckBox
          Left = 624
          Top = 10
          Width = 97
          Height = 17
          Caption = #26222#36890#21407#26009#20489
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object CheckBox3: TCheckBox
          Left = 728
          Top = 10
          Width = 97
          Height = 17
          Caption = #29305#25505#20489
          TabOrder = 11
        end
        object btnStockQuery: TButton
          Left = 826
          Top = 6
          Width = 75
          Height = 25
          Caption = #26597#35426
          TabOrder = 12
          OnClick = btnStockQueryClick
        end
      end
      object Panel5: TPanel
        Left = 1
        Top = 49
        Width = 1197
        Height = 288
        Align = alClient
        TabOrder = 1
        object GroupBox1: TGroupBox
          Left = 1
          Top = 1
          Width = 1195
          Height = 286
          Align = alClient
          TabOrder = 0
          object DBGridEh1: TDBGridEh
            Left = 2
            Top = 15
            Width = 1191
            Height = 269
            Align = alClient
            DataSource = DS
            DynProps = <>
            GridLineParams.DataVertLines = True
            GridLineParams.VertEmptySpaceStyle = dessNonEh
            IndicatorOptions = [gioShowRowIndicatorEh]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
            ReadOnly = True
            TabOrder = 0
            OnCellClick = DBGridEh1CellClick
            OnDrawColumnCell = DBGridEh1DrawColumnCell
            Columns = <
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'select'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'dbtype'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'img01'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'img02'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'img03'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'img04'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'img10'
                Footers = <>
              end
              item
                DynProps = <>
                EditButtons = <>
                FieldName = 'ta_img03'
                Footers = <>
              end>
            object RowDetailData: TRowDetailPanelControlEh
            end
          end
        end
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 344
      Width = 1199
      Height = 192
      Align = alBottom
      TabOrder = 1
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 1093
        Height = 190
        Align = alClient
        TabOrder = 0
        object DBGridEh2: TDBGridEh
          Left = 2
          Top = 15
          Width = 1089
          Height = 173
          Align = alClient
          DataSource = DS1
          DynProps = <>
          GridLineParams.VertEmptySpaceStyle = dessNonEh
          IndicatorOptions = [gioShowRowIndicatorEh]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghColumnResize, dghColumnMove]
          TabOrder = 0
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'gid'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'uuid'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'orderno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'orderitem'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'materialno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custom'
              Footers = <>
            end
            item
              Color = clYellow
              DynProps = <>
              EditButtons = <>
              FieldName = 'orderQty'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sQty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'dbtype'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'wareHouseNo'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'materialno1'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'storageNo'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'batchNo'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'stockQty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'isActive'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'orderBu'
              Footers = <>
              Visible = False
            end
            item
              Color = clYellow
              DynProps = <>
              EditButtons = <>
              FieldName = 'rStockQty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custno1'
              Footers = <>
              Visible = False
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'custom1'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
      object Panel6: TPanel
        Left = 1094
        Top = 1
        Width = 104
        Height = 190
        Align = alRight
        TabOrder = 1
        object btnImport: TButton
          Left = 5
          Top = 12
          Width = 95
          Height = 25
          Caption = #23566#20837#21246#36984
          TabOrder = 0
          OnClick = btnImportClick
        end
        object btnRemove: TButton
          Left = 5
          Top = 43
          Width = 95
          Height = 25
          Caption = #31227#38500#35352#37636
          TabOrder = 1
          OnClick = btnRemoveClick
        end
      end
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 435
    Top = 163
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 403
    Top = 163
  end
  object CDS1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 442
    Top = 489
  end
  object DS1: TDataSource
    DataSet = CDS1
    Left = 490
    Top = 489
  end
end

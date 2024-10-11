inherited FrmDLII020_selectsaleno: TFrmDLII020_selectsaleno
  Left = 803
  Top = 344
  Width = 840
  Height = 500
  Caption = #21517#24184#20986#36008#26126#32048
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 714
    Height = 462
  end
  inherited PCL: TPageControl
    Width = 714
    Height = 462
    inherited TabSheet1: TTabSheet
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 706
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 2
          Top = 18
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = #20986#36008#26085#26399#65306
        end
        object Label2: TLabel
          Tag = 1
          Left = 165
          Top = 18
          Width = 13
          Height = 13
          Alignment = taRightJustify
          Caption = #33267
        end
        object Label3: TLabel
          Left = 396
          Top = 18
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = 'No/'#20986#36008#21934#65306
        end
        object BitBtn1: TBitBtn
          Left = 272
          Top = 13
          Width = 75
          Height = 25
          Caption = #26597#35426#20986#36008#21934
          TabOrder = 2
          OnClick = BitBtn1Click
        end
        object dtp1: TDateTimePicker
          Left = 70
          Top = 15
          Width = 90
          Height = 21
          Date = 43286.000000000000000000
          Time = 43286.000000000000000000
          TabOrder = 0
        end
        object dtp2: TDateTimePicker
          Left = 182
          Top = 15
          Width = 90
          Height = 21
          Date = 43286.000000000000000000
          Time = 43286.000000000000000000
          TabOrder = 1
        end
        object Edit1: TEdit
          Left = 466
          Top = 15
          Width = 110
          Height = 21
          TabOrder = 3
        end
        object BitBtn2: TBitBtn
          Left = 576
          Top = 13
          Width = 85
          Height = 25
          Caption = #26597#35426#21015#21360#35352#37636
          TabOrder = 4
          OnClick = BitBtn2Click
        end
        object BitBtn3: TBitBtn
          Left = 662
          Top = 13
          Width = 40
          Height = 25
          Caption = #20316#24290
          TabOrder = 5
          OnClick = BitBtn3Click
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 50
        Width = 706
        Height = 384
        Align = alClient
        TabOrder = 1
        object DBGridEh1: TDBGridEh
          Left = 1
          Top = 1
          Width = 574
          Height = 382
          Align = alClient
          DataSource = DataSource1
          DynProps = <>
          FooterParams.Color = clWindow
          GridLineParams.VertEmptySpaceStyle = dessNonEh
          IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
          ReadOnly = True
          TabOrder = 0
          OnDblClick = DBGridEh1DblClick
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oga01'
              Footers = <>
              ReadOnly = False
              Width = 100
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oga02'
              Footers = <>
              Width = 70
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'ptype'
              Footers = <>
              Width = 60
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'ogapost'
              Footers = <>
              ReadOnly = False
              Width = 60
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'ogaprsw'
              Footers = <>
              Width = 60
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'scan'
              Footers = <>
              Width = 60
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'out'
              Footers = <>
              Width = 60
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
        object Memo1: TMemo
          Left = 575
          Top = 1
          Width = 130
          Height = 382
          Align = alRight
          TabOrder = 1
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #32317#21934#34399
      ImageIndex = 1
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 706
        Height = 434
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = CDS
    Left = 332
    Top = 395
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 395
  end
end

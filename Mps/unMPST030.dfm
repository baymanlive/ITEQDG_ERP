inherited FrmMPST030: TFrmMPST030
  Left = 623
  Top = 81
  Caption = 'FrmMPST030'
  ClientHeight = 547
  ClientWidth = 1126
  PixelsPerInch = 96
  TextHeight = 13
  inherited ToolBar: TToolBar
    Width = 1126
  end
  inherited PnlBottom: TPanel
    Top = 517
    Width = 1126
  end
  inherited Panel1: TPanel
    Width = 1126
  end
  inherited pnl: TPanel
    Width = 996
    Height = 473
    inherited PCL2: TPageControl
      Top = 273
      Width = 996
      inherited TabSheet2: TTabSheet
        Caption = #25286#20998#36948#20132#26085#26399
        inherited DBGridEh2: TDBGridEh
          Width = 988
          OnCellClick = DBGridEh2CellClick
          Columns = <
            item
              Alignment = taCenter
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'ditem'
              Footers = <>
              ReadOnly = True
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Materialno'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Adate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'cdate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Qty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark1'
              Footers = <>
              PickList.Strings = (
                #33258#35069
                'DG'#24235
                'GZ'#24235
                #22806#36092#28961#37675
                #22806#36092#21488#28771
                #22806#36092#30408#39498
                #26376#35336#21010)
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'Remark2'
              Footers = <>
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'GarbageFlag'
              Footers = <>
              ReadOnly = True
            end
            item
              Color = clInfoBk
              DynProps = <>
              EditButtons = <>
              FieldName = 'Flag'
              Footers = <>
              ReadOnly = True
            end>
        end
      end
      object TabSheet3: TTabSheet
        Caption = #25490#31243#36039#26009
        ImageIndex = 1
        object DBGridEh3: TDBGridEh
          Left = 0
          Top = 0
          Width = 825
          Height = 172
          Align = alClient
          DataSource = DS3
          DynProps = <>
          FooterParams.Color = clWindow
          GridLineParams.VertEmptySpaceStyle = dessNonEh
          IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
          ReadOnly = True
          TabOrder = 0
          OnColWidthsChanged = DBGridEh3ColWidthsChanged
          OnMouseDown = DBGridEh3MouseDown
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sdate'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'wono'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'machine'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'sqty'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'currentBoiler'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'adate_new'
              Footers = <>
            end
            item
              DisplayFormat = 'YYYY-M-D HH:NN'
              DynProps = <>
              EditButtons = <>
              FieldName = 'cx_date'
              Footers = <>
            end>
          object RowDetailData: TRowDetailPanelControlEh
          end
        end
      end
    end
    inherited PCL: TPageControl
      Width = 996
      Height = 273
      inherited TabSheet1: TTabSheet
        Caption = #35330#21934#36039#26009
        inherited DBGridEh1: TDBGridEh
          Width = 988
          Height = 245
          OnGetCellParams = DBGridEh1GetCellParams
          OnTitleClick = DBGridEh1TitleClick
          Columns = <
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oea02'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oea01'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb03'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oea04'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'occ02'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb04'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb06'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ima021'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ta_oeb01'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'ta_oeb02'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oao06'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb15'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb05'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb12'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb24'
              Footers = <>
            end
            item
              DynProps = <>
              EditButtons = <>
              FieldName = 'qty'
              Footers = <>
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeaconf'
              Footers = <>
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'oeb70'
              Footers = <>
            end
            item
              Alignment = taCenter
              DynProps = <>
              EditButtons = <>
              FieldName = 'spflag'
              Footers = <>
            end>
        end
      end
    end
  end
  object PnlRight: TPanel [4]
    Left = 996
    Top = 44
    Width = 130
    Height = 473
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object btn_mpst030A: TBitBtn
      Tag = 2
      Left = 5
      Top = 10
      Width = 120
      Height = 25
      Caption = #20841#35282#35330#21934#25286#20998
      TabOrder = 0
      OnClick = btn_mpst030AClick
      NumGlyphs = 2
    end
    object btn_mpst030E: TBitBtn
      Tag = 2
      Left = 5
      Top = 40
      Width = 120
      Height = 25
      Caption = #26356#26032#21934#31558#20841#35282#35330#21934
      TabOrder = 1
      OnClick = btn_mpst030EClick
      NumGlyphs = 2
    end
    object btn_mpst030F: TBitBtn
      Tag = 2
      Left = 5
      Top = 70
      Width = 120
      Height = 25
      Caption = #26356#26032#25972#21934#20841#35282#35330#21934
      TabOrder = 2
      OnClick = btn_mpst030FClick
      NumGlyphs = 2
    end
    object btn_mpst030B: TBitBtn
      Tag = 2
      Left = 5
      Top = 100
      Width = 120
      Height = 25
      Caption = #25490#31243#25286#20998
      TabOrder = 3
      OnClick = btn_mpst030BClick
      NumGlyphs = 2
    end
    object btn_mpst030G: TBitBtn
      Tag = 2
      Left = 5
      Top = 130
      Width = 120
      Height = 25
      Caption = #22823#35330#21934#25286#20998
      TabOrder = 4
      OnClick = btn_mpst030GClick
      NumGlyphs = 2
    end
    object btn_mpst030C: TBitBtn
      Tag = 2
      Left = 5
      Top = 162
      Width = 120
      Height = 25
      Caption = #26410#25286#20998#26126#32048
      TabOrder = 5
      OnClick = btn_mpst030CClick
      NumGlyphs = 2
    end
    object btn_mpst030D: TBitBtn
      Tag = 3
      Left = 5
      Top = 192
      Width = 120
      Height = 25
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 6
      OnClick = btn_mpst030DClick
      NumGlyphs = 2
    end
    object btn_mpst030H: TBitBtn
      Tag = 2
      Left = 5
      Top = 222
      Width = 120
      Height = 25
      Caption = #36031#26131#31649#29702#25286#20998
      TabOrder = 7
      OnClick = btn_mpst030BClick
      NumGlyphs = 2
    end
  end
  inherited PopupMenu1: TPopupMenu
    object N280: TMenuItem [2]
      Caption = #20840#37096#21034#38500
      OnClick = N280Click
    end
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 693
    Top = 373
  end
  object DS3: TDataSource
    DataSet = CDS3
    Left = 722
    Top = 373
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 680
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 716
    Top = 16
  end
end

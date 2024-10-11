inherited FrmQuery: TFrmQuery
  Left = 196
  Top = 126
  Width = 650
  Height = 400
  Hint = '  '
  Caption = 'Query'
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar [0]
    Left = 0
    Top = 0
    Width = 634
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 70
    Flat = True
    Images = ImageList1
    ShowCaptions = True
    TabOrder = 0
    Wrapable = False
    object btn_insert: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Caption = 'btn_insert'
      ImageIndex = 4
      OnClick = btn_insertClick
    end
    object btn_edit: TToolButton
      Left = 58
      Top = 0
      AutoSize = True
      Caption = 'btn_edit'
      ImageIndex = 5
      OnClick = btn_editClick
    end
    object btn_delete: TToolButton
      Left = 107
      Top = 0
      AutoSize = True
      Caption = 'btn_delete'
      ImageIndex = 6
      OnClick = btn_deleteClick
    end
    object ToolButton3: TToolButton
      Left = 166
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 20
      Style = tbsSeparator
    end
    object btn_postobj: TToolButton
      Left = 174
      Top = 0
      Caption = 'btn_postobj'
      ImageIndex = 34
      OnClick = btn_postobjClick
    end
    object btn_deleteobj: TToolButton
      Left = 244
      Top = 0
      Caption = 'btn_deleteobj'
      Enabled = False
      ImageIndex = 35
      OnClick = btn_deleteobjClick
    end
  end
  object PCL: TPageControl [1]
    Left = 0
    Top = 42
    Width = 634
    Height = 301
    Hint = '  '
    ActivePage = queryObj
    Align = alClient
    TabOrder = 1
    object queryObj: TTabSheet
      Caption = 'queryObj'
      object DBGridEh1: TDBGridEh
        Left = 90
        Top = 0
        Width = 445
        Height = 273
        Align = alClient
        BorderStyle = bsNone
        DataSource = DS
        DynProps = <>
        FooterParams.Color = clWindow
        GridLineParams.VertEmptySpaceStyle = dessNonEh
        IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
        TabOrder = 1
        VertScrollBar.VisibleMode = sbNeverShowEh
        OnEditButtonClick = DBGridEh1EditButtonClick
        Columns = <
          item
            DynProps = <>
            DropDownRows = 14
            EditButtons = <>
            FieldName = 'Caption'
            Footers = <>
            Width = 180
          end
          item
            DynProps = <>
            DropDownRows = 14
            EditButtons = <>
            FieldName = 'Expr'
            Footers = <>
            Width = 70
          end
          item
            ButtonStyle = cbsDropDown
            DynProps = <>
            EditButtons = <>
            FieldName = 'Value'
            Footers = <>
            Width = 100
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Fieldname'
            Footers = <>
            Width = 80
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Expr1'
            Footers = <>
            Width = 80
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Typename'
            Footers = <>
            Width = 81
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object LB: TListBox
        Left = 0
        Top = 0
        Width = 90
        Height = 273
        Align = alLeft
        BevelInner = bvNone
        BevelOuter = bvNone
        ItemHeight = 13
        TabOrder = 0
        OnClick = LBClick
      end
      object PnlRight: TPanel
        Left = 535
        Top = 0
        Width = 91
        Height = 273
        Hint = '  '
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object btn_ok: TBitBtn
          Left = 10
          Top = 10
          Width = 70
          Height = 25
          Caption = 'btn_ok'
          TabOrder = 0
          OnClick = btn_okClick
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333330000333333333333333333333333F33333333333
            00003333344333333333333333388F3333333333000033334224333333333333
            338338F3333333330000333422224333333333333833338F3333333300003342
            222224333333333383333338F3333333000034222A22224333333338F338F333
            8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
            33333338F83338F338F33333000033A33333A222433333338333338F338F3333
            0000333333333A222433333333333338F338F33300003333333333A222433333
            333333338F338F33000033333333333A222433333333333338F338F300003333
            33333333A222433333333333338F338F00003333333333333A22433333333333
            3338F38F000033333333333333A223333333333333338F830000333333333333
            333A333333333333333338330000333333333333333333333333333333333333
            0000}
          NumGlyphs = 2
        end
        object btn_quit: TBitBtn
          Left = 10
          Top = 40
          Width = 70
          Height = 25
          Caption = 'btn_quit'
          TabOrder = 1
          OnClick = btn_quitClick
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            333333333333333333333333000033338833333333333333333F333333333333
            0000333911833333983333333388F333333F3333000033391118333911833333
            38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
            911118111118333338F3338F833338F3000033333911111111833333338F3338
            3333F8330000333333911111183333333338F333333F83330000333333311111
            8333333333338F3333383333000033333339111183333333333338F333833333
            00003333339111118333333333333833338F3333000033333911181118333333
            33338333338F333300003333911183911183333333383338F338F33300003333
            9118333911183333338F33838F338F33000033333913333391113333338FF833
            38F338F300003333333333333919333333388333338FFF830000333333333333
            3333333333333333333888330000333333333333333333333333333333333333
            0000}
          NumGlyphs = 2
        end
      end
    end
  end
  object MonthCalendar1: TMonthCalendar [2]
    Left = 184
    Top = 137
    Width = 197
    Height = 153
    AutoSize = True
    Date = 42374.585724490740000000
    TabOrder = 2
    Visible = False
    OnClick = MonthCalendar1Click
  end
  object Panel1: TPanel [3]
    Left = 0
    Top = 38
    Width = 634
    Height = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
  end
  object StatusBar1: TStatusBar [4]
    Left = 0
    Top = 343
    Width = 634
    Height = 19
    Panels = <
      item
        Width = 240
      end
      item
        Width = 50
      end>
  end
  inherited ImageList1: TImageList
    Left = 57
    Top = 273
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 114
    Top = 273
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterInsert = CDSAfterInsert
    AfterEdit = CDSAfterEdit
    BeforePost = CDSBeforePost
    AfterPost = CDSAfterPost
    AfterCancel = CDSAfterCancel
    AfterScroll = CDSAfterScroll
    OnNewRecord = CDSNewRecord
    Left = 85
    Top = 273
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 143
    Top = 273
  end
end

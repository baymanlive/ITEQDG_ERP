inherited FrmMPST040_IndateOrd: TFrmMPST040_IndateOrd
  Left = 396
  Top = 279
  Width = 900
  Height = 520
  Caption = #26032#22686#20986#36008#34920
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 782
    Height = 493
    inherited btn_ok: TBitBtn
      Left = 5
      Width = 100
    end
    inherited btn_quit: TBitBtn
      Left = 5
      Width = 100
    end
    object btn1: TBitBtn
      Left = 5
      Top = 70
      Width = 100
      Height = 25
      Hint = #35336#31639#24235#23384
      Caption = #24235#23384#33287#26410#20132#29376#27841
      TabOrder = 2
      OnClick = btn1Click
      NumGlyphs = 2
    end
  end
  inherited PCL: TPageControl
    Width = 782
    Height = 493
    inherited TabSheet1: TTabSheet
      object ProgressBar1: TProgressBar
        Left = 196
        Top = 176
        Width = 150
        Height = 17
        TabOrder = 1
        Visible = False
      end
      object Lv1: TListView
        Left = 0
        Top = 40
        Width = 774
        Height = 425
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Checkboxes = True
        Columns = <>
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawSubItem = Lv1CustomDrawSubItem
        OnSelectItem = Lv1SelectItem
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 774
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object lblindate: TLabel
          Left = 40
          Top = 13
          Width = 40
          Height = 13
          Alignment = taRightJustify
          Caption = 'lblindate'
        end
        object lblorderno: TLabel
          Left = 271
          Top = 13
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = 'lblorderno'
        end
        object Label1: TLabel
          Left = 512
          Top = 13
          Width = 78
          Height = 13
          Alignment = taRightJustify
          Caption = #26356#25913#20986#36008#25976#37327
        end
        object Dtp1: TDateTimePicker
          Left = 84
          Top = 10
          Width = 100
          Height = 21
          Date = 42429.000000000000000000
          Time = 42429.000000000000000000
          TabOrder = 0
        end
        object Edit1: TEdit
          Left = 324
          Top = 10
          Width = 100
          Height = 21
          TabOrder = 1
          Text = 'Edit1'
        end
        object btn_query: TBitBtn
          Left = 428
          Top = 7
          Width = 55
          Height = 25
          Caption = #26597#35426
          TabOrder = 2
          OnClick = btn_queryClick
        end
        object Edit2: TEdit
          Left = 595
          Top = 10
          Width = 50
          Height = 21
          TabOrder = 3
          OnChange = Edit2Change
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25552#31034#20449#24687
      ImageIndex = 1
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 766
        Height = 454
        Align = alClient
        TabOrder = 0
      end
    end
  end
end

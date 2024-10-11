inherited FrmDLII430_planlist: TFrmDLII430_planlist
  Width = 947
  Height = 565
  Caption = #20986#36554#35336#21123#23458#25142#36984#25799
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 821
    Height = 526
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 821
    Height = 526
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Lv1: TListView
      Left = 120
      Top = 40
      Width = 701
      Height = 486
      Hint = #23458#25142
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
      OnDblClick = Lv1DblClick
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 821
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 102
        Top = 14
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Label1'
      end
      object btn_query: TBitBtn
        Left = 240
        Top = 7
        Width = 40
        Height = 25
        Caption = #26597#35426
        TabOrder = 0
        OnClick = btn_queryClick
      end
      object Dtp: TDateTimePicker
        Left = 140
        Top = 10
        Width = 100
        Height = 21
        Date = 42755.000000000000000000
        Time = 42755.000000000000000000
        TabOrder = 1
      end
      object Edit1: TEdit
        Left = 456
        Top = 10
        Width = 73
        Height = 21
        TabOrder = 2
        Text = '0'
        Visible = False
        OnChange = Edit1Change
        OnExit = Edit1Exit
      end
    end
    object LB: TListBox
      Left = 0
      Top = 40
      Width = 120
      Height = 486
      Hint = #36335#32218
      Align = alLeft
      BevelInner = bvNone
      BevelOuter = bvNone
      ItemHeight = 13
      TabOrder = 2
      OnClick = LBClick
    end
  end
end

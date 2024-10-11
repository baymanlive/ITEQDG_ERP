inherited FrmDLII570: TFrmDLII570
  Caption = 'FrmDLII570'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object PPColor: TLabel
          Left = 20
          Top = 33
          Width = 41
          Height = 13
          Caption = 'PPColor'
        end
        object CCLColor: TLabel
          Left = 196
          Top = 34
          Width = 50
          Height = 13
          Caption = 'CCLColor'
        end
        object PPDirection: TLabel
          Left = 404
          Top = 34
          Width = 58
          Height = 13
          Caption = 'PPDirection'
        end
        object CCLDirection: TLabel
          Left = 580
          Top = 34
          Width = 67
          Height = 13
          Caption = 'CCLDirection'
        end
        object PPDirectionPnl: TLabel
          Left = 404
          Top = 214
          Width = 74
          Height = 13
          Caption = 'PPDirectionPnl'
        end
        object DBMemo1: TDBMemo
          Left = 20
          Top = 50
          Width = 160
          Height = 330
          DataField = 'PPColor'
          DataSource = DS
          TabOrder = 0
        end
        object DBMemo2: TDBMemo
          Left = 196
          Top = 50
          Width = 160
          Height = 330
          DataField = 'CCLColor'
          DataSource = DS
          TabOrder = 1
        end
        object DBMemo3: TDBMemo
          Left = 404
          Top = 50
          Width = 160
          Height = 150
          DataField = 'PPDirection'
          DataSource = DS
          TabOrder = 2
        end
        object DBMemo4: TDBMemo
          Left = 580
          Top = 50
          Width = 160
          Height = 330
          DataField = 'CCLDirection'
          DataSource = DS
          TabOrder = 4
        end
        object DBMemo5: TDBMemo
          Left = 404
          Top = 230
          Width = 160
          Height = 150
          DataField = 'PPDirectionPnl'
          DataSource = DS
          TabOrder = 3
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        Height = 412
        object Iuser: TLabel
          Left = 33
          Top = 13
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 187
          Top = 13
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 33
          Top = 43
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 187
          Top = 43
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object DBEdit21: TDBEdit
          Left = 85
          Top = 10
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit22: TDBEdit
          Left = 245
          Top = 10
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit23: TDBEdit
          Left = 85
          Top = 40
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit24: TDBEdit
          Left = 245
          Top = 40
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Mdate'
          DataSource = DS
          Enabled = False
          TabOrder = 3
        end
      end
    end
  end
end

inherited FrmMPSI290: TFrmMPSI290
  Caption = 'FrmMPSI290'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PCL: TPageControl
    inherited TabSheet1: TTabSheet
      inherited Pnl1: TPanel
        object Custno: TLabel
          Left = 61
          Top = 35
          Width = 29
          Height = 13
          Caption = #23458#25142':'
        end
        object Stime: TLabel
          Tag = 1
          Left = 330
          Top = 35
          Width = 55
          Height = 13
          Caption = #20999#36008#26178#38291':'
          Transparent = True
        end
        object DBDateTimeEditEh1: TDBDateTimeEditEh
          Left = 330
          Top = 55
          Width = 78
          Height = 21
          DataField = 'Stime'
          DataSource = DS
          DynProps = <>
          EditButton.Visible = False
          EditButtons = <>
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Visible = True
          EditFormat = 'HH:NN'
        end
        object Memo1: TMemo
          Left = 60
          Top = 55
          Width = 180
          Height = 300
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    inherited TabSheet2: TTabSheet
      inherited Pnl2: TPanel
        Height = 412
        object Iuser: TLabel
          Left = 38
          Top = 38
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #26032#22686'user:'
        end
        object Idate: TLabel
          Left = 192
          Top = 38
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #24314#27284#26085#26399':'
        end
        object Muser: TLabel
          Left = 38
          Top = 68
          Width = 49
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913'user:'
        end
        object Mdate: TLabel
          Left = 192
          Top = 68
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #20462#25913#26085#26399':'
        end
        object DBEdit8: TDBEdit
          Left = 90
          Top = 35
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Iuser'
          DataSource = DS
          Enabled = False
          TabOrder = 0
        end
        object DBEdit9: TDBEdit
          Left = 250
          Top = 35
          Width = 150
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Idate'
          DataSource = DS
          Enabled = False
          TabOrder = 1
        end
        object DBEdit10: TDBEdit
          Left = 90
          Top = 65
          Width = 80
          Height = 21
          Hint = #24115#34399
          Color = clYellow
          DataField = 'Muser'
          DataSource = DS
          Enabled = False
          TabOrder = 2
        end
        object DBEdit11: TDBEdit
          Left = 250
          Top = 65
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
  inherited CDS: TClientDataSet
    AfterOpen = CDSAfterOpen
  end
end

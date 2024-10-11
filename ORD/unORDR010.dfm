inherited FrmORDR010: TFrmORDR010
  Left = 239
  Top = 37
  Width = 1153
  Height = 704
  Caption = 'FrmORDR010'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 636
    Width = 1145
  end
  inherited ToolBar: TToolBar
    Width = 1145
    ButtonWidth = 73
    object ToolButton3: TToolButton
      Left = 780
      Top = 0
      Caption = 'ToolButton3'
      ImageIndex = 20
      Visible = False
      OnClick = ToolButton3Click
    end
    object ToolButton4: TToolButton
      Left = 853
      Top = 0
      Caption = #27604#36611
      ImageIndex = 4
      Visible = False
      OnClick = ToolButton4Click
    end
    object ToolButton10: TToolButton
      Left = 926
      Top = 0
      Caption = 'ToolButton10'
      ImageIndex = 5
      Visible = False
      OnClick = ToolButton10Click
    end
    object ToolButton11: TToolButton
      Left = 999
      Top = 0
      Caption = 'ToolButton11'
      ImageIndex = 6
      Visible = False
      OnClick = ToolButton11Click
    end
    object ToolButton12: TToolButton
      Left = 1072
      Top = 0
      Caption = 'SendMail'
      ImageIndex = 7
      OnClick = ToolButton12Click
    end
  end
  inherited PCL: TPageControl
    Width = 1121
    Height = 548
    inherited TabSheet1: TTabSheet
      inherited DBGridEh1: TDBGridEh
        Width = 1105
        Height = 511
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        OnDrawColumnCell = DBGridEh1DrawColumnCell
        OnGetCellParams = DBGridEh1GetCellParams
        OnTitleBtnClick = DBGridEh1TitleBtnClick
        Columns = <
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ddate'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custno'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'custname'
            Footers = <>
            ReadOnly = False
            Width = 72
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'dno'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ditem'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialno'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'materialname'
            Footers = <>
            ReadOnly = False
            Title.TitleButton = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'myname'
            Footers = <>
            ReadOnly = False
            Title.TitleButton = True
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'cpno'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'maker'
            Footers = <>
            ReadOnly = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Bu'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Iuser'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Idate'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Muser'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Mdate'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'CustNo_1'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Kind'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD01'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD02'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD03'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD04'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD05'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD06'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD07'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD08'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD09'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD10'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD11'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD12'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD13'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD14'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD15'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD16'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD17'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD18'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD19'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'ORD20'
            Footers = <>
            Visible = False
          end
          item
            DynProps = <>
            EditButtons = <>
            FieldName = 'Combo'
            Footers = <>
            Visible = False
          end>
      end
    end
  end
  inherited PnlBottom: TPanel
    Top = 606
    Width = 1145
  end
  inherited CDS: TClientDataSet
    object CDSddate: TDateTimeField
      FieldName = 'ddate'
    end
    object CDScustname: TWideStringField
      FieldName = 'custname'
      Size = 10
    end
    object CDSmaterialno: TWideStringField
      FieldName = 'materialno'
      Size = 50
    end
    object CDSmaterialname: TWideStringField
      FieldName = 'materialname'
      Size = 200
    end
    object CDSmyname: TStringField
      FieldName = 'myname'
      Size = 200
    end
    object CDSBu: TStringField
      FieldName = 'Bu'
      Size = 6
    end
    object CDSIuser: TStringField
      FieldName = 'Iuser'
      Size = 10
    end
    object CDSIdate: TDateTimeField
      FieldName = 'Idate'
    end
    object CDSMuser: TStringField
      FieldName = 'Muser'
      Size = 10
    end
    object CDSMdate: TDateTimeField
      FieldName = 'Mdate'
    end
    object CDSKind: TStringField
      FieldName = 'Kind'
      Size = 3
    end
    object CDSORD01: TStringField
      FieldName = 'ORD01'
    end
    object CDSORD02: TStringField
      FieldName = 'ORD02'
      Size = 10
    end
    object CDSORD03: TStringField
      FieldName = 'ORD03'
    end
    object CDSORD04: TStringField
      FieldName = 'ORD04'
    end
    object CDSORD05: TStringField
      FieldName = 'ORD05'
      Size = 10
    end
    object CDSORD06: TStringField
      FieldName = 'ORD06'
      Size = 30
    end
    object CDSORD07: TStringField
      FieldName = 'ORD07'
    end
    object CDSORD08: TStringField
      FieldName = 'ORD08'
    end
    object CDSORD09: TStringField
      FieldName = 'ORD09'
    end
    object CDSORD10: TStringField
      FieldName = 'ORD10'
      Size = 10
    end
    object CDSORD11: TStringField
      FieldName = 'ORD11'
      Size = 10
    end
    object CDSORD12: TStringField
      FieldName = 'ORD12'
      Size = 30
    end
    object CDSORD13: TStringField
      FieldName = 'ORD13'
      Size = 30
    end
    object CDSORD14: TBooleanField
      FieldName = 'ORD14'
    end
    object CDSORD15: TBooleanField
      FieldName = 'ORD15'
    end
    object CDSORD16: TStringField
      FieldName = 'ORD16'
      Size = 80
    end
    object CDSORD17: TStringField
      FieldName = 'ORD17'
      Size = 30
    end
    object CDSORD18: TStringField
      FieldName = 'ORD18'
      Size = 30
    end
    object CDSORD19: TStringField
      FieldName = 'ORD19'
      Size = 30
    end
    object CDSORD20: TStringField
      FieldName = 'ORD20'
      Size = 30
    end
    object CDSCombo: TStringField
      FieldName = 'Combo'
      Size = 100
    end
    object CDSmaker: TWideStringField
      FieldName = 'maker'
      Size = 10
    end
    object CDSdno: TWideStringField
      FieldName = 'dno'
    end
    object CDSditem: TIntegerField
      FieldName = 'ditem'
    end
    object CDSGlassCloth: TWideStringField
      FieldName = 'GlassCloth'
      Size = 1
    end
    object CDScpno: TWideStringField
      FieldName = 'cpno'
      Size = 50
    end
    object CDScompare: TBooleanField
      FieldName = 'compare'
    end
    object CDScompare2: TBooleanField
      FieldName = 'compare2'
    end
    object CDScustno: TWideStringField
      FieldName = 'custno'
      Size = 100
    end
    object CDScompare_pp: TBooleanField
      FieldName = 'compare_pp'
    end
  end
  object CDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 429
  end
  object CDS3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 429
  end
  object CDS080: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 429
  end
  object CDS040: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 461
  end
  object CDS060: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 461
  end
  object CDS041: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 461
  end
  object CDS090: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 493
  end
  object CDS100: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 493
  end
  object CDS110: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 493
  end
  object CDS010: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 525
  end
  object CDS120: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 525
  end
  object CDS130: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 525
  end
  object IdSMTP1: TIdSMTP
    MaxLineAction = maException
    ReadTimeout = 0
    Host = '192.168.4.20'
    Port = 25
    AuthenticationType = atLogin
    Password = 'AAaa1234'
    Username = 'terry.tang'
    Left = 132
    Top = 325
  end
  object IdMessage1: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meMIME
    Recipients = <>
    ReplyTo = <>
    Left = 204
    Top = 325
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 284
    Top = 325
  end
  object CDS150: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 852
    Top = 429
  end
end

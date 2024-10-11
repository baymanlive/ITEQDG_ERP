inherited FrmMPST070_CalCCL: TFrmMPST070_CalCCL
  Left = 633
  Top = 156
  Width = 758
  Height = 533
  Caption = 'CCL'#33184#31995#21295#32317#20998#26512
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlRight: TPanel
    Left = 632
    Top = 45
    Height = 449
    inherited btn_quit: TBitBtn
      Top = 72
    end
    object btn_export: TBitBtn
      Left = 10
      Top = 41
      Width = 91
      Height = 25
      Caption = 'btn_export'
      TabOrder = 2
      OnClick = btn_exportClick
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00000000000000000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF000000000000000000848484008484840000000000FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00000000008484840084848400848484008484840000000000FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF000000000000000000848484008484840000000000FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF000000
        000084840000848400008484000084840000848400008484000000000000FF00
        FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF000000
        000000000000000000000000000000000000000000000000000000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
        0000C6C60000C6C60000C6C60000C6C60000C6C60000C6C6000000000000FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00000000000000000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 742
    Height = 45
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 218
      Top = 19
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #32080#26463#26085#26399
    end
    object Label1: TLabel
      Left = 20
      Top = 19
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #38283#22987#26085#26399
    end
    object DateTimePicker1: TDateTimePicker
      Left = 92
      Top = 16
      Width = 101
      Height = 21
      Date = 44670.392206030090000000
      Time = 44670.392206030090000000
      TabOrder = 0
    end
    object DateTimePicker2: TDateTimePicker
      Left = 274
      Top = 16
      Width = 109
      Height = 21
      Date = 44670.392317071760000000
      Time = 44670.392317071760000000
      TabOrder = 1
    end
  end
  object DBGridEh1: TDBGridEh [2]
    Left = 0
    Top = 45
    Width = 632
    Height = 449
    Align = alClient
    DataSource = DS
    DynProps = <>
    FooterRowCount = 1
    FooterParams.Color = clWindow
    GridLineParams.VertEmptySpaceStyle = dessNonEh
    IndicatorOptions = [gioShowRowIndicatorEh, gioShowRecNoEh]
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghRowHighlight, dghDialogFind, dghShowRecNo, dghColumnResize, dghColumnMove]
    ReadOnly = True
    SumList.Active = True
    TabOrder = 2
    Columns = <
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'kind'
        Footers = <>
      end
      item
        DynProps = <>
        EditButtons = <>
        FieldName = 'Sqty'
        Footers = <>
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object Memo_sql: TMemo [3]
    Left = 56
    Top = 360
    Width = 657
    Height = 32
    Enabled = False
    Lines.Strings = (
      'select A.kind,sum(isnull(A.Sqty,0)) '
      'as Sqty from ( '
      'select  '
      'case when substring(Materialno,9,6)='#39'246490'#39' then '#39'740490'#39
      '     when substring(Materialno,9,6)='#39'245490'#39' then '#39'740490'#39
      '     when substring(Materialno,9,6)='#39'240490'#39' then '#39'740490'#39
      '     when substring(Materialno,9,6)='#39'272490'#39' then '#39'820490'#39
      '     when substring(Materialno,9,6)='#39'273490'#39' then '#39'820490'#39
      ''
      '     when substring(Materialno,9,6)='#39'280490'#39' then '#39'860490'#39
      '     when substring(Materialno,9,6)='#39'282490'#39' then '#39'860490'#39
      '     when substring(Materialno,9,6)='#39'285490'#39' then '#39'860490'#39
      '     when substring(Materialno,9,6)='#39'286490'#39' then '#39'860490'#39
      ''
      '     when substring(Materialno,9,6)='#39'170490'#39' then '#39'860490'#39
      ''
      '     when substring(Materialno,9,6)='#39'370420'#39' then '#39'370430'#39
      '     when substring(Materialno,9,6)='#39'370430'#39' then '#39'370430'#39
      '     when substring(Materialno,9,6)='#39'410430'#39' then '#39'370430'#39
      '     when substring(Materialno,9,6)='#39'406425'#39' then '#39'370430'#39
      '     when substring(Materialno,9,6)='#39'375430'#39' then '#39'370430'#39
      ''
      '     when substring(Materialno,9,6)='#39'373493'#39' then '#39'370490'#39
      '     when substring(Materialno,9,6)='#39'372492'#39' then '#39'370490'#39
      '     when substring(Materialno,9,6)='#39'371491'#39' then '#39'370490'#39
      ''
      '     when substring(Materialno,9,6)='#39'411491'#39' then '#39'410490'#39
      '     when substring(Materialno,9,6)='#39'412492'#39' then '#39'410490'#39
      '     when substring(Materialno,9,6)='#39'413493'#39' then '#39'410490'#39
      ''
      '     when substring(Materialno,9,6)='#39'431491'#39' then '#39'430490'#39
      '     when substring(Materialno,9,6)='#39'432492'#39' then '#39'430490'#39
      '     when substring(Materialno,9,6)='#39'433493'#39' then '#39'430490'#39
      '     '
      '     when substring(Materialno,9,6)='#39'550420'#39' then '#39'550430'#39
      '     when substring(Materialno,9,6)='#39'550430'#39' then '#39'550430'#39
      '    else substring(Materialno,9,6) end as kind,'
      '    case'
      '     when substring(Materialno,9,6)='#39'740490'#39' then Sqty*2'
      
        '     when substring(Materialno,9,6)='#39'246490'#39' then floor(Sqty/3*2' +
        ')'
      
        '     when substring(Materialno,9,6)='#39'245490'#39' then floor(Sqty/3*2' +
        ')'
      
        '     when substring(Materialno,9,6)='#39'240490'#39' then floor(Sqty/3*2' +
        ')'
      '     when substring(Materialno,9,6)='#39'820490'#39' then Sqty*2'
      
        '     when substring(Materialno,9,6)='#39'272490'#39' then floor(Sqty/3*2' +
        ')'
      
        '     when substring(Materialno,9,6)='#39'273490'#39' then floor(Sqty/3*2' +
        ')'
      ''
      '     when substring(Materialno,9,6)='#39'860490'#39' then Sqty*2'
      
        '     when substring(Materialno,9,6)='#39'280490'#39' then floor(Sqty/3*2' +
        ')'
      
        '     when substring(Materialno,9,6)='#39'285490'#39' then floor(Sqty/3*2' +
        ')'
      
        '     when substring(Materialno,9,6)='#39'286490'#39' then floor(Sqty/3*2' +
        ')'
      ''
      '     when substring(Materialno,9,6)='#39'170490'#39' then Sqty /5 *2'
      ''
      '     when substring(Materialno,9,6)='#39'370420'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'370430'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'410430'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'406425'#39' then Sqty'
      ''
      '     when substring(Materialno,9,6)='#39'373493'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'372492'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'371491'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'411491'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'412492'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'413493'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'431491'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'432492'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'433493'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'550420'#39' then Sqty'
      '     when substring(Materialno,9,6)='#39'550430'#39' then Sqty'
      '     else Sqty end as Sqty'
      ' from (select Sdate,Materialno,Sqty from MPS012'
      '        where substring(Materialno,1,1) in ('#39'E'#39','#39'T'#39')'
      '         and CONVERT(varchar(10),Sdate,120)>=@variable01'
      '         and CONVERT(varchar(10),Sdate,120)<=@variable02'
      '        union all'
      '        select Sdate,Materialno,Sqty from MPS010'
      '        where substring(Materialno,1,1) in ('#39'E'#39','#39'T'#39')'
      '         and CONVERT(varchar(10),Sdate,120)>=@variable01'
      '         and CONVERT(varchar(10),Sdate,120)<=@variable02'
      '       ) AA'
      '         ) A group by  A.kind  order by A.kind  ')
    TabOrder = 3
    Visible = False
  end
  object DS: TDataSource
    Left = 56
    Top = 273
  end
end

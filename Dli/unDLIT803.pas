unit unDLIT803;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  StrUtils, DB, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TFrmDLIT803 = class(TFrmSTDI080)
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    OpenDialog1: TOpenDialog;
    DS: TDataSource;
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetSBarsX;
    function CheckValue(xName, xValue:string):string;
    function CheckPlace(xPno,xPlace:string):string;
  public
    { Public declarations }
  end;

var
  FrmDLIT803: TFrmDLIT803;

implementation

uses unGlobal, unCommon, ComObj, unDLIT803_showret;

{$R *.dfm}

procedure TFrmDLIT803.SetSBarsX;
begin
  if CDS.Active then
  begin
    if CDS.IsEmpty or (CDS.RecNo=-1) then
       Edit1.Text:='0'
    else
       Edit1.Text:=IntToStr(CDS.RecNo);
    Edit2.Text:=IntToStr(CDS.RecordCount);
  end else
  begin
    Edit1.Text:='0';
    Edit2.Text:='0';
  end;
end;

function TFrmDLIT803.CheckValue(xName, xValue:string):string;
begin
  Result:='';

  if SameText(xName,'purno') then
  begin
    if (Length(xValue)<>10) or (Copy(xValue,4,1)<>'-') then
    begin
      Result:='���ʳ渹���~';
      Exit;
    end;

    if Pos(Copy(xValue,1,3),'P1Z,323,327,32E')=0 then
    begin
      Result:='��O���~,�u���\:P1Z,323,327,32E';
      Exit;
    end;
  end else
  if SameText(xName,'pursno') then
  begin
    if StrToIntDef(xValue,0)<=0 then
    begin
      Result:='���ʳ涵�����~';
      Exit;
    end;
  end else
  if SameText(xName,'pno') then
  begin
    if Length(xValue)<10 then
    begin
      Result:='�Ƹ����~';
      Exit;
    end;
  end else
  if SameText(xName,'lot') then
  begin
    if Length(xValue)<9 then
    begin
      Result:='�帹���~,�̤p9�X';
      Exit;
    end;
  end else
  if SameText(xName,'qty') then
  begin
    if StrToFloatDef(xValue,0)<=0 then
    begin
      Result:='�ƶq���~';
      Exit;
    end;
  end else
  if SameText(xName,'units') then
  begin
    if (xValue<>'RL') and (xValue<>'SH') and (xValue<>'M') and (xValue<>'PN') then
    begin
      Result:='�����~,����:SH�BRL�BM�BPN';
      Exit;
    end;
  end else
  if SameText(xName,'place') then
  begin
    if Length(xValue)<>5 then
    begin
      Result:='�ܮw�O���~,����5�X';
      Exit;
    end;
  end else
  if SameText(xName,'area') then
  begin
    if Length(xValue)<>4 then
    begin
      Result:='�x����~,����4�X';
      Exit;
    end;
  end;
end;

function TFrmDLIT803.CheckPlace(xPno,xPlace:string):string;
var
  fstCode:string;
begin
  Result:='';

  fstCode:=Copy(xPno,1,1);
  if fstCode='E' then
  begin
   if Pos(xPlace,'Y0A0F,D3A17,Y0AM0,Y0AA0')=0 then
    begin
      Result:='�ܧO���~,����:Y0A0F,D3A17,Y0AM0,Y0AA0';
      Exit;
    end;
  end else
  if fstCode='T' then
  begin
   if Pos(xPlace,'N0A0F,N3A18,N0AM0,N0AA0')=0 then
    begin
      Result:='�ܧO���~,����:N0A0F,N3A18,N0AM0,N0AA0';
      Exit;
    end;
  end else
  if (fstCode='B') or (fstCode='M') then
  begin
   if Pos(xPlace,'N3A18,N0AM0')=0 then
    begin
      Result:='�ܧO���~,����:N3A18,N0AM0';
      Exit;
    end;
  end else
  if (fstCode='R') or (fstCode='N') then
  begin
   if Pos(xPlace,'D3A17,Y0AM0')=0 then
    begin
      Result:='�ܧO���~,����:D3A17,Y0AM0';
      Exit;
    end;
  end else
  if fstCode='P' then
  begin
   if Pos(xPlace,'Y2A10')=0 then
    begin
      Result:='�ܧO���~,����:Y2A10';
      Exit;
    end;
  end else
  if fstCode='Q' then
  begin
   if Pos(xPlace,'N2A10')=0 then
    begin
      Result:='�ܧO���~,����:N2A10';
      Exit;
    end;
  end else
  begin
    Result:='�Ƹ����~,��1�X����:E,T,B,R,M,N,P,Q';
    Exit;
  end;
end;

procedure TFrmDLIT803.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetSBarsX;
end;

procedure TFrmDLIT803.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SetSBarsX;
end;

procedure TFrmDLIT803.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  p_TableName:='dli803';

  inherited;
  
  btn_export.Caption:=CheckLang('�פJ���');
  btn_query.Caption:=CheckLang('���f');
  SetGrdCaption(DBGridEh1, p_TableName);
  btn_print.Visible:=False;
  btn_export.Visible:=True;
  btn_query.Visible:=True;

  tmpSQL:='select * from '+p_TableName+' where 1=2';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmDLIT803.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmDLIT803.btn_exportClick(Sender: TObject);
var
  i,j,row,sno:Integer;
  tmpStr,ret:string;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
begin
  //inherited;
  if not OpenDialog1.Execute then
     Exit;

  for i:=0 to DBGridEh1.Columns.Count-1 do
    DBGridEh1.Columns[i].Tag:=0;

  tmpCDS:=TClientDataSet.Create(nil);
  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog1.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno:=ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i:=1 to sno do
    begin
      tmpStr:=Trim(ExcelApp.Cells[1,i].Value);

      if tmpStr<>'' then
      for j:=0 to DBGridEh1.Columns.Count-1 do
      if DBGridEh1.Columns[j].Title.Caption=tmpStr then
      begin
        DBGridEh1.Columns[j].Tag:=i;
        Break;
      end;
    end;

    for j:=0 to DBGridEh1.Columns.Count-1 do
    if DBGridEh1.Columns[j].Tag=0 then
    begin
      ShowMsg('Excel�ɮׯʤ����[%s]', 48, DBGridEh1.Columns[j].Title.Caption);
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�פJExcel���...');
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible:=True;
    tmpCDS.Data:=CDS.Data;
    tmpCDS.EmptyDataSet;
    row:=2;
    while True do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      //�����ŭ�,�h�X
      tmpStr:='';
      for i:=1 to sno do
         tmpStr:=tmpStr+Trim(VarToStr(ExcelApp.Cells[row,i].Value));
      if Length(tmpStr)=0 then
         Break;

      tmpCDS.Append;
      for i:=0 to DBGridEh1.Columns.Count-1 do
      begin
        j:=DBGridEh1.Columns[i].Tag;
        tmpStr:=StringReplace(Trim(ExcelApp.Cells[row,j].Value),'''','',[rfReplaceAll]);
        ret:=CheckValue(DBGridEh1.Columns[i].FieldName, tmpStr);
        if Length(ret)>0 then
        begin
          ShowMsg('��'+IntToStr(row)+'��,'+ret+#13#10+'��e:'+tmpStr,48);
          Exit;
        end;

        tmpCDS.FieldByName(DBGridEh1.Columns[i].FieldName).Value:=tmpStr;
      end;
      tmpCDS.Post;

      ret:=CheckPlace(tmpCDS.FieldByName('pno').AsString,tmpCDS.FieldByName('place').AsString);
      if Length(ret)>0 then
      begin
        ShowMsg('��'+IntToStr(row)+'��,'+ret+#13#10+'��e:'+tmpCDS.FieldByName('place').AsString,48);
        Exit;
      end;

      Inc(row);
    end;

    if tmpCDS.ChangeCount>0 then
       tmpCDS.MergeChangeLog;
    CDS.Data:=tmpCDS.Data;

  finally
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpCDS);
    ExcelApp.Quit;
  end;
end;

procedure TFrmDLIT803.btn_queryClick(Sender: TObject);
var
  i,sno:Integer;
  per,qty,maxqty,minqty:Double;
  tmpPurno,tmpSQL,tmpSid,tmpRva01,tmpImgFilter,tmpPmhFilter,tmpLotFilter:string;
  tmpPurnoList,tmpRetList:TStrings;
  Data:OleVariant;
  tmpCDS,tmpSrcCDS,tmpSumCDS,pmmCDS,rvaCDS,rvbCDS,imgCDS,pmhCDS:TClientDataSet;
begin
//  inherited;
  if not SameText(g_UInfo^.BU,'ITEQDG') then
  begin
    ShowMsg('���{���u�A�ΪF��t!',48);
    Exit;
  end;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('�L���,�п��Excel�ɶפJ���!',48);
    Exit;
  end;

  if ShowMsg('�T�w�i�榬�f��?',33)=IdCancel then
     Exit;

  tmpPurnoList:=TStringList.Create;
  tmpRetList:=TStringList.Create;
  tmpCDS:=TClientDataSet.Create(nil);
  tmpSrcCDS:=TClientDataSet.Create(nil);
  tmpSumCDS:=TClientDataSet.Create(nil);
  pmmCDS:=TClientDataSet.Create(nil);
  rvaCDS:=TClientDataSet.Create(nil);
  rvbCDS:=TClientDataSet.Create(nil);
  imgCDS:=TClientDataSet.Create(nil);
  pmhCDS:=TClientDataSet.Create(nil);
  try
    tmpSumCDS.Data:=CDS.Data;
    tmpSumCDS.EmptyDataSet; //�[�`�ƶq,�Τ_�ˬd�W�u��

    tmpSrcCDS.Data:=CDS.Data;
    tmpPurno:='';
    tmpImgFilter:='';
    tmpPmhFilter:='';
    tmpLotFilter:='';
    with tmpSrcCDS do
    begin
      First;
      while not Eof do
      begin
        if Pos(FieldByName('purno').AsString,tmpPurno)=0 then
           tmpPurno:=tmpPurno+','+Quotedstr(FieldByName('purno').AsString);

        tmpSQL:='(img01='+Quotedstr(FieldByName('pno').AsString)
               +' and img02='+Quotedstr(FieldByName('place').AsString)
               +' and img03='+Quotedstr(FieldByName('area').AsString)
               +' and img04='+Quotedstr(FieldByName('lot').AsString)+')';
        if Pos(tmpSQL,tmpImgFilter)=0 then
           tmpImgFilter:=tmpImgFilter+' or '+tmpSQL;

        if Pos(FieldByName('pno').AsString,tmpPmhFilter)=0 then
           tmpPmhFilter:=tmpPmhFilter+' or pmh01='+Quotedstr(FieldByName('pno').AsString);

        if Pos(FieldByName('lot').AsString,tmpLotFilter)=0 then
           tmpLotFilter:=tmpLotFilter+','+Quotedstr(FieldByName('lot').AsString);

        if tmpSumCDS.Locate('purno;pursno',VarArrayOf([FieldByName('purno').AsString,FieldByName('pursno').AsInteger]),[]) then
        begin
          tmpSumCDS.Edit;
          tmpSumCDS.FieldByName('qty').AsFloat:=tmpSumCDS.FieldByName('qty').AsFloat+FieldByName('qty').AsFloat;
          tmpSumCDS.Post;
        end else
        begin
          tmpSumCDS.Append;
          tmpSumCDS.FieldByName('purno').AsString:=FieldByName('purno').AsString;
          tmpSumCDS.FieldByName('pursno').AsInteger:=FieldByName('pursno').AsInteger;
          tmpSumCDS.FieldByName('qty').AsFloat:=FieldByName('qty').AsFloat;
          tmpSumCDS.Post;
        end;

        Next;
      end;
    end;

    Delete(tmpPurno,1,1);
    Delete(tmpImgFilter,1,4);
    Delete(tmpPmhFilter,1,4);
    Delete(tmpLotFilter,1,1);

    if tmpSumCDS.ChangeCount>0 then
       tmpSumCDS.MergeChangeLog;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�ˬd��Ѧ��f�帹�O�_����...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select rvb38 from '+g_UInfo^.BU+'.rva_file,'+g_UInfo^.BU+'.rvb_file'
           +' where rva01=rvb01 and to_char(rva06,''YYYY-MM-DD'')=to_char(sysdate,''YYYY-MM-DD'')'
           +' and rvb38 in ('+tmpLotFilter+') and rvaconf<>''X''';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
    begin
      if ShowMsg('��Ѧ��f�帹����,�нT�{(�@'+IntToStr(tmpCDS.RecordCount)+'�ӭ���,�䤤�@�ӬO:'+tmpCDS.Fields[0].AsString+')'+#13#10+'�Ы�[�T�w]�~�򦬳f,��[����]����ާ@',33)=IdCancel then
         Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�ˬd�O�_�����T�{�����f��...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select distinct rva01 from '+g_UInfo^.BU+'.rva_file,'+g_UInfo^.BU+'.rvb_file'
           +' where rva01=rvb01 and rvb04 in ('+tmpPurno+') and rvaconf=''N''';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then    //�@�i���ʳ�إߤ@�i���f��,�i�H���γs��rvb_file
       Exit;
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
    begin
      if not Assigned(FrmDLIT803_showret) then
         FrmDLIT803_showret:=TFrmDLIT803_showret.Create(Application);
      FrmDLIT803_showret.Memo1.Lines.Clear;
      FrmDLIT803_showret.Memo1.Lines.Add(CheckLang('�s�b���T�{�����f��,�Х��T�{:'));
      while not tmpCDS.Eof do
      begin
        FrmDLIT803_showret.Memo1.Lines.Add(tmpCDS.Fields[0].AsString);
        tmpCDS.Next;
      end;
      FrmDLIT803_showret.ShowModal;
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�ˬd���ʳ���...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.pmm_file,'+g_UInfo^.BU+'.pmn_file'
           +' where pmm01=pmn01 and pmm01 in ('+tmpPurno+') and pmmacti=''Y''';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmmCDS.Data:=Data;
    if pmmCDS.IsEmpty then
    begin
      ShowMsg('���ʳ椣�s�b!',48);
      Exit;
    end;

    with tmpSrcCDS do
    begin
      First;
      while not Eof do
      begin
        if not pmmCDS.Locate('pmn01;pmn02',VarArrayOf([FieldByName('purno').AsString,FieldByName('pursno').AsInteger]),[]) then
        begin
          ShowMsg('��'+IntToStr(RecNo)+'��,���ʳ椣�s�b:'+#13#10+
              FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString,48);
          Exit;
        end;

        if FieldByName('pno').AsString<>pmmCDS.FieldByName('pmn04').AsString then
        begin
          ShowMsg('��'+IntToStr(RecNo)+'��,�P���ʳ�Ƹ����P:'+
              FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
              '���ʳ�:'+pmmCDS.FieldByName('pmn04').AsString+#13#10+
              '��e:'+FieldByName('pno').AsString,48);
          Exit;
        end;

        if FieldByName('units').AsString<>pmmCDS.FieldByName('pmn07').AsString then
        begin
          ShowMsg('��'+IntToStr(RecNo)+'��,�P���ʳ��줣�P:'+
              FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
              '���ʳ�:'+pmmCDS.FieldByName('pmn07').AsString+#13#10+
              '��e:'+FieldByName('units').AsString,48);
          Exit;
        end;

        Next;
      end;
    end;

    //�ˬd�W��B�u��
    with tmpSumCDS do
    begin
      First;
      while not Eof do
      begin
        if not pmmCDS.Locate('pmn01;pmn02',VarArrayOf([FieldByName('purno').AsString,FieldByName('pursno').AsInteger]),[]) then
        begin
          ShowMsg('�L�k�w�����ʳ�:'+FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString,48);
          Exit;
        end;

        per:=pmmCDS.FieldByName('pmn13').AsFloat;  //�W�u��v
        if per>0 then
        begin
          qty:=FieldByName('qty').AsFloat+pmmCDS.FieldByName('pmn50').AsFloat+pmmCDS.FieldByName('pmn51').AsFloat;  //�ݥ�q+�w��q+�b��q
          maxqty:=(pmmCDS.FieldByName('pmn20').AsFloat*(100+per))/100;     //�̤j�i��q(pmn20:���ʶq)
          minqty:=(pmmCDS.FieldByName('pmn20').AsFloat*(100-per))/100;     //�̤p�i��q
          if pmmCDS.FieldByName('pmn14').AsString='Y' then //Y:�i������f,�u����W��; N:���i������f,�W��P�u�泣����
          begin
            if qty>maxqty then
            begin
              ShowMsg('�ҥ�f���ƶq�`�p�j�󤹳\����f�ƶq:'+#13#10+
                  FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
                  '��e��f:'+FloatToStr(qty)+'>�̤j�i��f:'+FloatToStr(maxqty),48);
              Exit;
            end;
          end else
          begin
            if (qty>maxqty) or (qty<minqty) then
            begin
              ShowMsg('�ҥ�f���ƶq�`�p�j��/�p�_���\����f�ƶq:'+#13#10+
                  FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
                  '��e��f:'+FloatToStr(qty)+'>�̤j�i��f:'+FloatToStr(maxqty)+',<�̤p�i��f:'+FloatToStr(minqty),48);
              Exit;
            end;
          end;
        end;

        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�d�߮w�s���...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.img_file where '+tmpImgFilter;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    imgCDS.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�d�߼t�Ӯƥ���...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select pmh01,pmh02,pmh08,pmh13 from '+g_UInfo^.BU+'.pmh_file where '+tmpPmhFilter;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmhCDS.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('���b������f���ƪ��c...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from rva_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    rvaCDS.Data:=Data;

    Data:=null;
    tmpSQL:='select * from rvb_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    rvbCDS.Data:=Data;

    //�}�l�س�,�@�i���ʳ�إߤ@�i���f��
    tmpPurnoList.DelimitedText:=StringReplace(tmpPurno,'''','',[rfReplaceAll]);
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpPurnoList.Count;
    g_ProgressBar.Visible:=True;
    for i:=0 to tmpPurnoList.Count-1 do
    begin
      tmpPurno:=tmpPurnoList.Strings[i];
      if not pmmCDS.Locate('pmn01',tmpPurno,[]) then
      begin
        ShowMsg('�L�k�w�����ʳ�:'+tmpPurno,48);
        Exit;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('���b�B�z���ʳ�:'+tmpPurno);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      rvaCDS.Append;
      rvaCDS.FieldByName('rva01').AsString:=IntToStr(i);                            //���f�渹(�Z���Τ@��s)
      rvaCDS.FieldByName('rva02').AsString:=tmpPurno;                               //���ʳ渹
      rvaCDS.FieldByName('rva04').AsString:='N';                                    //�O�_��L/C����
      rvaCDS.FieldByName('rva05').AsString:=pmmCDS.FieldByName('pmm09').AsString;   //�����t��
      rvaCDS.FieldByName('rva06').AsDateTime:=Date;                                 //���f���
      if Copy(rvaCDS.FieldByName('rva02').AsString,1,3)='P1Z' then
        rvaCDS.FieldByName('rva10').AsString:='REG'
      else
        rvaCDS.FieldByName('rva10').AsString:=pmmCDS.FieldByName('pmm02').AsString;   //�������OREG
      rvaCDS.FieldByName('rvaprsw').AsString:='Y';                                  //�O�_�ݦC�L���f��
      rvaCDS.FieldByName('rvaconf').AsString:='N';                                  //��ƽT�{�X
      rvaCDS.FieldByName('rvaprno').AsInteger:=0;                                   //�C�L����
      rvaCDS.FieldByName('rvaacti').AsString:='Y';                                  //��Ʀ��ĽX
      rvaCDS.FieldByName('rvauser').AsString:=g_UInfo^.UserId;                      //�g��H
      rvaCDS.FieldByName('rvagrup').AsString:='0D8120';                             //����
      rvaCDS.FieldByName('rvamodu').AsString:=g_UInfo^.UserId;                      //�ק�H
      rvaCDS.FieldByName('rvadate').AsDateTime:=Date;                               //�ק���
      rvaCDS.Post;

      sno:=1;
      tmpSrcCDS.Filtered:=False;
      tmpSrcCDS.Filter:='purno='+Quotedstr(tmpPurno);
      tmpSrcCDS.Filtered:=True;
      tmpSrcCDS.IndexFieldNames:='pursno;lot;qty';
      while not tmpSrcCDS.Eof do
      begin
        if not pmmCDS.Locate('pmn01;pmn02',VarArrayOf([tmpPurno,tmpSrcCDS.FieldByName('pursno').AsInteger]),[]) then
        begin
          ShowMsg('�L�k�w�����ʳ�:'+tmpPurno+'/'+tmpSrcCDS.FieldByName('pursno').AsString,48);
          Exit;
        end;

        rvbCDS.Append;
        rvbCDS.FieldByName('rvb01').AsString:=rvaCDS.FieldByName('rva01').AsString;     //���f�渹(�Z���Τ@��s)
        rvbCDS.FieldByName('rvb02').AsInteger:=sno;                                     //���f����
        rvbCDS.FieldByName('rvb03').AsInteger:=pmmCDS.FieldByName('pmn02').AsInteger;   //���ʶ���
        rvbCDS.FieldByName('rvb04').AsString:=pmmCDS.FieldByName('pmn01').AsString;     //���ʳ渹
        rvbCDS.FieldByName('rvb05').AsString:=pmmCDS.FieldByName('pmn04').AsString;     //�Ƹ�
        rvbCDS.FieldByName('rvb06').AsInteger:=0;                                       //�w�дڶq
        rvbCDS.FieldByName('rvb07').AsFloat:=tmpSrcCDS.FieldByName('qty').AsFloat;      //�ꦬ�ƶq
        rvbCDS.FieldByName('rvb08').AsFloat:=rvbCDS.FieldByName('rvb07').AsFloat;       //���Ƽƶq
        rvbCDS.FieldByName('rvb09').AsInteger:=0;                                       //���дڶq
        rvbCDS.FieldByName('rvb10').AsFloat:=pmmCDS.FieldByName('pmn31').AsFloat;       //���|���
        rvbCDS.FieldByName('rvb10t').AsFloat:=pmmCDS.FieldByName('pmn31t').AsFloat;     //�t�|���
        rvbCDS.FieldByName('rvb11').AsInteger:=0;                                       //�N�R����
        rvbCDS.FieldByName('rvb12').AsDateTime:=Date;                                   //���f���������
        rvbCDS.FieldByName('rvb15').AsInteger:=0;                                       //�e���˼�
        rvbCDS.FieldByName('rvb16').AsInteger:=0;                                       //�e���ƥ�
        rvbCDS.FieldByName('rvb18').AsString:='10';                                     //���f���p 10:�b���f����� 30:�J[�w�s]
        rvbCDS.FieldByName('rvb19').AsString:='1';                                      //���f�ʽ� 1:���ʦ��f��
        rvbCDS.FieldByName('rvb27').AsFloat:=0;                                         //����
        rvbCDS.FieldByName('rvb28').AsFloat:=0;                                         //����
        rvbCDS.FieldByName('rvb29').AsFloat:=0;                                         //�h�f�q
        rvbCDS.FieldByName('rvb30').AsFloat:=0;                                         //�w����J�w�q
        rvbCDS.FieldByName('rvb31').AsFloat:=rvbCDS.FieldByName('rvb07').AsFloat;       //rvb07�ꦬ�q-rvb29�h�^�q-rvb����q
        rvbCDS.FieldByName('rvb32').AsFloat:=0;                                         //����
        rvbCDS.FieldByName('rvb33').AsFloat:=0;                                         //�����ƶq QC��J
        rvbCDS.FieldByName('rvb35').AsString:='N';                                      //�˫~�_
        rvbCDS.FieldByName('rvb36').AsString:=tmpSrcCDS.FieldByName('place').AsString;  //�ܮw
        rvbCDS.FieldByName('rvb37').AsString:=tmpSrcCDS.FieldByName('area').AsString;   //�x��
        rvbCDS.FieldByName('rvb38').AsString:=tmpSrcCDS.FieldByName('lot').AsString;    //�帹
        rvbCDS.FieldByName('rvb39').AsString:='Y';                                      //����_(rvb40������,rvb41���絲�G)
        rvbCDS.FieldByName('ta_rvb01').AsString:='N';                                   //VMI�J�w�_
        rvbCDS.FieldByName('ta_rvb02').AsInteger:=0;                                    //VMI�i�J�w�q
        rvbCDS.FieldByName('ta_rvb03').AsInteger:=0;                                    //VMI�J�w�q
        rvbCDS.FieldByName('ta_rvb04').AsInteger:=0;                                    //VMI�i��X�q
        rvbCDS.FieldByName('ta_rvb05').AsInteger:=0;                                    //VMI��X�q
        
        //�K��
        if pmhCDS.Locate('pmh01;pmh02;pmh13',
            VarArrayOf([rvbCDS.FieldByName('rvb05').AsString,
                        rvaCDS.FieldByName('rva05').AsString,
                        pmmCDS.FieldByName('pmm22').AsString]),[]) then
        if pmhCDS.FieldByName('pmh08').AsString='N' then                                //�ٲ�����:or (sma886[6,6]='N' and sma886[8,8]='N') or rvb19='2'
           rvbCDS.FieldByName('rvb39').AsString:='N';                                   //QC����_

        rvbCDS.Post;

        //�K�[�@���w�s��0�����
        if not imgCDS.Locate('img01;img02;img03;img04',
            VarArrayOf([rvbCDS.FieldByName('rvb05').AsString,
                        rvbCDS.FieldByName('rvb36').AsString,
                        rvbCDS.FieldByName('rvb37').AsString,
                        rvbCDS.FieldByName('rvb38').AsString]),[]) then
        begin
          imgCDS.Append;
          imgCDS.FieldByName('img01').AsString:=rvbCDS.FieldByName('rvb05').AsString;
          imgCDS.FieldByName('img02').AsString:=rvbCDS.FieldByName('rvb36').AsString;
          imgCDS.FieldByName('img03').AsString:=rvbCDS.FieldByName('rvb37').AsString;
          imgCDS.FieldByName('img04').AsString:=rvbCDS.FieldByName('rvb38').AsString;
          imgCDS.FieldByName('img05').AsString:=rvbCDS.FieldByName('rvb01').AsString;
          imgCDS.FieldByName('img06').AsString:=rvbCDS.FieldByName('rvb02').AsString;
          if pmmCDS.FieldByName('pmn07').AsString='RL' then
             imgCDS.FieldByName('img09').AsString:='M'
          else
             imgCDS.FieldByName('img09').AsString:=pmmCDS.FieldByName('pmn07').AsString;
          imgCDS.FieldByName('img10').AsFloat:=0;
          imgCDS.FieldByName('img17').AsDateTime:=Date;
          imgCDS.FieldByName('img18').AsDateTime:=EncodeDate(9999,12,31);
          imgCDS.FieldByName('img19').AsString:='A';
          imgCDS.FieldByName('img20').AsFloat:=1;
          imgCDS.FieldByName('img21').AsFloat:=1;
          imgCDS.FieldByName('img22').AsString:='S';
          imgCDS.FieldByName('img23').AsString:='Y';
          imgCDS.FieldByName('img24').AsString:='Y';
          imgCDS.FieldByName('img25').AsString:='N';
          imgCDS.FieldByName('img27').AsInteger:=0;
          imgCDS.FieldByName('img28').AsInteger:=0;
          imgCDS.FieldByName('img30').AsFloat:=0;
          imgCDS.FieldByName('img31').AsFloat:=0;
          imgCDS.FieldByName('img32').AsFloat:=0;
          imgCDS.FieldByName('img33').AsFloat:=0;
          imgCDS.FieldByName('img34').AsFloat:=1;
          imgCDS.FieldByName('img37').AsDateTime:=Date;
          imgCDS.Post;
        end;

        tmpSrcCDS.Next;
        Inc(sno);
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�B�z���f�渹...');
    Application.ProcessMessages;
    tmpRetList.Clear;
    rvaCDS.First;
    while not rvaCDS.Eof do
    begin
      tmpSid:=Copy(rvaCDS.FieldByName('rva02').AsString,1,3); //�e3�X��O
      if tmpSid='327' then
         tmpSid:='337'
      else if tmpSid='323' then
         tmpSid:='333'
      else if tmpSid='32E' then
         tmpSid:='33E'
      else if tmpSid='P1Z' then
         tmpSid:='337'
      else begin
        ShowMsg('�������ʳ�O:'+tmpSid,48);
        Exit;
      end;

      tmpRva01:='';
      tmpSid:=tmpSid+'-'+GetYM;
      for i:=0 to tmpRetList.Count-1 do
      if tmpSid=LeftStr(tmpRetList.Strings[i],6) then //�e6�X�ۦP,�����ϥΦ��渹,�_�h���s�d��rva_file�̤j�渹
      begin
        if tmpRva01<tmpRetList.Strings[i] then
           tmpRva01:=tmpRetList.Strings[i];
      end;

      if Length(tmpRva01)=0 then
      begin
        Data:=null;
        tmpSQL:='select nvl(max(rva01),'''') as rva01 from '+g_UInfo^.BU+'.rva_file'
               +' where rva01 like ''' + tmpSid + '%''';
        if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
           Exit;
        tmpRva01:=GetNewNo(tmpSid, VarToStr(Data));
      end else
        tmpRva01:=GetNewNo(tmpSid, tmpRva01);

      tmpRetList.Add(tmpRva01);
      with rvbCDS do
      begin
        Filtered:=False;
        Filter:='rvb01='+Quotedstr(rvaCDS.FieldByName('rva01').AsString);
        Filtered:=True;
        while not IsEmpty do  //���rvb01�Z,Filtered�ͮ�
        begin
          Edit;
          FieldByName('rvb01').AsString:=tmpRva01;
          Post;
        end;
      end;

      rvaCDS.Edit;
      rvaCDS.FieldByName('rva01').AsString:=tmpRva01;
      rvaCDS.Post;

      rvaCDS.Next;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�x�s���...');
    Application.ProcessMessages;
    if not CDSPost(imgCDS,'img_file','ORACLE') then
       Exit;

    if not CDSPost(rvaCDS,'rva_file','ORACLE') then
       Exit;

    rvbCDS.Filtered:=False;
    if not CDSPost(rvbCDS,'rvb_file','ORACLE') then
    begin
      while not rvaCDS.IsEmpty do
        rvaCDS.Delete;
      CDSPost(rvaCDS,'rva_file','ORACLE');
    end;
    
    //�ٲ�:�K�[excel��Ʀ�dli803

    if not Assigned(FrmDLIT803_showret) then
       FrmDLIT803_showret:=TFrmDLIT803_showret.Create(Application);
    FrmDLIT803_showret.Memo1.Lines.Clear;
    FrmDLIT803_showret.Memo1.Lines.AddStrings(tmpRetList);
    FrmDLIT803_showret.Memo1.Lines.Insert(0,CheckLang('���f����,���f��X:'));
    FrmDLIT803_showret.ShowModal;
    
  finally
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpSrcCDS);
    FreeAndNil(pmmCDS);
    FreeAndNil(rvaCDS);
    FreeAndNil(rvbCDS);
    FreeAndNil(imgCDS);
    FreeAndNil(pmhCDS);
    FreeAndNil(tmpPurnoList);
    FreeAndNil(tmpRetList);
  end;
end;

end.

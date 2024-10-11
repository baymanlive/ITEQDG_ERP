unit unCCLStruct;

interface

uses
  SysUtils, Forms, DB, DBClient, StrUtils, Variants, unGlobal, unCommon;

  procedure SetCCLStruct(xCDS:TClientDataSet; xBu,xPnoField,xStructFiled,xPnlField:string);

implementation


procedure SetCCLStruct(xCDS:TClientDataSet; xBu,xPnoField,xStructFiled,xPnlField:string);
var
  cnt,tmpLen:Integer;
  tmpBu,tmpSQL,tmpPno:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
  DSNE1,DSNE2,DSNE3,DSNE4,DSNE5:TDataSetNotifyEvent;
begin
  if (not xCDS.Active) or xCDS.IsEmpty then
     Exit;

  if SameText(xBu,'ITEQDG') or SameText(xBu,'ITEQGZ') then
     tmpBu:='ITEQDG'
  else
     tmpBu:=xBu;

  tmpSQL:='select tc_ocl01,tc_ocl07 from '+tmpBu+'.tc_ocl_file';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  DSNE1:=xCDS.AfterScroll;
  DSNE2:=xCDS.BeforeEdit;
  DSNE3:=xCDS.AfterEdit;
  DSNE4:=xCDS.BeforePost;
  DSNE5:=xCDS.AfterPost;
  xCDS.AfterScroll:=nil;
  xCDS.BeforeEdit:=nil;
  xCDS.AfterEdit:=nil;
  xCDS.BeforePost:=nil;
  xCDS.AfterPost:=nil;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  g_StatusBar.Panels[0].Text:=CheckLang('正在更新結構...');
  Application.ProcessMessages;
  try
    tmpCDS1.Data:=Data;

    cnt:=0;
    tmpSQL:='';
    xCDS.First;
    while not xCDS.Eof do
    begin
      tmpPno:=xCDS.FieldByName(xPnoField).AsString;
      tmpLen:=Length(tmpPno);
      if (tmpLen=11) or (tmpLen=17) or (tmpLen=19) then
      begin
        if (tmpLen=11) or (tmpLen=19) then
        begin
          if tmpCDS1.Locate('tc_ocl01',xCDS.FieldByName(xPnlField).AsString,[]) then
             tmpPno:=LeftStr(tmpPno,8)+tmpCDS1.Fields[1].AsString+RightStr(tmpPno,3)
          else
             tmpPno:=LeftStr(tmpPno,8)+'999999'+RightStr(tmpPno,3);
        end;

        if Pos(tmpPno,tmpSQL)=0 then
        begin
          tmpSQL:=tmpSQL+','+Quotedstr(tmpPno);
          Inc(cnt);
        end;
      end;

      xCDS.Next;

      if (cnt=999) or xCDS.Eof then
      if Length(tmpSQL)>0 then
      begin
        Delete(tmpSQL,1,1);
        Data:=null;
        tmpSQL:='select bmb01,listagg(fname,''+'') within group (order by bmb01) fname'
               +' from(select bmb01,gek04||''*''||to_char(sum(round(bmb06/bmb20))) fname'
               +' from '+tmpBu+'.bma_file,'+tmpBu+'.bmb_file,'+tmpBu+'.gek_file'
               +' where bma01=bmb01 and bmaacti=''Y'' and substr(bmb03,4,2)=gek03'
               +' and bmb04<=sysdate and (bmb05 is null or bmb05>sysdate)'
               +' and (bmb01 like ''E%'' or bmb01 like ''T%'')'
               +' and (bmb03 like ''P%'' or bmb03 like ''Q%'')'
               +' and gek01=''C4'' and bmb01 in ('+tmpSQL+')'
               +' group by bmb01,gek04) t'
               +' group by bmb01';            
        if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
           Exit;

        if tmpCDS2.Active then
           tmpCDS2.AppendData(Data, True)
        else
           tmpCDS2.Data:=Data;

        cnt:=0;
        tmpSQL:='';
      end;
    end;

    xCDS.First;
    while not xCDS.Eof do
    begin
      tmpPno:=xCDS.FieldByName(xPnoField).AsString;
      tmpLen:=Length(tmpPno);
      if (tmpLen=11) or (tmpLen=17) or (tmpLen=19) then
      begin
        if (tmpLen=11) or (tmpLen=19) then
        begin
          if tmpCDS1.Locate('tc_ocl01',xCDS.FieldByName(xPnlField).AsString,[]) then
             tmpPno:=LeftStr(tmpPno,8)+tmpCDS1.Fields[1].AsString+RightStr(tmpPno,3)
          else
             tmpPno:=LeftStr(tmpPno,8)+'999999'+RightStr(tmpPno,3);
        end;

        if tmpCDS2.Locate('bmb01',tmpPno,[]) then
        begin
          xCDS.Edit;
          xCDS.FieldByName(xStructFiled).AsString:=tmpCDS2.Fields[1].AsString;
          xCDS.Post;
        end;
      end;

      xCDS.Next;
    end;

    if xCDS.ChangeCount>0 then
       xCDS.MergeChangeLog;
       
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    xCDS.AfterScroll:=DSNE1;
    xCDS.BeforeEdit:=DSNE2;
    xCDS.AfterEdit:=DSNE3;
    xCDS.BeforePost:=DSNE4;
    xCDS.AfterPost:=DSNE5;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.

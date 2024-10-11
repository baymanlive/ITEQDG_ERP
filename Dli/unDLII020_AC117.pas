unit unDLII020_AC117;

interface

uses
  unGlobal, unCommon, db, dbclient, Variants, sysutils, Dialogs, Classes, windows;

procedure AC117ZBPrint(CDS, cds3: tclientdataset; Sender: TObject);

procedure ResetTmp3(tmp3: tclientdataset);

implementation

procedure ResetTmp3(tmp3: tclientdataset);
var
  list: TStringlist;
  i,k: Integer;
  tmpstr: string;
  split_qty, total_qty: double;
begin
  tmp3.first;
  while not tmp3.Eof do
  begin
    while tmp3.fieldbyname('qty').AsFloat > 300 do
    begin
      k:=ShowMsg('數量大於300,是否拆分?', 35);
      if MB_OK = k then
      begin
        list := TStringlist.create;
        try
          for i := 0 to tmp3.FieldCount - 1 do
          begin
            list.append(tmp3.fields[i].asstring);
          end;
          if inputquery('請輸入棧板數量', tmp3.fieldbyname('qty').AsString, tmpstr) then
          begin
            split_qty := StrToFloatDef(tmpstr, 0);
            total_qty := tmp3.fieldbyname('qty').AsFloat;
            tmp3.edit;
            tmp3.fieldbyname('qty').AsFloat := split_qty;
            total_qty := total_qty - split_qty;
            if (split_qty > 0) and (split_qty < total_qty) then
            begin
              if tmp3.Eof then
              begin
                tmp3.Append;
              end
              else
              begin
                tmp3.Next;
                tmp3.Insert;
              end;
              for i := 0 to tmp3.FieldCount - 1 do
              begin
                tmp3.Fields[i].AsString := list[i];
              end;
              tmp3.fieldbyname('qty').AsFloat :=total_qty;
              Continue;
            end;
          end;
        finally
          list.free;
        end;
      end;
    end;
    tmp3.Next;
  end;
end;

procedure AC117ZBPrint(CDS, cds3: tclientdataset; Sender: TObject);
var
  ArrPrintData: TArrPrintData;
  tmp, tmp2, tmp3: TClientDataSet;
  i: Integer;
  sql, remark, dno, ditem, sno, oea04, tmpstr: string;
  data: olevariant;
  total_qty, split_qty: double;
  list: TStringlist;
begin
  if not CDS.Active then
    Exit;
  if CDS.IsEmpty then
    exit;
  remark := CDS.fieldbyname('remark').AsString;
  if (pos('AC117', remark) = 0) and (pos('ACC19', remark) = 0) then
  begin
    showmsg('僅限廣合使用');
    exit;
  end;

  sql := 'exec proc_GetLBLSno '''',''AC117zb''';

  if not QueryOneCR(sql, data) then
    exit;
  sno := vartostr(data);
  dno := copy(remark, 4, 10);
  remark := copy(remark, 15, 255);  //JX-222-370042-1-AC117
  i := pos('-', remark);
  ditem := copy(remark, 1, i - 1);

  tmp := TClientDataSet.Create(nil);
  tmp2 := TClientDataSet.Create(nil);
//  tmp3 := TClientDataSet.Create(nil);
//  tmp3.Data := cds3.Data;
//  ResetTmp3(tmp3);

  try
    sql :=
      'select oea04,oea10,oeb01,oeb11,ta_oeb10,occ02 from iteqjx.oea_file,iteqjx.oeb_file,iteqjx.occ_file where oea01=oeb01 and oea04=occ01 and oea01='
      + quotedstr(dno) + ' and oeb03=' + quotedstr(ditem);
    if not querybysql(sql, data, 'ORACLE') then
      exit;
    tmp.data := data;
    oea04 := tmp.fieldbyname('oea04').asstring;
    dno := tmp.fieldbyname('oea10').asstring;
    ditem := tmp.fieldbyname('oeb01').asstring;
//    custPno := tmp.fieldbyname('oeb11').asstring;
//    custPno := tmp.fieldbyname('oeb11').asstring;

    tmp2.FieldDefs.Add('lot', ftString, 50);
    tmp2.FieldDefs.Add('dno', ftString, 50);
    tmp2.FieldDefs.Add('qty', ftString, 50);
    tmp2.FieldDefs.Add('sno', ftString, 50);
    tmp2.FieldDefs.Add('pno', ftString, 50);
    tmp2.FieldDefs.Add('oea04', ftString, 50);
    tmp2.FieldDefs.Add('occ02', ftString, 50);
    tmp2.FieldDefs.Add('ta_oeb10', ftString, 200);
    tmp2.FieldDefs.Add('custpno', ftString, 50);
    tmp2.CreateDataSet;
    cds3.DisableControls;
    cds3.First;
    sql := '';
    while not cds3.eof do
    begin
      tmp2.Append;
      tmp2.FieldByName('qty').AsString := cds3.fieldbyname('qty').asstring;
      tmp2.FieldByName('dno').AsString := dno;
      tmp2.FieldByName('oea04').AsString := oea04;
      tmp2.FieldByName('occ02').AsString := tmp.fieldbyname('occ02').asstring;
      tmp2.FieldByName('pno').AsString := CDS.fieldbyname('pno').asstring;
      tmp2.FieldByName('custpno').AsString := tmp.fieldbyname('oeb11').asstring;
      tmp2.FieldByName('ta_oeb10').AsString := tmp.fieldbyname('ta_oeb10').asstring;
      tmp2.FieldByName('lot').AsString := cds3.fieldbyname('manfac').asstring;
      if not QueryOneCR('exec proc_GetLBLSno '''',''AC117zb''', data) then
        exit;
      tmp2.FieldByName('sno').AsString := vartostr(data);       
      {(*}
      sql := sql + format(' insert into log004(sno,lot,qty) values(%s,%s,%s)',[
                    quotedstr(tmp2.FieldByName('sno').AsString),
                    quotedstr(tmp2.fieldbyname('lot').asstring),
                    tmp2.FieldByName('qty').AsString
                    ]);
      {*)}
      tmp2.post;

      cds3.next;
    end;
    postbysql(sql);
    SetLength(ArrPrintData, 2);
    ArrPrintData[0].data := tmp2.Data;
    ArrPrintData[0].RecNo := tmp2.RecNo;
    ArrPrintData[1].data := cds3.Data;
    ArrPrintData[1].RecNo := cds3.RecNo;
    GetPrintObj('Dli', ArrPrintData, 'DLII020_ZB');
  finally
    ArrPrintData := nil;
    tmp.Free;
    tmp2.free;
    tmp3.Free;
    cds3.EnableControls;
  end;
end;
//
//procedure AC117ZBPrint(CDS, cds3: tclientdataset; Sender: TObject);
//var
//  ArrPrintData: TArrPrintData;
//  tmp, tmp2: TClientDataSet;
//  i: Integer;
//  sql, remark, dno, ditem, sno, oea04,tmpstr: string;
//  data: olevariant;
//  total_qty, split_qty: double;
//begin
//  if not CDS.Active then
//    Exit;
//  if CDS.IsEmpty then
//    exit;
//  remark := CDS.fieldbyname('remark').AsString;
//  if (pos('AC117', remark) = 0) and (pos('ACC19', remark) = 0) then
//  begin
//    showmsg('僅限廣合使用');
//    exit;
//  end;
//
//  sql := 'exec proc_GetLBLSno '''',''AC117zb''';
//
//  if not QueryOneCR(sql, data) then
//    exit;
//  sno := vartostr(data);
//  dno := copy(remark, 4, 10);
//  remark := copy(remark, 15, 255);  //JX-222-370042-1-AC117
//  i := pos('-', remark);
//  ditem := copy(remark, 1, i - 1);
//
//  tmp := TClientDataSet.Create(nil);
//  tmp2 := TClientDataSet.Create(nil);
//  try
//    sql :=

  //      'select oea04,oea10,oeb01,oeb11,ta_oeb10,occ02 from iteqjx.oea_file,iteqjx.oeb_file,iteqjx.occ_file where oea01=oeb01 and oea04=occ01 and oea01='
//      + quotedstr(dno) + ' and oeb03=' + quotedstr(ditem);
//    if not querybysql(sql, data, 'ORACLE') then
//      exit;
//    tmp.data := data;
//    oea04 := tmp.fieldbyname('oea04').asstring;
//    dno := tmp.fieldbyname('oea10').asstring;
//    ditem := tmp.fieldbyname('oeb01').asstring;
////    custPno := tmp.fieldbyname('oeb11').asstring;
////    custPno := tmp.fieldbyname('oeb11').asstring;
//
//    tmp2.FieldDefs.Add('lot', ftString, 50);
//    tmp2.FieldDefs.Add('dno', ftString, 50);
//    tmp2.FieldDefs.Add('qty', ftString, 50);
//    tmp2.FieldDefs.Add('sno', ftString, 50);
//    tmp2.FieldDefs.Add('pno', ftString, 50);
//    tmp2.FieldDefs.Add('oea04', ftString, 50);
//    tmp2.FieldDefs.Add('occ02', ftString, 50);
//    tmp2.FieldDefs.Add('ta_oeb10', ftString, 200);
//    tmp2.FieldDefs.Add('custpno', ftString, 50);
//    tmp2.CreateDataSet;
//    cds3.DisableControls;
//    cds3.First;
//    sql := '';
//    while not cds3.eof do
//    begin
//      tmp2.Append;
//
//      if cds3.fieldbyname('qty').AsFloat > 300 then
//      begin
//        tmpstr := '';
//        if inputquery('請輸入棧板數量', cds3.fieldbyname('qty').AsString, tmpstr) then
//        begin
//          split_qty := StrToFloatDef(tmpstr, 0);
//          total_qty := cds3.fieldbyname('qty').AsFloat;
//          if (split_qty > 0) and (split_qty < total_qty) then
//          begin
//
//          end
//          else
//          begin
//            Continue;
//          end;
//        end;
//      end;
//      tmp2.FieldByName('qty').AsString := cds3.fieldbyname('qty').asstring;
//      tmp2.FieldByName('dno').AsString := dno;
//      tmp2.FieldByName('oea04').AsString := oea04;
//      tmp2.FieldByName('occ02').AsString := tmp.fieldbyname('occ02').asstring;
//      tmp2.FieldByName('pno').AsString := CDS.fieldbyname('pno').asstring;
//      tmp2.FieldByName('custpno').AsString := tmp.fieldbyname('oeb11').asstring;
//      tmp2.FieldByName('ta_oeb10').AsString := tmp.fieldbyname('ta_oeb10').asstring;
//      tmp2.FieldByName('lot').AsString := cds3.fieldbyname('manfac').asstring;
//      if not QueryOneCR('exec proc_GetLBLSno '''',''AC117zb''', data) then
//        exit;
//      tmp2.FieldByName('sno').AsString := vartostr(data);
//      {(*}
//      sql := sql + format(' insert into log004(sno,lot,qty) values(%s,%s,%s)',[
//                    quotedstr(tmp2.FieldByName('sno').AsString),
//                    quotedstr(tmp2.fieldbyname('lot').asstring),
//                    tmp2.FieldByName('qty').AsString
//                    ]);
//      {*)}
//      tmp2.post;
//
//      cds3.next;
//    end;
//    postbysql(sql);
//    SetLength(ArrPrintData, 2);
//    ArrPrintData[0].data := tmp2.Data;
//    ArrPrintData[0].RecNo := tmp2.RecNo;
//    ArrPrintData[1].data := cds3.Data;
//    ArrPrintData[1].RecNo := cds3.RecNo;
//    GetPrintObj('Dli', ArrPrintData, 'DLII020_ZB');
//  finally
//    ArrPrintData := nil;
//    tmp.Free;
//    tmp2.free;
//    cds3.EnableControls;
//  end;
//end;

end.


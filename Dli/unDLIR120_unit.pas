unit unDLIR120_unit;

interface

uses DBClient;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="CCLKB" fieldtype="i4" />'     //CCL卡板數
              +'<FIELD attrname="PPKB" fieldtype="i4" />'      //PP卡板數
              +'<FIELD attrname="TotKB" fieldtype="i4" />'     //總卡板數
              +'<FIELD attrname="TotGW" fieldtype="r8" />'     //總淨重
              +'<FIELD attrname="TotTare" fieldtype="r8" />'   //總皮重
              +'<FIELD attrname="SH_Amt" fieldtype="r8" />'    //CCL金額(張)
              +'<FIELD attrname="RL_Amt" fieldtype="r8" />'    //PP金額(卷)
              +'<FIELD attrname="CCLPN_Amt" fieldtype="r8" />' //CCL金額(PN)
              +'<FIELD attrname="PPPN_Amt" fieldtype="r8" />'  //PP金額(PN)
              +'<FIELD attrname="TotAmt" fieldtype="r8" />'    //總金額
              +'<FIELD attrname="SH_NW" fieldtype="r8" />'     //CCL淨重(張)
              +'<FIELD attrname="RL_NW" fieldtype="r8" />'     //PP淨重(卷)
              +'<FIELD attrname="CCLPN_NW" fieldtype="r8" />'  //CCL淨重(PN)
              +'<FIELD attrname="PPPN_NW" fieldtype="r8" />'   //PP淨重(PN)
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';
var
  g_CDS:TCLientDataSet;

implementation

end.

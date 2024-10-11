unit unDLIR120_unit;

interface

uses DBClient;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="CCLKB" fieldtype="i4" />'     //CCL�d�O��
              +'<FIELD attrname="PPKB" fieldtype="i4" />'      //PP�d�O��
              +'<FIELD attrname="TotKB" fieldtype="i4" />'     //�`�d�O��
              +'<FIELD attrname="TotGW" fieldtype="r8" />'     //�`�b��
              +'<FIELD attrname="TotTare" fieldtype="r8" />'   //�`�֭�
              +'<FIELD attrname="SH_Amt" fieldtype="r8" />'    //CCL���B(�i)
              +'<FIELD attrname="RL_Amt" fieldtype="r8" />'    //PP���B(��)
              +'<FIELD attrname="CCLPN_Amt" fieldtype="r8" />' //CCL���B(PN)
              +'<FIELD attrname="PPPN_Amt" fieldtype="r8" />'  //PP���B(PN)
              +'<FIELD attrname="TotAmt" fieldtype="r8" />'    //�`���B
              +'<FIELD attrname="SH_NW" fieldtype="r8" />'     //CCL�b��(�i)
              +'<FIELD attrname="RL_NW" fieldtype="r8" />'     //PP�b��(��)
              +'<FIELD attrname="CCLPN_NW" fieldtype="r8" />'  //CCL�b��(PN)
              +'<FIELD attrname="PPPN_NW" fieldtype="r8" />'   //PP�b��(PN)
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';
var
  g_CDS:TCLientDataSet;

implementation

end.

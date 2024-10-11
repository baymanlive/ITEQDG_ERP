class AppConsts {
  static const appName = 'PDA作業系統';
  static const userId = '用戶編號';
  static const userPsw = '用戶密碼';
  static const strCanBeEmpty = '不能爲空';

  static const strLogin = '登入';
  static const baseUrl = 'http://192.168.4.14:5000/api/pda/';

  // static const baseUrl = 'http://iteq.com.cn:9592/api/pda/';

  // static const baseUrl = 'http://10.2.20.44:9592/api/pda/';

  static const btnZc = '資材作業';
  static const btnTiaojiao = '調膠作業';
  static const strIpqct620 = '調膠發工單';
  static const btnZcDeliver = '成品/半成品發料';
  static const btnZcDeliverNote = '送貨單管理';
  static const btnZcReceiving = '成品/半成品收料';
  static const btnZcPallet = '棧板管理';
  static const btnZcAllot = '兩階段調撥';
  static const btnZcDeliverCheck = '出貨檢核';
  static const btnZcJyFilesUpload = '俊亞資料上傳';
  static const btnZcCoatingPrepare = '上膠備料';
  static const btnZcGzAuto = '廣州自動倉';
  static const btnZcStockCount = '庫存盤點';
  static const btnZcStkArea = '儲位調撥';

  static const btnCoc = 'COC作業';
  static const btnZz = '製造作業';
  static const btnHj = '劃膠作業';
  static const btnPp = 'PP出貨作業';
  static const strChoiceQty = '請選擇對應數量';

  static const btnPassword = '修改密碼';
  static const strCustnoNotMarch = '客戶編號不匹配';
  static const btnExit = '退出系統';
  static const strBack = '返回';
  static const strPallet = '棧板';
  static const strPiror = '上一筆';
  static const strNext = '下一筆';
  static const strQrcode = '二維碼';
  static const strRecord = '筆';

  static const lblCocLot = 'COC批號掃描';
  static const lblCocEpt = 'COC異常處理';
  static const lblCocCustQrcode = '檢核客戶二維碼';
  static const strCheck = '檢核';
  static const strCheckOk = '$strCheck通過';
  static const strStorageLocation = '儲位';
  static const strClear = '清空';
  static const strYes = '確定';
  static const strSave = '保存';
  static const strCancel = '取消';
  static const strContinue = '是否繼續?';
  static const strQuesbox = '提示信息';
  static const strPno = '料號';
  static const strWono = '製令';
  static const strCustno = '客戶編號';
  static const strTotalQty = '總數';
  static const strScannedTotalQty = '已掃描數';
  static const strCo = '訂單號';
  static const strCustname = '客戶簡稱';
  static const strCustPno = '客戶料號';
  static const strQty = '數量';
  static const strOrderCount = '訂單數量';
  static const strNotCount = '應出數量';
  static const strErr = '異常';
  static const strReason = '原因';
  static const strView = '查看';
  static const strCancle = '取消';
  static const strLot = '批號';
  static const strLastLot = '上次$strLot';
  static const strColor = '顏色';
  static const strDirect = '方向';
  static const strColorDirect = '$strColor$strDirect';
  static const strErrMsg = '錯誤提示';
  static const strInputQty = '請輸入數量';
  static const strOld = '舊';
  static const strNew = '新';

  static const strBu = 'Bu';
  static const strDno = '單號';
  static const strDitem = '項次';
  static const strOk = '確定';
  static const strWrong = '錯誤';
  static const strWriteErr = '寫入資料失敗';
  static const strToUpgrade = '請先更新本程序';
  static const strNoParam = '未有設定參數';
  static const strParamPosErr = '位置參數錯誤';
  static const strDiff = '不一致';
  static const strPnoDiff = '料號$strDiff';
  static const strPoDiff = '訂單號$strDiff';
  static const strLotDiff = '批號$strDiff';
  static const strCustPoDiff = '客戶訂單號$strDiff';
  static const strQtyDiff = '$strQty$strDiff';
  static const strNoSplitrer = '沒有設定分割符號';
  static const strOpOk = '操作成功';
  static const strSaveOk = '保存成功';
  static const strTip = '提示';
  static const strTestOk = '驗證通過';
  static const strZC = '資材';
  static const strCocErrScan = '此笔资料异常,不可扫描!';
  static const strDli010Empty = '出貨表不存在此筆數據';

  static const strAtleastOne = '至少選中一項';
  static const errReasons = [
    '栈板异常',
    '包装破损',
    '未盖样品章',
    '铜箔不符',
    '玻布不符',
    '未按先进先出',
    '小标签异常',
    '品名/规格有误',
    '标签异常',
    '备注有误',
    '客户二维码有误'
  ];

  static const strJyzscan = '檢驗站掃描';
  static const strCclPackingScan = 'Pnl包裝掃描';
  static const strCgbb = '重工並包';
  static const strBbc = '重工并包確認';

  static const strZck = '製程卡';
  static const strArrowLabel = '箭頭標';
  static const strOutBoxLabel = '外箱標籤';
  static const strZckCode = '$strZck$strQrcode';
  static const strLabel = '標籤';
  static const strLabelCode = '$strLabel$strQrcode';

  static const strSxjscan = '上膠下卷掃描';
  static const strPackingScan = 'PP打包掃描';

  static const strPlsWait = '請等待';
  static const strSecond = '秒';

  static const strLoadingUpgrade = '正在下載更新,請稍候...';

  static const strIteqWx = '無錫';

  static const strUserIdPswErr = '用戶名或密碼錯';
}

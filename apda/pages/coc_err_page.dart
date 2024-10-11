import 'package:apda/pages/coc_err_remark_page.dart';
import 'package:apda/utils/app_client.dart';
import 'package:apda/utils/app_const.dart';
import 'package:apda/utils/app_size.dart';
import 'package:apda/widgets/app_btn.dart';
import 'package:apda/widgets/bu.dart';
import 'package:apda/widgets/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CocErrPage extends StatefulWidget {
  const CocErrPage({Key? key}) : super(key: key);

  @override
  State<CocErrPage> createState() => _CocErrPageState();
}

class _CocErrPageState extends State<CocErrPage> {
  List errs = [];
  bool _loading = true;
  ErrDataSource errDataSource = ErrDataSource([]);
  @override
  initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var obj = {'bu': 'ITEQDG'};

    await AppClient.getAsync('coc_err', obj, onSuccess: (value) {
      errs = value;
    });
    // errs = results['value'];
    setState(() {
      errDataSource = ErrDataSource(errs);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? MyLoading()
            : Column(children: [
                Expanded(
                  child: SfDataGrid(
                    onCellTap: (details) {
                      var itm = errs[details.rowColumnIndex.rowIndex];
                      var obj = OrderModel(itm['Bu'], itm['Dno'], itm['Ditem']);
                      Get.to(() => CocErrRemarkPage(obj));
                    },
                    selectionMode: SelectionMode.none,
                    source: errDataSource,
                    columnWidthMode: ColumnWidthMode.auto,
                    columns: [
                      GridColumn(
                          columnName: AppConsts.strPno,
                          label: Center(
                            child: Text(
                              AppConsts.strPno,
                            ),
                          )),
                      GridColumn(
                          columnName: AppConsts.strCo,
                          label: Center(child: Text(AppConsts.strCo))),
                      GridColumn(
                          columnName: AppConsts.strCustno,
                          label: Center(
                              child: Text(
                            AppConsts.strCustno,
                            overflow: TextOverflow.ellipsis,
                          ))),
                      GridColumn(
                          columnName: AppConsts.strCustname,
                          label: Center(child: Text(AppConsts.strCustname))),
                      GridColumn(
                          columnName: AppConsts.strQty,
                          label: Center(child: Text(AppConsts.strQty))),
                      GridColumn(
                          columnName: AppConsts.strErr,
                          label: Center(child: Text(AppConsts.strErr))),
                      GridColumn(
                          visible: false,
                          columnName: AppConsts.strBu,
                          label: Center(child: Text(AppConsts.strBu))),
                      GridColumn(
                          visible: false,
                          columnName: AppConsts.strDno,
                          label: Center(child: Text(AppConsts.strDno))),
                      GridColumn(
                          visible: false,
                          columnName: AppConsts.strDitem,
                          label: Center(child: Text(AppConsts.strDitem))),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // AppBtn(AppConsts.strCancle + AppConsts.strErr,
                    //     width: AppSize.w * 20),
                    AppBtn(
                      AppConsts.strBack,
                      width: AppSize.w * 20,
                      onPressed: () => Get.back(),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ]),
      ),
    );
  }
}

class ErrDataSource extends DataGridSource {
  ErrDataSource(List list) {
    _data = list
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: AppConsts.strPno, value: e['Pno']),
              DataGridCell<String>(
                  columnName: AppConsts.strCo, value: e['Orderno']),
              DataGridCell<String>(
                  columnName: AppConsts.strCustno, value: e['Custno']),
              DataGridCell<String>(
                  columnName: AppConsts.strCustname, value: e['Custshort']),
              DataGridCell<double>(
                  columnName: AppConsts.strQty, value: e['notcount']),
              DataGridCell<String>(
                  columnName: AppConsts.strErr,
                  value: e['coc_errX'] ? 'X' : ''),
              DataGridCell<String>(
                  columnName: AppConsts.strErr, value: e['Bu']),
              DataGridCell<String>(
                  columnName: AppConsts.strErr, value: e['Dno']),
              DataGridCell<int>(
                  columnName: AppConsts.strErr, value: e['Ditem']),
            ]))
        .toList();
  }

  List<DataGridRow> _data = [];

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

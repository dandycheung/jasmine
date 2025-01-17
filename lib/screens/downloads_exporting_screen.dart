import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';

import '../basic/commons.dart';
import '../configs/is_pro.dart';
import 'components/content_loading.dart';

class DownloadsExportingScreen extends StatefulWidget {
  final List<int> idList;

  const DownloadsExportingScreen({Key? key, required this.idList})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DownloadsExportingScreenState();
}

class _DownloadsExportingScreenState extends State<DownloadsExportingScreen> {
  bool exporting = false;
  bool exported = false;
  bool exportFail = false;
  dynamic e;
  String exportMessage = "正在导出";

  @override
  void initState() {
    //registerEvent(_onMessageChange, "EXPORT");
    super.initState();
  }

  @override
  void dispose() {
    //unregisterEvent(_onMessageChange);
    super.dispose();
  }

  void _onMessageChange(event) {
    setState(() {
      exportMessage = event;
    });
  }

  Widget _body() {
    if (exporting) {
      return ContentLoading(label: exportMessage);
    }
    if (exportFail) {
      return Center(child: Text("导出失败\n$e"));
    }
    if (exported) {
      return const Center(child: Text("导出成功"));
    }
    return ListView(
      children: [
        // Container(height: 20),
        // MaterialButton(
        //   onPressed: _exportPkz,
        //   child: const Text("导出PKZ"),
        // ),
        Container(height: 20),
        MaterialButton(
          onPressed: _exportPkis,
          child: Text(
            "分别导出JMI" + (!isPro ? "\n(发电后使用)" : ""),
            style: TextStyle(
              color: !isPro ? Colors.grey : null,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(height: 20),
        MaterialButton(
          onPressed: _exportZips,
          child: Text(
            "分别导出JM.ZIP" + (!isPro ? "\n(发电后使用)" : ""),
            style: TextStyle(
              color: !isPro ? Colors.grey : null,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(height: 20),
      ],
    );
  }

  // _exportPkz() async {
  //   late String? path;
  //   try {
  //     path = await chooseFolder(context);
  //   } catch (e) {
  //     defaultToast(context, "$e");
  //     return;
  //   }
  //   print("path $path");
  //   if (path != null) {
  //     try {
  //       setState(() {
  //         exporting = true;
  //       });
  //       await methods.exportComicDownloadToPkz(
  //         widget.idList,
  //         path,
  //       );
  //       exported = true;
  //     } catch (err) {
  //       e = err;
  //       exportFail = true;
  //     } finally {
  //       setState(() {
  //         exporting = false;
  //       });
  //     }
  //   }
  // }

  _exportPkis() async {
    if (!isPro) {
      defaultToast(context, "请先发电鸭");
      return;
    }
    late String? path;
    try {
      path = await chooseFolder(context);
    } catch (e) {
      defaultToast(context, "$e");
      return;
    }
    print("path $path");
    if (path != null) {
      try {
        setState(() {
          exporting = true;
        });
        await methods.export_jm_jmi(
          widget.idList,
          path,
        );
        exported = true;
      } catch (err) {
        e = err;
        exportFail = true;
      } finally {
        setState(() {
          exporting = false;
        });
      }
    }
  }

  _exportZips() async {
    if (!isPro) {
      defaultToast(context, "请先发电鸭");
      return;
    }
    late String? path;
    try {
      path = await chooseFolder(context);
    } catch (e) {
      defaultToast(context, "$e");
      return;
    }
    print("path $path");
    if (path != null) {
      try {
        setState(() {
          exporting = true;
        });
        await methods.export_jm_zip(
          widget.idList,
          path,
        );
        exported = true;
      } catch (err) {
        e = err;
        exportFail = true;
      } finally {
        setState(() {
          exporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("批量导出"),
        ),
        body: _body(),
      ),
      onWillPop: () async {
        if (exporting) {
          defaultToast(context, "导出中, 请稍后");
          return false;
        }
        return true;
      },
    );
  }
}

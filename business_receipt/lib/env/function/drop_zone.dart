import 'dart:io';
import 'dart:html' as html;

import 'package:business_receipt/env/function/button/custom_button_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/color_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/model/employee_model/excel_employee_model.dart';
import 'package:business_receipt/model/employee_model/file_model.dart';
import 'package:drop_zone/drop_zone.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
// import 'package:flutter_dropzone/flutter_dropzone.dart';

class DropZoneWidget extends StatefulWidget {
  final ValueChanged<ExcelFileModel> onDroppedFile;
  final ExcelEmployeeModel? excelEmployeeModel;
  final Function callBackDropZone;
  final Function callBackChooseFile;
  const DropZoneWidget({
    Key? key,
    required this.onDroppedFile,
    required this.excelEmployeeModel,
    required this.callBackDropZone,
    required this.callBackChooseFile,
  }) : super(key: key);

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  // late DropzoneViewController controller;
  bool isHighlighted = false;

  // File? file;
  // FilePickerResult? result;

  Widget dragAndDropWidget({required BuildContext context}) {
    Future acceptFile({required Uint8List? data, required String name, required String? mime, required int bytes}) async {
      // final String name = event.name;
      // final String mime = await controller.getFileMIME(event);
      // final int bytes = await controller.getFileSize(event);
      // final String url = await controller.createFileUrl(event);
      // final Uint8List data = await controller.getFileData(event);
      void okFunction() {
        closeDialogGlobal(context: context);
      }

      if ((mime != null) && (data != null) && (bytes <= 5000000)) {
        if (mime == "xlsx") {
          final ExcelFileModel fileModel = ExcelFileModel(name: name, mime: mime, bytes: bytes, data: data);
          widget.onDroppedFile(fileModel);
        } else {
          okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: invalidFileStrGlobal);
        }
      } else {
        okDialogGlobal(context: context, okFunction: okFunction, titleStr: errorStrGlobal, subtitleStr: invalidFileStrGlobal);
      }
    }

    Widget insideSizeBoxWidget() {
      return DropZone(
        onDragEnter: () {
          isHighlighted = true;
          setState(() {});
        },
        onDragExit: () {
          isHighlighted = false;
          setState(() {});
        },
        onDrop: (files) async {
          widget.callBackDropZone();
          if (files != null) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(files.first);
            await reader.onLoad.first;
            final Uint8List data = reader.result as Uint8List;
            final String name = files.first.name;
            final int bytes = files.first.size;
            final String mime = name.substring(name.lastIndexOf('.')).replaceAll(".", "");
            acceptFile(name: name, mime: mime, bytes: bytes, data: data);
            // setState(() {
            //   imageData = reader.result as Uint8List;
            // });
          }
        },
        child: Stack(children: [
          // DropzoneView(
          //   onDrop: acceptFile,
          //   onCreated: (controller) => this.controller = controller,
          //   onHover: () {
          //     isHighlighted = true;
          //     setState(() {});
          //   },
          //   onLeave: () {
          //     isHighlighted = false;
          //     setState(() {});
          //   },
          // ),
          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.cloud_upload, size: 80, color: textButtonColorGlobal),
              Text("Drop Files Here", style: textStyleGlobal(level: Level.normal, color: textButtonColorGlobal)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20), shape: RoundedRectangleBorder()),
                onPressed: () async {
                  // final List<dynamic> events = await controller.pickFiles();
                  // if (events.isEmpty) return;
                  // acceptFile(events.first);

          widget.callBackChooseFile();
                  try {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      if (kIsWeb) {
                        final Uint8List? data = result.files.first.bytes;
                        final String name = result.files.first.name;
                        final int bytes = result.files.first.size;
                        final String? mime = result.files.first.extension;
                        acceptFile(name: name, mime: mime, bytes: bytes, data: data);
                      } else {
                        File? file = File(result.files.single.path!);
                        final String name = basename(file.path);
                        final String mime = file.path.substring(file.path.lastIndexOf('.')).replaceAll(".", "");
                        final Uint8List data = await file.readAsBytes(); // Uint8List

                        final int bytes = await file.length();
                        acceptFile(name: name, mime: mime, bytes: bytes, data: data);
                      }
                    } else {
                      // User canceled the picker
                    }
                  } catch (_) {}
                },
                icon: Icon(Icons.search, size: 32),
                label: Text("Choose Files", style: textStyleGlobal(level: Level.normal, color: textButtonColorGlobal)),
              )
            ]),
          ),
        ]),
      );
    }

    return CustomButtonGlobal(
      insideSizeBoxWidget: insideSizeBoxWidget(),

      //  Stack(children: [
      //   // DropzoneView(
      //   //   onDrop: acceptFile,
      //   //   onCreated: (controller) => this.controller = controller,
      //   //   onHover: () {
      //   //     isHighlighted = true;
      //   //     setState(() {});
      //   //   },
      //   //   onLeave: () {
      //   //     isHighlighted = false;
      //   //     setState(() {});
      //   //   },
      //   // ),
      //   Center(
      //     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Icon(Icons.cloud_upload, size: 80, color: textButtonColorGlobal),
      //       Text("Drop Files Here", style: textStyleGlobal(level: Level.normal, color: textButtonColorGlobal)),
      //       const SizedBox(height: 16),
      //       ElevatedButton.icon(
      //         style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20), shape: RoundedRectangleBorder()),
      //         onPressed: () async {
      //           // final List<dynamic> events = await controller.pickFiles();
      //           // if (events.isEmpty) return;
      //           // acceptFile(events.first);

      //           try {
      //             FilePickerResult? result = await FilePicker.platform.pickFiles();
      //             if (result != null) {
      //               if (kIsWeb) {
      //                 final Uint8List? data = result.files.first.bytes;
      //                 final String name = result.files.first.name;
      //                 final int bytes = result.files.first.size;
      //                 final String? mime = result.files.first.extension;
      //                 acceptFile(name: name, mime: mime, bytes: bytes, data: data);
      //               } else {
      //                 File? file = File(result.files.single.path!);
      //                 final String name = basename(file.path);
      //                 final String mime = file.path.substring(file.path.lastIndexOf('.'));
      //                 final Uint8List data = await file.readAsBytes(); // Uint8List

      //                 final int bytes = await file.length();
      //                 acceptFile(name: name, mime: mime, bytes: bytes, data: data);
      //               }
      //             } else {
      //               // User canceled the picker
      //             }
      //           } catch (_) {}
      //         },
      //         icon: Icon(Icons.search, size: 32),
      //         label: Text("Choose Files", style: textStyleGlobal(level: Level.normal, color: textButtonColorGlobal)),
      //       )
      //     ]),
      //   ),
      // ]),
      onTapUnlessDisable: () {},
      colorSideBox: isHighlighted ? defaultButtonColorGlobal : addButtonColorGlobal,
    );
  }

  Widget displayExcelListWidget() {
    return Text("has data");
  }

  @override
  Widget build(BuildContext context) {
    return (widget.excelEmployeeModel == null) ? dragAndDropWidget(context: context) : displayExcelListWidget();
  }
}

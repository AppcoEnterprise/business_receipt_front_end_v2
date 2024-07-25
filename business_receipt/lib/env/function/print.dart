import 'dart:ui';

import 'package:business_receipt/env/function/cash_money.dart';
import 'package:business_receipt/env/function/customer.dart';
import 'package:business_receipt/env/function/date.dart';
import 'package:business_receipt/env/function/delay_env.dart';
import 'package:business_receipt/env/function/dialog_env.dart';
import 'package:business_receipt/env/function/draw_line.dart';
import 'package:business_receipt/env/function/merge_value_from_model.dart';
import 'package:business_receipt/env/function/money.dart';
import 'package:business_receipt/env/function/rate.dart';
// import 'package:business_receipt/env/function/salary.dart';
import 'package:business_receipt/env/function/text/text_config_env.dart';
import 'package:business_receipt/env/function/text/text_field_env.dart';
import 'package:business_receipt/env/function/text/text_style_env.dart';
import 'package:business_receipt/env/value_env/large_normal_mini_env.dart';
import 'package:business_receipt/env/value_env/other_value_env.dart';
import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
// import 'package:business_receipt/env/value_env/temporary_database/admin_temporary_database.dart';
// import 'package:business_receipt/env/value_env/temporary_database/employee_temporary_database.dart';
import 'package:business_receipt/env/value_env/title_env.dart';
import 'package:business_receipt/env/value_env/valid_button_env.dart';
import 'package:business_receipt/model/admin_model/card/card_combine_model.dart';
import 'package:business_receipt/model/admin_model/card/card_model.dart';
import 'package:business_receipt/model/admin_model/customer_model.dart';
import 'package:business_receipt/model/admin_model/print_model.dart';
import 'package:business_receipt/model/admin_model/rate_model.dart';
import 'package:business_receipt/model/valid_button_model.dart';
import 'package:business_receipt/model/employee_model/amount_and_profit_model.dart';
import 'package:business_receipt/model/employee_model/calculate_model.dart';
import 'package:business_receipt/model/employee_model/card/card_main_stock_model.dart';
import 'package:business_receipt/model/employee_model/card/sell_card_model.dart';
import 'package:business_receipt/model/employee_model/cash_model.dart';
import 'package:business_receipt/model/employee_model/exchange_money_model.dart';
import 'package:business_receipt/model/employee_model/give_card_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/give_money_to_mat_model.dart';
import 'package:business_receipt/model/employee_model/other_in_or_out_come_model.dart';
import 'package:business_receipt/model/employee_model/profile_model.dart';
import 'package:business_receipt/model/employee_model/salary_model.dart';
import 'package:business_receipt/model/employee_model/transfer_order_model.dart';
import 'package:business_receipt/model/money_type_and_value_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<pw.Widget> generateImageListFromStringTest({
  required String text,
  Level? level,
  double? fontSize,
  FontWeight? fontWeight,
  Color color = Colors.black,
  TextDecoration decoration = TextDecoration.none,
}) async {
  if (fontSize == null && level == null) {
    level = Level.normal;
  }
  String detectLanguage({required String string}) {
    String languageCodes = languageDefaultStr;

    final RegExp persian = RegExp(r'^[\u0600-\u06FF]+');
    final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');
    final RegExp chinese = RegExp(r'^[\u4E00-\u9FFF]+');
    final RegExp japanese = RegExp(r'^[\u3040-\u30FF]+');
    final RegExp korean = RegExp(r'^[\uAC00-\uD7AF]+');
    final RegExp ukrainian = RegExp(r'^[\u0400-\u04FF\u0500-\u052F]+');
    final RegExp russian = RegExp(r'^[\u0400-\u04FF]+');
    final RegExp italian = RegExp(r'^[\u00C0-\u017F]+');
    final RegExp french = RegExp(r'^[\u00C0-\u017F]+');
    final RegExp spanish = RegExp(r'[\u00C0-\u024F\u1E00-\u1EFF\u2C60-\u2C7F\uA720-\uA7FF\u1D00-\u1D7F]+');
    final RegExp khmer = RegExp(r'^[\u1780-\u17DD\u17E0-\u17E9\u17F0-\u17F9\u19E0-\u19FF]+');
    final RegExp thai = RegExp(r'^[\u0E00-\u0E7F]+');

    if (persian.hasMatch(string)) languageCodes = "IRR";
    if (arabic.hasMatch(string)) languageCodes = "AED";
    if (chinese.hasMatch(string)) languageCodes = "CNY";
    if (japanese.hasMatch(string)) languageCodes = "JPY";
    if (korean.hasMatch(string)) languageCodes = "KRW";
    if (russian.hasMatch(string)) languageCodes = "RUB";
    if (ukrainian.hasMatch(string)) languageCodes = "UAH";
    if (italian.hasMatch(string)) languageCodes = "EUR";
    if (french.hasMatch(string)) languageCodes = "EUR";
    if (spanish.hasMatch(string)) languageCodes = "EUR";
    if (khmer.hasMatch(string)) languageCodes = "KHR";
    if (thai.hasMatch(string)) languageCodes = "THB";

    return languageCodes;
  }

  Future<pw.Widget> generateImageFromString({required TitlePrintModel textModel}) async {
    final isUSDFont = (textModel.language == "USD");
    if (isUSDFont) {
      pw.FontWeight fontWeightMatch = pw.FontWeight.normal;
      if (fontWeight != null) {
        if (fontWeight == FontWeight.bold) {
          fontWeightMatch = pw.FontWeight.bold;
        }
      }
      return pw.Text(
        textModel.value,
        style: pw.TextStyle(
          fontSize: ((level == null) ? fontSize! : printTextSizeGlobal(level: level)) / usdFontSizeProvider,
          fontWeight: fontWeightMatch,
          color: (color == Colors.black) ? PdfColors.black : PdfColors.white,
          decoration: (decoration == TextDecoration.lineThrough) ? pw.TextDecoration.lineThrough : pw.TextDecoration.none,
        ),
      );
    } else {
      final PictureRecorder recorder = PictureRecorder();
      Canvas canvas = Canvas(recorder);
      TextStyle textStyle = TextStyle(
        fontFamily: textModel.language,
        fontSize: otherFontSizeProvider * (((level == null) ? fontSize! : printTextSizeGlobal(level: level))),
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color,
        decoration: decoration,
      );
      TextSpan span = TextSpan(style: textStyle, text: textModel.value);
      TextPainter tp = TextPainter(text: span, maxLines: 1, textDirection: TextDirection.ltr);
      tp.layout(minWidth: 0, maxWidth: double.infinity);
      tp.paint(canvas, const Offset(0.0, 0.0));
      var picture = recorder.endRecording();
      final pngBytes = await picture.toImage(tp.size.width.toInt(), tp.size.height.toInt());
      final byteData = await pngBytes.toByteData(format: ImageByteFormat.png);
      return pw.Container(
        child: pw.Image(pw.MemoryImage(byteData!.buffer.asUint8List())),
        height: (((level == null) ? fontSize! : printTextSizeGlobal(level: level))),
      );
    }
  }

  List<TitlePrintModel> titlePrintModelList = [TitlePrintModel(language: languageDefaultStr, value: "")];
  int titlePrintModelIndex = 0;
  if (text.isNotEmpty) {
    titlePrintModelList[titlePrintModelIndex] = TitlePrintModel(language: detectLanguage(string: text[0]), value: text[0]);
  }
  for (int textIndex = 1; textIndex < text.length; textIndex++) {
    final bool isMatchLanguagePrevious = (titlePrintModelList[titlePrintModelIndex].language == detectLanguage(string: text[textIndex]));
    if (isMatchLanguagePrevious) {
      titlePrintModelList[titlePrintModelIndex].value = titlePrintModelList[titlePrintModelIndex].value + text[textIndex];
    } else {
      titlePrintModelIndex++;
      titlePrintModelList.add(TitlePrintModel(language: detectLanguage(string: text[textIndex]), value: text[textIndex]));
    }
  }
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [for (int i = 0; i < titlePrintModelList.length; i++) await generateImageFromString(textModel: titlePrintModelList[i])],
  );
}

//----------------------header and footer print--------------------------------------
pw.Widget _headerTitleImagePrint = pw.Container();
pw.Widget _headerSubtitleOrContainerImagePrint = pw.Container();
pw.Widget _employeeNameImagePrint = pw.Container();
pw.Widget _communicationListWidgetImagePrint = pw.Container();
pw.Widget _footerTitleOrContainerImagePrint = pw.Container();
pw.Widget _footerSubtitleOrContainerImagePrint = pw.Container();

//----------------------exchange print--------------------------------------
pw.Widget _subtitleExchangeImagePrint = pw.Container();
pw.Widget _getMoneyExchangeImagePrint = pw.Container();
pw.Widget _giveMoneyExchangeImagePrint = pw.Container();
pw.Widget _rateExchangeImagePrint = pw.Container();
pw.Widget _showRateImagePrint = pw.Container();

//----------------------sell card print------------------------------------------
pw.Widget _subtitleSellCardImagePrint = pw.Container();
pw.Widget _priceCardSellCardImagePrint = pw.Container();
pw.Widget _typeCardSellStrImagePrint = pw.Container();
pw.Widget _qtyCardSellStrImagePrint = pw.Container();
pw.Widget _totalCardSellStrImagePrint = pw.Container();
pw.Widget _calculateByCardSellStrImagePrint = pw.Container();
pw.Widget _mergeCalculateByCardSellStrImagePrint = pw.Container();

//-------------------------other income or outcome---------------------------------------
pw.Widget _subtitleOtherIncomeImagePrint = pw.Container();
pw.Widget _subtitleOtherOutcomeImagePrint = pw.Container();

//-------------------------borrow or lend---------------------------------------
pw.Widget _subtitleBorrowImagePrint = pw.Container();
pw.Widget _subtitleLendImagePrint = pw.Container();

pw.Widget _subtitleTransferImagePrint = pw.Container();
pw.Widget _subtitleReceiveImagePrint = pw.Container();

//-------------------------card stock left---------------------------------------
pw.Widget _subtitleCardStockLeftImagePrint = pw.Container();

//-------------------------card stock---------------------------------------
pw.Widget _subtitleCardStockImagePrint = pw.Container();

//-------------------------give money to mat---------------------------------------
pw.Widget _subtitleGiveMoneyToMatImagePrint = pw.Container();

//-------------------------give money to mat---------------------------------------
pw.Widget _subtitleGiveCardToMatImagePrint = pw.Container();

//-------------------------total history---------------------------------------
pw.Widget _subtitleTotalHistoryImagePrint = pw.Container();

//-------------------------calculate---------------------------------------
pw.Widget _subtitleCalculateImagePrint = pw.Container();

//-------------------------money---------------------------------------
pw.Widget _subtitleShowCardPriceImagePrint = pw.Container();

//-------------------------total borrow or lend---------------------------------------
pw.Widget _subtitleLoanImagePrint = pw.Container();
pw.Widget _subtitleTotalLoanImagePrint = pw.Container();

//-------------------------Count Money Invoice---------------------------------------
// pw.Widget _typeMoneyImagePrint = pw.Container();
// pw.Widget _categoryTypeMoneyImagePrint = pw.Container();
// pw.Widget _validMoneyByImagePrint = pw.Container();
// pw.Widget _orderMoneyImagePrint = pw.Container();
// pw.Widget _qty100MoneyImagePrint = pw.Container();
// pw.Widget _moneyAllCleanImagePrint = pw.Container();

pw.Widget _employeeSignatureImagePrint = pw.Container();
pw.Widget _customerSignatureImagePrint = pw.Container();

Future<void> initPrint() async {
  //-----------------------------header and footer--------------------------------------
  final bool isHasHeaderTitle = (printModelGlobal.header.title.text.isNotEmpty);
  if (isHasHeaderTitle) {
    _headerTitleImagePrint = await generateImageListFromStringTest(level: Level.large, text: printModelGlobal.header.title.text, fontWeight: FontWeight.bold);
  }
  final bool isHasHeaderSubtitle = (printModelGlobal.header.subtitle.text.isNotEmpty);
  if (isHasHeaderSubtitle) {
    _headerSubtitleOrContainerImagePrint = await generateImageListFromStringTest(level: Level.mini, text: printModelGlobal.header.subtitle.text);
  }
  _employeeNameImagePrint = await generateImageListFromStringTest(level: Level.mini, text: profileModelEmployeeGlobal!.name.text);
  _communicationListWidgetImagePrint = pw.Column(children: [
    for (int communicationIndex = 0; communicationIndex < printModelGlobal.communicationList.length; communicationIndex++)
      pw.Row(children: [
        await generateImageListFromStringTest(level: Level.mini, text: printModelGlobal.communicationList[communicationIndex].title.text),
        pw.Text(" : ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
        await generateImageListFromStringTest(level: Level.mini, text: printModelGlobal.communicationList[communicationIndex].subtitle.text),
      ]),
  ]);
  final bool isHasFooterTitle = (printModelGlobal.footer.title.text.isNotEmpty);
  if (isHasFooterTitle) {
    _footerTitleOrContainerImagePrint =
        await generateImageListFromStringTest(level: Level.mini, text: printModelGlobal.footer.title.text, fontWeight: FontWeight.bold);
  }

  final bool isHasFooterSubtitle = (printModelGlobal.footer.subtitle.text.isNotEmpty);
  if (isHasFooterSubtitle) {
    _footerSubtitleOrContainerImagePrint =
        await generateImageListFromStringTest(level: Level.mini, text: printModelGlobal.footer.subtitle.text, fontWeight: FontWeight.bold);
  }

  //----------------------------exchange----------------------------------------------
  _subtitleExchangeImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleExchangeStrPrintGlobal, fontWeight: FontWeight.bold);
  _getMoneyExchangeImagePrint = await generateImageListFromStringTest(level: Level.normal, text: getMoneyExchangeStrPrintGlobal, fontWeight: FontWeight.bold);
  _giveMoneyExchangeImagePrint = await generateImageListFromStringTest(level: Level.normal, text: giveMoneyExchangeStrPrintGlobal, fontWeight: FontWeight.bold);
  _rateExchangeImagePrint = await generateImageListFromStringTest(level: Level.normal, text: rateExchangeStrPrintGlobal, fontWeight: FontWeight.bold);
  _showRateImagePrint = await generateImageListFromStringTest(level: Level.normal, text: showRatePriceStrPrintGlobal, fontWeight: FontWeight.bold);
  //--------------------------sell card---------------------------------------------------
  _subtitleSellCardImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleSellCardStrPrintGlobal, fontWeight: FontWeight.bold);
  _calculateByCardSellStrImagePrint = await generateImageListFromStringTest(level: Level.normal, text: calculateByStrPrintGlobal, fontWeight: FontWeight.bold);
  _priceCardSellCardImagePrint = await generateImageListFromStringTest(level: Level.normal, text: priceCardStrPrintGlobal, fontWeight: FontWeight.bold);
  _typeCardSellStrImagePrint = await generateImageListFromStringTest(level: Level.normal, text: typeCardStrPrintGlobal, fontWeight: FontWeight.bold);
  _qtyCardSellStrImagePrint = await generateImageListFromStringTest(level: Level.normal, text: qtyCardStrPrintGlobal, fontWeight: FontWeight.bold);
  _totalCardSellStrImagePrint = await generateImageListFromStringTest(level: Level.normal, text: totalCardStrPrintGlobal, fontWeight: FontWeight.bold);
  _mergeCalculateByCardSellStrImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: mergeCalculateByCardStrPrintGlobal, fontWeight: FontWeight.bold);

  //-------------------------other income or outcome---------------------------------------
  _subtitleOtherIncomeImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: subtitleOtherOutcomeStrPrintGlobal, fontWeight: FontWeight.bold);
  _subtitleOtherOutcomeImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: subtitleOtherIncomeStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------borrow or lend---------------------------------------
  _subtitleBorrowImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleBorrowStrPrintGlobal, fontWeight: FontWeight.bold);
  _subtitleLendImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleLendStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------card stock---------------------------------------
  _subtitleCardStockImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleCardStockStrPrintGlobal, fontWeight: FontWeight.bold);
  _subtitleCardStockLeftImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: subtitleCardStockLeftStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------give money to mat---------------------------------------
  _subtitleGiveMoneyToMatImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: subtitleGiveMoneyToMoneyStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------give card to mat---------------------------------------
  _subtitleGiveCardToMatImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: subtitleGiveCardToMoneyStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------total history---------------------------------------
  _subtitleTotalHistoryImagePrint =
      await generateImageListFromStringTest(level: Level.normal, text: subtitleTotalHistoryStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------calculate---------------------------------------
  _subtitleCalculateImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleCalculateStrPrintGlobal, fontWeight: FontWeight.bold);

//------------------------money----------------------------
  _subtitleShowCardPriceImagePrint = await generateImageListFromStringTest(level: Level.normal, text: showCardPriceStrPrintGlobal, fontWeight: FontWeight.bold);

// //-------------------------Count Money Invoice---------------------------------------
//   _categoryTypeMoneyImagePrint = await generateImageListFromStringTest(level: Level.mini, text: categoryTypeMoneyStrPrintGlobal, fontWeight: FontWeight.bold);
//   _typeMoneyImagePrint = await generateImageListFromStringTest(level: Level.mini, text: typeMoneyStrPrintGlobal, fontWeight: FontWeight.bold);
//   _orderMoneyImagePrint = await generateImageListFromStringTest(level: Level.mini, text: orderMoneyStrPrintGlobal, fontWeight: FontWeight.bold);
//   _qty100MoneyImagePrint = await generateImageListFromStringTest(level: Level.mini, text: qty100MoneyStrPrintGlobal, fontWeight: FontWeight.bold);
//   _validMoneyByImagePrint = await generateImageListFromStringTest(level: Level.mini, text: validMoneyByStrPrintGlobal, fontWeight: FontWeight.bold);
//   _moneyAllCleanImagePrint = await generateImageListFromStringTest(level: Level.mini, text: moneyAllCleanStrPrintGlobal, fontWeight: FontWeight.bold);

  _employeeSignatureImagePrint = await generateImageListFromStringTest(level: Level.mini, text: employeeSignatureStrPrintGlobal, fontWeight: FontWeight.bold);
  _customerSignatureImagePrint = await generateImageListFromStringTest(level: Level.mini, text: customerSignatureStrPrintGlobal, fontWeight: FontWeight.bold);

//-------------------------total borrow or lend---------------------------------------
  _subtitleLoanImagePrint = await generateImageListFromStringTest(level: Level.normal, text: loanStrPrintGlobal, fontWeight: FontWeight.bold);

  _subtitleTotalLoanImagePrint = await generateImageListFromStringTest(level: Level.normal, text: totalLoanStrPrintGlobal, fontWeight: FontWeight.bold);

  _subtitleTransferImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleTransferStrPrintGlobal, fontWeight: FontWeight.bold);
  _subtitleReceiveImagePrint = await generateImageListFromStringTest(level: Level.normal, text: subtitleReceiverStrPrintGlobal, fontWeight: FontWeight.bold);
}

pw.Widget paddingDrawLineWidget({double? width}) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.mini), bottom: printPaddingSizeGlobal(level: Level.mini)),
    child: pw.Container(color: PdfColors.black, width: width, height: 0.75),
  );
}

Future<pw.Widget> remarkListWidget({required String remark}) async {
  List<String> remarkList = [];
  int separateIndex = 0;
  for (int remarkIndex = 0; remarkIndex < remark.length; remarkIndex++) {
    if (remark[remarkIndex] == "|") {
      remarkList.add(remark.substring(separateIndex, remarkIndex));
      separateIndex = remarkIndex + 1;
    }
  }
  if (separateIndex == 0) {
    return await generateImageListFromStringTest(level: Level.mini, text: "remark: $remark");
  } else {
    return pw.Column(children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [pw.Text("remark:", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider))],
      ),
      for (int remarkIndex = 0; remarkIndex < remarkList.length; remarkIndex++)
        pw.Row(children: [await generateImageListFromStringTest(level: Level.mini, text: "  ${remarkList[remarkIndex]}")])
    ]);
  }
}

Future<void> printInvoice({
  bool isShowHeaderAndFooter = true,
  required pw.Widget invoiceBodyWidget,
  required String invoiceId,
  required DateTime invoiceDate,
  required String remark,
  double printWidth = widthPrint,
}) async {
  final pw.Widget remarkImage = await remarkListWidget(remark: remark);
  final pw.Document pdf = pw.Document();
  pw.Widget setWidthWidget() {
    pw.Widget paddingVerticalWidget() {
      pw.Widget headerWidget() {
        return pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_headerTitleImagePrint]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_headerSubtitleOrContainerImagePrint]),
        ]);
      }

      pw.Widget footerWidget() {
        pw.Widget invoiceIdAndDateAndEmployeeNameWidget() {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            (invoiceId.isEmpty)
                ? pw.Container()
                : pw.Text("$idStrPrintGlobal: $invoiceId", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
            pw.Text("$dateStrPrintGlobal: ${formatFullDateToStr(date: invoiceDate)}",
                style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
            pw.Row(children: [
              pw.Text("$nameStrPrintGlobal: ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
              _employeeNameImagePrint
            ])
            // pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            //   pw.Text("$idStrPrintGlobal: $invoiceId", style: pw.TextStyle(fontSize: printOrCardTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
            //   pw.Text("$dateStrPrintGlobal: ${formatDateStr(date: invoiceDate)}", style: pw.TextStyle(fontSize: printOrCardTextSizeGlobal(level: Level.mini) / usdFontSizeProvider))
            // ]),
          ]);
        }

        pw.Widget paddingRemarkWidget() {
          return remark.isEmpty ? pw.Container() : pw.Padding(padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.mini)), child: remarkImage);
        }

        final bool isCommunicationEmpty = printModelGlobal.communicationList.isEmpty;
        final bool isHasFooterTitle = (printModelGlobal.footer.title.text.isNotEmpty);
        final bool isHasFooterSubtitle = (printModelGlobal.footer.subtitle.text.isNotEmpty);
        return pw.Column(children: [
          paddingRemarkWidget(),
          paddingDrawLineWidget(),
          invoiceIdAndDateAndEmployeeNameWidget(),
          isCommunicationEmpty ? pw.Container() : paddingDrawLineWidget(),
          _communicationListWidgetImagePrint,
          (isHasFooterTitle || isHasFooterSubtitle) ? paddingDrawLineWidget() : pw.Container(),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_footerTitleOrContainerImagePrint]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_footerSubtitleOrContainerImagePrint]),
          _employeeSignatureImagePrint,
          _customerSignatureImagePrint,
        ]);
      }

      return pw.Padding(
        padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.normal), right: printPaddingSizeGlobal(level: Level.normal)),
        child: pw.Column(
          children: [
            isShowHeaderAndFooter ? headerWidget() : pw.Container(),
            invoiceBodyWidget,
            isShowHeaderAndFooter ? footerWidget() : pw.Container(),
          ],
        ),
      );
    }

    return pw.Container(width: printWidth, child: paddingVerticalWidget());
  }

  pdf.addPage(pw.Page(
    margin: pw.EdgeInsets.zero,
    // pageFormat: PdfPageFormat.a4,
    pageFormat: PdfPageFormat.a3,
    build: (pw.Context context) {
      return setWidthWidget();
    },
  ));
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}

Future<void> printExchangeMoneyInvoice({required ExchangeMoneyModel exchangeModel, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingExchangeInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleExchangeImagePrint]);
  }

  Future<pw.Widget> getExchangeCalculationDetail() async {
    Future<pw.Widget> paddingVerticalCalculateExchangeWidget() async {
      Future<pw.Widget> calculateExchangeWidget() async {
        Future<pw.Widget> calculationExchangeElement({required int exchangeIndex}) async {
          final bool isBuyRate = exchangeModel.exchangeList[exchangeIndex].rate!.isBuyRate!;
          final String operator = isBuyRate ? "X" : "/";

          final String getMoneyStr = exchangeModel.exchangeList[exchangeIndex].getMoney.text;
          final String getMoneyTypeStr =
              isBuyRate ? exchangeModel.exchangeList[exchangeIndex].rate!.rateType.first : exchangeModel.exchangeList[exchangeIndex].rate!.rateType.last;
          final pw.Widget getMoneyTypeImage =
              await generateImageListFromStringTest(level: Level.normal, text: findMoneyModelByMoneyType(moneyType: getMoneyTypeStr).moneyTypeLanguagePrint!);

          final String giveMoneyStr = exchangeModel.exchangeList[exchangeIndex].giveMoney.text;
          final String giveMoneyTypeStr =
              isBuyRate ? exchangeModel.exchangeList[exchangeIndex].rate!.rateType.last : exchangeModel.exchangeList[exchangeIndex].rate!.rateType.first;
          final pw.Widget giveMoneyTypeImage =
              await generateImageListFromStringTest(level: Level.normal, text: findMoneyModelByMoneyType(moneyType: giveMoneyTypeStr).moneyTypeLanguagePrint!);

          final String rateValueStr = exchangeModel.exchangeList[exchangeIndex].rate!.discountValue.text;

          // pw.Widget gottenMoneyType = (gottenCurrencyModel.moneyTypeLanguage == null)
          //     ? pw.Text(gottenCurrencyModel.moneyType, style: pw.TextStyle(fontSize: 10))
          //     : await generateImageListFromStringTest(text: gottenCurrencyModel.moneyTypeLanguage!, fontFamily: "KHR", imageHeight: 16, fontWeight: FontWeight.bold);
          // CurrencyModel givenCurrencyModel =
          //     getCurrencyModelByMoneyType(exchangeModel.currencyModelList, isBuyRate ? exchangeModel.exchangeList[index].rate!.rateType.last : exchangeModel.exchangeList[index].rate!.rateType.first);
          // pw.Widget givenMoneyType = (givenCurrencyModel.moneyTypeLanguage == null)
          //     ? pw.Text(givenCurrencyModel.moneyType, style: pw.TextStyle(fontSize: 10))
          //     : await generateImageListFromStringTest(text: givenCurrencyModel.moneyTypeLanguage!, fontFamily: "KHR", imageHeight: 16, fontWeight: FontWeight.bold);

          return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text("$getMoneyStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
            getMoneyTypeImage,
            pw.Text(" $operator $rateValueStr = $giveMoneyStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
            giveMoneyTypeImage
          ]);
        }

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            for (int exchangeIndex = 0; exchangeIndex < exchangeModel.exchangeList.length; exchangeIndex++)
              await calculationExchangeElement(exchangeIndex: exchangeIndex)
          ],
        );
      }

      return pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: paddingSizeGlobal(level: Level.normal)), child: await calculateExchangeWidget());
    }

    return pw.Container(color: PdfColors.grey400, width: double.infinity, child: await paddingVerticalCalculateExchangeWidget());
  }

  Future<pw.Widget> getExchangeMergeCalculation() async {
    List<MoneyTypeAndValueModel> getFromCustomerMoneyList = [];
    List<MoneyTypeAndValueModel> giveToCustomerMoneyList = [];
    exchangeToMerge(
        getFromCustomerMoneyList: getFromCustomerMoneyList,
        giveToCustomerMoneyList: giveToCustomerMoneyList,
        exchangeMoneyModel: exchangeModel,
        profitList: []);

    if (exchangeModel.exchangeList.length > 1) {
      Future<pw.Widget> getOrGiveMoneyWidget({required List<MoneyTypeAndValueModel> getOrGiveFromCustomerMoneyList}) async {
        Future<pw.Widget> paddingLeftWidget({required int getOrGiveIndex}) async {
          final pw.Widget moneyTypeLanguageImage = await generateImageListFromStringTest(
            text: findMoneyModelByMoneyType(moneyType: getOrGiveFromCustomerMoneyList[getOrGiveIndex].moneyType).moneyTypeLanguagePrint!,
            fontWeight: FontWeight.bold,
            level: Level.normal,
          );
          pw.Widget moneyTypeAndAmountWidget() {
            final String amountStr = formatAndLimitNumberTextGlobal(
                valueStr: getOrGiveFromCustomerMoneyList[getOrGiveIndex].value.toString(), isRound: false, isAllowZeroAtLast: false);
            return pw.Row(children: [
              pw.Text(" (${getOrGiveFromCustomerMoneyList[getOrGiveIndex].moneyType}) : ",
                  style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              pw.Text("$amountStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.large) / usdFontSizeProvider)),
            ]);
          }

          final pw.Widget symbolImage = await generateImageListFromStringTest(
            text: findMoneyModelByMoneyType(moneyType: getOrGiveFromCustomerMoneyList[getOrGiveIndex].moneyType).symbol!,
            fontWeight: FontWeight.bold,
            level: Level.normal,
          );

          return pw.Padding(
            padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.large)),
            child: pw.Row(children: [moneyTypeLanguageImage, moneyTypeAndAmountWidget(), symbolImage]),
          );
        }

        return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
          child: pw.Column(children: [
            for (int getOrGiveIndex = 0; getOrGiveIndex < getOrGiveFromCustomerMoneyList.length; getOrGiveIndex++)
              await paddingLeftWidget(getOrGiveIndex: getOrGiveIndex)
          ]),
        );
      }

      Future<pw.Widget> rateListWidget() async {
        Future<pw.Widget> rateWidget({required int exchangeIndex}) async {
          final bool isBuyRate = exchangeModel.exchangeList[exchangeIndex].rate!.isBuyRate!;
          final String rateTypeFirstStr = exchangeModel.exchangeList[exchangeIndex].rate!.rateType.first;
          final String rateTypeLastStr = exchangeModel.exchangeList[exchangeIndex].rate!.rateType.last;
          final pw.Widget rateFirstSymbolImage = await generateImageListFromStringTest(
            text: findMoneyModelByMoneyType(moneyType: rateTypeFirstStr).symbol!,
            fontWeight: FontWeight.bold,
            level: Level.normal,
          );
          final pw.Widget rateLastSymbolImage = await generateImageListFromStringTest(
            text: findMoneyModelByMoneyType(moneyType: rateTypeLastStr).symbol!,
            fontWeight: FontWeight.bold,
            level: Level.normal,
          );

          final String rateStr = exchangeModel.exchangeList[exchangeIndex].rate!.discountValue.text;

          return pw.Padding(
            padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.large)),
            child: isBuyRate
                ? pw.Row(children: [
                    pw.Text("$rateTypeFirstStr -> $rateTypeLastStr :  $rateStr  ( ",
                        style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
                    rateFirstSymbolImage,
                    pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
                    rateLastSymbolImage,
                    pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
                  ])
                : pw.Row(children: [
                    pw.Text("$rateTypeLastStr -> $rateTypeFirstStr :  $rateStr  ( ",
                        style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
                    rateLastSymbolImage,
                    pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
                    rateFirstSymbolImage,
                    pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
                  ]),
          );
        }

        return pw.Column(children: [
          for (int exchangeIndex = 0; exchangeIndex < exchangeModel.exchangeList.length; exchangeIndex++) await rateWidget(exchangeIndex: exchangeIndex)
        ]);
      }

      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        _getMoneyExchangeImagePrint,
        await getOrGiveMoneyWidget(getOrGiveFromCustomerMoneyList: getFromCustomerMoneyList),
        _giveMoneyExchangeImagePrint,
        await getOrGiveMoneyWidget(getOrGiveFromCustomerMoneyList: giveToCustomerMoneyList),
        _rateExchangeImagePrint,
        await rateListWidget(),
      ]);
    } else {
      final bool isBuyRate = exchangeModel.exchangeList.first.rate!.isBuyRate!;
      final String rateTypeFirstStr = exchangeModel.exchangeList.first.rate!.rateType.first;
      final String rateTypeLastStr = exchangeModel.exchangeList.first.rate!.rateType.last;
      final String rateStr = exchangeModel.exchangeList.first.rate!.discountValue.text;
      final String getMoneyStr = exchangeModel.exchangeList.first.getMoney.text;
      final String getMoneyTypeStr = isBuyRate ? rateTypeFirstStr : rateTypeLastStr;
      final String giveMoneyStr = exchangeModel.exchangeList.first.giveMoney.text;
      final String giveMoneyTypeStr = isBuyRate ? rateTypeLastStr : rateTypeFirstStr;

      Future<pw.Widget> getOrGiveExchangeWidget({required pw.Widget image, required String moneyType, required String getOrGiveStr}) async {
        final pw.Widget moneyTypeLanguageImage = await generateImageListFromStringTest(
          text: findMoneyModelByMoneyType(moneyType: moneyType).moneyTypeLanguagePrint!,
          fontWeight: FontWeight.bold,
          level: Level.normal,
        );
        // final pw.Widget rateFirstSymbolImage = await generateImageListFromStringTest(
        //   text: findMoneyModelByMoneyType(moneyType: moneyType).symbol,
        //   fontWeight: FontWeight.bold,
        //   level: Level.normal,
        // );
        return pw.Row(children: [
          image,
          pw.Text(" ($moneyType) : ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          pw.Text("$getOrGiveStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.large) / usdFontSizeProvider)),
          moneyTypeLanguageImage,
        ]);
      }

      Future<pw.Widget> rateWidget() async {
        final pw.Widget rateFirstSymbolImage = await generateImageListFromStringTest(
          text: findMoneyModelByMoneyType(moneyType: getMoneyTypeStr).symbol!,
          fontWeight: FontWeight.bold,
          level: Level.normal,
        );
        final pw.Widget rateLastSymbolImage = await generateImageListFromStringTest(
          text: findMoneyModelByMoneyType(moneyType: giveMoneyTypeStr).symbol!,
          fontWeight: FontWeight.bold,
          level: Level.normal,
        );
        return pw.Row(children: [
          _rateExchangeImagePrint,
          pw.Text(" : $rateStr  ( ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          rateFirstSymbolImage,
          pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          rateLastSymbolImage,
          pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
        ]);
      }

      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.start, children: [
        await getOrGiveExchangeWidget(getOrGiveStr: getMoneyStr, moneyType: getMoneyTypeStr, image: _getMoneyExchangeImagePrint),
        await getOrGiveExchangeWidget(getOrGiveStr: giveMoneyStr, moneyType: giveMoneyTypeStr, image: _giveMoneyExchangeImagePrint),
        await rateWidget(),
      ]);
    }
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    await getExchangeCalculationDetail(),
    paddingDrawLineWidget(),
    await getExchangeMergeCalculation(),
  ]);
  await printInvoice(invoiceBodyWidget: invoiceBody, invoiceId: exchangeModel.id!, invoiceDate: exchangeModel.date!, remark: exchangeModel.remark.text);
  closeDialogGlobal(context: context);
}

Future<void> printSellCardInvoice({required SellCardModel sellCardModel, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingSellCardInvoiceStrGlobal);

  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleSellCardImagePrint]);
  }

  pw.Widget calculateResult({
    required String operatorStr,
    required double getMoneyNumber,
    required String getMoneyType,
    double? resultNumber,
    String? resultMoneyType,
    bool isGetMoneyRound = false,
  }) {
    const double distanceBetweenOperatorAndValue = 20;
    final String getMoneyStr = formatAndLimitNumberTextGlobal(
      valueStr: getMoneyNumber.toString(),
      isRound: isGetMoneyRound,
      places: findMoneyModelByMoneyType(moneyType: getMoneyType).decimalPlace!,
      isAllowZeroAtLast: false,
    );
    final TextStyle textStyle = TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / cardFontSizeProvider);
    final pw.TextStyle pwTextStyle = pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / cardFontSizeProvider);
    final double getMoneyTextWidth = findTextSize(text: "$getMoneyType $getMoneyStr", style: textStyle).width + distanceBetweenOperatorAndValue;

    final bool isNoResult = ((resultNumber == null) || (resultMoneyType == null));
    double resultTextWidth = 0;
    String giveMoneyStr = "";
    if (!isNoResult) {
      giveMoneyStr = formatAndLimitNumberTextGlobal(
        valueStr: resultNumber.toString(),
        isRound: (resultNumber > 0),
        places: findMoneyModelByMoneyType(moneyType: resultMoneyType).decimalPlace!,
        isAllowZeroAtLast: false,
      );
      resultTextWidth = findTextSize(text: "$resultMoneyType $giveMoneyStr", style: textStyle).width + distanceBetweenOperatorAndValue;
    }
    final double textWidthLongest = (getMoneyTextWidth > resultTextWidth) ? getMoneyTextWidth : resultTextWidth;

    pw.Widget getMoneyWidget() {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Container(
            height: 15,
            width: textWidthLongest,
            child: pw.Stack(
              children: [
                pw.Positioned(top: -2.5, left: 0, child: pw.Text(operatorStr, style: pwTextStyle)),
                pw.Positioned(bottom: 0, right: 0, child: pw.Text("$getMoneyType $getMoneyStr", style: pwTextStyle)),
              ],
            ),
          ),
        ],
      );
    }

    pw.Widget resultWidget() {
      return isNoResult
          ? pw.Container()
          : pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  height: 14,
                  width: textWidthLongest,
                  child: pw.Stack(
                    children: [
                      pw.Positioned(top: 1, left: 0, child: paddingDrawLineWidget(width: textWidthLongest)),
                      pw.Positioned(top: 3, bottom: 0, right: 0, child: pw.Text("$resultMoneyType $giveMoneyStr", style: pwTextStyle)),
                    ],
                  ),
                ),
              ],
            );
    }

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [getMoneyWidget(), resultWidget()]);
  }

  pw.Widget customerMoneyListWidget({required CalculateSellCardModel calculateSellCardModel}) {
    pw.Widget customerMoneyWidget({required int customerMoneyIndex}) {
      final RateForCalculateModel? rateOrNull = calculateSellCardModel.customerMoneyList[customerMoneyIndex].rate;
      final bool isHasRate = (rateOrNull != null);
      if (isHasRate) {
        final String operatorStr = rateOrNull.isBuyRate! ? "/" : "x";
        final double rateValueNumber = textEditingControllerToDouble(controller: rateOrNull.discountValue)!;
        // final String rateValueMoneyTypeStr = rateOrNull.isBuyRate! ? rateOrNull.rateType.first : rateOrNull.rateType.last;

        double previousValueNumber = calculateSellCardModel.totalMoney;
        final bool isCustomerMoneyFirstIndex = (customerMoneyIndex > 0);
        if (isCustomerMoneyFirstIndex) {
          previousValueNumber = calculateSellCardModel.customerMoneyList[customerMoneyIndex - 1].giveMoney!;
        }

        final double convertMoneyNumber = rateOrNull.isBuyRate! ? (previousValueNumber / rateValueNumber) : (previousValueNumber * rateValueNumber);
        final String convertMoneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyIndex].moneyType!;

        final double getMoneyNumber = double.parse(formatAndLimitNumberTextGlobal(
          valueStr: calculateSellCardModel.customerMoneyList[customerMoneyIndex].getMoney!,
          isRound: false,
          isAddComma: false,
          isAllowZeroAtLast: false,
        ));

        final double giveMoneyNumber = calculateSellCardModel.customerMoneyList[customerMoneyIndex].giveMoney!;

        return pw.Column(children: [
          calculateResult(
            operatorStr: operatorStr,
            getMoneyNumber: rateValueNumber,
            getMoneyType:
                "${rateOrNull.isBuyRate! ? rateOrNull.rateType.first : rateOrNull.rateType.last} -> ${rateOrNull.isBuyRate! ? rateOrNull.rateType.last : rateOrNull.rateType.first}",
            resultNumber: convertMoneyNumber,
            resultMoneyType: convertMoneyTypeStr,
          ),
          calculateResult(
            operatorStr: "-",
            getMoneyNumber: getMoneyNumber,
            getMoneyType: convertMoneyTypeStr,
            resultNumber: giveMoneyNumber,
            resultMoneyType: convertMoneyTypeStr,
          ),
        ]);
      } else {
        final double getMoneyNumber = double.parse(formatAndLimitNumberTextGlobal(
          valueStr: calculateSellCardModel.customerMoneyList[customerMoneyIndex].getMoney!,
          isRound: false,
          isAddComma: false,
          isAllowZeroAtLast: false,
        ));

        final double giveMoneyNumber = calculateSellCardModel.customerMoneyList[customerMoneyIndex].giveMoney!;

        final String moneyTypeStr = calculateSellCardModel.customerMoneyList[customerMoneyIndex].moneyType!;
        return calculateResult(
          operatorStr: "-",
          getMoneyNumber: getMoneyNumber,
          getMoneyType: moneyTypeStr,
          resultNumber: giveMoneyNumber,
          resultMoneyType: moneyTypeStr,
        );
      }
    }

    return pw.Column(children: [
      for (int customerMoneyIndex = 0; customerMoneyIndex < calculateSellCardModel.customerMoneyList.length; customerMoneyIndex++)
        customerMoneyWidget(customerMoneyIndex: customerMoneyIndex),
    ]);
  }

  Future<pw.Widget> cardSellElementByMoneyType() async {
    Future<pw.Widget> cardListWidget() async {
      Future<pw.Widget> moneyWidget({required int moneyIndex}) async {
        pw.Widget tableRowWidget(
            {required pw.Widget categoryWidget, required pw.Widget qtyWidget, required pw.Widget priceWidget, required pw.Widget totalWidget}) {
          return pw.Padding(
            padding: pw.EdgeInsets.symmetric(horizontal: printPaddingSizeGlobal(level: Level.normal)),
            child: pw.Row(children: [
              pw.Expanded(flex: 6, child: pw.Row(children: [categoryWidget])),
              pw.Expanded(flex: 3, child: pw.Row(children: [qtyWidget])),
              pw.Expanded(flex: 4, child: pw.Row(children: [priceWidget])),
              pw.Expanded(flex: 5, child: pw.Row(children: [pw.Spacer(), totalWidget])),
            ]),
          );
        }

        Future<pw.Widget> totalByWidget() async {
          pw.Widget moneyTypeWidget = await generateImageListFromStringTest(
            level: Level.normal,
            text: findMoneyModelByMoneyType(moneyType: sellCardModel.moneyTypeList[moneyIndex].calculate.moneyType).moneyTypeLanguagePrint!,
            fontWeight: FontWeight.bold,
          );
          return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_calculateByCardSellStrImagePrint, moneyTypeWidget]);
        }

        pw.Widget headerWidget() {
          return pw.Container(
            color: PdfColors.grey400,
            width: double.infinity,
            child: tableRowWidget(
              categoryWidget: _typeCardSellStrImagePrint,
              qtyWidget: _qtyCardSellStrImagePrint,
              priceWidget: _priceCardSellCardImagePrint,
              totalWidget: _totalCardSellStrImagePrint,
            ),
          );
        }

        Future<pw.Widget> bodyWidget() async {
          Future<pw.Widget> cardWidget({required int cardIndex}) async {
            final String companyName = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].cardCompanyName;
            final String category = formatAndLimitNumberTextGlobal(
                valueStr: sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].category.toString(), isRound: false, isAllowZeroAtLast: false);
            final pw.Widget categoryWidget = await generateImageListFromStringTest(
              level: Level.mini,
              text: "$companyName x $category",
              fontWeight: (printModelGlobal.selectedLanguage! == languageDefaultStr) ? FontWeight.normal : FontWeight.bold,
            );

            final String moneyTypeStr = sellCardModel.moneyTypeList[moneyIndex].calculate.moneyType;

            final int qtyNumber = sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].qty;
            final double priceNumber = double.parse(sellCardModel.moneyTypeList[moneyIndex].cardList[cardIndex].sellPrice.discountValue);
            final double totalNumber = qtyNumber * priceNumber;

            final String qtyStr = formatAndLimitNumberTextGlobal(valueStr: qtyNumber.toString(), isRound: false, isAllowZeroAtLast: false);
            final String priceStr = formatAndLimitNumberTextGlobal(valueStr: priceNumber.toString(), isRound: false, isAllowZeroAtLast: false);
            final String totalStr = formatAndLimitNumberTextGlobal(
              valueStr: totalNumber.toString(),
              isRound: true,
              places: findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!,
              isAllowZeroAtLast: false,
            );

            final pw.Widget qtyTextWidget =
                pw.Text(qtyStr, style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / cardFontSizeProvider, fontWeight: pw.FontWeight.bold));
            final pw.Widget priceTextWidget = pw.Text(priceStr, style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / cardFontSizeProvider));
            final pw.Widget totalTextWidget = pw.Text(totalStr, style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / cardFontSizeProvider));

            return tableRowWidget(categoryWidget: categoryWidget, qtyWidget: qtyTextWidget, priceWidget: priceTextWidget, totalWidget: totalTextWidget);
          }

          return pw.Column(children: [
            for (int cardIndex = 0; cardIndex < sellCardModel.moneyTypeList[moneyIndex].cardList.length; cardIndex++) await cardWidget(cardIndex: cardIndex)
          ]);
        }

        pw.Widget footerWidget() {
          pw.Widget totalTextWidget() {
            final String moneyTypeStr = sellCardModel.moneyTypeList[moneyIndex].calculate.moneyType;
            final String totalStr = formatAndLimitNumberTextGlobal(
                valueStr: sellCardModel.moneyTypeList[moneyIndex].calculate.totalMoney.toString(), isRound: false, isAllowZeroAtLast: false);
            return pw.Text("$moneyTypeStr $totalStr", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / cardFontSizeProvider));
          }

          pw.Widget getMoneyOrMergeWidget() {
            final bool isMergePrice = (sellCardModel.mergeCalculate != null);
            if (isMergePrice) {
              final RateForCalculateModel? rateOrNull = sellCardModel.moneyTypeList[moneyIndex].rate;
              final bool isHasRate = (rateOrNull != null);
              if (isHasRate) {
                final String operatorStr = rateOrNull.isBuyRate! ? "/" : "x";
                final double totalMoneyNumber = textEditingControllerToDouble(controller: rateOrNull.discountValue)!;
                // final String totalMoneyTypeStr = rateOrNull.isBuyRate! ? rateOrNull.rateType.first : rateOrNull.rateType.last;

                final double convertMoneyNumber = sellCardModel.moneyTypeList[moneyIndex].calculate.convertMoney!;
                // print("sellCardModel.moneyTypeList[moneyIndex].calculate => ${jsonEncode(sellCardModel.moneyTypeList[moneyIndex].calculate.toJson())}");
                // final String convertMoneyTypeStr = rateOrNull.isBuyRate! ? rateOrNull.rateType.last : rateOrNull.rateType.first;
                // print("convertMoneyNumber => $convertMoneyNumber");
                return calculateResult(
                  operatorStr: operatorStr,
                  getMoneyNumber: totalMoneyNumber,
                  getMoneyType:
                      "${rateOrNull.isBuyRate! ? rateOrNull.rateType.first : rateOrNull.rateType.last} -> ${rateOrNull.isBuyRate! ? rateOrNull.rateType.last : rateOrNull.rateType.first}",
                  resultNumber: convertMoneyNumber,
                  resultMoneyType: rateOrNull.isBuyRate! ? rateOrNull.rateType.first : rateOrNull.rateType.last,
                );
              } else {
                return pw.Container();
              }
            } else {
              return customerMoneyListWidget(calculateSellCardModel: sellCardModel.moneyTypeList[moneyIndex].calculate);
            }
          }

          return pw.Padding(
            padding: pw.EdgeInsets.only(right: printPaddingSizeGlobal(level: Level.normal)),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [totalTextWidget(), getMoneyOrMergeWidget()]),
          );
        }

        return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.large)),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              await totalByWidget(),
              paddingDrawLineWidget(),
              headerWidget(),
              paddingDrawLineWidget(),
              await bodyWidget(),
              paddingDrawLineWidget(),
              footerWidget()
            ],
          ),
        );
      }

      return pw.Column(
          children: [for (int moneyIndex = 0; moneyIndex < sellCardModel.moneyTypeList.length; moneyIndex++) await moneyWidget(moneyIndex: moneyIndex)]);
    }

    return await cardListWidget();
  }

  Future<pw.Widget> mergeCalculateByMoneyTypeWidget() async {
    Future<pw.Widget> titleAndCalculateWidget() async {
      Future<pw.Widget> totalByWidget() async {
        pw.Widget moneyTypeWidget = await generateImageListFromStringTest(
          level: Level.normal,
          text: findMoneyModelByMoneyType(moneyType: sellCardModel.mergeCalculate!.moneyType).moneyTypeLanguagePrint!,
          fontWeight: FontWeight.bold,
        );
        return pw.Padding(
          padding: pw.EdgeInsets.only(right: printPaddingSizeGlobal(level: Level.normal)),
          child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [_mergeCalculateByCardSellStrImagePrint, moneyTypeWidget]),
        );
      }

      pw.Widget calculateListWidget() {
        pw.Widget sumTotalEachMoneyTypeWidget() {
          pw.Widget sumWidget({required int moneyIndex}) {
            final double convertNumber = sellCardModel.moneyTypeList[moneyIndex].calculate.convertMoney!.abs();
            String convertMoneyTypeStr = sellCardModel.moneyTypeList[moneyIndex].calculate.moneyType;
            final RateForCalculateModel? rate = sellCardModel.moneyTypeList[moneyIndex].rate;
            final bool isHasRate = (rate != null);
            if (isHasRate) {
              convertMoneyTypeStr = rate.isBuyRate! ? rate.rateType.first : rate.rateType.last;
            }

            final bool isHasSingleSize = (sellCardModel.moneyTypeList.length == 1);
            if (isHasSingleSize) {
              final String convertStr = formatAndLimitNumberTextGlobal(
                valueStr: (sellCardModel.mergeCalculate!.convertMoney == null)
                    ? sellCardModel.mergeCalculate!.totalMoney.abs().toString()
                    : sellCardModel.mergeCalculate!.convertMoney!.abs().toString(),
                isRound: true,
                isAllowZeroAtLast: false,
              );

              return pw.Padding(
                padding: pw.EdgeInsets.only(right: printPaddingSizeGlobal(level: Level.normal)),
                child:
                    pw.Text("$convertMoneyTypeStr $convertStr", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              );
            } else {
              final bool isLastIndex = ((sellCardModel.moneyTypeList.length - 1) == moneyIndex);
              if (isLastIndex) {
                final String totalMoneyTypeStr = sellCardModel.mergeCalculate!.moneyType;
                final double totalNumber = sellCardModel.mergeCalculate!.totalMoney;

                return pw.Padding(
                  padding: pw.EdgeInsets.only(right: printPaddingSizeGlobal(level: Level.normal)),
                  child: calculateResult(
                      isGetMoneyRound: true,
                      getMoneyNumber: convertNumber,
                      getMoneyType: convertMoneyTypeStr,
                      operatorStr: "+",
                      resultNumber: totalNumber,
                      resultMoneyType: totalMoneyTypeStr),
                );
              } else {
                final bool isFirstIndex = (moneyIndex == 0);
                return pw.Padding(
                  padding: pw.EdgeInsets.only(right: printPaddingSizeGlobal(level: Level.normal)),
                  child: calculateResult(
                      isGetMoneyRound: true, getMoneyNumber: convertNumber, getMoneyType: convertMoneyTypeStr, operatorStr: isFirstIndex ? "" : "+"),
                );
              }
            }
          }

          return pw.Column(
              children: [for (int moneyIndex = 0; moneyIndex < sellCardModel.moneyTypeList.length; moneyIndex++) sumWidget(moneyIndex: moneyIndex)]);
        }

        pw.Widget paddingCustomerMoneyListWidget() {
          return pw.Padding(
              padding: pw.EdgeInsets.only(right: printPaddingSizeGlobal(level: Level.normal)),
              child: customerMoneyListWidget(calculateSellCardModel: sellCardModel.mergeCalculate!));
        }

        return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [sumTotalEachMoneyTypeWidget(), paddingCustomerMoneyListWidget()]);
      }

      return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
          child: pw.Column(children: [await totalByWidget(), calculateListWidget()]));
    }

    final bool isMergePrice = (sellCardModel.mergeCalculate != null);
    return isMergePrice ? await titleAndCalculateWidget() : pw.Container();
  }

  pw.Widget invoiceBody = pw.Column(children: [subtitleWidget(), await cardSellElementByMoneyType(), await mergeCalculateByMoneyTypeWidget()]);

  await printInvoice(invoiceBodyWidget: invoiceBody, invoiceId: sellCardModel.id!, invoiceDate: sellCardModel.date!, remark: sellCardModel.remark.text);
  closeDialogGlobal(context: context);
}

Future<void> printOtherInOrOutComeInvoice({required OtherInOrOutComeModel otherInOrOutComeModel, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingInOrOutComeInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        (textEditingControllerToDouble(controller: otherInOrOutComeModel.value)! >= 0) ? _subtitleOtherIncomeImagePrint : _subtitleOtherOutcomeImagePrint
      ],
    );
  }

  final String moneyTypeStr = otherInOrOutComeModel.moneyType!;
  final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  pw.Widget amountImage = await generateImageListFromStringTest(
    level: Level.normal,
    text:
        "${(textEditingControllerToDouble(controller: otherInOrOutComeModel.value)! >= 0) ? getMoneyExchangeStrPrintGlobal : giveMoneyExchangeStrPrintGlobal} ($moneyTypeStr): ${otherInOrOutComeModel.value.text} $moneyTypeLanguageStr",
    fontWeight: FontWeight.bold,
  );

  pw.Widget otherInOrOutComeWidget() {
    return pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)), child: pw.Row(children: [amountImage]));
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    otherInOrOutComeWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: otherInOrOutComeModel.id!,
    invoiceDate: otherInOrOutComeModel.date!,
    remark: otherInOrOutComeModel.remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> printBorrowOrLendInvoice({required MoneyCustomerModel borrowOrLend, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingBorrowOrLendInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [(textEditingControllerToDouble(controller: borrowOrLend.value)! >= 0) ? _subtitleLendImagePrint : _subtitleBorrowImagePrint],
    );
  }

  final String moneyTypeStr = borrowOrLend.moneyType!;
  final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  pw.Widget amountImage = await generateImageListFromStringTest(
    level: Level.normal,
    text:
        "${(textEditingControllerToDouble(controller: borrowOrLend.value)! >= 0) ? getMoneyExchangeStrPrintGlobal : giveMoneyExchangeStrPrintGlobal} ($moneyTypeStr): ${borrowOrLend.value.text} $moneyTypeLanguageStr",
    fontWeight: FontWeight.bold,
  );

  pw.Widget customerNameImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$customerNameStrPrintGlobal: ${borrowOrLend.customerName}",
    fontWeight: FontWeight.bold,
  );

  pw.Widget borrowOrLendWidget() {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [amountImage, customerNameImage]),
    );
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    borrowOrLendWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: borrowOrLend.id!,
    invoiceDate: borrowOrLend.date!,
    remark: borrowOrLend.remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> printCardStockInvoice({required InformationAndCardMainStockModel cardStockModel, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingAddCardStockInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleCardStockImagePrint]);
  }

  pw.Widget qtyImage = await generateImageListFromStringTest(
    level: Level.normal,
    text:
        "$getCardStrPrintGlobal ${cardStockModel.cardCompanyName} x ${cardStockModel.category}: ${cardStockModel.mainPrice.maxStock} $pieceCardStrPrintGlobal",
    fontWeight: FontWeight.bold,
  );

  final String moneyTypeStr = cardStockModel.mainPrice.moneyType!;
  final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  final String cardMainPriceStr = formatAndLimitNumberTextGlobal(
    valueStr: (cardStockModel.mainPrice.maxStock * textEditingControllerToDouble(controller: cardStockModel.mainPrice.price)!).toString(),
    isRound: false,
  );
  pw.Widget amountImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$giveMoneyExchangeStrPrintGlobal ($moneyTypeStr): $cardMainPriceStr $moneyTypeLanguageStr",
    fontWeight: FontWeight.bold,
  );

  pw.Widget priceImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$priceForCardStrPrintGlobal: ${cardStockModel.mainPrice.price.text} $moneyTypeLanguageStr",
    fontWeight: FontWeight.bold,
  );

  Future<pw.Widget> cardStockWidget() async {
    Future<pw.Widget> rateListWidget() async {
      Future<pw.Widget> rateWidget({required int rateIndex}) async {
        final bool isBuyRate = cardStockModel.mainPrice.rateList[rateIndex].isBuyRate!;
        final String rateTypeFirstStr = cardStockModel.mainPrice.rateList[rateIndex].rateType.first;
        final String rateTypeLastStr = cardStockModel.mainPrice.rateList[rateIndex].rateType.last;
        final pw.Widget rateFirstSymbolImage = await generateImageListFromStringTest(
          text: findMoneyModelByMoneyType(moneyType: rateTypeFirstStr).symbol!,
          fontWeight: FontWeight.bold,
          level: Level.mini,
        );
        final pw.Widget rateLastSymbolImage = await generateImageListFromStringTest(
          text: findMoneyModelByMoneyType(moneyType: rateTypeLastStr).symbol!,
          fontWeight: FontWeight.bold,
          level: Level.mini,
        );
        final String percentageStr = cardStockModel.mainPrice.rateList[rateIndex].percentage.text;
        final String rateStr = cardStockModel.mainPrice.rateList[rateIndex].discountValue.text;

        return pw.Padding(
          padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.large)),
          child: isBuyRate
              ? pw.Row(children: [
                  pw.Text("$percentageStr % | $rateTypeFirstStr -> $rateTypeLastStr :  $rateStr  ( ",
                      style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
                  rateFirstSymbolImage,
                  pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
                  rateLastSymbolImage,
                  pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
                ])
              : pw.Row(children: [
                  pw.Text("$percentageStr % | $rateTypeLastStr -> $rateTypeFirstStr :  $rateStr  ( ",
                      style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
                  rateLastSymbolImage,
                  pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
                  rateFirstSymbolImage,
                  pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider)),
                ]),
        );
      }

      return pw.Column(children: [
        for (int exchangeIndex = 0; exchangeIndex < cardStockModel.mainPrice.rateList.length; exchangeIndex++) await rateWidget(rateIndex: exchangeIndex)
      ]);
    }

    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        qtyImage,
        amountImage,
        pw.Padding(padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)), child: priceImage),
        cardStockModel.mainPrice.rateList.isEmpty ? pw.Container() : _rateExchangeImagePrint,
        await rateListWidget(),
      ]),
    );
  }

  pw.Widget invoiceBody =
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [subtitleWidget(), paddingDrawLineWidget(), await cardStockWidget()]);

  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: cardStockModel.mainPrice.id!,
    invoiceDate: cardStockModel.mainPrice.date!,
    remark: cardStockModel.mainPrice.remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> printGiveMoneyToMatInvoice({required GiveMoneyToMatModel giveMoneyToMatModel, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingGetMoneyToMatInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleGiveMoneyToMatImagePrint]);
  }

  final String moneyTypeStr = giveMoneyToMatModel.moneyType!;
  final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  pw.Widget amountImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$giveMoneyExchangeStrPrintGlobal ($moneyTypeStr): ${giveMoneyToMatModel.value.text} $moneyTypeLanguageStr",
    fontWeight: FontWeight.bold,
  );

  pw.Widget employeeNameImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$employeeNameStrPrintGlobal: ${giveMoneyToMatModel.employeeName}",
    fontWeight: FontWeight.bold,
  );

  pw.Widget otherInOrOutComeWidget() {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [amountImage, employeeNameImage]),
    );
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    otherInOrOutComeWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: giveMoneyToMatModel.id!,
    invoiceDate: giveMoneyToMatModel.date!,
    remark: giveMoneyToMatModel.remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> printGiveCardToMatInvoice({required GiveCardToMatModel giveCardToMatModel, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingGetCardToMatInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleGiveCardToMatImagePrint]);
  }

  pw.Widget qtyImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "${giveCardToMatModel.cardCompanyName} x ${giveCardToMatModel.category}: ${giveCardToMatModel.qty.text} $pieceCardStrPrintGlobal",
    fontWeight: FontWeight.bold,
  );

  pw.Widget employeeNameImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$employeeNameStrPrintGlobal: ${giveCardToMatModel.employeeName}",
    fontWeight: FontWeight.bold,
  );

  pw.Widget otherInOrOutComeWidget() {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [qtyImage, employeeNameImage]),
    );
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    otherInOrOutComeWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: giveCardToMatModel.id!,
    invoiceDate: giveCardToMatModel.date!,
    remark: giveCardToMatModel.remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> printTotalHistoryInvoice({
  required BuildContext context,
  required DateTime date,
  required String remark,
  required CashModel cashModel,
  required List<CardModel> cardModelList,
  required List<AmountAndProfitModel> amountAndProfitModel,
  required List<SalaryHistory> salaryList,
  required DisplayBusinessOptionProfileEmployeeModel displayBusinessOptionModel,
}) async {
  // await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  // loadingDialogGlobal(context: context, loadingTitle: printingTotalMoneyAndCardInvoiceStrGlobal);
  // pw.Widget subtitleWidget() {
  //   return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleTotalHistoryImagePrint]);
  // }

  // Future<pw.Widget> totalCardStockListWidget() async {
  //   Future<pw.Widget> cardWidget({required int cardIndex}) async {
  //     final String companyNameStr = cardModelList[cardIndex].cardCompanyName.text;
  //     Future<pw.Widget> categoryWidget({required int categoryIndex}) async {
  //       final String categoryStr = cardModelList[cardIndex].categoryList[categoryIndex].category.text;
  //       int stockNumber = cardModelList[cardIndex].categoryList[categoryIndex].totalStock;
  //       // for (int mainStockIndex = 0; mainStockIndex < cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList.length; mainStockIndex++) {
  //       //   stockNumber =
  //       //       stockNumber + textEditingControllerToInt(controller: cardModelList[cardIndex].categoryList[categoryIndex].mainPriceList[mainStockIndex].stock)!;
  //       // }
  //       final String stockStr = formatAndLimitNumberTextGlobal(valueStr: stockNumber.toString(), isRound: false, isAllowZeroAtLast: false);
  //       return (stockNumber == 0)
  //           ? pw.Container()
  //           : await generateImageListFromStringTest(
  //               level: Level.normal,
  //               text: "$companyNameStr x $categoryStr: $stockStr $pieceCardStrPrintGlobal",
  //               fontWeight: FontWeight.bold,
  //             );
  //       // return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       //   Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(categoryStr, style: textStyleGlobal(level: Level.normal))])),
  //       //   Expanded(child: Text(": $stockStr", style: textStyleGlobal(level: Level.normal))),
  //       // ]);
  //     }

  //     return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //       for (int categoryIndex = 0; categoryIndex < cardModelList[cardIndex].categoryList.length; categoryIndex++)
  //         await categoryWidget(categoryIndex: categoryIndex),
  //     ]);

  //     }

  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)),
  //     child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //       _subtitleCardStockLeftImagePrint,
  //       for (int cardIndex = 0; cardIndex < cardModelList.length; cardIndex++) await cardWidget(cardIndex: cardIndex),
  //     ]),
  //   );
  // }

  // Future<pw.Widget> totalMoneyWidget() async {
  //   Future<pw.Widget> amountTextWidget({required int amountAndProfitIndex}) async {
  //     final String moneyTypeStr = amountAndProfitModel[amountAndProfitIndex].moneyType;
  //     final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
  //     final String amountStr = formatAndLimitNumberTextGlobal(
  //       valueStr: amountAndProfitModel[amountAndProfitIndex].amount.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String profitStr = formatAndLimitNumberTextGlobal(
  //       valueStr: amountAndProfitModel[amountAndProfitIndex].profit.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //      final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  //     return (amountAndProfitModel[amountAndProfitIndex].amount == 0 && amountAndProfitModel[amountAndProfitIndex].profit == 0)
  //         ? pw.Container()
  //         : pw.Column(children: [
  //             await generateImageListFromStringTest(level: Level.normal, text: "$moneyTypeStr: $amountStr $moneyTypeLanguageStr", fontWeight: FontWeight.bold),
  //             await generateImageListFromStringTest(
  //                 level: Level.normal, text: "$profitStrGlobal: $profitStr $moneyTypeLanguageStr", fontWeight: FontWeight.bold),
  //           ]);
  //       }

  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)),
  //     child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //       await generateImageListFromStringTest(level: Level.normal, text: "$mergeInsideStrGlobal:", fontWeight: FontWeight.bold),
  //       for (int amountAndProfitIndex = 0; amountAndProfitIndex < amountAndProfitModel.length; amountAndProfitIndex++)
  //         await amountTextWidget(amountAndProfitIndex: amountAndProfitIndex),
  //     ]),
  //   );
  // }

  // Future<pw.Widget> totalMoneyEstimateWidget() async {
  //   Future<pw.Widget> amountTextWidget({required int cashIndex}) async {
  //     final String moneyTypeStr = cashModel.cashList[cashIndex].moneyType;
  //     final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
  //     double totalMoney = 0;
  //     for (int moneyIndex = 0; moneyIndex < cashModel.cashList[cashIndex].moneyList.length; moneyIndex++) {
  //       totalMoney = totalMoney + textEditingControllerToDouble(controller: cashModel.cashList[cashIndex].moneyList[moneyIndex])!;
  //     }
  //     final String amountStr = formatAndLimitNumberTextGlobal(
  //       valueStr: totalMoney.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     Future<pw.Widget> rateWidget() async {
  //       final bool isBuyRate = cashModel.cashList[cashIndex].isBuyRate;
  //       final String rateTypeFirstStr = cashModel.mergeBy!;
  //       final String rateTypeLastStr = cashModel.cashList[cashIndex].moneyType;
  //       final pw.Widget rateFirstSymbolImage = await generateImageListFromStringTest(
  //         text: findMoneyModelByMoneyType(moneyType: rateTypeFirstStr).symbol!,
  //         fontWeight: FontWeight.bold,
  //         level: Level.normal,
  //       );
  //       final pw.Widget rateLastSymbolImage = await generateImageListFromStringTest(
  //         text: findMoneyModelByMoneyType(moneyType: rateTypeLastStr).symbol!,
  //         fontWeight: FontWeight.bold,
  //         level: Level.normal,
  //       );

  //       final String rateStr = cashModel.cashList[cashIndex].averageRate.text;

  //       return (rateTypeFirstStr == rateTypeLastStr)
  //           ? pw.Container()
  //           : isBuyRate
  //               ? pw.Row(children: [
  //                   pw.Text("$rateTypeFirstStr -> $rateTypeLastStr :  $rateStr  ( ",
  //                       style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //                   rateFirstSymbolImage,
  //                   pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //                   rateLastSymbolImage,
  //                   pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //                 ])
  //               : pw.Row(children: [
  //                   pw.Text("$rateTypeLastStr -> $rateTypeFirstStr :  $rateStr  ( ",
  //                       style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //                   rateLastSymbolImage,
  //                   pw.Text(" -> ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //                   rateFirstSymbolImage,
  //                   pw.Text(" )", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //                 ]);
  //     }

  //     final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  //     return (totalMoney == 0)
  //         ? pw.Container()
  //         : pw.Column(children: [
  //             await generateImageListFromStringTest(level: Level.normal, text: "$moneyTypeStr: $amountStr $moneyTypeLanguageStr", fontWeight: FontWeight.bold),
  //             await rateWidget(),
  //           ]);
  //     }

  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)),
  //     child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //       await generateImageListFromStringTest(level: Level.normal, text: "$mergeOutStrGlobal:", fontWeight: FontWeight.bold),
  //       for (int cashIndex = 0; cashIndex < cashModel.cashList.length; cashIndex++) await amountTextWidget(cashIndex: cashIndex),
  //     ]),
  //   );
  // }

  // Future<pw.Widget> finalResultTextWidget() async {
  //   final double totalEstimateCashMoney = totalEstimateCashMoneyStr(cashModel: cashModel);
  //   final double totalEstimate = totalEstimateStr(cashModel: cashModel, amountAndProfitModel: amountAndProfitModel);
  //   final double leftNumber = (totalEstimateCashMoney - totalEstimate);
  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)),
  //     child: pw.Column(children: [
  //       await generateImageListFromStringTest(level: Level.normal, text: "$balanceStrGlobal: ", fontWeight: FontWeight.bold),
  //       await generateImageListFromStringTest(
  //         level: Level.normal,
  //         text: "$mergeOutStrGlobal: ${totalEstimateNumberToStr(totalNumber: totalEstimateCashMoney, cashModel: cashModel)} ${cashModel.mergeBy}",
  //         fontWeight: FontWeight.bold,
  //       ),
  //       await generateImageListFromStringTest(
  //         level: Level.normal,
  //         text: "$mergeInsideStrGlobal: ${totalEstimateNumberToStr(totalNumber: totalEstimate, cashModel: cashModel)} ${cashModel.mergeBy}",
  //         fontWeight: FontWeight.bold,
  //       ),
  //       await generateImageListFromStringTest(
  //         level: Level.normal,
  //         text: "$inAndOutStrGlobal ${totalEstimateNumberToStr(totalNumber: leftNumber, cashModel: cashModel)} ${cashModel.mergeBy} ",
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ]),
  //   );
  // }

  // Future<pw.Widget> salaryCalculateTextWidget() async {
  //   double salaryTotal = 0;
  //   Future<pw.Widget> salaryStartAndEndSellingListTextWidget({required int salaryIndex}) async {
  //     final SalaryValueModel elementStartAndEndSelling = getSalaryElement(salary: salaryList[salaryIndex]);
  //     final int secondBetween2Date = elementStartAndEndSelling.startDateCalculation.difference(elementStartAndEndSelling.endDateCalculation).inSeconds;
  //     final double earningForSecond = textEditingControllerToDouble(controller: salaryList[salaryIndex].salaryCalculation.earningForSecond)!;
  //     salaryTotal = salaryTotal + elementStartAndEndSelling.value;
  //     final int place = findMoneyModelByMoneyType(moneyType: salaryList[salaryIndex].salaryCalculation.moneyType!).decimalPlace!;
  //     final String hourBetween2DateStr = formatAndLimitNumberTextGlobal(
  //       valueStr: (secondBetween2Date.abs() / 3600).toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String earningForHourStr = formatAndLimitNumberTextGlobal(
  //       valueStr: (earningForSecond * 3600).toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String elementStartAndEndSellingStr = formatAndLimitNumberTextGlobal(
  //       valueStr: elementStartAndEndSelling.value.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     return pw.Padding(
  //       padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
  //       child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //         await generateImageListFromStringTest(
  //             level: Level.normal, text: "$startSellingSalaryStrGlobal: ${elementStartAndEndSelling.startDateCalculation}", fontWeight: FontWeight.bold),
  //         await generateImageListFromStringTest(
  //             level: Level.normal, text: "$endSellingSalaryStrGlobal: ${elementStartAndEndSelling.endDateCalculation}", fontWeight: FontWeight.bold),
  //         pw.Text("$hourBetween2DateStr * $earningForHourStr", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //         pw.Text("= $elementStartAndEndSellingStr ${salaryList[salaryIndex].salaryCalculation.moneyType}",
  //             style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //       ]),
  //     );
  //   }

  //   Future<pw.Widget> salaryInvoiceTextWidget() async {
  //     final double earningForInvoice = textEditingControllerToDouble(controller: salaryList.last.salaryCalculation.earningForInvoice)!;
  //     final int invoiceCount = displayBusinessOptionModel.exchangeCount +
  //         displayBusinessOptionModel.sellCardCount +
  //         displayBusinessOptionModel.excelCount +
  //         displayBusinessOptionModel.transferCount;
  //     final double invoiceCalculate = invoiceCount * earningForInvoice;
  //     salaryTotal = salaryTotal + invoiceCalculate;
  //     final int place = findMoneyModelByMoneyType(moneyType: salaryList.last.salaryCalculation.moneyType!).decimalPlace!;
  //     final String earningForInvoiceStr = formatAndLimitNumberTextGlobal(
  //       valueStr: earningForInvoice.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String invoiceCalculateStr = formatAndLimitNumberTextGlobal(
  //       valueStr: invoiceCalculate.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String invoiceCountStr = formatAndLimitNumberTextGlobal(
  //       valueStr: invoiceCount.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     return pw.Padding(
  //       padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
  //       child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //         await generateImageListFromStringTest(level: Level.normal, text: "$invoiceSalaryStrGlobal:", fontWeight: FontWeight.bold),
  //         pw.Text("$invoiceCountStr * $earningForInvoiceStr", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //         pw.Text(
  //           "= $invoiceCalculateStr ${salaryList.last.salaryCalculation.moneyType}",
  //           style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider),
  //         ),
  //       ]),
  //     );
  //   }

  //   Future<pw.Widget> salaryMoneyInUsedTextWidget() async {
  //     final double earningForMoneyInUsed = textEditingControllerToDouble(controller: salaryList.last.salaryCalculation.earningForMoneyInUsed)!;
  //     double mergeMoneyInUsed = 0;
  //     for (int currencyIndex = 0; currencyIndex < amountAndProfitModel.length; currencyIndex++) {
  //       if (salaryList.last.salaryCalculation.moneyType == amountAndProfitModel[currencyIndex].moneyType) {
  //         mergeMoneyInUsed += amountAndProfitModel[currencyIndex].amountInUsed;
  //       } else {
  //         RateModel? rateModel =
  //             getRateModel(rateTypeFirst: amountAndProfitModel[currencyIndex].moneyType, rateTypeLast: salaryList.last.salaryCalculation.moneyType!);
  //         if (rateModel != null) {
  //           if (rateModel.buy != null && rateModel.sell != null) {
  //             double averageRateNumber =
  //                 (textEditingControllerToDouble(controller: rateModel.buy!.value)! + textEditingControllerToDouble(controller: rateModel.sell!.value)!) / 2;
  //             final bool isMulti = amountAndProfitModel[currencyIndex].moneyType == rateModel.rateType.first;
  //             if (isMulti) {
  //               mergeMoneyInUsed += (amountAndProfitModel[currencyIndex].amountInUsed * averageRateNumber);
  //             } else {
  //               mergeMoneyInUsed += (amountAndProfitModel[currencyIndex].amountInUsed / averageRateNumber);
  //             }
  //           } else {
  //             mergeMoneyInUsed = 0;
  //             break;
  //           }
  //         } else {
  //           mergeMoneyInUsed = 0;
  //           break;
  //         }
  //       }
  //     }
  //     final moneyInUsedCalculate = mergeMoneyInUsed * earningForMoneyInUsed;
  //     salaryTotal = salaryTotal + moneyInUsedCalculate;
  //     final int place = findMoneyModelByMoneyType(moneyType: salaryList.last.salaryCalculation.moneyType!).decimalPlace!;
  //     final String earningForMoneyInUsedStr = formatAndLimitNumberTextGlobal(
  //       valueStr: earningForMoneyInUsed.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       // places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String moneyInUsedCalculateStr = formatAndLimitNumberTextGlobal(
  //       valueStr: moneyInUsedCalculate.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     final String mergeMoneyInUsedStr = formatAndLimitNumberTextGlobal(
  //       valueStr: mergeMoneyInUsed.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     return pw.Padding(
  //       padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
  //       child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
  //         await generateImageListFromStringTest(level: Level.normal, text: "$moneyInUsedSalaryStrGlobal:", fontWeight: FontWeight.bold),
  //         pw.Text("$mergeMoneyInUsedStr * $earningForMoneyInUsedStr",
  //             style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //         pw.Text("= $moneyInUsedCalculateStr ${salaryList.last.salaryCalculation.moneyType}",
  //             style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
  //       ]),
  //     );
  //   }

  //   Future<pw.Widget> totalSalaryTextWidget() async {
  //     final int place = findMoneyModelByMoneyType(moneyType: salaryList.last.salaryCalculation.moneyType!).decimalPlace!;
  //     final String salaryTotalStr = formatAndLimitNumberTextGlobal(
  //       valueStr: salaryTotal.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     return await generateImageListFromStringTest(
  //         level: Level.normal, text: "$salaryGetStrGlobal: $salaryTotalStr ${salaryList.last.salaryCalculation.moneyType}", fontWeight: FontWeight.bold);
  //   }

  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)),
  //     child: pw.Column(children: [
  //       await generateImageListFromStringTest(level: Level.normal, text: "$calculateSalaryStrGlobal: ", fontWeight: FontWeight.bold),
  //       for (int salaryIndex = 0; salaryIndex < salaryList.length; salaryIndex++) await salaryStartAndEndSellingListTextWidget(salaryIndex: salaryIndex),
  //       await salaryInvoiceTextWidget(),
  //       await salaryMoneyInUsedTextWidget(),
  //       await totalSalaryTextWidget(),
  //     ]),
  //   );
  // }

  // Future<pw.Widget> balanceListTextWidget() async {
  //   List<MoneyTypeAndValueModel> balanceList = [];
  //   final bool isCashLargerLength = (cashModel.cashList.length > amountAndProfitModel.length);
  //   double getTotalMoney({required List<TextEditingController> moneyList}) {
  //     double totalMoney = 0;
  //     for (int moneyIndex = 0; moneyIndex < moneyList.length; moneyIndex++) {
  //       totalMoney = totalMoney + textEditingControllerToDouble(controller: moneyList[moneyIndex])!;
  //     }
  //     return totalMoney;
  //   }

  //   if (isCashLargerLength) {
  //     for (int cashIndex = 0; cashIndex < cashModel.cashList.length; cashIndex++) {
  //       final int moneyTypeIndex =
  //           amountAndProfitModel.indexWhere((element) => (element.moneyType == cashModel.cashList[cashIndex].moneyType)); //never equal -1
  //       double valueNumber = getTotalMoney(moneyList: cashModel.cashList[cashIndex].moneyList);
  //       if (moneyTypeIndex != -1) {
  //         valueNumber = valueNumber - amountAndProfitModel[moneyTypeIndex].amount;
  //       }
  //       balanceList.add(
  //         MoneyTypeAndValueModel(
  //           moneyType: cashModel.cashList[cashIndex].moneyType,
  //           value: valueNumber,
  //         ),
  //       );
  //     }
  //   } else {
  //     for (int amountAndProfitIndex = 0; amountAndProfitIndex < amountAndProfitModel.length; amountAndProfitIndex++) {
  //       final int moneyTypeIndex =
  //           cashModel.cashList.indexWhere((element) => (element.moneyType == amountAndProfitModel[amountAndProfitIndex].moneyType)); //never equal -1
  //       double valueNumber = -1 * amountAndProfitModel[amountAndProfitIndex].amount;
  //       if (moneyTypeIndex != -1) {
  //         valueNumber = valueNumber + getTotalMoney(moneyList: cashModel.cashList[moneyTypeIndex].moneyList);
  //       }
  //       balanceList.add(
  //         MoneyTypeAndValueModel(
  //           moneyType: amountAndProfitModel[amountAndProfitIndex].moneyType,
  //           value: valueNumber,
  //         ),
  //       );
  //     }
  //   }

  //   Future<pw.Widget> balanceElement({required int balanceIndex}) async {
  //     final String moneyTypeStr = balanceList[balanceIndex].moneyType;
  //     final int place = findMoneyModelByMoneyType(moneyType: moneyTypeStr).decimalPlace!;
  //     // double totalMoney = 0;
  //     // for (int moneyIndex = 0; moneyIndex < balanceList[balanceIndex].moneyList.length; moneyIndex++) {
  //     //   totalMoney = totalMoney + textEditingControllerToDouble(controller: balanceList[balanceIndex].moneyList[moneyIndex])!;
  //     // }
  //     final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;

  //     final String amountStr = formatAndLimitNumberTextGlobal(
  //       valueStr: balanceList[balanceIndex].value.toString(),
  //       isRound: false,
  //       isAllowZeroAtLast: false,
  //       places: (place >= 0) ? (place * multiPlaceOfProfitNumberWhenPlaceMoreThan0) : placeOfProfitNumberWhenPlaceMoreThan0,
  //     );
  //     return (balanceList[balanceIndex].value == 0)
  //         ? pw.Container()
  //         : await generateImageListFromStringTest(level: Level.normal, text: "$moneyTypeStr: $amountStr $moneyTypeLanguageStr", fontWeight: FontWeight.bold);
  //   }

  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(top: printPaddingSizeGlobal(level: Level.normal)),
  //     child: pw.Column(children: [
  //       await generateImageListFromStringTest(level: Level.normal, text: "( $mergeOutStrGlobal - $mergeInsideStrGlobal ):", fontWeight: FontWeight.bold),
  //       for (int balanceIndex = 0; balanceIndex < balanceList.length; balanceIndex++) await balanceElement(balanceIndex: balanceIndex),
  //     ]),
  //   );
  // }

  // bool isShowCard() {
  //   for (int companyIndex = 0; companyIndex < cardModelList.length; companyIndex++) {
  //     for (int categoryIndex = 0; categoryIndex < cardModelList[companyIndex].categoryList.length; categoryIndex++) {
  //       for (int mainIndexIndex = 0; mainIndexIndex < cardModelList[companyIndex].categoryList[categoryIndex].mainPriceList.length; mainIndexIndex++) {
  //         if (cardModelList[companyIndex].categoryList[categoryIndex].mainPriceList[mainIndexIndex].maxStock != 0) {
  //           return true;
  //         }
  //       }
  //     }
  //   }
  //   return false;
  // }

  // pw.Widget invoiceBody = pw.Column(children: [
  //   subtitleWidget(),
  //   paddingDrawLineWidget(),
  //   isShowCard() ? await totalCardStockListWidget() : pw.Container(),
  //   isShowCard() ? paddingDrawLineWidget() : pw.Container(),
  //   await totalMoneyEstimateWidget(),
  //   paddingDrawLineWidget(),
  //   await totalMoneyWidget(),
  //   paddingDrawLineWidget(),
  //   await balanceListTextWidget(),
  //   paddingDrawLineWidget(),
  //   await finalResultTextWidget(),
  //   paddingDrawLineWidget(),
  //   await salaryCalculateTextWidget(),
  // ]);
  // await printInvoice(invoiceBodyWidget: invoiceBody, invoiceId: "", invoiceDate: date, remark: remark);
  // closeDialogGlobal(context: context);
}

Future<void> printCalculateByOperatorInvoice({required CalculateByAmount calculate, required BuildContext context}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingCalculationInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleCalculateImagePrint]);
  }

  final String moneyTypeStr = calculate.moneyType!;
  final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;
  final String moneyTypeSymbol = findMoneyModelByMoneyType(moneyType: moneyTypeStr).symbol!;
  pw.Widget moneyTypeImage = await generateImageListFromStringTest(level: Level.normal, text: moneyTypeLanguageStr, fontWeight: FontWeight.bold);

  List<pw.Widget> moneyTypeImageList = [
    for (int i = 0; i < calculate.calculateElementList.length; i++)
      await generateImageListFromStringTest(level: Level.normal, text: moneyTypeSymbol, fontWeight: FontWeight.bold)
  ];

  List<pw.Widget> qtyImageList = [
    for (int i = 0; i < calculate.calculateElementList.length; i++)
      await generateImageListFromStringTest(level: Level.normal, text: pieceCardStrPrintGlobal, fontWeight: FontWeight.bold)
  ];
  pw.Widget calculateElementWidget({required int calculateIndex}) {
    final String valueTypeStr = calculate.calculateElementList[calculateIndex].valueStr;
    final String valueOrQtyStr = calculate.calculateElementList[calculateIndex].valueController.text;
    final bool isQtyCalculate = (valueTypeStr != "0");
    pw.Widget calculateTextWidget() {
      String amountAndMoneyTypeStr = "";
      if (isQtyCalculate) {
        final double qtyNumber = textEditingControllerToDouble(controller: calculate.calculateElementList[calculateIndex].valueController)!;
        final double valueTypeNumber =
            double.parse(formatAndLimitNumberTextGlobal(valueStr: calculate.calculateElementList[calculateIndex].valueStr, isRound: false, isAddComma: false));
        amountAndMoneyTypeStr = formatAndLimitNumberTextGlobal(valueStr: (qtyNumber * valueTypeNumber).toString(), isRound: false, isAddComma: true);
      } else {
        amountAndMoneyTypeStr = calculate.calculateElementList[calculateIndex].valueController.text;
      }

      return pw.Text("${calculate.calculateElementList[calculateIndex].operatorStr}$amountAndMoneyTypeStr ",
          style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider));
    }

    pw.Widget textWidget({required String valueStr}) {
      return pw.Text(valueStr, style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider));
    }
    // final String valueStr = calculate.calculateElementList[calculateIndex].;

    // pw.Widget moneyTypeImage = await generateImageListFromStringTest(level: Level.normal, text: "($valueStr $moneyTypeLanguageStr)", fontWeight: FontWeight.bold);
    if (calculate.calculateElementList[calculateIndex].valueController.text.isEmpty) {
      return pw.Container();
    } else {
      pw.Widget typeImage = isQtyCalculate
          ? pw.Row(children: [
              textWidget(valueStr: "($valueOrQtyStr "),
              qtyImageList[calculateIndex],
              textWidget(valueStr: "  | $valueTypeStr "),
              moneyTypeImageList[calculateIndex],
              textWidget(valueStr: " )"),
            ])
          : moneyTypeImage;
      return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [calculateTextWidget(), typeImage]);
    }
  }

  pw.Widget calculateListWidget() {
    pw.Widget calculateTotalWidget() {
      double totalNumber = 0;
      for (int calculateIndex = 0; calculateIndex < calculate.calculateElementList.length; calculateIndex++) {
        if (calculate.calculateElementList[calculateIndex].valueController.text.isNotEmpty) {
          final bool isQtyCalculate = (calculate.calculateElementList[calculateIndex].valueStr != "0");

          double valueNumber = 0;
          if (isQtyCalculate) {
            final double qtyNumber = textEditingControllerToDouble(controller: calculate.calculateElementList[calculateIndex].valueController)!;
            final double valueTypeNumber = double.parse(
                formatAndLimitNumberTextGlobal(valueStr: calculate.calculateElementList[calculateIndex].valueStr, isRound: false, isAddComma: false));
            valueNumber = (qtyNumber * valueTypeNumber);
          } else {
            valueNumber = textEditingControllerToDouble(controller: calculate.calculateElementList[calculateIndex].valueController)!;
          }
          // double valueNumber = textEditingControllerToDouble(controller: calculate.calculateElementList[calculateIndex].valueController)!;
          bool isSum = (calculate.calculateElementList[calculateIndex].operatorStr == "+");
          totalNumber = totalNumber + ((isSum ? 1 : -1) * valueNumber);
        }
      }
      final String operatorStr = (totalNumber >= 0) ? "+" : "";
      return pw.Text(
        "$operatorStr${formatAndLimitNumberTextGlobal(valueStr: totalNumber.toString(), isRound: calculate.isFormat)} ",
        style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider),
      );
    }

    // final String moneyTypeStr = calculate.moneyType!;
    // final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;
    // final String valueStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).valueList

    // pw.Widget moneyTypeImage = await generateImageListFromStringTest(level: Level.normal, text: "($valueStr $moneyTypeLanguageStr)", fontWeight: FontWeight.bold);

    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(
        children: [
          for (int calculationIndex = 0; calculationIndex < calculate.calculateElementList.length; calculationIndex++)
            calculateElementWidget(calculateIndex: calculationIndex),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [paddingDrawLineWidget(width: widthPrint / 1.25)]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [calculateTotalWidget(), moneyTypeImage])
        ],
      ),
    );
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    calculateListWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: "",
    invoiceDate: DateTime.now(),
    remark: calculate.remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> cardPriceInvoiceInvoice({required BuildContext context, required TextEditingController remark}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingCountingInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleShowCardPriceImagePrint]);
  }

  Future<pw.Widget> sellPriceWidget({required CardSellPriceListCardModel sellPrice}) async {
    final String startPriceStr = sellPrice.startValue.text;
    final String endPriceStr = sellPrice.endValue.text;
    final String priceStr = sellPrice.price.text;
    final String moneyTypeStr = sellPrice.moneyType!;
    final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.normal), bottom: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(children: [
          pw.Text("$startPriceStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          await generateImageListFromStringTest(level: Level.normal, text: pieceCardStrPrintGlobal, fontWeight: FontWeight.bold),
          pw.Text(" <=", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          pw.Text(" x", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          // await generateImageListFromStringTest(level: Level.normal, text: "≤", fontWeight: FontWeight.bold),
          pw.Text(" <=", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          pw.Text(" $endPriceStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          await generateImageListFromStringTest(level: Level.normal, text: pieceCardStrPrintGlobal, fontWeight: FontWeight.bold),
        ]),
        pw.Row(children: [
          await generateImageListFromStringTest(level: Level.normal, text: priceCardStrPrintGlobal, fontWeight: FontWeight.bold),
          pw.Text(" ($moneyTypeStr): $priceStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
          await generateImageListFromStringTest(level: Level.normal, text: moneyTypeLanguageStr, fontWeight: FontWeight.bold),
        ]),
      ]),
    );
  }

  Future<pw.Widget> textFieldAndDeleteWidget({required int cardIndex, required int categoryIndex}) async {
    final isSelectedPrint = cardModelListGlobal[cardIndex].categoryList[categoryIndex].isSelectedPrint;
    if (isSelectedPrint) {
      final pw.Widget companyName = await generateImageListFromStringTest(
        level: Level.normal,
        text: cardModelListGlobal[cardIndex].cardCompanyName.text,
        fontWeight: FontWeight.bold,
      );
      final String categoryStr = cardModelListGlobal[cardIndex].categoryList[categoryIndex].category.text;
      return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            paddingDrawLineWidget(),
            pw.Row(children: [
              companyName,
              pw.Text(" x $categoryStr: ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider))
            ]),
            // pw.Padding(padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.normal)), child: ),
            for (int sellPriceIndex = 0; sellPriceIndex < cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList.length; sellPriceIndex++)
              cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex].isSelectedPrint
                  ? await sellPriceWidget(sellPrice: cardModelListGlobal[cardIndex].categoryList[categoryIndex].sellPriceList[sellPriceIndex])
                  : pw.Container(),
          ]));
    }
    return pw.Container();
  }

  Future<pw.Widget> textCombineWidget({required int cardCombineIndex}) async {
    final isSelectedPrint = cardCombineModelListGlobal[cardCombineIndex].isSelectedPrint;
    if (isSelectedPrint) {
      final pw.Widget combineName = await generateImageListFromStringTest(
        level: Level.normal,
        text: cardCombineModelListGlobal[cardCombineIndex].combineName.text,
        fontWeight: FontWeight.bold,
      );

      Future<pw.Widget> subCombineWidget({required SubCardCombineModel subCardCombineModel}) async {
        final pw.Widget companyName = await generateImageListFromStringTest(
          level: Level.normal,
          text: subCardCombineModel.cardCompanyName!,
          fontWeight: FontWeight.bold,
        );
        final String categoryStr = formatAndLimitNumberTextGlobal(valueStr: subCardCombineModel.category.toString(), isRound: false);
        return  pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(children: [
              companyName,
              pw.Text(" x $categoryStr: ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider))
            ]),
            await sellPriceWidget(sellPrice: subCardCombineModel.cardSellPriceListCardModel!),
          ]);
      }

      return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            paddingDrawLineWidget(),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center,children: [combineName]),
            for (int subCardCombineIndex = 0; subCardCombineIndex < cardCombineModelListGlobal[cardCombineIndex].cardList.length; subCardCombineIndex++)
              await subCombineWidget(subCardCombineModel: cardCombineModelListGlobal[cardCombineIndex].cardList[subCardCombineIndex]),
          ]));
    }
    return pw.Container();
  }

  Future<pw.Widget> calculateListWidget() async {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      for (int cardIndex = 0; cardIndex < cardModelListGlobal.length; cardIndex++)
        for (int categoryIndex = 0; categoryIndex < cardModelListGlobal[cardIndex].categoryList.length; categoryIndex++)
          await textFieldAndDeleteWidget(cardIndex: cardIndex, categoryIndex: categoryIndex),
      for (int cardCombineIndex = 0; cardCombineIndex < cardCombineModelListGlobal.length; cardCombineIndex++)
        await textCombineWidget(cardCombineIndex: cardCombineIndex)
    ]);
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    // paddingDrawLineWidget(),
    await calculateListWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: "",
    invoiceDate: DateTime.now(),
    remark: remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> transferFeeInvoiceInvoice({required BuildContext context, required TextEditingController remark}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingCountingInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleShowCardPriceImagePrint]);
  }

  Future<pw.Widget> textFieldAndDeleteWidget({required int transferIndex, required int moneyTypeIndex}) async {
    final bool isTransferSelectedPrint = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isTransferSelectedPrint;
    final bool isReceiverSelectedPrint = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].isReceiverSelectedPrint;
    if (isTransferSelectedPrint || isReceiverSelectedPrint) {
      final int customerIndex = (transferModelListGlobal[transferIndex].customerId == null)
          ? -1
          : getIndexByCustomerId(customerId: transferModelListGlobal[transferIndex].customerId!);
      final String customerNameStr = (customerIndex == -1) ? profileModelAdminGlobal!.name.text : customerModelListGlobal[customerIndex].name.text;
      final pw.Widget customerNameImage = await generateImageListFromStringTest(level: Level.normal, text: customerNameStr, fontWeight: FontWeight.bold);
      final String moneyTypeStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyType!;
      Future<pw.Widget> sellPriceWidget({required int sellPriceIndex}) async {
        final String startPriceStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].startValue.text;
        final String endPriceStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].endValue.text;
        final String priceStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].fee.text;
        final String transferOrReceiveStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isTransfer
            ? transferPrintStrGlobal
            : receivePrintStrGlobal;
        // final String moneyTypeStr = transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].moneyType!;
        final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;
        final String moneyTypeSymbolStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).symbol!;
        return pw.Padding(
          padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.normal), bottom: printPaddingSizeGlobal(level: Level.normal)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(children: [
              await generateImageListFromStringTest(level: Level.normal, text: transferOrReceiveStr, fontWeight: FontWeight.bold),
              pw.Text(" | $startPriceStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              await generateImageListFromStringTest(level: Level.normal, text: moneyTypeSymbolStr, fontWeight: FontWeight.bold),
              pw.Text(" <=", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              pw.Text(" x", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              // await generateImageListFromStringTest(level: Level.normal, text: "≤", fontWeight: FontWeight.bold),
              pw.Text(" <=", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              pw.Text(" $endPriceStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              await generateImageListFromStringTest(level: Level.normal, text: moneyTypeSymbolStr, fontWeight: FontWeight.bold),
            ]),
            pw.Row(children: [
              await generateImageListFromStringTest(level: Level.normal, text: transferFeeStrPrintGlobal, fontWeight: FontWeight.bold),
              pw.Text(" ($moneyTypeStr): $priceStr ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              await generateImageListFromStringTest(level: Level.normal, text: moneyTypeLanguageStr, fontWeight: FontWeight.bold),
            ]),
          ]),
        );
      }

      return pw.Padding(
          padding: pw.EdgeInsets.only(bottom: printPaddingSizeGlobal(level: Level.normal)),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(children: [
              pw.Text("$moneyTypeStr | ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              customerNameImage,
              pw.Text(": ", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
            ]),
            // pw.Padding(padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.normal)), child: ),
            for (int sellPriceIndex = 0;
                sellPriceIndex < transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList.length;
                sellPriceIndex++)
              transferModelListGlobal[transferIndex].moneyTypeList[moneyTypeIndex].moneyList[sellPriceIndex].isSelectedPrint
                  ? await sellPriceWidget(sellPriceIndex: sellPriceIndex)
                  : pw.Container(),
          ]));
    }
    return pw.Container();
  }

  Future<pw.Widget> calculateListWidget() async {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      for (int cardIndex = 0; cardIndex < transferModelListGlobal.length; cardIndex++)
        for (int categoryIndex = 0; categoryIndex < transferModelListGlobal[cardIndex].moneyTypeList.length; categoryIndex++)
          await textFieldAndDeleteWidget(transferIndex: cardIndex, moneyTypeIndex: categoryIndex),
    ]);
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    await calculateListWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: "",
    invoiceDate: DateTime.now(),
    remark: remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> ratePriceInvoiceInvoice({required BuildContext context, required TextEditingController remark}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingCountingInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_showRateImagePrint]);
  }

  Future<pw.Widget> textFieldAndDeleteWidget({required int rateIndex}) async {
    final RateModel rateModel = rateModelListAdminGlobal[rateIndex];
    final String rateFirstStr = rateModel.rateType.first;
    final String rateLastStr = rateModel.rateType.last;
    final String rateFirstLanguageStr = findMoneyModelByMoneyType(moneyType: rateFirstStr).moneyTypeLanguagePrint!;
    final String rateLastLanguageStr = findMoneyModelByMoneyType(moneyType: rateLastStr).moneyTypeLanguagePrint!;
    final String rateFirstSymbolStr = findMoneyModelByMoneyType(moneyType: rateFirstStr).symbol!;
    final String rateLastSymbolStr = findMoneyModelByMoneyType(moneyType: rateLastStr).symbol!;
    Future<pw.Widget> rateWidget({required BuyOrSellRateModel? buyOrSellRateModel, required bool isBuy}) async {
      if (buyOrSellRateModel != null) {
        if (buyOrSellRateModel.isSelectedPrint) {
          final String rateTypeStr =
              isBuy ? "$rateFirstLanguageStr$tokeStrPrintGlobal$rateLastLanguageStr" : "$rateLastLanguageStr$tokeStrPrintGlobal$rateFirstLanguageStr";
          final String valueStr = buyOrSellRateModel.value.text;
          final String symbolStr = isBuy ? "$rateFirstSymbolStr -> $rateLastSymbolStr" : "$rateLastSymbolStr -> $rateFirstSymbolStr";
          return pw.Padding(
            padding: pw.EdgeInsets.only(left: paddingSizeGlobal(level: Level.normal)),
            child: await generateImageListFromStringTest(level: Level.normal, text: "$rateTypeStr: $valueStr ( $symbolStr )", fontWeight: FontWeight.bold),
          );
        }
      }
      return pw.Container();
    }

    bool isShowRate() {
      if (rateModel.buy != null || rateModel.sell != null) {
        if (rateModel.buy != null) {
          if (rateModel.buy!.isSelectedPrint) {
            return true;
          }
        }
        if (rateModel.sell != null) {
          if (rateModel.sell!.isSelectedPrint) {
            return true;
          }
        }
        // ? pw.Container()
        // : (!(rateModel.buy!.isSelectedPrint || rateModel.sell!.isSelectedPrint))?
      }
      return false;
    }

    return isShowRate()
        ? pw.Padding(
            padding: pw.EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text("$rateFirstStr - $rateLastStr:", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
              await rateWidget(buyOrSellRateModel: rateModel.buy, isBuy: true),
              await rateWidget(buyOrSellRateModel: rateModel.sell, isBuy: false),
            ]),
          )
        : pw.Container();
  }

  Future<pw.Widget> calculateListWidget() async {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      for (int rateIndex = 0; rateIndex < rateModelListAdminGlobal.length; rateIndex++) await textFieldAndDeleteWidget(rateIndex: rateIndex),
    ]);
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    await calculateListWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: "",
    invoiceDate: DateTime.now(),
    remark: remark.text,
  );
  closeDialogGlobal(context: context);
}

Future<void> printOtherInvoice({required BuildContext context, required PrintCustomizeModel printCustomize}) async {
  PrintCustomizeModel printCustomizeTemp = clonePrintCustomizeModel(printCustomizeModel: printCustomize);
  Future<void> callback() async {
    await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
    loadingDialogGlobal(context: context, loadingTitle: printingCountingInvoiceStrGlobal);
    Future<pw.Widget> subtitleWidget() async {
      return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
        await generateImageListFromStringTest(
          text: printCustomizeTemp.title.text,
          fontWeight: FontWeight.bold,
          level: Level.normal,
        ),
      ]);
    }

    // pw.Container(
    //   color: PdfColors.grey,
    //   child: await generateImageListFromStringTest(
    //     text: "ជីកាយ",
    //     fontWeight: FontWeight.bold,
    //     level: Level.normal,
    //   ),
    // )
    Future<pw.Widget> printListWidget() async {
      Future<pw.Widget> columnElementWidget({required int columnIndex}) async {
        Future<pw.Widget> rowElementWidget({required int rowIndex}) async {
          pw.MainAxisAlignment alignment = pw.MainAxisAlignment.start;
          if (printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isCenterAlign) {
            alignment = pw.MainAxisAlignment.center;
          } else if (printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isRightAlign) {
            alignment = pw.MainAxisAlignment.end;
          }

          PdfColor colorBackground = PdfColors.white;
          Color colorText = Colors.black;
          if (printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].fillValue == "normal") {
            colorBackground = PdfColors.grey;
          } else if (printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].fillValue == "large") {
            colorBackground = PdfColors.black;
            colorText = Colors.white;
          }
          return pw.Container(
            color: colorBackground,
            child: pw.Row(mainAxisAlignment: alignment, children: [
              await generateImageListFromStringTest(
                color: colorText,
                text: printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].text.text,
                fontWeight: printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: textEditingControllerToDouble(controller: printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].fontSize)!,
                decoration: printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isUnderLine ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ]),
          );
        }

        pw.MainAxisAlignment alignment = pw.MainAxisAlignment.start;
        if (printCustomizeTemp.textColumnList[columnIndex].isCenterAlign) {
          alignment = pw.MainAxisAlignment.center;
        } else if (printCustomizeTemp.textColumnList[columnIndex].isRightAlign) {
          alignment = pw.MainAxisAlignment.end;
        }
        return pw.Row(mainAxisAlignment: alignment, children: [
          for (int rowIndex = 0; rowIndex < printCustomizeTemp.textColumnList[columnIndex].textRowList.length; rowIndex++)
            printCustomizeTemp.textColumnList[columnIndex].isExpandedAlign
                ? pw.Expanded(child: await rowElementWidget(rowIndex: rowIndex))
                : await rowElementWidget(rowIndex: rowIndex),
        ]);
      }

      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        for (int columnIndex = 0; columnIndex < printCustomizeTemp.textColumnList.length; columnIndex++) await columnElementWidget(columnIndex: columnIndex)
      ]);
    }

    pw.Widget invoiceBody = pw.Column(children: [
      printCustomizeTemp.isHasHeaderAndFooter ? await subtitleWidget() : pw.Container(),
      printCustomizeTemp.isHasHeaderAndFooter ? paddingDrawLineWidget() : pw.Container(),
      await printListWidget(),
    ]);
    await printInvoice(
      isShowHeaderAndFooter: printCustomizeTemp.isHasHeaderAndFooter,
      invoiceBodyWidget: invoiceBody,
      invoiceId: "",
      invoiceDate: DateTime.now(),
      remark: "",
      //205  80
      //x    80
      printWidth: textEditingControllerToDouble(controller: printCustomizeTemp.width)! * (205 / 80),
    );
    closeDialogGlobal(context: context);
  }

  bool isHasTextfield = false;

  for (int columnIndex = 0; columnIndex < printCustomizeTemp.textColumnList.length; columnIndex++) {
    for (int rowIndex = 0; rowIndex < printCustomizeTemp.textColumnList[columnIndex].textRowList.length; rowIndex++) {
      if (!printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isText) {
        isHasTextfield = true;
        break;
      }
    }
    if (isHasTextfield) {
      break;
    }
  }
  if (isHasTextfield) {
    void cancelFunctionOnTap() {
      void okFunction() {
        closeDialogGlobal(context: context);
      }

      void cancelFunction() {}
      confirmationDialogGlobal(
          context: context,
          okFunction: okFunction,
          cancelFunction: cancelFunction,
          titleStr: cancelEditingSettingGlobal,
          subtitleStr: cancelEditingSettingConfirmGlobal);
    }

    ValidButtonModel validPrintButtonFunction() {
      for (int columnIndex = 0; columnIndex < printCustomizeTemp.textColumnList.length; columnIndex++) {
        for (int rowIndex = 0; rowIndex < printCustomizeTemp.textColumnList[columnIndex].textRowList.length; rowIndex++) {
          if (!printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isText &&
              printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].text.text.isEmpty) {
            // return false;
            // return ValidButtonModel(isValid: false, errorStr: "Textfield must not be blank");
            return ValidButtonModel(
              isValid: false,
              errorType: ErrorTypeEnum.valueOfString,
              error: "Textfield is empty",
              errorLocationList: [
                TitleAndSubtitleModel(title: "column index", subtitle: columnIndex.toString()),
                TitleAndSubtitleModel(title: "row index", subtitle: rowIndex.toString()),
              ],
            );
          }
        }
      }
      // return true;
      // return ValidButtonModel(isValid: true, errorStr: "");
      return ValidButtonModel(isValid: true);
    }

    Widget editCardDialog({required Function setStateFromDialog, required Size screenSizeFromDialog}) {
      Widget titleWidget() {
        return Padding(
          padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.large)),
          child: Text(textInputStrPrintGlobal, style: textStyleGlobal(level: Level.large, fontWeight: FontWeight.bold)),
        );
      }

      Widget textfieldList({required int columnIndex, required int rowIndex}) {
        void onTapFromOutsiderFunction() {}
        void onChangeFromOutsiderFunction() {
          setStateFromDialog(() {});
        }

        return printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].isText
            ? Container()
            : Padding(
                padding: EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.mini)),
                child: textFieldGlobal(
                  textFieldDataType: TextFieldDataType.str,
                  controller: printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].text,
                  onTapFromOutsiderFunction: onTapFromOutsiderFunction,
                  onChangeFromOutsiderFunction: onChangeFromOutsiderFunction,
                  labelText: printCustomizeTemp.textColumnList[columnIndex].textRowList[rowIndex].textfield.text,
                  level: Level.normal,
                ),
              );
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleWidget(),
        for (int columnIndex = 0; columnIndex < printCustomizeTemp.textColumnList.length; columnIndex++)
          for (int rowIndex = 0; rowIndex < printCustomizeTemp.textColumnList[columnIndex].textRowList.length; rowIndex++)
            textfieldList(columnIndex: columnIndex, rowIndex: rowIndex)
      ]);
    }

    actionDialogSetStateGlobal(
      dialogHeight: dialogSizeGlobal(level: Level.mini),
      dialogWidth: dialogSizeGlobal(level: Level.mini),
      cancelFunctionOnTap: cancelFunctionOnTap,
      context: context,
      contentFunctionReturnWidget: editCardDialog,
      printFunctionOnTap: () {
        closeDialogGlobal(context: context);
        callback();
      },
      validPrintFunctionOnTap: () => validPrintButtonFunction(),
    );
  } else {
    callback();
  }
}

Future<void> printLoanInvoiceInvoice(
    {required BuildContext context, required List<MoneyTypeAndValueForInputModel> totalList, required String customerName}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingTotalLoanInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [_subtitleLoanImagePrint]);
  }

  pw.Widget customerNameImage = await generateImageListFromStringTest(
    level: Level.normal,
    text: "$customerNameStrPrintGlobal: $customerName",
    fontWeight: FontWeight.bold,
  );

  Future<pw.Widget> getOrGiveMoneyWidget({required List<MoneyTypeAndValueForInputModel> totalList}) async {
    Future<pw.Widget> paddingLeftWidget({required int loanIndex}) async {
      final pw.Widget moneyTypeLanguageImage = await generateImageListFromStringTest(
        text: findMoneyModelByMoneyType(moneyType: totalList[loanIndex].moneyType).moneyTypeLanguagePrint!,
        fontWeight: FontWeight.bold,
        level: Level.normal,
      );
      pw.Widget moneyTypeAndAmountWidget() {
        final String amountStr = formatAndLimitNumberTextGlobal(valueStr: totalList[loanIndex].amount.text, isRound: false, isAllowZeroAtLast: false);
        return pw.Text(" (${totalList[loanIndex].moneyType}) : $amountStr ",
            style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider));
      }

      // final pw.Widget symbolImage = await generateImageListFromStringTest(
      //   text: findMoneyModelByMoneyType(moneyType: getOrGiveFromCustomerMoneyList[getOrGiveIndex].moneyType).symbol,
      //   fontWeight: FontWeight.bold,
      //   level: Level.normal,
      // );

      final pw.Widget borrowOrLendImage = await generateImageListFromStringTest(
        text: (textEditingControllerToDouble(controller: totalList[loanIndex].amount)! >= 0) ? customerBorrowingStrPrintGlobal : customerLendingStrPrintGlobal,
        fontWeight: FontWeight.bold,
        level: Level.normal,
      );

      return pw.Padding(
        padding: pw.EdgeInsets.only(left: printPaddingSizeGlobal(level: Level.normal)),
        child: pw.Row(children: [borrowOrLendImage, moneyTypeAndAmountWidget(), moneyTypeLanguageImage]),
      );
    }

    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
      child: pw.Column(children: [for (int loanIndex = 0; loanIndex < totalList.length; loanIndex++) await paddingLeftWidget(loanIndex: loanIndex)]),
    );
  }

  pw.Widget loanListImage = await getOrGiveMoneyWidget(totalList: totalList);
  pw.Widget calculateListWidget() {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [customerNameImage, _subtitleTotalLoanImagePrint, loanListImage]);
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    calculateListWidget(),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: "",
    invoiceDate: DateTime.now(),
    remark: "",
  );
  closeDialogGlobal(context: context);
}

Future<void> printTransferInvoice({
  required TransferOrder transferOrder,
  required BuildContext context,
}) async {
  await delayMillisecond(millisecond: delayMillisecondsRequestGlobal);
  loadingDialogGlobal(context: context, loadingTitle: printingBorrowOrLendInvoiceStrGlobal);
  pw.Widget subtitleWidget() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center, children: [transferOrder.isTransfer ? _subtitleTransferImagePrint : _subtitleReceiveImagePrint]);
  }

  Future<pw.Widget> amountWidget() async {
    List<MoneyTypeTransferOrder> moneyTypeTransferOrderList = [];
    // if (transferOrder.mergeMoneyList.isEmpty) {
    for (int amountIndex = 0; amountIndex < transferOrder.moneyList.length; amountIndex++) {
      final int moneyTypeIndex = moneyTypeTransferOrderList.indexWhere((element) => (element.moneyType == transferOrder.moneyList[amountIndex].moneyType));
      final MoneyListTransfer moneyList = transferOrder.moneyList[amountIndex];
      final String moneyTypeStr = moneyList.moneyType!;
      final double value = textEditingControllerToDouble(controller: moneyList.value)!;
      final double discountFee = textEditingControllerToDouble(controller: moneyList.discountFee)!;
      //sender 20000 + 100 = 20100
      //receiver -20000 + 100 = -19900
      final double totalAmount = value + (transferOrder.mergeMoneyList.isEmpty ? discountFee : 0);
      if (moneyTypeIndex == -1) {
        moneyTypeTransferOrderList.add(MoneyTypeTransferOrder(moneyType: moneyTypeStr, moneyList: [moneyList], totalAmount: totalAmount));
      } else {
        moneyTypeTransferOrderList[moneyTypeIndex].moneyList.add(moneyList);
        moneyTypeTransferOrderList[moneyTypeIndex].totalAmount += totalAmount;
      }
    }
    // }

    Future<pw.Widget> amountElementWidget({required int amountIndex}) async {
      const double distanceBetweenOperatorAndValue = 10;
      double longestTextWidth = 0;
      Future<pw.Widget> amountAndFeeWidget({required int moneyIndex}) async {
        final String moneyTypeStr = moneyTypeTransferOrderList[amountIndex].moneyList[moneyIndex].moneyType!;
        final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;
        final String valueStr = formatAndLimitNumberTextGlobal(
          valueStr: textEditingControllerToDouble(controller: moneyTypeTransferOrderList[amountIndex].moneyList[moneyIndex].value)!.toString(),
          isRound: false,
          isAllowZeroAtLast: false,
        );
        final String discountFeeStr = formatAndLimitNumberTextGlobal(
          valueStr: textEditingControllerToDouble(controller: moneyTypeTransferOrderList[amountIndex].moneyList[moneyIndex].discountFee)!.toString(),
          isRound: false,
          isAllowZeroAtLast: false,
        );
        final String dateStr = formatFullWithoutSSDateToStr(date: moneyTypeTransferOrderList[amountIndex].moneyList[moneyIndex].transferDate!);
        final String valueStrAndMoneyTypeStr = "$valueStr $moneyTypeLanguageStr";
        final String dateStrAndFeeStr = "($dateStr${transferOrder.mergeMoneyList.isEmpty ? " | $discountFeeStr $moneyTypeLanguageStr" : ""})";
        final double valueStrAndMoneyTypeTextWidth = findTextSize(
              text: valueStrAndMoneyTypeStr,
              style: TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider, fontWeight: FontWeight.bold),
            ).width +
            distanceBetweenOperatorAndValue;

        if (valueStrAndMoneyTypeTextWidth > longestTextWidth) {
          //100 > 10
          longestTextWidth = valueStrAndMoneyTypeTextWidth;
        }
        final double dateStrAndFeeTextWidth = findTextSize(
              text: dateStrAndFeeStr,
              style: TextStyle(fontSize: printTextSizeGlobal(level: Level.mini) / usdFontSizeProvider, fontWeight: FontWeight.bold),
            ).width +
            distanceBetweenOperatorAndValue;

        if (dateStrAndFeeTextWidth > longestTextWidth) {
          longestTextWidth = dateStrAndFeeTextWidth;
        }
        return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            await generateImageListFromStringTest(text: valueStrAndMoneyTypeStr, fontWeight: FontWeight.bold, level: Level.normal),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            await generateImageListFromStringTest(text: dateStrAndFeeStr, fontWeight: FontWeight.bold, level: Level.mini),
          ]),
        ]);
      }

      Future<pw.Widget> feeAndTotalWidget() async {
        double longestTextWidth = 0;
        const double distanceBetweenOperatorAndValue = 10;
        final String moneyTypeStr = moneyTypeTransferOrderList[amountIndex].moneyType;
        final String moneyTypeLanguageStr = findMoneyModelByMoneyType(moneyType: moneyTypeStr).moneyTypeLanguagePrint!;
        final double totalNumber = moneyTypeTransferOrderList[amountIndex].totalAmount;
        final String totalStr = formatAndLimitNumberTextGlobal(valueStr: totalNumber.toString(), isRound: false, isAllowZeroAtLast: false);
        final double feeNumber = textEditingControllerToDouble(controller: transferOrder.mergeMoneyList[amountIndex].discountFee)!;
        final String feeStr = formatAndLimitNumberTextGlobal(valueStr: feeNumber.toString(), isRound: false, isAllowZeroAtLast: false);
        final String resultStr = formatAndLimitNumberTextGlobal(valueStr: (totalNumber + feeNumber).toString(), isRound: false, isAllowZeroAtLast: false);
        final double totalTextWidth = findTextSize(
              text: "$totalStr $moneyTypeLanguageStr",
              style: TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider, fontWeight: FontWeight.bold),
            ).width +
            distanceBetweenOperatorAndValue;
        if (totalTextWidth > longestTextWidth) {
          //100 > 10
          longestTextWidth = totalTextWidth;
        }

        final double feeTextWidth = findTextSize(
              text: "$feeStr $moneyTypeLanguageStr",
              style: TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider, fontWeight: FontWeight.bold),
            ).width +
            distanceBetweenOperatorAndValue;
        if (feeTextWidth > longestTextWidth) {
          //100 > 10
          longestTextWidth = feeTextWidth;
        }

        final double resultTextWidth = findTextSize(
              text: "$resultStr $moneyTypeLanguageStr",
              style: TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider, fontWeight: FontWeight.bold),
            ).width +
            distanceBetweenOperatorAndValue;
        if (resultTextWidth > longestTextWidth) {
          //100 > 10
          longestTextWidth = resultTextWidth;
        }

        return pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Text("+$feeStr", style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
            await generateImageListFromStringTest(text: moneyTypeLanguageStr, fontWeight: FontWeight.bold, level: Level.normal),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [paddingDrawLineWidget(width: longestTextWidth)]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Text(resultStr, style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider)),
            await generateImageListFromStringTest(text: moneyTypeLanguageStr, fontWeight: FontWeight.bold, level: Level.normal),
          ]),
        ]);
      }

      return pw.Padding(
        padding: pw.EdgeInsets.only(bottom: paddingSizeGlobal(level: Level.normal)),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
          for (int moneyIndex = 0; moneyIndex < moneyTypeTransferOrderList[amountIndex].moneyList.length; moneyIndex++)
            await amountAndFeeWidget(moneyIndex: moneyIndex),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [paddingDrawLineWidget(width: longestTextWidth)]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Text(
              "${formatAndLimitNumberTextGlobal(valueStr: moneyTypeTransferOrderList[amountIndex].totalAmount.toString(), isRound: false, isAllowZeroAtLast: false)} ",
              style: pw.TextStyle(fontSize: printTextSizeGlobal(level: Level.normal) / usdFontSizeProvider),
            ),
            await generateImageListFromStringTest(
              text: findMoneyModelByMoneyType(moneyType: moneyTypeTransferOrderList[amountIndex].moneyType).moneyTypeLanguagePrint!,
              fontWeight: FontWeight.bold,
              level: Level.normal,
            ),
          ]),
          transferOrder.mergeMoneyList.isEmpty ? pw.Container() : await feeAndTotalWidget(),
        ]),
      );
    }

    Future<pw.Widget> amountElementOnly1Widget() async {
      final dateStr = formatFullWithoutSSDateToStr(date: moneyTypeTransferOrderList[0].moneyList[0].transferDate!);
      final String moneyTypeStr = findMoneyModelByMoneyType(moneyType: moneyTypeTransferOrderList[0].moneyType).moneyTypeLanguagePrint!;
      final String valueStr = formatAndLimitNumberTextGlobal(
        valueStr:
            (moneyTypeTransferOrderList[0].totalAmount - textEditingControllerToDouble(controller: moneyTypeTransferOrderList[0].moneyList[0].discountFee)!)
                .toString(),
        isRound: false,
        isAllowZeroAtLast: false,
      );
      final String feeStr = formatAndLimitNumberTextGlobal(
        valueStr: moneyTypeTransferOrderList[0].moneyList[0].discountFee.text.toString(),
        isRound: false,
        isAllowZeroAtLast: false,
      );
      final String totalStr = formatAndLimitNumberTextGlobal(
        valueStr: moneyTypeTransferOrderList[0].totalAmount.toString(),
        isRound: false,
        isAllowZeroAtLast: false,
      );
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            await generateImageListFromStringTest(
              text: "$transferDateStrPrintGlobal: $dateStr",
              fontWeight: FontWeight.bold,
              level: Level.normal,
            ),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            await generateImageListFromStringTest(
              text: "$transferMoneyStrPrintGlobal: $valueStr $moneyTypeStr",
              fontWeight: FontWeight.bold,
              level: Level.normal,
            ),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            await generateImageListFromStringTest(
              text: "$transferFeeStrPrintGlobal: $feeStr $moneyTypeStr",
              fontWeight: FontWeight.bold,
              level: Level.normal,
            ),
          ]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            await generateImageListFromStringTest(
              text: "$transferTotalStrPrintGlobal: $totalStr $moneyTypeStr",
              fontWeight: FontWeight.bold,
              level: Level.normal,
            ),
          ]),
        ],
      );
    }

    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: printPaddingSizeGlobal(level: Level.normal)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: (transferOrder.moneyList.length == 1)
            ? [await amountElementOnly1Widget()]
            : [for (int amountIndex = 0; amountIndex < moneyTypeTransferOrderList.length; amountIndex++) await amountElementWidget(amountIndex: amountIndex)],
      ),
    );
  }

  Future<pw.Widget> informationWidget({required PartnerAndSenderAndReceiver? partnerAndSenderAndReceiver, required String nameStr}) async {
    if (partnerAndSenderAndReceiver == null) return pw.Container();
    Future<pw.Widget> informationElementWidget({required int informationIndex}) async {
      final String informationTitleStr = partnerAndSenderAndReceiver.informationList[informationIndex].title.text;
      final String informationSubtitleStr = partnerAndSenderAndReceiver.informationList[informationIndex].subtitle.text;
      return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
        await generateImageListFromStringTest(text: "$informationTitleStr: $informationSubtitleStr", fontWeight: FontWeight.bold, level: Level.normal),
      ]);
    }

    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      paddingDrawLineWidget(),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
        await generateImageListFromStringTest(text: "$nameStr: ${partnerAndSenderAndReceiver.name.text}", fontWeight: FontWeight.bold, level: Level.normal),
      ]),
      for (int informationIndex = 0; informationIndex < partnerAndSenderAndReceiver.informationList.length; informationIndex++)
        await informationElementWidget(informationIndex: informationIndex)
    ]);
  }

  pw.Widget invoiceBody = pw.Column(children: [
    subtitleWidget(),
    paddingDrawLineWidget(),
    await amountWidget(),
    (transferOrder.partner.nameAndInformationId == null)
        ? pw.Container()
        : await informationWidget(partnerAndSenderAndReceiver: transferOrder.partner, nameStr: transferPartnerNameStrPrintGlobal),
    await informationWidget(partnerAndSenderAndReceiver: transferOrder.sender, nameStr: transferSenderNameStrPrintGlobal),
    await informationWidget(partnerAndSenderAndReceiver: transferOrder.receiver, nameStr: transferReceiverNameStrPrintGlobal),
  ]);
  await printInvoice(
    invoiceBodyWidget: invoiceBody,
    invoiceId: "",
    invoiceDate: DateTime.now(),
    remark: transferOrder.remark.text,
  );
  closeDialogGlobal(context: context);
}

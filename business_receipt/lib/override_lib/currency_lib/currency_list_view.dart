import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'currency.dart';
import 'currency_picker_theme_data.dart';
import 'currency_service.dart';

class CurrencyListView extends StatefulWidget {
  /// Called when a currency is select.
  ///
  /// The currency picker passes the new value to the callback.
  final ValueChanged<Currency> onSelect;

  /// The Currencies that will appear at the top of the list (optional).
  ///
  /// It takes a list of Currency code.
  final List<String>? favorite;

  /// Can be used to uses filter the Currency list (optional).
  ///
  /// It takes a list of Currency code.
  final List<String>? currencyFilter;

  /// Shows flag for each currency (optional).
  ///
  /// Defaults true.
  final bool showFlag;

  /// Shows currency name (optional).
  /// [showCurrencyName] and [showCurrencyCode] cannot be both false
  ///
  /// Defaults true.
  final bool showCurrencyName;

  /// Shows currency code (optional).
  /// [showCurrencyCode] and [showCurrencyName] cannot be both false
  ///
  /// Defaults true.
  final bool showCurrencyCode;

  /// To disable the search TextField (optional).
  final bool showSearchField;

  /// Hint of the search TextField (optional).
  ///
  /// Defaults Search.
  final String? searchHint;

  final ScrollController? controller;

  final ScrollPhysics? physics;

  /// An optional argument for for customizing the
  /// currency list bottom sheet.
  final CurrencyPickerThemeData? theme;

  const CurrencyListView({
    Key? key,
    required this.onSelect,
    this.favorite,
    this.currencyFilter,
    this.showSearchField = true,
    this.searchHint,
    this.showCurrencyCode = true,
    this.showCurrencyName = true,
    this.showFlag = true,
    this.physics,
    this.controller,
    this.theme,
  }) : super(key: key);

  @override
  _CurrencyListViewState createState() => _CurrencyListViewState();
}

class _CurrencyListViewState extends State<CurrencyListView> {
  final CurrencyService _currencyService = CurrencyService();

  late List<Currency> _filteredList;
  late List<Currency> _currencyList;
  List<Currency>? _favoriteList;

  TextEditingController? _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();

    _currencyList = _currencyService.getAll();

    _filteredList = <Currency>[];

    if (widget.currencyFilter != null) {
      final List<String> currencyFilter = widget.currencyFilter!.map((code) => code.toUpperCase()).toList();

      _currencyList.removeWhere((element) => !currencyFilter.contains(element.code));
    }

    if (widget.favorite != null) {
      _favoriteList = _currencyService.findCurrenciesByCode(widget.favorite!);
    }

    _filteredList.addAll(_currencyList);
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      setState(() {});
    });

    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: widget.showSearchField
              ? TextField(
                  focusNode: focusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      labelText: widget.searchHint ?? "Search",
                      labelStyle: TextStyle(color: focusNode.hasFocus ? HexColor("#1F3662") : Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide(color: HexColor("#1F3662")), borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#1F3662")),
                      )),
                  onChanged: _filterSearchResults,
                )
              : Container(),
        ),
        Expanded(
          child: ListView(
            physics: widget.physics,
            children: [
              if (_favoriteList != null) ...[
                ..._favoriteList!.map<Widget>((currency) => _listRow(currency)).toList(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(thickness: 1),
                ),
              ],
              ..._filteredList.map<Widget>((currency) => _listRow(currency)).toList()
            ],
          ),
        ),
      ],
    );
  }

  Widget _listRow(Currency currency) {
    final TextStyle titleTextStyle = widget.theme?.titleTextStyle ?? _defaultTitleTextStyle;
    final TextStyle subtitleTextStyle = widget.theme?.subtitleTextStyle ?? _defaultSubtitleTextStyle;

    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onSelect(currency);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    // const SizedBox(width: 15),
                    if (widget.showFlag) ...[
                      // _flagWidget(currency),
                      const SizedBox(width: 15),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showCurrencyCode) ...[
                            Text(
                              currency.code,
                              style: titleTextStyle,
                            ),
                          ],
                          if (widget.showCurrencyName) ...[
                            Text(
                              currency.name,
                              style: widget.showCurrencyCode ? subtitleTextStyle : titleTextStyle,
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  currency.symbol,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _flagWidget(Currency currency) {
  //   if (currency.flag == null) {
  //     return Image.asset(
  //       flagImageGlobal,
  //       // package: 'currency_picker',
  //       width: 27,
  //     );
  //     // Image.asset('assets/images/lion.png');
  //   }
  //   // return Text("hi");
  //   return Text(
  //     CurrencyUtils.currencyToEmoji(currency),
  //     style: TextStyle(
  //       fontSize: widget.theme?.flagSize ?? 25,
  //     ),
  //   );
  // }

  void _filterSearchResults(String query) {
    List<Currency> searchResult = <Currency>[];

    if (query.isEmpty) {
      searchResult.addAll(_currencyList);
    } else {
      searchResult = _currencyList
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()) || c.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() => _filteredList = searchResult);
  }

  TextStyle get _defaultTitleTextStyle => const TextStyle(fontSize: 17);
  TextStyle get _defaultSubtitleTextStyle => TextStyle(fontSize: 15, color: Theme.of(context).hintColor);
}
import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
// import 'package:loan_calc_dev/drag_scroll.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
// import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/amort_list_page/amort_list_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:provider/provider.dart';

class AmortizerList extends StatefulWidget {
  const AmortizerList({
    Key key,
    // this.savedIndex,
    // @required this.mbdList,
  }) : super(key: key);

  // final List<MonthlyBreakDown> mbdList;
  // final SavedIndex savedIndex;

  @override
  AmortizerListState createState() => AmortizerListState();
}

class AmortizerListState extends State<AmortizerList> {
  ScrollController scrollController;

  SavedIndex savedIndex;

  @override
  void initState() {
    super.initState();
    savedIndex = Provider.of<Calculation>(context, listen: false).savedIndex;
    scrollController = ScrollController(
      initialScrollOffset: savedIndex.index,
    );
  }

  @override
  void deactivate() {
    indexSaver();
    super.deactivate();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void indexSaver() {
    savedIndex.index = scrollController.offset;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final calculation = Provider.of<Calculation>(context, listen: false);
    final mbdList = calculation.mbdList;
    final precision = calculation.precision;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;
    if (mbdList?.isEmpty ?? true) return RouteGenerator.errorPage(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          DraggableScrollbar(
            scrollThumbBuilder: (
              Color backgroundColor,
              Animation<double> thumbAnimation,
              Animation<double> labelAnimation,
              double height, {
              Text labelText,
              BoxConstraints labelConstraints,
            }) {
              return FadeTransition(
                opacity: thumbAnimation,
                child: Container(
                  color: backgroundColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: height, width: 35),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(0, 2),
                              color: Color(0xF39E9E9E),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints.loose(Size(5, 30)),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                ),
              );
            },
            controller: scrollController,
            heightScrollThumb: 81 + topPadding, //56 + 30/2 + 10
            backgroundColor: Colors.transparent,
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 66 + topPadding,
              ), // 56 + 10
              itemExtent: 121,
              itemCount: mbdList.length,
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              itemBuilder: (context, index) {
                final mbdItem = mbdList[index];
                return MbdListItem(
                  width: width,
                  mbdItem: mbdItem,
                  precision: precision,
                );
              },
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            height: 56 + topPadding,
            child: RoundedAppBar(
              child: const Hero(
                tag: SC.amortHeroTag,
                child: Icon(
                  Icons.format_align_center,
                  size: 30,
                ),
              ),
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MbdListItem extends StatefulWidget {
  const MbdListItem({
    Key key,
    @required this.width,
    @required this.mbdItem,
    @required this.precision,
  }) : super(key: key);

  final double width;
  final MonthlyBreakDown mbdItem;
  final int precision;

  @override
  _MbdListItemState createState() => _MbdListItemState();
}

class _MbdListItemState extends State<MbdListItem> {
  bool _isExpanded;
  double _expandedWidth = 0;
  List<String> _listOfMbdItem;
  ScrollController _scrollController;

  double get collapsedWidth => widget.width - 40;

  MonthlyBreakDown get mbdItem => widget.mbdItem;

  int get precision => widget.precision;
  
  @override
  void initState() {
    super.initState();
    _listOfMbdItem = <String>[
      mbdItem.month.toString(),
      mbdItem.payment.toStringAsFixed(precision),
      mbdItem.paidInt.toStringAsFixed(precision),
      mbdItem.paidPrinc.toStringAsFixed(precision),
      mbdItem.totPrinc.toStringAsFixed(precision),
      mbdItem.totInt.toStringAsFixed(precision),
    ];
    _getExpandedWidth();
    _scrollController = ScrollController();
    _isExpanded = mbdItem.expanded;
  }

  void _getExpandedWidth() {
    for (String text in _listOfMbdItem) {
      final ts = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 16,
        ),
      );
      final tp = TextPainter(
        text: ts,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      _expandedWidth += tp.width;
    }
    _expandedWidth -= 40;
  }

  double _getWidth() {
    return _isExpanded
        ? _expandedWidth > collapsedWidth ? _expandedWidth : collapsedWidth
        : collapsedWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: MyCard(
        child: AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: AnimationProvider.expandedDuration,
          margin: const EdgeInsets.all(10.0),
          width: _getWidth(),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: FifteenFontText(
                          'Month\n${_listOfMbdItem[0]}',
                        ),
                      ),
                      Flexible(
                        child: FifteenFontText(
                          'Payment\n${_listOfMbdItem[1]}',
                        ),
                      ),
                      Flexible(
                        child: FifteenFontText(
                          'Interest\n${_listOfMbdItem[2]}',
                        ),
                      ),
                      Flexible(
                        child: FifteenFontText(
                          'Principal\n${_listOfMbdItem[3]}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: FifteenFontText(
                          'Total Repaid\n${_listOfMbdItem[4]}',
                        ),
                      ),
                      Flexible(
                        child: FifteenFontText(
                          'Total Interest\n${_listOfMbdItem[5]}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: -5,
                bottom: -10,
                child: collapsedWidth < _expandedWidth
                    ? IconButton(
                        icon: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            _isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _isExpanded = !_isExpanded);
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.fastOutSlowIn.flipped,
                          );
                          mbdItem.expanded = _isExpanded;
                        },
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

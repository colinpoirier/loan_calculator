import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/amort_list_page/fifteen_font_text.dart';
import 'package:loan_calc_dev/ui/helper_widgets/my_card.dart';

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
    _isExpanded = mbdItem.expanded;
    _scrollController = ScrollController(
      initialScrollOffset:
          _isExpanded ? mbdItem.offset : 0,
    )..addListener(() {
        if (_isExpanded)
          mbdItem.offset = _scrollController.offset;
      });
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
  }

  double _getWidth() {
    return _isExpanded
        ? _expandedWidth
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
                        child: SixteenFontText(
                          'Month\n${_listOfMbdItem[0]}',
                        ),
                      ),
                      Flexible(
                        child: SixteenFontText(
                          'Payment\n${_listOfMbdItem[1]}',
                        ),
                      ),
                      Flexible(
                        child: SixteenFontText(
                          'Interest\n${_listOfMbdItem[2]}',
                        ),
                      ),
                      Flexible(
                        child: SixteenFontText(
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
                        child: SixteenFontText(
                          'Total Repaid\n${_listOfMbdItem[4]}',
                        ),
                      ),
                      Flexible(
                        child: SixteenFontText(
                          'Total Interest\n${_listOfMbdItem[5]}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: -10,
                bottom: -10,
                child: collapsedWidth < _expandedWidth
                    ? IconButton(
                        icon: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
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

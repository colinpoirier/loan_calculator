import 'dart:math' as math;

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

  static const titles = <String>[
    'Month\n',
    'Payment\n',
    'Interest\n',
    'Principal\n',
    'Total Repaid\n',
    'Total Interest\n',
  ];

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
      initialScrollOffset: _isExpanded ? mbdItem.offset : 0,
    )..addListener(() {
        mbdItem.offset = _scrollController.offset;
      });
  }

  void _getExpandedWidth() {
    for (int i = 0; i < 4; i++) {
      final ts = TextSpan(
        style: TextStyle(
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: titles[i],
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: _listOfMbdItem[i],
          ),
        ],
      );
      final tp = TextPainter(
        textAlign: TextAlign.center,
        text: ts,
        textDirection: TextDirection.ltr,
        maxLines: 2,
      )..layout();
      _expandedWidth = math.max(tp.width, _expandedWidth);
    }
    _expandedWidth *= 4;
    _expandedWidth += 15;
  }

  double _getWidth() {
    return _isExpanded ? _expandedWidth : collapsedWidth;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                    children: <Widget>[
                      for (int i = 0; i < 4; i++) ...[
                        Expanded(
                          child: SixteenFontRichText(
                            top: titles[i],
                            bottom: _listOfMbdItem[i],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                        if (i < 3)
                          const SizedBox(
                            width: 5,
                          )
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      for (int i = 4; i < 6; i++) ...[
                        Expanded(
                          child: SixteenFontRichText(
                            top: titles[i],
                            bottom: _listOfMbdItem[i],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                        if (i < 5)
                          const SizedBox(
                            width: 5,
                          )
                      ],
                    ],
                  ),
                ],
              ),
              if (collapsedWidth < _expandedWidth)
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: IconButton(
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
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

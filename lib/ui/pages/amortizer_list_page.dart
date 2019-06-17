import 'package:flutter/material.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/ui/helper_widgets/amort_list_page/amort_list_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';

class AmortizerList extends StatefulWidget {
  const AmortizerList({
    Key key,
    this.savedIndex,
    @required this.mbdList,
  }) : super(key: key);

  final List mbdList;
  final SavedIndex savedIndex;

  @override
  AmortizerListState createState() => AmortizerListState();
}

class AmortizerListState extends State<AmortizerList> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(
      initialScrollOffset: widget.savedIndex.index,
    );
    super.initState();
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
    widget.savedIndex.index = scrollController.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: RoundedAppBar(
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
      body: DraggableScrollbar(
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: height, width: 35),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                          color: Colors.grey.withOpacity(0.95),
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
        heightScrollThumb: 50,
        backgroundColor: Colors.transparent,
        child: ListView.builder(
          itemCount: widget.mbdList.length,
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          itemExtent: 117,
          itemBuilder: (context, index) {
            final mbdItem = widget.mbdList[index];
            return MyCard(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const FifteenFontText(
                              'Month',
                            ),
                            FifteenFontText(
                              mbdItem.month.toString(),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            const FifteenFontText(
                              'Payment',
                            ),
                            FifteenFontText(
                              mbdItem.payment.toStringAsFixed(2),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            const FifteenFontText(
                              'Interest',
                            ),
                            FifteenFontText(
                              mbdItem.paidInt.toStringAsFixed(2),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            const FifteenFontText(
                              'Principal',
                            ),
                            FifteenFontText(
                              mbdItem.paidPrinc.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const FifteenFontText(
                              'Total Repaid',
                            ),
                            FifteenFontText(
                              mbdItem.totPrinc.toStringAsFixed(2),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            const FifteenFontText(
                              'Total Interest',
                            ),
                            FifteenFontText(
                              mbdItem.totInt.toStringAsFixed(2),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

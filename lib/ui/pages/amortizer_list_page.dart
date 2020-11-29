import 'package:flutter/material.dart';
// import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:copied_draggable_scrollbar/copied_draggable_scrollbar.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/ui/helper_widgets/amort_list_page/amort_list_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:provider/provider.dart';

class AmortizerList extends StatefulWidget {
  const AmortizerList({
    Key key,
  }) : super(key: key);

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
      extendBodyBehindAppBar: true,
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
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: DraggableScrollbar(
        scrollThumbBuilder: (
          Color backgroundColor,
          Animation<double> thumbAnimation,
          double height, {
          Text labelText,
          BoxConstraints labelConstraints,
        }) {
          return FadeTransition(
            // opacity: AlwaysStoppedAnimation<double>(1),
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
                    constraints: BoxConstraints.loose(
                      Size(
                        5,
                        height,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
              ),
            ),
          );
        },
        controller: scrollController,
        heightScrollThumb: 30,
        topPadding: 56 + topPadding, //56 + 30/2 + 10
        backgroundColor: Colors.transparent,
        child: ListView.builder(
          padding: EdgeInsets.only(
            top: 66 + topPadding,
          ), // 56 + 10
          itemExtent: 121,
          itemCount: mbdList.length,
          physics: const BouncingScrollPhysics(),
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
    );
  }
}


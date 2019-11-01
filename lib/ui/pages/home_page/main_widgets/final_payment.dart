import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
// import 'package:loan_calc_dev/models/data_classes.dart';
// import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:provider/provider.dart';

class FinalPayment extends StatelessWidget {
  const FinalPayment({
    Key key,
    // @required this.expandedDuration,
    // @required this.finalPayment,
    // @required this.mbdList,
    // @required this.iptList,
    // @required this.savedIndex,
  }) : super(key: key);

  // final Duration expandedDuration;
  // final String finalPayment;
  // final List<MonthlyBreakDown> mbdList;
  // final List<InputTracker> iptList;
  // final SavedIndex savedIndex;

  void navigate(
    String page,
    AnimationProvider animation,
    BuildContext context,
  ) {
    animation.cancelTimer();
    Navigator.of(context)
        .pushNamed(
          page,
        )
        .then((_) => animation.buttonFade());
  }

  @override
  Widget build(BuildContext context) {
    final animation = Provider.of<AnimationProvider>(context, listen: false);
    // final calculation = Provider.of<Calculation>(context);
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      child: Scroller.column(
        children: <Widget>[
          const Text(
            'Expected Final Payment',
            textScaleFactor: 1.0,
            overflow: TextOverflow.clip,
            softWrap: false,
            style: TextStyle(fontSize: 22.0),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Scroller.stack(
                children: <Widget>[
                  Consumer<Calculation>(
                    builder: (_, calculation, __) {
                      return ScaleSwitcher(
                        duration: AnimationProvider.expandedDuration,
                        child: Container(
                          alignment: Alignment.center,
                          key: ValueKey(calculation.finalPayment()),
                          height: 42,
                          child: Text(
                            calculation.finalPayment(),
                            // overflow: TextOverflow.clip,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                            // maxLines: 1,
                            style: TextStyle(
                              // height: 1.2,
                              fontSize: getFontSize(
                                  37.0,
                                  MediaQuery.textScaleFactorOf(context),
                                  1.2,
                                  (constraints.maxWidth - 90).clamp(0.0, 250.0),
                                  calculation.finalPayment(),
                                  TextDirection.ltr),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DataContainer(
                          topChild: const Text(
                            'List',
                            textScaleFactor: 1.0,
                          ),
                          bottomChild: const Hero(
                            tag: SC.amortHeroTag,
                            child: Icon(
                              Icons.format_align_center,
                              size: 30.0,
                            ),
                          ),
                          ontap: () => navigate(
                            SC.amortListPage,
                            animation,
                            context,
                          ),
                          // ontap: () {
                          //   animation.cancelTimer();
                          //   // final mbdList = calculation.mbdList;
                          //   // if (mbdList.length > 0) {
                          //   Navigator.of(context)
                          //       .pushNamed(
                          //         SC.amortListPage,
                          //         // arguments: {
                          //         //   SC.mbdList: mbdList,
                          //         //   // SC.savedIndex: savedIndex,
                          //         // },
                          //       )
                          //       .then((_) => animation.buttonFade());
                          //   // }
                          // },
                        ),
                        SizedBox(
                          width: (constraints.maxWidth - 100).clamp(0.0, 230.0),
                        ),
                        DataContainer(
                          topChild: const Text(
                            'Graph',
                            textScaleFactor: 1.0,
                          ),
                          bottomChild: const Hero(
                            tag: SC.graphHeroTag,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Icon(
                                Icons.graphic_eq,
                                size: 30.0,
                              ),
                            ),
                          ),
                          ontap: () {
                            animation.cancelTimer();
                            // final mbdList = calculation.mbdList;
                            // if (mbdList.length > 0) {
                            Navigator.of(context)
                                .pushNamed(
                                  SC.graphPage,
                                  // arguments: {
                                  //   SC.mbdList: mbdList,
                                  //   SC.iptList: iptList,
                                  // },
                                )
                                .then((_) => animation.buttonFade());
                            // }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

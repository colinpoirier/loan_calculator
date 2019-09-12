import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/models/saved_index.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';

class FinalPayment extends StatelessWidget {
  const FinalPayment({
    Key key,
    @required this.expandedDuration,
    @required this.finalPayment,
    @required this.mbdList,
    @required this.iptList,
    @required this.savedIndex,
  }) : super(key: key);

  final Duration expandedDuration;
  final String finalPayment;
  final List<MonthlyBreakDown> mbdList;
  final List<InputTracker> iptList;
  final SavedIndex savedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      child: Scroller.column(
        children: <Widget>[
          const Text(
            'Expected Final Payment',
            overflow: TextOverflow.clip,
            softWrap: false,
            style: TextStyle(fontSize: 22.0),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Scroller.stack(
                children: <Widget>[
                  ScaleSwitcher(
                    duration: expandedDuration,
                    child: Text(
                      finalPayment,
                      key: ValueKey(finalPayment),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      style: const TextStyle(
                        height: 1.2,
                        fontSize: 37.0,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DataContainer(
                          topChild: const Text('List'),
                          bottomChild: const Hero(
                            tag: SC.amortHeroTag,
                            child: Icon(
                              Icons.format_align_center,
                              size: 30.0,
                            ),
                          ),
                          ontap: () {
                            if (mbdList.length > 0) {
                              Navigator.of(context).pushNamed(
                                SC.amortListPage,
                                arguments: {
                                  SC.mbdList: mbdList,
                                  SC.savedIndex: savedIndex,
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(width: (constraints.maxWidth-100).clamp(0.0, 230.0),),
                        DataContainer(
                          topChild: const Text('Graph'),
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
                            if (mbdList.length > 0) {
                              Navigator.of(context).pushNamed(
                                SC.graphPage,
                                arguments: {
                                  SC.mbdList: mbdList,
                                  SC.iptList: iptList,
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}

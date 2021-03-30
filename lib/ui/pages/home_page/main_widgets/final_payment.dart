import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/utils.dart';
import 'package:loan_calc_dev/convience_classes/animation_provider.dart';
import 'package:loan_calc_dev/state_management/final_notifier/final_notifier.dart';
import 'package:loan_calc_dev/ui/helper_widgets/home_page/home_page_helper_widgets.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:provider/provider.dart';

class FinalPayment extends StatelessWidget {
  const FinalPayment({
    Key? key,
  }) : super(key: key);

  void navigate(
    String page,
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      page,
      arguments: context.read<FinalNotifier>().state.mbdList,
    );
  }

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
            textScaleFactor: 1.0,
            overflow: TextOverflow.clip,
            softWrap: false,
            style: TextStyle(fontSize: 22.0),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Scroller.stack(
                children: <Widget>[
                  Consumer<FinalNotifier>(
                    builder: (_, finalNotifier, __) {
                      final color = Theme.of(_).textTheme.bodyText1!.color!;
                      final finalPayment = finalNotifier.state.getFinalPayment();
                      return ScaleSwitcher(
                        duration: Animations.expandedDuration,
                        child: Container(
                          alignment: Alignment.center,
                          key: ValueKey(finalPayment),
                          height: 42,
                          child: Text(
                            finalPayment,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              color: finalNotifier.state.isEditing ? color.withOpacity(0.5) : color,
                              fontSize: getFontSize(
                                37.0,
                                1.2,
                                (constraints.maxWidth - 90).clamp(0.0, 250.0),
                                finalPayment,
                                TextDirection.ltr,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
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
                          context,
                        ),
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
                        ontap: () => navigate(
                          SC.graphPage,
                          context,
                        ),
                      ),
                    ],
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

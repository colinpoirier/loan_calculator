import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/storage/input_tracker/input_tracker_notifier.dart';
import 'package:loan_calc_dev/ui/pages/graph_page/graph_painter.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({
    Key? key,
    required this.mbdList,
  }) : super(key: key);

  final List<MonthlyBreakDown> mbdList;

  static const bsList = <BoxShadow>[
    BoxShadow(
      offset: Offset(-3.0, 0.0),
      blurRadius: 1.0,
      spreadRadius: -2.0,
      color: Color(0x33000000),
    ),
    BoxShadow(
      offset: Offset(-2.0, 0.0),
      blurRadius: 2.0,
      spreadRadius: 0.0,
      color: Color(0x24000000),
    ),
    BoxShadow(
      offset: Offset(-1.0, 0.0),
      blurRadius: 5.0,
      spreadRadius: 0.0,
      color: Color(0x1F000000),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputNotifier = Provider.of<InputTrackerNotifier>(context, listen: false);
    final iptList = inputNotifier.iptList;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: bsList,
                ),
                margin: const EdgeInsets.all(10),
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: CustomPaint(
                    painter: GraphPainter(
                      textStyle: theme.textTheme.bodyText2!,
                      themeBrightness: theme.brightness,
                      mbd: mbdList,
                      ipt: iptList.first,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: double.infinity,
              width: 50.0,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(30),
                ),
                boxShadow: bsList,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: IconButton(
                      onPressed: Navigator.of(context).pop,
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ),
                  const Hero(
                    tag: SC.graphHeroTag,
                    child: Icon(
                      Icons.graphic_eq,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

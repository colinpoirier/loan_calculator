import 'package:flutter/material.dart';
import 'package:loan_calc_dev/calculation/calculation.dart';
import 'package:loan_calc_dev/ui/pages/graph_page/graph_painter.dart';
import 'package:loan_calc_dev/ui/route_generator/route_generator.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';
import 'package:provider/provider.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({
    Key key,
  }) : super(key: key);

  final bsList = const <BoxShadow>[
    BoxShadow(offset: Offset(-3.0, 0.0), blurRadius: 1.0, spreadRadius: -2.0, color: Color(0x33000000)),
    BoxShadow(offset: Offset(-2.0, 0.0), blurRadius: 2.0, spreadRadius: 0.0, color: Color(0x24000000)),
    BoxShadow(offset: Offset(-1.0, 0.0), blurRadius: 5.0, spreadRadius: 0.0, color: Color(0x1F000000)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calculation = Provider.of<Calculation>(context, listen: false);
    final mbdList = calculation.mbdList;
    final iptList = calculation.iptList;
    if(mbdList?.isEmpty ?? true) return RouteGenerator.errorPage(context);
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
                  boxShadow: bsList
                ),
                margin: const EdgeInsets.all(10),
                child: Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: GraphPainter(
                        textStyle: theme.textTheme.bodyText2,
                        themeBrightness: theme.brightness,
                        mbd: mbdList,
                        ipt: iptList,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: double.infinity,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(30)),
                    boxShadow: bsList
                  ),
                  child: const Hero(
                    tag: SC.graphHeroTag,
                    child: Icon(
                      Icons.graphic_eq,
                      size: 30,
                    ),
                  ),
                ),
                SafeArea(
                  minimum: const EdgeInsets.only(top: 10),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

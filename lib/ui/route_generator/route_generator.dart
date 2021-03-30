import 'package:flutter/material.dart';
import 'package:loan_calc_dev/models/data_classes.dart';
import 'package:loan_calc_dev/ui/helper_widgets/rounded_appbar.dart';
import 'package:loan_calc_dev/ui/pages/amortizer_list_page.dart';
import 'package:loan_calc_dev/ui/pages/graph_page/graph_page.dart';
import 'package:loan_calc_dev/ui/pages/home_page/home_page.dart';
import 'package:loan_calc_dev/ui/pages/home_page/system_brightness.dart';
import 'package:loan_calc_dev/ui/route_generator/string_constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SC.homePage:
        return FadeRouteTransition(
          child: SystemBrightness(
            child: MyHomePage(),
          ),
        );
      case SC.graphPage:
        final args = settings.arguments;
        if (args is List<MonthlyBreakDown> && args.isNotEmpty){
          return FadeRouteTransition(
            child: GraphPage(mbdList: args,),
          );
        } else {
          return FadeRouteTransition(child: ErrorPage());
        }
      case SC.amortListPage:
        final args = settings.arguments;
        if (args is List<MonthlyBreakDown> && args.isNotEmpty){      
          return FadeRouteTransition(
            child: AmortizerList(mbdList: args),
          );
        } else {
          return FadeRouteTransition(child: ErrorPage());
        }        
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return FadeRouteTransition(
      child: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Error'),
        ),
      ),
    );
  }

  static Scaffold errorPage(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: Text('Error'),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoundedAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Center(
        child: Text('Error'),
      ),
    );
  }

}

class FadeRouteTransition extends PageRouteBuilder {
  final Widget child;

  FadeRouteTransition({
    required this.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return child;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              )),
              child: child,
            );
          },
        );
}

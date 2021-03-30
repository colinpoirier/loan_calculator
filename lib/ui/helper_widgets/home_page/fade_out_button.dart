import 'package:flutter/material.dart';
import 'package:loan_calc_dev/ui/pages/home_page/main_widgets/home_page_widgets.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({Key? key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.history),
      onPressed: Scaffold.of(context).openDrawer,
      tooltip: 'View history',
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => showModalBottomSheet(context: context, builder: (context) => SettingsDrawer()),
      tooltip: 'View settings',
    );
  }
}
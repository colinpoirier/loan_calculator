import 'package:flutter/material.dart';
import 'package:loan_calc_dev/provider/animation_provider.dart';
import 'package:loan_calc_dev/ui/pages/home_page/main_widgets/home_page_widgets.dart';
import 'package:provider/provider.dart';

class FadeOutButton extends StatefulWidget {
  @override
  _FadeOutButtonState createState() => _FadeOutButtonState();
}

class _FadeOutButtonState extends State<FadeOutButton>
    with SingleTickerProviderStateMixin {
  AnimationProvider animationProvider;

  @override
  void initState() {
    super.initState();
    animationProvider = Provider.of<AnimationProvider>(context, listen: false);
    animationProvider.fadeButtonController = AnimationController(
      vsync: this,
      duration: AnimationProvider.expandedDuration,
    );
    animationProvider.fadeButtonAnimation = CurvedAnimation(
      parent: animationProvider.fadeButtonController,
      curve: Curves.fastOutSlowIn, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationProvider.fadeButtonAnimation,
      child: IconButton(
        icon: const Icon(Icons.history),
        onPressed: Scaffold.of(context).openDrawer,
        tooltip: 'View history',
      ),
    );
  }
}

class SettingsButton extends StatefulWidget {
  SettingsButton({Key key}) : super(key: key);

  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton>
    with SingleTickerProviderStateMixin {
  AnimationProvider animationProvider;

  @override
  void initState() {
    super.initState();
    animationProvider = Provider.of<AnimationProvider>(context, listen: false);
    animationProvider.fadeSettingsController = AnimationController(
      vsync: this,
      duration: AnimationProvider.expandedDuration,
    );
    animationProvider.fadeSettingsAnimation = CurvedAnimation(
      parent: animationProvider.fadeSettingsController,
      curve: Curves.fastOutSlowIn,
    );
    animationProvider.buttonFade();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationProvider.fadeSettingsAnimation,
      child: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => showModalBottomSheet(context: context, builder: (context) => SettingsDrawer()),
        tooltip: 'View settings',
      ),
    );
  }
}
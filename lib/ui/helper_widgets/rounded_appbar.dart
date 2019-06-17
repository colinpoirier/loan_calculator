import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final Widget leading;

  const RoundedAppBar({Key key, this.child, this.leading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        color: Theme.of(context).primaryColor,
        elevation: 5,
        child: SafeArea(
          top: true,
          child: NavigationToolbar(
            leading: leading,
            middle: child,
            centerMiddle: true,
          )
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
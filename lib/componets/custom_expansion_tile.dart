import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final Widget title;
  final List<Widget> children;
  final Widget trailing;
  final Function(bool)? onExpansionChanged;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    this.onExpansionChanged,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // Remove divider color
      ),
      child: ListTileTheme(
        // contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        child: ExpansionTile(
            onExpansionChanged: onExpansionChanged,
            title: title,
            trailing: trailing,
            children: children),
      ),
    );
  }
}

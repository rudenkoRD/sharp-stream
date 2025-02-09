import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.secondary;
    final fillColor = Theme.of(context).scaffoldBackgroundColor;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          focused = true;
        });
      },
      onExit: (_) {
        setState(() {
          focused = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        decoration: BoxDecoration(
          color: fillColor,
          boxShadow: [
            BoxShadow(
              color: borderColor,
              offset: focused ? Offset(1.0, 1.0) : Offset(3.0, 3.0),
            ),
            BoxShadow(
              color: Colors.black87,
              offset: focused ? Offset(0.0, 0.0) : Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
          border: Border.fromBorderSide(
            BorderSide(color: borderColor, width: 2),
          ),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}

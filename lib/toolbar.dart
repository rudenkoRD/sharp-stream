import 'package:flutter/material.dart';
import 'package:sharp_stream/action_button.dart';
import 'package:sharp_stream/input_field.dart';

class Toolbar extends StatelessWidget {
  final TextEditingController usernameController;
  final VoidCallback onHide;

  const Toolbar({
    super.key,
    required this.usernameController,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.surfaceBright,
              width: 2.0,
            ),
          ),
        ),
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 250,
              child: InputField(
                controller: usernameController,
              ),
            ),
            ActionButton(
              icon: Icon(
                Icons.fullscreen,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: onHide,
            ),
          ],
        ),
      );
}

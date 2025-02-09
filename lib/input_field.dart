import 'package:flutter/material.dart';
import 'package:sharp_stream/styles.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  const InputField({super.key, required this.controller});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final focusNode = FocusNode();
  bool focused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(listenFocus);
  }

  void listenFocus() {
    setState(() {
      focused = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.secondary;
    final fillColor = Theme.of(context).scaffoldBackgroundColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 70),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
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
      ),
      child: ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, value, __) {
            final isNotEmpty = value.text.isNotEmpty;

            return TextField(
              focusNode: focusNode,
              controller: widget.controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor,
                focusColor: fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  borderSide: BorderSide(width: 2.0, color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  borderSide: BorderSide(width: 2.0, color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  borderSide: BorderSide(width: 2.0, color: borderColor),
                ),
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 14.0),
                hintText: 'username',
                hintStyle: textStyle.copyWith(
                    color: borderColor.withValues(alpha: 0.6)),
                suffixIcon: isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            onTap: widget.controller.clear,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                      )
                    : null,
                suffixIconConstraints: BoxConstraints(maxHeight: 28.0),
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: borderColor),
            );
          }),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}

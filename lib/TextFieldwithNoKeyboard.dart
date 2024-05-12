import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithNoKeyboard extends EditableText {
  TextFieldWithNoKeyboard({
    Key? key,
    required TextEditingController controller,
    required TextStyle style,
    required Function(String) onValueUpdated,
    Color cursorColor = Colors.black,
    bool autofocus = false,
    Color? selectionColor,
  }) : super(
    key: key,
    controller: controller,
    focusNode: TextFieldFocusNode(),
    style: style,
    cursorColor: cursorColor,
    autofocus: autofocus,
    selectionColor: selectionColor,
    backgroundCursorColor: Colors.black,
    onChanged: onValueUpdated,
  );

  @override
  EditableTextState createState() => TextFieldEditableState();
}

class TextFieldEditableState extends EditableTextState {
  @override
  void requestKeyboard() {
    super.requestKeyboard();
    // Hide keyboard
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class TextFieldFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

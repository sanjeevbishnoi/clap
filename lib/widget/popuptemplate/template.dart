import 'package:flutter/cupertino.dart';
import 'package:flutter_beautiful_popup/main.dart';

class CustomPopup {
  BuildContext context;
  CustomPopup({required this.context});

  get popup => BeautifulPopup(
        context: context,
        template: TemplateSuccess,
      );
/* popup.show(
  title: 'String or Widget',
  content: 'String or Widget',
  actions: [
    popup.button(
      label: 'Close',
      onPressed: Navigator.of(context).pop,
    ),
  ],
  // bool barrierDismissible = false,
  // Widget close,
); */

} 

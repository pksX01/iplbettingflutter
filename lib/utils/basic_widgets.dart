import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipl_betting_app/utils/theme_colors.dart';
import 'package:ipl_betting_app/utils/theme_sizes.dart';
import 'package:rxdart/rxdart.dart';

class SizedText extends Text {
  SizedText(String label, double size,
      {Color color = Colors.black,
      FontWeight weight = FontWeight.normal,
      TextOverflow overflow = TextOverflow.clip})
      : super(label,
            style: TextStyle(color: color, fontSize: size, fontWeight: weight),
            overflow: overflow);
}

class InputText {
  final Color hintTextColor;
  final Color inputTextColor;
  Container textField;

  InputText(TextEditingController controller, String hintText,
      {this.hintTextColor,
      this.inputTextColor,
      int maxLength,
      Function(String) onSubmit}) {
    var textStyle = new TextStyle(
      color: hintTextColor,
      fontSize: ThemeSizes.textSmall,
    );

    textField = Container(
      child: TextField(
        controller: controller,
        autofocus: true,
        onEditingComplete:
            onSubmit == null ? () {} : () => onSubmit(controller.text),
        textInputAction: TextInputAction.go,
        decoration: new InputDecoration(
            labelText: hintText,
            labelStyle: textStyle,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0)),
        style: new TextStyle(
          color: inputTextColor,
          fontSize: ThemeSizes.textMedium,
        ),
        keyboardType: TextInputType.phone,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: maxLength,
      ),
    );
  }
}

class CustomDropDown<T> extends StatelessWidget {
  final Map<T, String> items;
  final Function(T) onchanged;
  final StreamController<T> stream = new PublishSubject<T>();
  final String hintText;

  CustomDropDown(this.items, this.onchanged,
      { this.hintText = "Select an Option"});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream.stream,
        builder: (ctx, data) =>
            data.hasData ? _dropDown(data.data) : _dropDown(null));
  }

  dispose() {
    stream.close();
  }

  _dropDown([T val]) => Container(
      alignment: Alignment.centerLeft,
      child: new DropdownButton<T>(
        isExpanded: true,
        value: val,
        isDense: false,
        hint: Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: new SizedText(
            "   " + hintText,
            24.0,
            color:ThemeColors.textDarkHighEm,
          ),
        ),
        items: items.entries.map((seg) {
          return new DropdownMenuItem<T>(
            child: new SizedText(
              "   " + seg.value,
              24.0,
              color:ThemeColors.textDarkHighEm,
            ),
            value: seg.key,
          );
        }).toList(),
        onChanged: (newVal) {
          onchanged(newVal);
          stream.add(newVal);
        },
      ));
}

class BasicAppBar extends AppBar {
  BasicAppBar(String title, {menuItems, backButtonAction})
      : super(title: Text(title), actions: menuItems);
}

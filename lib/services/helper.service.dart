import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Helper {
  static String curencyFormat(double amount) {
    return FlutterMoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
          symbol: 'R\$',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 2,
          compactFormatType: CompactFormatType.short
      )
    ).output.symbolOnLeft;
  }

  static String decimalFormat(double amount, {int decimals = 0}) {
    if (decimals > 0 || hasDecimalInAmount(amount))
      return FlutterMoneyFormatter(
        amount: amount,
        settings: MoneyFormatterSettings(
            thousandSeparator: '.',
            decimalSeparator: ',',
            fractionDigits: decimals,
            compactFormatType: CompactFormatType.short
        )
      ).output.nonSymbol;
    else
      return FlutterMoneyFormatter(
        amount: amount,
        settings: MoneyFormatterSettings(
            thousandSeparator: '.',
            fractionDigits: 0,
            compactFormatType: CompactFormatType.short
        )
      ).output.nonSymbol;
  }

  static bool hasDecimalInAmount(double amount) {
    return amount - amount.toInt() > 0;
  }

  static Widget getAlertDialog({
    @required BuildContext context,
    @required String title,
    String description,
    String btnText,
    Function onClose
  }) {
    if (getPlatform(context) == TargetPlatform.android)
      return AlertDialog(
        title: title!= null ? Text(title) : null,
        content: description != null ? Text(description) : null,
        actions: <Widget>[
          FlatButton(
            child: Text((btnText != null && btnText.isNotEmpty) ? btnText : 'OK'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) onClose();
            },
          )
        ],
      );
    else
      return CupertinoAlertDialog(
        title: title!= null ? Text(title) : null,
        content: description != null ? Text(description) : null,
        actions: <Widget>[
          FlatButton(
            child: Text((btnText != null && btnText.isNotEmpty) ? btnText : 'OK'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) onClose();
            },
          )
        ],
      );
  }

  static getConfirmDialog({
    @required BuildContext context,
    @required String title,
    String description,
    String yesText,
    String cancelText,
    Function onYes,
    Function onCancel
  }) {
    if (getPlatform(context) == TargetPlatform.android)
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: description != null ? Text(description) : null,
        actions: <Widget>[
          FlatButton(
            child: Text((cancelText != null && cancelText.isNotEmpty) ? cancelText : 'Não'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onCancel != null) onCancel();
            },
          ),
          FlatButton(
            child: Text((yesText != null && yesText.isNotEmpty) ? yesText : 'Sim'),
            onPressed: () {
              Navigator.of(context).pop();
              if (onYes != null) onYes();
            },
          )
        ],
      );
    else
      return CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: description != null ? Text(description) : null,
        actions: <Widget>[
          FlatButton(
            child: Text((cancelText != null && cancelText.isNotEmpty) ? cancelText : 'Não'),
            onPressed: () {
              if (context != null) Navigator.of(context).pop();
              if (onCancel != null) onCancel();
            },
          ),
          FlatButton(
            child: Text((yesText != null && yesText.isNotEmpty) ? yesText : 'Sim'),
            onPressed: () {
              if (context != null) Navigator.of(context).pop();
              if (onYes != null) onYes();
            },
          )
        ],
      );
  }

  static TargetPlatform getPlatform(BuildContext context) {
    return Theme.of(context).platform;
  }
}
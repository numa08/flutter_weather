import 'package:flutter/material.dart';

class LastUpdated extends StatelessWidget {
  final DateTime dateTime;

  const LastUpdated({Key key, @required this.dateTime})
      : assert(dateTime != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        'Updated: ${TimeOfDay.fromDateTime(dateTime).format(context)}',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w200, color: Colors.white),
      );
}

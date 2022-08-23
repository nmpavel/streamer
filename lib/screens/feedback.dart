import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Feedback extends StatefulWidget {
  const Feedback({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  int yesCount = 0;
  int noCount = 0;

  @override
  void initState() {
    getFeedbackCount(id: widget.id);
    super.initState();
  }

  getFeedbackCount({String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      yesCount = prefs.getInt('Yes${widget.id}') ?? 0;
      noCount = prefs.getInt('No${widget.id}') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Number of Yes: $yesCount'),
      ),
    );
  }
}

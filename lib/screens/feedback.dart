import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  int yesCount = 0;
  int noCount = 0;

  @override
  void initState() {
    getFeedbackCount();
    super.initState();
  }

  getFeedbackCount() async {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Number of Yes: $yesCount'),
            Text('Number of No: $noCount'),
          ],
        ),
      ),
    );
  }
}

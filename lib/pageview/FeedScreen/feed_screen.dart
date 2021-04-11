import 'package:chatterbox/pageview/FeedScreen/feed_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<FeedHelper>(context).feedBody(context),
    );
  }
}

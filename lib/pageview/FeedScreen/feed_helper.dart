import 'package:chatterbox/utils/universalcolorvariables.dart';
import 'package:flutter/material.dart';

class FeedHelper extends ChangeNotifier
{
    Widget feedBody(BuildContext context)
    {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
              decoration: BoxDecoration(
                  color: UniversalColorVariables.darkBlackColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
            ),
          ),
        ),
      );
    }
}
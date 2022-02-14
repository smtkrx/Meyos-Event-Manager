import 'package:event_manager/fonts/fonts.dart';
import 'package:event_manager/samples/group.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import '../fonts/size.dart';

class CategoryButton extends StatelessWidget {
  final Group grp;
  final Function function;
//Made for the Category bar on the right of the All events page.
  const CategoryButton(this.grp, this.function);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalBlockSize * 2.5,
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: AnimatedButton(
          width: SizeConfig.horizontalBlockSize * 13,
          child: (grp.icon != null)
              ? Icon(
                  grp.icon,
                  color: grp.color,
                )
              : Text(
                  grp.title.toUpperCase().substring(0, 1),
                  style: MyFonts.bold.setColor(grp.color).size(25),
                ),
          color: Colors.black,
          onPressed: function,
          enabled: true,
          shadowDegree: ShadowDegree.light,
        ),
      ),
    );
  }
}

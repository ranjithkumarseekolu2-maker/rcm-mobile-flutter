import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/notification.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


class NotificationsCardWidget extends StatelessWidget {

final BuddyNotification? item;
NotificationsCardWidget({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ThemeConstants.whiteColor,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.task_alt_outlined,
                  color: Colors.green,
                  size: 25,
                ),
                SizedBox(
                  width: ThemeConstants.width10,
                ),
                Expanded(
                  child: Container(
                    // width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        item!.notificationText!,
                          
                            maxLines: 3,
                            style: Styles.labelStyles),
                        //   Text(" 9398867341", style: Styles.greyLabelStyles3),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ThemeConstants.width10),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                 timeago.format(
                      DateTime.parse(item!.createdAt!),
                      locale: 'en_short'),
                textAlign: TextAlign.end,
                style: Styles.greyLabelStyles3,
              ),
            )
          ],
        ),
      ),
    );
  }
}

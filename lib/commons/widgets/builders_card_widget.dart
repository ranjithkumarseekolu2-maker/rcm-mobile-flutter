import 'package:brickbuddy/commons/utils/date_util.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class BuildersCardWidget extends StatelessWidget {
  final dynamic item;
  VoidCallback? onPressedOnCall;
  BuildersCardWidget({super.key, this.item, this.onPressedOnCall});

  // AppointmentsController appointmentController = Get.find();
  @override
  Widget build(BuildContext context) {
    print('items.... ${item['agentId']}');
    String inputString = DateTimeUtils.formatMeetingTime(item['createdAt']);

    // Split the input string by space to separate time and AM/PM indicator
    List<String> components = inputString.split(' ');

    // Split the time component by colon to separate hours and minutes
    List<String> timeComponents = components[0].split(':');

    // Parse the hour component as an integer
    int hour = int.parse(timeComponents[0]);

    // Check if the hour is less than 10 and greater than 0 (indicating AM)
    if (hour < 10 && hour > 0) {
      // Add leading zero to the hour
      timeComponents[0] = '0$hour';
    } else if (hour == 0) {
      // Handle midnight (12:00 AM)
      timeComponents[0] = '12';
    } else if (hour > 12) {
      // Subtract 12 to switch to 12-hour format
      hour -= 12;
      // Add leading zero to the hour if it's less than 10
      if (hour < 10) {
        timeComponents[0] = '0$hour';
      } else {
        timeComponents[0] = hour.toString();
      }
    }

    // Construct the formatted string
    String formattedString = "${timeComponents.join(':')} ${components[1]}";
    print('formString $formattedString');

    return Card(
      color: ThemeConstants.whiteColor,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  item['builder']['DISPLAY_NAME'] != null
                                      ? Text(
                                          toBeginningOfSentenceCase(
                                                  item['builder']
                                                      ['DISPLAY_NAME']) ??
                                              "",
                                          style: Styles.label2Styles,
                                        )
                                      : Text("-"),
                                  item['builder']['ABOUT_BUILDER'] != null
                                      ? SizedBox(
                                          height: ThemeConstants.height6,
                                        )
                                      : SizedBox.shrink(),
                                  item['builder']['ABOUT_BUILDER'] != null
                                      ? Text(
                                          toBeginningOfSentenceCase(
                                                      item['builder']
                                                          ['ABOUT_BUILDER'])
                                                  .toString() ??
                                              "",
                                          style: Styles.hintStylesLight,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )
                                      : SizedBox.shrink(),
                                  item['builder']['HEAD_OFC_ADDRESS'] != null ||
                                          item['builder']
                                                  ['BRANCH_OFC_ADDRESS'] !=
                                              null
                                      ? SizedBox(
                                          height: ThemeConstants.height6,
                                        )
                                      : SizedBox.shrink(),
                                  item['builder']['HEAD_OFC_ADDRESS'] != null
                                      ? Row(
                                          children: [
                                            Icon(
                                              LineIcons.mapMarker,
                                              color: ThemeConstants.iconColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: ThemeConstants.width2,
                                            ),
                                            Expanded(
                                              child: Text(
                                                toBeginningOfSentenceCase(item[
                                                            'builder']
                                                        ['HEAD_OFC_ADDRESS'])
                                                    .toString(),
                                                style: Styles.hintStylesLight,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                      : item['builder']['BRANCH_OFC_ADDRESS'] !=
                                              null
                                          ? Row(
                                              children: [
                                                Icon(
                                                  LineIcons.mapMarker,
                                                  color:
                                                      ThemeConstants.iconColor,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: ThemeConstants.width2,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    toBeginningOfSentenceCase(item[
                                                                'builder'][
                                                            'BRANCH_OFC_ADDRESS'])
                                                        .toString(),
                                                    style:
                                                        Styles.hintStylesLight,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox.shrink(),
                                  SizedBox(
                                    height: ThemeConstants.height10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            LineIcons.calendar,
                                            size: 20,
                                            color: ThemeConstants.iconColor,
                                          ),
                                          SizedBox(
                                            width: ThemeConstants.width4,
                                          ),
                                          Text(
                                            DateTimeUtils.formatMeetingDate(
                                                item['createdAt']),
                                            style: Styles.hintStylesLight,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            LineIcons.clock,
                                            size: 20,
                                            color: ThemeConstants.iconColor,
                                          ),
                                          SizedBox(
                                            width: ThemeConstants.width4,
                                          ),
                                          Text(
                                            formattedString,
                                            //  DateTimeUtils.formatMeetingTime(item!.startDateTime),
                                            style: Styles.hintStylesLight,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        //SizedBox(height:ThemeConstants.height6),
                      ],
                    )),
                SizedBox(width: ThemeConstants.width10),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 1,
                color: const Color.fromRGBO(0, 0, 0, 0.05),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onPressedOnCall,
                  child: Row(
                    children: [
                      Icon(
                        LineIcons.phone,
                        color: ThemeConstants.primaryColor,
                        size: 15,
                      ),
                      SizedBox(
                        width: ThemeConstants.width4,
                      ),
                      Text(
                        item['builder']['OFC_PRIMARY_CONTACT_NO'],
                        style: Styles.linkStyles,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: item['status'] == 1
                          ? Color.fromARGB(255, 209, 252, 211)
                          : Color.fromARGB(255, 199, 230, 253),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6.0),
                    child: Text(
                      item['status'] == 0 ? 'Pending' : 'Active',
                      style: TextStyle(
                          color: item['status'] == 1
                              ? Color.fromARGB(255, 3, 141, 10)
                              : Colors.blue,
                          fontSize: ThemeConstants.fontSize10),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  buildLabel(label) {
    return Row(
      children: [
        Text(
          label,
          style: Styles.labelStyles,
        ),
        label == "Description" || label == "Selected Lead"
            ? SizedBox.shrink()
            : Text(
                ' *',
                style: TextStyle(
                    color: ThemeConstants.errorColor,
                    decoration: TextDecoration.none,
                    fontSize: ThemeConstants.fontSize14),
              )
      ],
    );
  }
}

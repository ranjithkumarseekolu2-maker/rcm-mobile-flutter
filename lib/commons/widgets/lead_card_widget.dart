// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class LeadCardWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onPressedOnPhoneNumber;
  final VoidCallback? onPressedOnWhatsapp;
  dynamic item;

  LeadCardWidget(
      {super.key,
      required this.onPressed,
      required this.item,
      required this.onPressedOnWhatsapp,
      required this.onPressedOnPhoneNumber});

//  LeadCardWidget();
  @override
  Widget build(BuildContext context) {
    print('item....12 $item');
    return Card(
        color: ThemeConstants.whiteColor,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // add Card-like elevation
            // boxShadow: kElevationToShadow[4],
            // gradient: LinearGradient(
            //   stops: const [0.02, 0.02],
            //   colors: [
            //     item['leadStatus'] == 'new'
            //         ? Colors.green
            //         : item['leadStatus'] == 'existing'
            //             ? Colors.blue
            //             : item['leadStatus'] == 'coldLead'
            //                 ? Colors.orange
            //                 : Colors.red,
            //     Colors.white!,
            //   ],
            // ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(width: 10.0),
                        // Text(
                        //   "${toBeginningOfSentenceCase(item['contacts']['FIRST_NAME'])}",
                        //   style: Styles.label2Styles,
                        // ),
                        item['contacts']['LAST_NAME'] != ''
                            ? Flexible(
                                child: Text(
                                  item['contacts']['FIRST_NAME'] +
                                      ' ' +
                                      item['contacts']['LAST_NAME'],
                                  style: Styles.label2Styles,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Flexible(
                                child: Text(
                                  item['contacts']['FIRST_NAME'] ?? '',
                                  style: Styles.label2Styles,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        Container(
                          decoration: BoxDecoration(
                              color: item['agentStatus'] == 'Qualify' ||
                                      item['agentStatus'] == 'Schedule Site Visit' ||
                                      item['agentStatus'] == 'Site Visit'
                                  ? Color.fromARGB(255, 199, 230, 253)
                                   : item['agentStatus'] == 'Pre Qualify'
                                      ? Colors.grey[300]
                                  : item['agentStatus'] == 'Negotiation In Progress' ||
                                          item['agentStatus'] == 'Agreement' ||
                                          item['agentStatus'] ==
                                              'Payment In Progress'
                                      ? Color.fromARGB(255, 255, 243, 208)
                                      : item['agentStatus'] == 'Closed Lost'
                                          ? Color.fromARGB(255, 255, 210, 207)
                                          : Color.fromARGB(255, 209, 252, 211),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 8.0),
                            child: Text(
                              "${item['agentStatus']}",
                              style: TextStyle(
                                  color: item['agentStatus'] == 'Qualify' ||
                                          item['agentStatus'] == 'Schedule Site Visit' ||
                                          item['agentStatus'] == 'Site Visit'
                                      ? Colors.lightBlue[900]
                                      : item['agentStatus'] == 'Pre Qualify' 
                                          ? Colors.black
                                          : item['agentStatus'] ==
                                                      'Agreement' ||
                                                  item['agentStatus'] ==
                                                      'Negotiation In Progress' ||
                                                  item['agentStatus'] ==
                                                      'Payment In Progress'
                                              ? const Color.fromARGB(
                                                  255, 148, 111, 1)
                                              : item['agentStatus'] ==
                                                      'Closed Lost'
                                                  ? Color.fromARGB(
                                                      255, 155, 13, 3)
                                                  : Color.fromARGB(
                                                      255, 3, 141, 10),
                                  fontSize: ThemeConstants.fontSize10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ThemeConstants.height6),
                    Row(
                      children: [
                        Icon(
                          LineIcons.building,
                          color: ThemeConstants.iconColor,
                          size: 20,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '${toBeginningOfSentenceCase(item['project']['PROJECT_NAME'])}',
                          style: Styles.hintStyles,
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: onPressedOnPhoneNumber,
                          child: Row(
                            children: [
                              Icon(
                                LineIcons.phone,
                                color: ThemeConstants.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                '${item['contacts']['PRIMARY_NUMBER']}',
                                style: Styles.linkStyles,
                              ),
                              SizedBox(width: 5.0),
                              InkWell(
                                onTap: onPressedOnWhatsapp,
                                child: Icon(
                                  LineIcons.whatSApp,
                                  color: Colors.green,
                                  size: 20,
                                  weight: 50,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //  OutlinedButton(onPressed: () {}, child: Text('view')),
                        InkWell(
                          onTap: onPressed,
                          child: Row(
                            children: [
                              Text('View Details', style: Styles.textBtnStyle),
                              Icon(
                                Icons.chevron_right,
                                color: ThemeConstants.primaryColor,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                        // MaterialButton(
                        //   // minWidth: Get.width * 0.15,
                        //   height: ThemeConstants.height24,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(2),
                        //   ),
                        //   color: ThemeConstants.primaryColor,
                        //   onPressed: onPressed,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('View', style: Styles.whiteSubHeadingStyles3),
                        //       SizedBox(
                        //         width: ThemeConstants.width2,
                        //       ),
                        //       Icon(
                        //         LineIcons.chevronCircleRight,
                        //         color: Colors.white,
                        //         size: 18,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // IconButton(
                        //     icon: Icon(
                        //       Icons.remove_red_eye,
                        //       size: 20,
                        //     ),
                        //     onPressed: onPressed),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.calendar_month,
                    //       color: Colors.grey[700],
                    //       size: 15,
                    //     ),
                    //     SizedBox(width: 5.0),
                    //     Text(DateFormat('dd-MM-yyyy')
                    //         .format(DateTime.parse(item['updatedAt']))),
                    //   ],
                    // ),
                  ],
                ),
                SizedBox(width: ThemeConstants.width10),
              ],
            ),
          ),
        ));
  }
}

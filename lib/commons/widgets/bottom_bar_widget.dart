import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/components/contacts/contacts_controller.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class BottombarWidget extends StatelessWidget {
  const BottombarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          selectedItemColor: ThemeConstants.primaryColor,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                LineIcons.home,
                color: ThemeConstants.greyColor,
                size: 28,
              ),
              label: "Home",
              activeIcon: Icon(
                LineIcons.home,
                color: ThemeConstants.primaryColor,
                size: 28,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineIcons.phone,
                color: ThemeConstants.greyColor,
                size: 28,
              ),
              label: "Contacts",
              activeIcon: Icon(
                LineIcons.phone,
                color: ThemeConstants.primaryColor,
                size: 28,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineIcons.buildingAlt,
                color: ThemeConstants.greyColor,
                size: 28,
              ),
              label: "Projects",
              activeIcon: Icon(
                LineIcons.buildingAlt,
                color: ThemeConstants.primaryColor,
                size: 28,
              ),
            ),
            BottomNavigationBarItem(
              icon: LineIcon.user(
                size: 28,
                color: ThemeConstants.greyColor,
              ),
              label: "Leads",
              activeIcon: LineIcon.user(
                size: 28,
                color: ThemeConstants.primaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                LineIcons.bars,
                color: ThemeConstants.greyColor,
                size: 28,
              ),
              label: "Menu",
              activeIcon: Icon(
                LineIcons.bars,
                color: ThemeConstants.primaryColor,
                size: 28,
              ),
            ),
          ],
          currentIndex: CommonService.instance.selectedIndex.value,
          onTap: (index) async {
            print('index: $index');

            CommonService.instance.selectedIndex.value = index;
            if (index == 0) {
              HomeController homeController = Get.put(HomeController());
              homeController.getDashboardDetails();
              Get.delete<HomeController>(force: true);
              Get.toNamed(Routes.homeScreen);
            }
            if (index == 1) {
              Get.delete<ContactsController>(force: true);
              Get.toNamed(Routes.contactsComponent);
            }
            if (index == 2) {
              Get.delete<ProjectsController>(force: true);
              Get.toNamed(Routes.projects);
            }
            if (index == 3) {
              CommonService.instance.isFilterSelected.value = false;
              CommonService.instance.selectedBuilderId.value = '';
              CommonService.instance.selectedBuilder.value = '';
              CommonService.instance.selectedActivity.value = '';
              CommonService.instance.selectedProject.value = '';
              CommonService.instance.selectedProjectId.value = '';
              CommonService.instance.selectedStatus.value = '';
              Get.delete<LeadsListingController>(force: true);
              Get.toNamed(Routes.leads);
            }
            if (index == 4) {
              Get.toNamed(Routes.menuScreen);
            }
          },
          selectedFontSize: 13,
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: ThemeConstants.fontFamily,
              color: ThemeConstants.primaryColor),
          unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: ThemeConstants.fontFamily,
              color: ThemeConstants.greyColor),
          unselectedFontSize: 13,
          iconSize: 20,
          elevation: 0,
          backgroundColor: Colors.white,
        ));
  }
}

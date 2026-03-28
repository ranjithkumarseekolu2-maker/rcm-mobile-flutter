import 'package:brickbuddy/components/add_new_contact/add_new_contact_component.dart';
import 'package:brickbuddy/components/appointments/appointments_component.dart';
import 'package:brickbuddy/components/contact_support/contact_support_component.dart';
import 'package:brickbuddy/components/contacts/contacts_component.dart';
import 'package:brickbuddy/components/create_builder/create_builder_component.dart';
import 'package:brickbuddy/components/faq/faq_component.dart';
import 'package:brickbuddy/components/home/home_component.dart';
import 'package:brickbuddy/components/leads/filter_leads_component.dart';
import 'package:brickbuddy/components/leads/lead_listing_component.dart';
import 'package:brickbuddy/components/login/forgot_details/forgot_details_component.dart';
import 'package:brickbuddy/components/login/forgot_details/verify_otp/otp_verification_component.dart';
import 'package:brickbuddy/components/login/login_component.dart';
import 'package:brickbuddy/components/login/signup/otp_verification/verify_otp_component.dart';

import 'package:brickbuddy/components/login/signup/signup_component.dart';
import 'package:brickbuddy/components/login/signup/sucess_component.dart';
import 'package:brickbuddy/components/menu/menu_component.dart';
import 'package:brickbuddy/components/my_builders/my_builders_component.dart';
import 'package:brickbuddy/components/notifications/notifications_component.dart';
import 'package:brickbuddy/components/project_documents/project_documents_component.dart';
import 'package:brickbuddy/components/projects/create_project_component.dart';

import 'package:brickbuddy/components/projects/projects_component.dart';
import 'package:brickbuddy/components/projects/refer/refer_component.dart';
import 'package:brickbuddy/components/splash_screen/splash_component.dart';
import 'package:get/get.dart';

part './app_routes.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.splashScreen,
      page: () => SplashComponent(),
    ),
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginComponent(),
    ),
    GetPage(
      name: Routes.homeScreen,
      page: () => HomeComponent(),
    ),
    GetPage(
      name: Routes.projects,
      page: () => ProjectsComponent(),
    ),
    GetPage(
      name: Routes.signupScreen,
      page: () => SignupComponent(),
    ),
    GetPage(
      name: Routes.menuScreen,
      page: () => MenuComponent(),
    ),
    GetPage(
      name: Routes.appointmentsScreen,
      page: () => AppointmentsComponent(),
    ),
    GetPage(
      name: Routes.contactsComponent,
      page: () => ContactsComponent(),
    ),
    GetPage(
      name: Routes.leads,
      page: () => LeadListingComponent(),
    ),
    GetPage(
      name: Routes.filter,
      page: () => Filter_leads(),
    ),
    GetPage(
      name: Routes.createproject,
      page: () => CreateProject(),
    ),
    GetPage(
      name: Routes.addcontact,
      page: () => Add_Contact(),
    ),
    GetPage(
      name: Routes.notificationsComponent,
      page: () => NotificationsComponent(),
    ),
    GetPage(
      name: Routes.otpverification,
      page: () => Otp_Verification(),
    ),
    GetPage(
      name: Routes.sucess,
      page: () => SucessComponent(),
    ),
    GetPage(
      name: Routes.sucess,
      page: () => SucessComponent(),
    ),
    GetPage(
      name: Routes.projectDocuments,
      page: () => ProjectsDocumentsComponent(),
    ),
    GetPage(
      name: Routes.forgotDetailsComponent,
      page: () => ForgotDetailsComponent(),
    ),
    GetPage(
      name: Routes.verifyOtpComponent,
      page: () => VerifyOtpComponent(),
    ),
    GetPage(
      name: Routes.faqScreen,
      page: () => FAQComponent(),
    ),
    GetPage(
      name: Routes.support,
      page: () => CustomerSupportComponent(),
    ),
    GetPage(
      name: Routes.referComponent,
      page: () => ReferComponent(),
    ),
    GetPage(
      name: Routes.createBuilderComponent,
      page: () => CreateBuilderComponent(),
    ),
    GetPage(
      name: Routes.myBuildersComponent,
      page: () => MyBuildersComponent(),
    ),
  ];
}

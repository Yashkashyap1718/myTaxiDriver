import 'package:driver/app/modules/create_support_ticket/bindings/create_support_ticket_binding.dart';
import 'package:driver/app/modules/create_support_ticket/views/create_support_ticket_view.dart';
import 'package:driver/app/modules/support_screen/bindings/support_screen_binding.dart';
import 'package:driver/app/modules/support_screen/views/support_screen_view.dart';
import 'package:driver/app/modules/support_ticket_details/bindings/support_ticket_details_binding.dart';
import 'package:driver/app/modules/support_ticket_details/views/support_ticket_details_view.dart';
import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/documents_model.dart';
import '../modules/add_bank/bindings/add_bank_binding.dart';
import '../modules/add_bank/views/add_bank_view.dart';
import '../modules/ask_for_otp/bindings/ask_for_otp_binding.dart';
import '../modules/ask_for_otp/views/ask_for_otp_view.dart';
import '../modules/booking_details/bindings/booking_details_binding.dart';
import '../modules/booking_details/views/booking_details_view.dart';
import '../modules/chat_screen/bindings/chat_screen_binding.dart';
import '../modules/chat_screen/views/chat_screen_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/html_view_screen/bindings/html_view_screen_binding.dart';
import '../modules/html_view_screen/views/html_view_screen_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_bank/bindings/my_bank_binding.dart';
import '../modules/my_bank/views/my_bank_view.dart';
import '../modules/my_rides/bindings/my_rides_binding.dart';
import '../modules/my_rides/views/my_rides_view.dart';
import '../modules/my_wallet/bindings/my_wallet_binding.dart';
import '../modules/my_wallet/views/my_wallet_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/otp_screen/bindings/otp_screen_binding.dart';
import '../modules/otp_screen/views/otp_screen_view.dart';
import '../modules/permission/bindings/permission_binding.dart';
import '../modules/permission/views/permission_view.dart';
import '../modules/reason_for_cancel/bindings/reason_for_cancel_binding.dart';
import '../modules/reason_for_cancel/views/reason_for_cancel_view.dart';
import '../modules/review_screen/bindings/review_screen_binding.dart';
import '../modules/review_screen/views/review_screen_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/track_ride_screen/bindings/track_ride_screen_binding.dart';
import '../modules/track_ride_screen/views/track_ride_screen_view.dart';
import '../modules/update_vehicle_details/bindings/update_vehicle_details_binding.dart';
import '../modules/update_vehicle_details/views/update_vehicle_details_view.dart';
import '../modules/upload_documents/bindings/upload_documents_binding.dart';
import '../modules/upload_documents/views/upload_documents_view.dart';
import '../modules/verify_documents/bindings/verify_documents_binding.dart';
import '../modules/verify_documents/views/verify_documents_view.dart';
import '../modules/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/verify_otp/views/verify_otp_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREEN,
      page: () => const IntroScreenView(),
      binding: IntroScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD_DOCUMENTS,
      page: () => UploadDocumentsView(
        document: DocumentsModel(
            id: '', isEnable: false, isTwoSide: false, title: ''),
        isUploaded: false,
      ),
      binding: UploadDocumentsBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_VEHICLE_DETAILS,
      page: () => const UpdateVehicleDetailsView(
        isUploaded: false,
      ),
      binding: UpdateVehicleDetailsBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_DOCUMENTS,
      page: () => const VerifyDocumentsView(isFromDrawer: false),
      binding: VerifyDocumentsBinding(),
    ),
    GetPage(
      name: _Paths.MY_RIDES,
      page: () => MyRidesView(),
      binding: MyRidesBinding(),
    ),
    GetPage(
      name: _Paths.ASK_FOR_OTP,
      page: () => const AskForOtpView(),
      binding: AskForOtpBinding(),
    ),
    GetPage(
      name: _Paths.OTP_SCREEN,
      page: () => OtpScreenView(
        bookingModel: BookingModel(),
      ),
      binding: OtpScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_DETAILS,
      page: () => const BookingDetailsView(),
      binding: BookingDetailsBinding(),
    ),
    GetPage(
      name: _Paths.REASON_FOR_CANCEL,
      page: () => ReasonForCancelView(
        bookingModel: BookingModel(),
      ),
      binding: ReasonForCancelBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.MY_WALLET,
      page: () => const MyWalletView(),
      binding: MyWalletBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),
    GetPage(
      name: _Paths.PERMISSION,
      page: () => const PermissionView(),
      binding: PermissionBinding(),
    ),
    GetPage(
      name: _Paths.HTML_VIEW_SCREEN,
      page: () => const HtmlViewScreenView(
        title: '',
        htmlData: '',
      ),
      binding: HtmlViewScreenBinding(),
    ),
    GetPage(
      name: _Paths.TRACK_RIDE_SCREEN,
      page: () => const TrackRideScreenView(),
      binding: TrackRideScreenBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(
        receiverId: '',
      ),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_SCREEN,
      page: () => const ReviewScreenView(),
      binding: ReviewScreenBinding(),
    ),
    GetPage(
      name: _Paths.MY_BANK,
      page: () => const MyBankView(),
      binding: MyBankBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BANK,
      page: () => const AddBankView(),
      binding: AddBankBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT_SCREEN,
      page: () => const SupportScreenView(),
      binding: SupportScreenBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_SUPPORT_TICKET,
      page: () => const CreateSupportTicketView(),
      binding: CreateSupportTicketBinding(),
    ),
    GetPage(
      name: _Paths.SUPPORT_TICKET_DETAILS,
      page: () => const SupportTicketDetailsView(),
      binding: SupportTicketDetailsBinding(),
    ),
  ];
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/admin_commission.dart';
import 'package:driver/app/models/bank_detail_model.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/currencies_model.dart';
import 'package:driver/app/models/documents_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/app/models/support_reason_model.dart';
import 'package:driver/app/models/support_ticket_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/app/models/vehicle_brand_model.dart';
import 'package:driver/app/models/vehicle_model_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/models/withdraw_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class FireStoreUtils {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return firebaseAuth.currentUser!.uid;
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (firebaseAuth.currentUser != null) {
      isLogin = await userExistOrNot(firebaseAuth.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.drivers).doc(uid).get().then(
      (value) {
        if (value.exists) {
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<bool> updateDriverUserLocation(
      DriverUserModel userModel) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.drivers)
        .doc(userModel.id)
        .update(userModel.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> updateDriverUser(DriverUserModel userModel) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.drivers)
        .doc(userModel.id)
        .set(userModel.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<LanguageModel>> getLanguage() async {
    List<LanguageModel> languageModelList = [];
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection(CollectionName.languages)
        .get();
    for (var document in snap.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        languageModelList.add(LanguageModel.fromJson(data));
      } else {
        print('getLanguage is null ');
      }
    }
    return languageModelList;
  }

  static Future<bool> updateDriverUserOnline(bool isOnline) async {
    bool isUpdate = false;
    DriverUserModel? userModel = await getDriverUserProfile(getCurrentUid());
    if (userModel != null) {
      userModel.isOnline = isOnline;
      await fireStore
          .collection(CollectionName.drivers)
          .doc(userModel.id)
          .set(userModel.toJson())
          .whenComplete(() {
        isUpdate = true;
      }).catchError((error) {
        log("Failed to update user: $error");
        isUpdate = false;
      });
    }
    return isUpdate;
  }

  static Future<DriverUserModel?> getDriverUserProfile(String uuid) async {
    DriverUserModel? userModel;
    await fireStore
        .collection(CollectionName.drivers)
        .doc(uuid)
        .get()
        .then((value) {
      if (value.exists) {
        userModel = DriverUserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to get user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<UserModel?> getUserProfileByUserId(String uuid) async {
    UserModel? userModel;
    await fireStore
        .collection(CollectionName.drivers)
        .doc(uuid)
        .get()
        .then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to get user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<UserModel?> getUserProfile(String uuid) async {
    UserModel? userModel;
    await fireStore
        .collection(CollectionName.users)
        .doc(uuid)
        .get()
        .then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<bool?> deleteDriverUser() async {
    bool? isDelete;
    try {
      await fireStore
          .collection(CollectionName.drivers)
          .doc(FireStoreUtils.getCurrentUid())
          .delete();
      await firebaseAuth.currentUser!.delete().then((value) {
        isDelete = true;
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isDelete;
  }

  static Future<bool?> updateDriverUserWallet({required String amount}) async {
    bool isAdded = false;
    await getDriverUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) async {
      if (value != null) {
        DriverUserModel userModel = value;
        userModel.walletAmount =
            (double.parse(userModel.walletAmount.toString()) +
                    double.parse(amount))
                .toString();
        await FireStoreUtils.updateDriverUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> updateTotalEarning({required String amount}) async {
    bool isAdded = false;
    await getDriverUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) async {
      if (value != null) {
        DriverUserModel userModel = value;
        userModel.totalEarning =
            (double.parse(userModel.totalEarning.toString()) +
                    double.parse(amount))
                .toString();
        await FireStoreUtils.updateDriverUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> updateOtherUserWallet(
      {required String amount, required String id}) async {
    bool isAdded = false;
    await getDriverUserProfile(id).then((value) async {
      if (value != null) {
        DriverUserModel userModel = value;
        userModel.walletAmount =
            (double.parse(userModel.walletAmount.toString()) +
                    double.parse(amount))
                .toString();
        await FireStoreUtils.updateDriverUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<BookingModel?> getRideDetails(String bookingId) async {
    BookingModel? bookingModel;
    await fireStore
        .collection(CollectionName.bookings)
        .where("id", isEqualTo: bookingId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        bookingModel = BookingModel.fromJson(element.data());
      }
    }).catchError((error) {
      log(error.toString());
    });
    return bookingModel;
  }

  static Future<List<VehicleTypeModel>?> getVehicleType() async {
    List<VehicleTypeModel> vehicleTypeList = [];
    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.vehicleType)
          .where("isActive", isEqualTo: true)
          .get();

      print("*****Length : ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isEmpty) {
        print("No active vehicle types found.");
        return vehicleTypeList; // Return empty list if no documents are found
      }

      for (var element in querySnapshot.docs) {
        VehicleTypeModel vehicleTypeModel =
            VehicleTypeModel.fromJson(element.data());
        vehicleTypeList.add(vehicleTypeModel);
      }
    } catch (error) {
      log("Error fetching vehicle types: $error");
      return null; // Return null or an empty list in case of an error
    }

    return vehicleTypeList; // Returns the populated list or an empty list
  }

  static Future<List<DocumentsModel>?> getDocumentList() async {
    List<DocumentsModel> documentList = [];
    await fireStore
        .collection(CollectionName.documents)
        .where("isEnable", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        DocumentsModel vehicleTypeModel =
            DocumentsModel.fromJson(element.data());
        documentList.add(vehicleTypeModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return documentList;
  }

  static Future<List<VehicleBrandModel>?> getVehicleBrand() async {
    List<VehicleBrandModel> vehicleTypeList = [];
    await fireStore
        .collection(CollectionName.vehicleBrand)
        .where("isEnable", isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        VehicleBrandModel vehicleTypeModel =
            VehicleBrandModel.fromJson(element.data());
        vehicleTypeList.add(vehicleTypeModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return vehicleTypeList;
  }

  static Future<List<VehicleModelModel>?> getVehicleModel(
      String brandId) async {
    List<VehicleModelModel> vehicleTypeList = [];
    await fireStore
        .collection(CollectionName.vehicleModel)
        .where("isEnable", isEqualTo: true)
        .where("brandId", isEqualTo: brandId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        VehicleModelModel vehicleTypeModel =
            VehicleModelModel.fromJson(element.data());
        vehicleTypeList.add(vehicleTypeModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return vehicleTypeList;
  }

  static Future<bool> addDocument(VerifyDriverModel verifyDriver) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.verifyDriver)
        .doc(verifyDriver.driverId)
        .set(verifyDriver.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update data: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<VerifyDriverModel?> getVerifyDriver(String uuid) async {
    VerifyDriverModel? verifyDriverModel;

    await fireStore
        .collection(CollectionName.verifyDriver)
        .where('driverId', isEqualTo: uuid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        verifyDriverModel = VerifyDriverModel.fromJson(value.docs.first.data());
      } else {
        verifyDriverModel = null;
      }
    }).catchError((error) {
      log("Failed to update data: $error");
      verifyDriverModel = null;
    });
    return verifyDriverModel;
  }

  Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    await fireStore
        .collection(CollectionName.currency)
        .where("active", isEqualTo: true)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currencyModel;
  }

  getSettings() async {
    await fireStore
        .collection(CollectionName.settings)
        .doc("constant")
        .get()
        .then((value) {
      if (value.exists) {
        Constant.mapAPIKey = value.data()!["googleMapKey"];
        Constant.senderId = value.data()!["notification_senderId"];
        Constant.jsonFileURL = value.data()!["jsonFileURL"];
        Constant.minimumAmountToWithdrawal =
            value.data()!["minimum_amount_withdraw"];
        Constant.minimumAmountToDeposit =
            value.data()!["minimum_amount_deposit"];
        Constant.appName = value.data()!["appName"];
        Constant.appColor = value.data()!["appColor"];
        Constant.termsAndConditions = value.data()!["termsAndConditions"];
        Constant.privacyPolicy = value.data()!["privacyPolicy"];
        Constant.aboutApp = value.data()!["aboutApp"];
      }
    });
    await fireStore
        .collection(CollectionName.settings)
        .doc("globalValue")
        .get()
        .then((value) {
      if (value.exists) {
        Constant.distanceType = value.data()!["distanceType"];
        Constant.driverLocationUpdate = value.data()!["driverLocationUpdate"];
        Constant.radius = value.data()!["radius"];
        Constant.minimumAmountToAcceptRide =
            value.data()!["minimum_amount_accept_ride"];
      }
    });
    await fireStore
        .collection(CollectionName.settings)
        .doc("canceling_reason")
        .get()
        .then((value) {
      if (value.exists) {
        Constant.cancellationReason = value.data()!["reasons"];
      }
    });

    await fireStore
        .collection(CollectionName.settings)
        .doc("global")
        .get()
        .then((value) {
      if (value.exists) {
        // Constant.appVersion = value.data()!["appVersion"];
      }
    });

    await fireStore
        .collection(CollectionName.settings)
        .doc("admin_commission")
        .get()
        .then((value) {
      // Check if the document exists and contains data
      if (value.exists && value.data() != null) {
        AdminCommission adminCommission =
            AdminCommission.fromJson(value.data()!);
        if (adminCommission.active == true) {
          Constant.adminCommission = adminCommission;
        }
      } else {
        // Handle the case when the document doesn't exist or has no data
        print('************Document does not exist or has no data');
      }
    }).catchError((error) {
      // Log the error or handle it
      print('************Error fetching admin commission: $error');
    });

    await fireStore
        .collection(CollectionName.settings)
        .doc("referral")
        .get()
        .then((value) {
      if (value.exists) {
        Constant.referralAmount = value.data()!["referralAmount"];
      }
    });

    await fireStore
        .collection(CollectionName.settings)
        .doc("contact_us")
        .get()
        .then((value) {
      if (value.exists) {
        Constant.supportURL = value.data()!["supportURL"];
      }
    });
  }

  Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await fireStore
        .collection(CollectionName.settings)
        .doc("payment")
        .get()
        .then((value) {
      paymentModel = PaymentModel.fromJson(value.data()!);
      Constant.paymentModel = PaymentModel.fromJson(value.data()!);
    });
    print("Payment Data : ${json.encode(paymentModel!.toJson().toString())}");
    return paymentModel;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModelList = [];

    await fireStore
        .collection(CollectionName.walletTransaction)
        .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
        .where('type', isEqualTo: "driver")
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WalletTransactionModel walletTransactionModel =
            WalletTransactionModel.fromJson(element.data());
        walletTransactionModelList.add(walletTransactionModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return walletTransactionModelList;
  }

  static Future<bool?> setWalletTransaction(
      WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    log("====> 3");
    await fireStore
        .collection(CollectionName.walletTransaction)
        .doc(walletTransactionModel.id)
        .set(walletTransactionModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> setBooking(BookingModel bookingModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.bookings)
        .doc(bookingModel.id)
        .set(bookingModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to add ride: $error");
      isAdded = false;
    });
    return isAdded;
  }

  StreamController<List<BookingModel>>? getNearestBookingController;

  Stream<List<BookingModel>> getBookings(
      double? latitude, double? longLatitude) async* {
    getNearestBookingController =
        StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];
    Query query = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingPlaced)
        .where('vehicleType.id',
            isEqualTo: Constant.userModel!.driverVehicleDetails!.vehicleTypeId);
    GeoFirePoint center = GeoFlutterFire()
        .point(latitude: latitude ?? 0.0, longitude: longLatitude ?? 0.0);
    Stream<List<DocumentSnapshot>> stream = GeoFlutterFire()
        .collection(collectionRef: query)
        .within(
            center: center,
            radius: double.parse(Constant.radius),
            field: 'position',
            strictMode: true);

    stream.listen((List<DocumentSnapshot> documentList) {
      log("Length= : ${documentList.length}");
      bookingsList.clear();
      for (var document in documentList) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.driverId != null &&
            bookingModel.driverId!.isNotEmpty) {
          if ((bookingModel.driverId ?? '') != FireStoreUtils.getCurrentUid()) {
            bookingsList.add(bookingModel);
          }
        } else if (bookingModel.rejectedDriverId != null &&
            bookingModel.rejectedDriverId!.isNotEmpty) {
          if (!(bookingModel.rejectedDriverId ?? [])
              .contains(FireStoreUtils.getCurrentUid())) {
            bookingsList.add(bookingModel);
          }
        } else {
          bookingsList.add(bookingModel);
        }
      }
      getNearestBookingController!.sink.add(bookingsList);
    });

    yield* getNearestBookingController!.stream;
  }

  closeStream() {
    if (getNearestBookingController != null) {
      getNearestBookingController!.close();
    }
  }

  StreamController<List<BookingModel>>? getHomeOngoingBookingController;

  Stream<List<BookingModel>> getHomeOngoingBookings() async* {
    getHomeOngoingBookingController =
        StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];
    Stream<QuerySnapshot> stream1 = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', whereIn: [
          BookingStatus.bookingAccepted,
          BookingStatus.bookingPlaced,
          BookingStatus.bookingOngoing
        ])
        .where('driverId', isEqualTo: Constant.userModel!.id)
        .snapshots();
    stream1.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.driverId != null &&
            bookingModel.driverId!.isNotEmpty) {
          if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
            bookingsList.add(bookingModel);
          }
        }
      }
      // final closetsDateTimeToNow = bookingsList.reduce(
      //         (a, b) => (a.bookingTime!).toDate().difference(DateTime.now()).abs() < (b.bookingTime!).toDate().difference(DateTime.now()).abs() ? a : b);

      getHomeOngoingBookingController!.sink.add(bookingsList);
    });

    yield* getHomeOngoingBookingController!.stream;
  }

  closeHomeOngoingStream() {
    if (getHomeOngoingBookingController != null) {
      getHomeOngoingBookingController!.close();
    }
  }

  StreamController<List<BookingModel>>? getOngoingBookingController;

  Stream<List<BookingModel>> getOngoingBookings() async* {
    getOngoingBookingController =
        StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];

    Stream<QuerySnapshot> stream = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingAccepted)
        .where('driverId', isEqualTo: Constant.userModel!.id)
        .orderBy('createAt', descending: true)
        .snapshots();
    stream.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.driverId != null &&
            bookingModel.driverId!.isNotEmpty) {
          if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
            bookingsList.add(bookingModel);
          }
        }
      }
      getOngoingBookingController!.sink.add(bookingsList);
    });
    Stream<QuerySnapshot> stream1 = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingOngoing)
        .where('driverId', isEqualTo: Constant.userModel!.id)
        .snapshots();
    stream1.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      // bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.driverId != null &&
            bookingModel.driverId!.isNotEmpty) {
          if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
            bookingsList.add(bookingModel);
          }
        }
      }
      getOngoingBookingController!.sink.add(bookingsList);
    });

    yield* getOngoingBookingController!.stream;
  }

  closeOngoingStream() {
    if (getOngoingBookingController != null) {
      getOngoingBookingController!.close();
    }
  }

  StreamController<List<BookingModel>>? getCompletedBookingController;

  Stream<List<BookingModel>> getCompletedBookings() async* {
    getCompletedBookingController =
        StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];

    Stream<QuerySnapshot> stream = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingCompleted)
        .where('driverId', isEqualTo: Constant.userModel!.id)
        .orderBy('createAt', descending: true)
        .snapshots();
    stream.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.driverId != null &&
            bookingModel.driverId!.isNotEmpty) {
          if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
            bookingsList.add(bookingModel);
          }
        }
      }
      getCompletedBookingController!.sink.add(bookingsList);
    });

    yield* getCompletedBookingController!.stream;
  }

  closeCompletedStream() {
    if (getCompletedBookingController != null) {
      getCompletedBookingController!.close();
    }
  }

  StreamController<List<BookingModel>>? getCancelledBookingController;

  Stream<List<BookingModel>> getCancelledBookings() async* {
    getCancelledBookingController =
        StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];

    Stream<QuerySnapshot> stream = fireStore
        .collection(CollectionName.bookings)
        .where('bookingStatus', isEqualTo: BookingStatus.bookingCancelled)
        .where('driverId', isEqualTo: Constant.userModel!.id)
        .orderBy('createAt', descending: true)
        .snapshots();
    stream.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.driverId != null &&
            bookingModel.driverId!.isNotEmpty) {
          if ((bookingModel.driverId ?? '') == FireStoreUtils.getCurrentUid()) {
            bookingsList.add(bookingModel);
          }
        }
      }
      getCancelledBookingController!.sink.add(bookingsList);
    });

    yield* getCancelledBookingController!.stream;
  }

  closeCancelledStream() {
    if (getCancelledBookingController != null) {
      getCancelledBookingController!.close();
    }
  }

  StreamController<List<BookingModel>>? getRejectedBookingController;

  Stream<List<BookingModel>> getRejectedBookings() async* {
    getRejectedBookingController =
        StreamController<List<BookingModel>>.broadcast();
    List<BookingModel> bookingsList = [];

    Stream<QuerySnapshot> stream = fireStore
        .collection(CollectionName.bookings)
        .where('rejectedDriverId', arrayContains: Constant.userModel!.id)
        .orderBy("createAt", descending: true)
        .snapshots();
    stream.listen((QuerySnapshot querySnapshot) {
      log("Length= : ${querySnapshot.docs.length}");
      bookingsList.clear();
      for (var document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;
        BookingModel bookingModel = BookingModel.fromJson(data);
        if (bookingModel.rejectedDriverId != null &&
            bookingModel.rejectedDriverId!.isNotEmpty) {
          if ((bookingModel.rejectedDriverId ?? [])
              .contains(FireStoreUtils.getCurrentUid())) {
            bookingsList.add(bookingModel);
          }
        }
      }
      getRejectedBookingController!.sink.add(bookingsList);
    });

    yield* getRejectedBookingController!.stream;
  }

  closeRejectedStream() {
    if (getRejectedBookingController != null) {
      getRejectedBookingController!.close();
    }
  }

  static Future<List<NotificationModel>?> getNotificationList() async {
    List<NotificationModel> notificationModelList = [];
    await fireStore
        .collection(CollectionName.notification)
        .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
        .orderBy('createdAt', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        NotificationModel notificationModel =
            NotificationModel.fromJson(element.data());
        notificationModelList.add(notificationModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return notificationModelList;
  }

  static Future<bool?> setNotification(
      NotificationModel notificationModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.notification)
        .doc(notificationModel.id)
        .set(notificationModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<ReviewModel>?> getReviewList(
      DriverUserModel driverUserModel) async {
    List<ReviewModel> reviewModelList = [];
    await fireStore
        .collection(CollectionName.review)
        .where("driverId", isEqualTo: driverUserModel.id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        ReviewModel reviewModel = ReviewModel.fromJson(element.data());
        reviewModelList.add(reviewModel);
      }
    });
    return reviewModelList;
  }

  static Future<List<BankDetailsModel>?> getBankDetailList(
      String? driverId) async {
    List<BankDetailsModel> bankDetailsList = [];
    await fireStore
        .collection(CollectionName.bankDetails)
        .where("driverID", isEqualTo: driverId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        BankDetailsModel bankDetailModel =
            BankDetailsModel.fromJson(element.data());
        bankDetailsList.add(bankDetailModel);
      }
    });
    return bankDetailsList;
  }

  static Future<bool> addBankDetail(BankDetailsModel bankDetailsModel) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.bankDetails)
        .doc(bankDetailsModel.id)
        .set(bankDetailsModel.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update data: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> updateBankDetail(
      BankDetailsModel bankDetailsModel) async {
    bool isUpdate = false;
    await fireStore
        .collection(CollectionName.bankDetails)
        .doc(bankDetailsModel.id)
        .update(bankDetailsModel.toJson())
        .whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update data: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool?> setWithdrawRequest(WithdrawModel withdrawModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.withdrawalHistory)
        .doc(withdrawModel.id)
        .set(withdrawModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<WithdrawModel>> getWithDrawRequest() async {
    List<WithdrawModel> withdrawalList = [];
    await fireStore
        .collection(CollectionName.withdrawalHistory)
        .where('driverId', isEqualTo: getCurrentUid())
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        WithdrawModel documentModel = WithdrawModel.fromJson(element.data());
        withdrawalList.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return withdrawalList;
  }

  static Future<int> getTotalRide() async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance
        .collection(CollectionName.bookings)
        .where("driverId", isEqualTo: getCurrentUid());
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    return query.count ?? 0;
  }

  static Future<int> getCompletedRide() async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance
        .collection(CollectionName.bookings)
        .where("driverId", isEqualTo: getCurrentUid())
        .where("bookingStatus", isEqualTo: BookingStatus.bookingCompleted);
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    return query.count ?? 0;
  }

  static Future<int> getOngoingRide() async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance
        .collection(CollectionName.bookings)
        .where("driverId", isEqualTo: getCurrentUid())
        .where("bookingStatus", isEqualTo: BookingStatus.bookingOngoing);
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    return query.count ?? 0;
  }

  static Future<int> getNewRide() async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance
        .collection(CollectionName.bookings)
        .where("driverId", isEqualTo: getCurrentUid())
        .where("bookingStatus", isEqualTo: BookingStatus.bookingAccepted);
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    return query.count ?? 0;
  }

  static Future<int> getRejectedRide() async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance
        .collection(CollectionName.bookings)
        .where("rejectedDriverId", arrayContains: getCurrentUid());
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    return query.count ?? 0;
  }

  static Future<int> getCancelledRide() async {
    final Query<Map<String, dynamic>> productList = FirebaseFirestore.instance
        .collection(CollectionName.bookings)
        .where("driverId", isEqualTo: getCurrentUid())
        .where("bookingStatus", isEqualTo: BookingStatus.bookingCancelled);
    AggregateQuerySnapshot query = await productList.count().get();
    log('The number of products: ${query.count}');
    return query.count ?? 0;
  }

  static Future<List<SupportReasonModel>> getSupportReason() async {
    List<SupportReasonModel> supportReasonList = [];
    await fireStore
        .collection(CollectionName.supportReason)
        .where("type", isEqualTo: "driver")
        .get()
        .then((value) {
      for (var element in value.docs) {
        SupportReasonModel supportReasonModel =
            SupportReasonModel.fromJson(element.data());
        supportReasonList.add(supportReasonModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return supportReasonList;
  }

  static Future<bool> addSupportTicket(
      SupportTicketModel supportTicketModel) async {
    bool isAdded = false;
    await fireStore
        .collection(CollectionName.supportTicket)
        .doc(supportTicketModel.id)
        .set(supportTicketModel.toJson())
        .then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to add Support Ticket : $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<SupportTicketModel>> getSupportTicket(String id) async {
    List<SupportTicketModel> supportTicketList = [];
    await fireStore
        .collection(CollectionName.supportTicket)
        .where("userId", isEqualTo: id)
        .orderBy("createAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        SupportTicketModel supportTicketModel =
            SupportTicketModel.fromJson(element.data());
        supportTicketList.add(supportTicketModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return supportTicketList;
  }
// Stream<List<BookingModel>> getBookings(double? latitude, double? longLatitude) async* {
//   getNearestBookingController = StreamController<List<BookingModel>>.broadcast();
//   List<BookingModel> bookingsList = [];
//   log("Length= : ${Constant.radius}");
//   log("Length= : $latitude");
//   log("Length= : $longLatitude");
//   // Query query = fireStore
//   //     .collection(CollectionName.bookings)
//   //     .where('bookingStatus', isEqualTo: BookingStatus.bookingPlaced)
//   //     .where('vehicleType.id', isEqualTo: Constant.userModel!.driverVehicleDetails!.vehicleTypeId)
//   //     .orderBy('bookingTime', descending: true);
//   // GeoFirePoint center = GeoFlutterFire().point(latitude: latitude ?? 0.0, longitude: longLatitude ?? 0.0);
//   // Stream<List<DocumentSnapshot>> stream = GeoFlutterFire()
//   //     .collection(collectionRef: query)
//   //     .within(center: center, radius: 100, field: 'position', strictMode: true);
//   Stream<QuerySnapshot> stream=  fireStore
//       .collection(CollectionName.bookings)
//       .where('bookingStatus', isEqualTo: BookingStatus.bookingPlaced)
//       .where('vehicleType.id', isEqualTo: Constant.userModel!.driverVehicleDetails!.vehicleTypeId)
//       .orderBy('bookingTime', descending: true).snapshots();
//   stream.listen((QuerySnapshot querySnapshot) {
//     bookingsList.clear();
//     log("Length= : ${querySnapshot.docs.length}");
//     for (var document in querySnapshot.docs) {
//       final data = document.data() as Map<String, dynamic>;
//       BookingModel bookingModel = BookingModel.fromJson(data);
//       if (bookingModel.driverId != null && bookingModel.driverId!.isNotEmpty) {
//         if ((bookingModel.driverId??'') != FireStoreUtils.getCurrentUid()) {
//           bookingsList.add(bookingModel);
//         }
//       } else {
//         bookingsList.add(bookingModel);
//       }
//     }
//     getNearestBookingController!.sink.add(bookingsList);
//   });
//
//   yield* getNearestBookingController!.stream;
// }
//
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/model/set_model.dart';
import 'package:iamsmart/model/ticket_model.dart';
import 'package:iamsmart/model/transaction_model.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/util/preference_key.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/faq_model.dart';
import '../model/transaction_activity_model.dart';
import '../util/constants.dart';
import '../util/email_generator.dart';
import '../util/utilities.dart';

class DBService {
  static DBService instance = DBService();
  late FirebaseFirestore _db;
  String userCollection = 'users';
  String txnCollection = 'transactions';
  String setCollection = 'sets';
  String faqCollection = 'faq';
  String ticketCollection = 'tickets';

  DBService() {
    _db = FirebaseFirestore.instance;
  }

  Future<void> createUser(UserProfile user, UserProfile? referedBy) async {
    await _db.collection(userCollection).doc(user.id).set(user.toMap());
    if (referedBy != null) {
      await _db.collection(userCollection).doc(referedBy.id).update({
        'referalList': FieldValue.arrayUnion([user.id]),
      });
    }
  }

  Future<void> updateLastLoginTime(String userId) async {
    Map<String, dynamic> map = {
      'lastLogin': Timestamp.now().millisecondsSinceEpoch,
    };
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      map['latitude'] = position.latitude;
      map['longitude'] = position.longitude;
      map['fcmToken'] = prefs.getString(PreferenceKey.fcmToken);
    }
    await _db.collection(userCollection).doc(userId).update(map);
  }

  Future<UserProfile> getUserById(String userId) async {
    UserProfile user = UserProfile();
    await _db.collection(userCollection).doc(userId).get().then((snapshot) {
      Map<String, dynamic> userMap = snapshot.data() ?? {};
      user = UserProfile.fromMap(userMap);
    });

    return user;
  }

  Future<UserProfile?> getUserByRefcode(String refCode) async {
    UserProfile? user;

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(userCollection)
        .where('inviteCode', isEqualTo: refCode)
        .get();

    if (querySnapshot.size > 0) {
      user = UserProfile.fromMap(querySnapshot.docs.first.data());
    }
    return user;
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> profileData,
      BuildContext context) async {
    await _db
        .collection(userCollection)
        .doc(userId)
        .update(profileData)
        .then((value) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        autoDismiss: false,
        desc: 'Your profile data is updated',
        btnOkOnPress: () {
          context.pop();
          context.pop();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onDismissCallback: (type) {},
        btnOkText: 'Okay',
      ).show();
    });
  }

  Future<String> addTransaction(TransactionModel txn) async {
    var ref = _db.collection(txnCollection).doc();
    txn.id = ref.id;
    await ref.set(txn.toMap());
    return txn.id!;
  }

  Future<List<TransactionModel>> getAllTransactions(String userId) async {
    List<TransactionModel> txnList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(txnCollection)
        .where('user.id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    txnList = querySnapshot.docs
        .map((txn) => TransactionModel.fromMap(txn.data()))
        .toList();
    return txnList;
  }

  Future<TransactionModel> getTransactionById(String txnId) async {
    TransactionModel txn = TransactionModel();
    await _db.collection(txnCollection).doc(txnId).get().then((snapshot) {
      txn = TransactionModel.fromMap(snapshot.data() ?? {});
    });
    return txn;
  }

  Future<List<SetModel>> getAllSet(String userId) async {
    List<SetModel> setList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(setCollection)
        .where('userProfile.id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    setList =
        querySnapshot.docs.map((set) => SetModel.fromMap(set.data())).toList();
    return setList;
  }

  Future<SetModel> getSetById(String setId) async {
    SetModel set = SetModel();
    await _db.collection(setCollection).doc(setId).get().then((s) {
      set = SetModel.fromMap(s.data() ?? {});
    });
    return set;
  }

  Future<bool> withdrawSet(SetModel set, double amount) async {
    UserProfile userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    userProfile = await getUserById(userProfile.id!);
    TransactionModel txn = TransactionModel(
      amount: amount,
      assignedTo: Party.admin.name,
      creditParty: Party.userWallet.name,
      debitParty: Party.aiWallet.name,
      status: PaymentStatus.pending.name,
      transactionActivity: [
        TransactionActivityModel(
          comment:
              'Redeem from ${set.userProfile!.name!} #${set.setNumber} | $rupeeSymbol ${set.amount}',
          createdAt: DateTime.now(),
        )
      ],
      transactionMode: set.id,
      user: userProfile,
      transactionScreenshot: '',
      createdAt: DateTime.now(),
    );

    await addTransaction(txn);
    await Utilities.sendEmail(EmailGenerator().setCloseRequest(set));

    await _db
        .collection(setCollection)
        .doc(set.id)
        .update({'status': SetStatus.pending.name});

    return false;
  }

  Future<List<TransactionModel>> getCurrentDateTransactions(
      String userId) async {
    List<TransactionModel> txnList = [];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(txnCollection)
        .where('user.id', isEqualTo: userId)
        .where('createdAt',
            isGreaterThanOrEqualTo: today.millisecondsSinceEpoch)
        .orderBy('createdAt', descending: true)
        .get();

    txnList = querySnapshot.docs
        .map((txn) => TransactionModel.fromMap(txn.data()))
        .toList();
    return txnList;
  }

  Future<List<TransactionModel>> getCurrentDateRewardTransactions(
      String userId, int timeInEpoch, int endTime) async {
    List<TransactionModel> txnList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(txnCollection)
        .where('user.id', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: timeInEpoch)
        .where('createdAt', isLessThan: endTime)
        .where('assignedTo', isEqualTo: Party.userWallet.name)
        .where('creditParty', isEqualTo: Party.userWallet.name)
        .where('debitParty', isEqualTo: Party.reward.name)
        .orderBy('createdAt', descending: true)
        .get();

    txnList = querySnapshot.docs
        .map((txn) => TransactionModel.fromMap(txn.data()))
        .toList();
    return txnList;
  }

  Future<List<FaqModel>> getAllFaqs() async {
    List<FaqModel> faqList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(faqCollection)
        .orderBy('faqNo', descending: false)
        .get();

    faqList =
        querySnapshot.docs.map((faq) => FaqModel.fromMap(faq.data())).toList();

    return faqList;
  }

  Future<String> createTicket(TicketModel ticket) async {
    var ref = _db.collection(ticketCollection).doc();
    ticket.id = ref.id;
    await ref.set(ticket.toMap());
    return ticket.id!;
  }

  Future<List<TicketModel>> getAllTicketsById(String userId) async {
    List<TicketModel> list = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection(ticketCollection)
        .where('user.id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    list = querySnapshot.docs
        .map((txn) => TicketModel.fromMap(txn.data()))
        .toList();
    return list;
  }

  Future<TicketModel> getTicketById(String id) async {
    TicketModel ticketModel = TicketModel();
    await _db.collection(ticketCollection).doc(id).get().then((value) {
      ticketModel = TicketModel.fromMap(value.data() ?? {});
    });

    return ticketModel;
  }

  Future<void> updateTicket(TicketModel ticket) async {
    await _db
        .collection(ticketCollection)
        .doc(ticket.id)
        .update(ticket.toMap());
  }
}

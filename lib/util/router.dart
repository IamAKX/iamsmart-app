import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamsmart/main.dart';
import 'package:iamsmart/screen/ai_sets/ai_set_details.dart';
import 'package:iamsmart/screen/ai_sets/ai_set_screen.dart';
import 'package:iamsmart/screen/depositToUserWallet/deposit_to_user_wallet_screen.dart';
import 'package:iamsmart/screen/explore/explore_detail_screen.dart';
import 'package:iamsmart/screen/forgotPassword/forgot_password_screen.dart';
import 'package:iamsmart/screen/login/login_screen.dart';
import 'package:iamsmart/screen/mainContainer/main_container.dart';
import 'package:iamsmart/screen/register/register_screen.dart';
import 'package:iamsmart/screen/setting/change_password.dart';
import 'package:iamsmart/screen/setting/kyc_document_screen.dart';
import 'package:iamsmart/screen/setting/profile_details_screen.dart';
import 'package:iamsmart/screen/transaction/transaction_detail_screen.dart';
import 'package:iamsmart/screen/transferToAIWallet/transafer_to_ai_wallet_screen.dart';
import 'package:iamsmart/util/preference_key.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: LoginScreen.loginRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: RegisterScreen.registerRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: ForgotPasswordScreen.forgotPasswordRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: MainContainer.mainContainerRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const MainContainer();
      },
    ),
    GoRoute(
      path: DepositeToUserWalletScreen.depositeToUserWalletRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const DepositeToUserWalletScreen();
      },
    ),
    GoRoute(
      path: TransferToAIWalletScreen.transferToAIWalletRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const TransferToAIWalletScreen();
      },
    ),
    GoRoute(
      path: AiSetScreen.aiSetRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const AiSetScreen();
      },
    ),
    GoRoute(
      path: TransactionDetailScreen.transactionDetailScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return TransactionDetailScreen(
          txnId: state.params['txnId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: ExploreDetailScreen.exploreDetailRoute,
      builder: (BuildContext context, GoRouterState state) {
        return ExploreDetailScreen(
          exploreId: state.params['exploreId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AiSetDetailScreen.transactionDetailScreenRoute,
      builder: (BuildContext context, GoRouterState state) {
        return AiSetDetailScreen(
          txnId: state.params['txnId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: ProfileDetailScreen.profileDetailRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileDetailScreen();
      },
    ),
    GoRoute(
      path: ChangePasswordScreen.changePasswordRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(
      path: KycDocumentScreen.kycDocumentRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const KycDocumentScreen();
      },
    ),
  ],
  initialLocation: getInitialRoute(),
);

String getInitialRoute() {
  // if (FirebaseAuth.instance.currentUser != null &&
  //     prefs.containsKey(PreferenceKey.user)) {
  //   return MainContainer.mainContainerRoute;
  // }
  return LoginScreen.loginRoute;
}

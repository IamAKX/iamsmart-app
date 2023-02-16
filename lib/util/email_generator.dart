import '../model/email_model.dart';
import '../model/set_model.dart';
import '../model/user_profile.dart';
import 'constants.dart';

class EmailGenerator {
  String fromEmail = "iamsmart.visutechnologies@gmail.com";

  //done
  EmailModel depositToUserWalletRequest(
      UserProfile user, String amount, String txnId) {
    return EmailModel(
      from: fromEmail,
      to: user.email,
      subject:
          '${txnId.substring(0, 10)} : Received Deposit Request in user wallet',
      text:
          'Dear ${user.name},\nGreetings!\n\nYour Deposit request in user wallet for an amount of $rupeeSymbol $amount/- has  been received . Amount will be reflected in your user  wallet within 6 working hours.\n\nRegards,\nTeam IamSmart .',
    );
  }

// Done
  EmailModel depositToUserWalletConfirmation(
      UserProfile user, String amount, String txnId) {
    return EmailModel(
        from: fromEmail,
        to: user.email,
        subject:
            '${txnId.substring(0, 10)} : Completed Deposit Request in user wallet',
        text:
            'Dear ${user.name},\nGreetings !\n\nYour Deposit request in user wallet for an amount of  $rupeeSymbol $amount/- has  been completed. \nTransaction ID: $txnId\n\nRegards,\nTeam IamSmart .');
  }

// done
  EmailModel transferFromUserWalletToAIWalletConfirmation(
      UserProfile user, String amount, String txnId) {
    return EmailModel(
      from: fromEmail,
      to: user.email,
      subject:
          '${txnId.substring(0, 10)} : Completed Transfer Request from user wallet to AI wallet',
      text:
          'Dear ${user.name},\nGreetings!\n\nYour Deposit request from User wallet to AI wallet for an amount of  $rupeeSymbol $amount/- has  been completed. \nTransaction ID: $txnId\n\nRegards, \nTeam IamSmart .',
    );
  }

  EmailModel transferFromUserWalletToAIWalletRequest(
      UserProfile user, String amount, String txnId) {
    return EmailModel(
      from: fromEmail,
      to: user.email,
      subject:
          '${txnId.substring(0, 10)} : Received Transfer Request from user wallet to AI wallet',
      text:
          'Dear ${user.name},\nGreetings !\n\nYour Deposit request from User wallet to AI wallet for an amount of  $rupeeSymbol $amount/- has  been received . Amount will be reflected in your AI wallet within 6 working hours.\n\nRegards, \nTeam IamSmart .',
    );
  }
//done
  EmailModel setCreateRequest(SetModel set) {
    return EmailModel(
      from: fromEmail,
      to: set.userProfile!.email,
      subject: 'Set #${set.setNumber} has been created',
      text:
          'Dear ${set.userProfile!.name},\nGreetings !\n\nBased on the deposit of $rupeeSymbol ${currencyFormatter.format(set.amount)}/- done from User wallet to AI wallet, a new Set #${set.setNumber} has been created . \n\nRegards ,\nTeam IamSmart .',
    );
  }


  EmailModel setCloseRequest(SetModel set) {
    return EmailModel(
      from: fromEmail,
      to: set.userProfile!.email,
      subject:
          'Request for Set closure of Set #${set.setNumber} has been received.',
      text:
          'Dear ${set.userProfile!.name},\nGreetings !\n\nYour request for the Closure of Set #${set.setNumber} has been received . The Set will be closed and the respective amount will be \nDeposited in your User wallet within 48 working hours. \n\nRegards ,\nTeam IamSmart .',
    );
  }
//done
  EmailModel setCloseConfirmation(SetModel set) {
    return EmailModel(
      from: fromEmail,
      to: set.userProfile!.email,
      subject:
          'Request for Set closure of Set #${set.setNumber} has been completed.',
      text:
          'Dear ${set.userProfile!.name},\nGreetings !\n\nYour request for the Closure of Set #${set.setNumber} has been received . The Set has been closed and the respective amount is \nDeposited in your User wallet.\nTransaction ID : ${set.id} \n\nRegards ,\nTeam IamSmart .',
    );
  }
// done
  EmailModel withdrawFromUserWalletRequest(
      UserProfile user, String amount, String txnId) {
    return EmailModel(
      from: fromEmail,
      to: user.email,
      subject:
          '${txnId.substring(0, 10)} : Received withdrawal request from User wallet',
      text:
          'Dear ${user.name},\nGreetings !\n\nYour withdrawal request from user wallet for an amount of  $rupeeSymbol $amount/- has  been received . The Amount will be processed within 6 working hours.\n\nRegards ,\nTeam IamSmart .',
    );
  }

// done
  EmailModel withdrawFromUserWalletConfirmation(
      UserProfile user, String amount, String txnId) {
    return EmailModel(
      from: fromEmail,
      to: user.email,
      subject:
          '${txnId.substring(0, 10)} : Completed Withdrawal Request from user wallet',
      text:
          'Dear ${user.name},\nGreetings !\n\nYour Withdrawal request of amount Rs $rupeeSymbol ${amount}/- has been successfully completed.\nTransaction ID: $txnId\n\nThe amount has been disbursed to the bank account details mentioned below.\nBank name : ${user.bankAccountName}\nAccount number: ${user.bankAccountNumber}\nBranch name : ${user.bankBranchCode}\nIFSC code: ${user.bankIFSCCode}\n\nNote: These Bank account Details are fetched from your profile details.\n\nRegards, \nTeam IamSmart .\n',
    );
  }
}

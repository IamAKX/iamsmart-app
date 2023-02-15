import 'package:intl/intl.dart';

const String rupeeSymbol = '₹';
var currencyFormatter = NumberFormat("#,##,##0.00", "en_US");
List<String> depositePaymentModeList = [
  // 'Debit card',
  // 'Credit card',
  'IMPS',
  'NEFT',
  'PayPal',
  'UPI ID'
  // 'Other'
];

List<String> withdrawlPaymentModeList = ['IMPS', 'NEFT', 'Other'];

List<String> kycDocumentList = ['Aadhaar', 'PAN', 'Driving License'];

String loremIpsum =
    '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.''';

const String defaultProfileImage =
    'https://firebasestorage.googleapis.com/v0/b/iamsmart-d3a89.appspot.com/o/profileImage%2Fuser.png?alt=media&token=594fe065-73c8-43f6-a82e-b3e6384d736d';

enum PaymentStatus {
  pending,
  approved,
  rejected,
  transfered,
  invested,
  withdrawn
}

enum Party { userExternal, userWallet, aiWallet, admin, reward }

enum SetStatus { running, partial, closed, pending }

String depositToUserWalletPrompt =
    'Deposited amount can take upto 6 working hours to get approved';
String transferToUserWalletPrompt =
    'Transfered amount can take upto 6 working hours to get approved';

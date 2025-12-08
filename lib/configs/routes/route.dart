import 'package:get/get.dart';

import '../../views/main_screen/order_history/order_history_page.dart';
import '../../views/main_screen/redeem_history/redeem_history_page.dart';
import '../../views/main_screen/card_draw_history/card_draw_history_page.dart';
import '../../views/main_screen/transaction_history/transaction_history_page.dart';
import '../../views/main_screen/payment/payment_page.dart';
import '../../views/splash/splash_page.dart';
import '../../views/main_screen/main_page.dart';
import '../../views/main_screen/card_detail/card_detail_page.dart';
import '../../views/main_screen/card_draw/card_draw_page.dart';
import '../../views/main_screen/cart/cart_page.dart';
import '../../views/main_screen/product_detail/product_detail_page.dart';
import '../../views/main_screen/explore/view_all_cards_page.dart';
import '../../views/main_screen/profile/profile_page.dart';
import '../../views/main_screen/checkout_confirmation/checkout_confirmation_page.dart';
import '../../views/main_screen/payment_success/payment_success_page.dart';
import '../../views/main_screen/redeem_gift/redeem_gift_page.dart';

class RoutePath {
  final String singlePath;
  final RoutePath? parent;

  String get path => parent != null
      ? '${parent != null ? parent!.path : ''}$singlePath'
      : singlePath;

  String get p => path;

  String get sp => singlePath;

  const RoutePath(this.singlePath, {this.parent});

  @override
  String toString() => path;
}

class SpecialRoute {
  final String route;
  final bool requiredSupportedChain;
  final bool requiredConnected;

  // final bool Function(dynamic args, UserEntity? user)? except;
  final bool? except;

  SpecialRoute(
    this.route, {
    bool requiredSupportedChain = false,
    this.requiredConnected = false,
    this.except,
  }) : requiredSupportedChain = requiredConnected || requiredSupportedChain;
}

abstract class Routes {
  static const splash = RoutePath('/');
  static const main = RoutePath('/main');
  static const start = RoutePath('/start');
  static const intro = RoutePath('/intro');
  static const unauthenticated = RoutePath('/401');
  static const unauthorized = RoutePath('/403');
  static const maintenance = RoutePath('/maintenance');
  static const auth = RoutePath('/auth');
  static const login = RoutePath('/login');
  static const register = RoutePath('/register');
  static const activateAccount = RoutePath('/activate-account');
  static const verifyEmail = RoutePath('/verify-email');
  static const biometric = RoutePath('/biometric');
  static const forgotPass = RoutePath('/forgot-password');
  static const forgotPassVerify = RoutePath(
    '/forgot-password-verify',
    parent: Routes.forgotPass,
  );
  static const createNewPassword = RoutePath(
    '/create-new-password',
    parent: Routes.forgotPass,
  );
  static const dev = RoutePath('/dev');
  static const qrScan = RoutePath('/qr-scan');
  static const webView = RoutePath('/web-view');
  static const notifications = RoutePath('/notifications');
  static const createNameWallet = RoutePath('/create-name-wallet');
  static const createPost = RoutePath('/create-post');
  static const localAuth = RoutePath('/local-auth');
  static const search = RoutePath('/search');
  static const meetingCall = RoutePath('/meeting-call');
  static const editCmt = RoutePath('/edit-cmt');
  static const addToken = RoutePath('/add-token');

  /// Setting
  static const changeProfile = RoutePath('/change-profile');
  static const security = RoutePath('/security');
  static const createSecurityPin = RoutePath('/create-security-pin');
  static const changeLocalPassword = RoutePath('/change-local-password');
  static const contact = RoutePath('/contact');
  static const meetingSetting = RoutePath('/meeting-setting');
  static const walletSetting = RoutePath('/wallet-setting');
  static const myWallet = RoutePath('/my-wallet');
  static const addressBook = RoutePath('/address-book');
  static const editAddress = RoutePath('/edit-address');
  static const changePassword = RoutePath('/change-password');

  /// Social view
  static const chat = RoutePath('/chat');
  static const newMessage = RoutePath('/new-message');
  static const addFriend = RoutePath('/add-friend');
  static const addGroup = RoutePath('/add-group');
  static const reportPost = RoutePath('/report-post');
  static const postDetail = RoutePath('/post-detail');
  static const blockList = RoutePath('/block-list');
  static const createStory = RoutePath('/create-story');

  /// Profile
  static const profile = RoutePath('/profile');

  /// Wallet
  static const walletSystem = RoutePath('/wallet-system');
  static const createNewWallet = RoutePath('/create-new-wallet');
  static const createNewWalletSuccess = RoutePath('/create-new-wallet-success');
  static const importWallet = RoutePath('/import-wallet');
  static const sentTo = RoutePath('/sent-to');
  static const walletHistory = RoutePath('/wallet-history');
  static const showPrivateKey = RoutePath('/show-private-key');
  static const showMnemonic = RoutePath('/show-mnemonic');
  static const tokenExternalHistoryDetail =
      RoutePath('/token-external-history-detail');

  /// Meeting
  static const participants = RoutePath('/meeting/participants');
  static const addParticipant = RoutePath('/meeting/add-participant');

  /// Call
  static const call = RoutePath('/call');
  static const outgoingCall = RoutePath('/call/outgoing');

  /// Card Detail
  static const cardDetail = RoutePath('/card-detail');
  
  /// Card Draw
  static const cardDraw = RoutePath('/card-draw');
  
  /// Cart
  static const cart = RoutePath('/cart');
  
  /// Product Detail
  static const productDetail = RoutePath('/product-detail');
  
  /// View All Cards
  static const viewAllCards = RoutePath('/view-all-cards');
  
  /// Checkout Confirmation
  static const checkoutConfirmation = RoutePath('/checkout-confirmation');
  
  /// Payment
  static const payment = RoutePath('/payment');
  
  /// Payment Success
  static const paymentSuccess = RoutePath('/payment-success');
  
  /// Redeem Gift
  static const redeemGift = RoutePath('/redeem-gift');
  
  /// Order History
  static const orderHistory = RoutePath('/order-history');
  
  /// Redeem History
  static const redeemHistory = RoutePath('/redeem-history');
  
  /// Card Draw History
  static const cardDrawHistory = RoutePath('/card-draw-history');
  
  /// Transaction History
  static const transactionHistory = RoutePath('/transaction-history');
}

final List<GetPage> getPages = [
  GetPage(
    name: Routes.splash.sp,
    page: () => SplashPage(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.main.sp,
    page: () => const MainPage(),
    binding: MainBinding(),
  ),
  GetPage(
    name: Routes.cardDetail.sp,
    page: () => const CardDetailPage(),
    binding: CardDetailBinding(),
    transition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.cardDraw.sp,
    page: () => const CardDrawPage(),
    binding: CardDrawBinding(),
    transition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.cart.sp,
    page: () => const CartPage(),
    binding: CartBinding(),
    transition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.productDetail.sp,
    page: () => const ProductDetailPage(),
    binding: ProductDetailBinding(),
    transition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.viewAllCards.sp,
    page: () => const ViewAllCardsPage(),
    binding: ViewAllCardsBinding(),
    transition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.profile.sp,
    page: () => const ProfilePage(),
    binding: ProfileBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.checkoutConfirmation.sp,
    page: () => const CheckoutConfirmationPage(),
    binding: CheckoutConfirmationBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.payment.sp,
    page: () => const PaymentPage(),
    binding: PaymentBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.paymentSuccess.sp,
    page: () => const PaymentSuccessPage(),
    binding: PaymentSuccessBinding(),
    transition: Transition.fade,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.redeemGift.sp,
    page: () => const RedeemGiftPage(),
    binding: RedeemGiftBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.orderHistory.sp,
    page: () => const OrderHistoryPage(),
    binding: OrderHistoryBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.redeemHistory.sp,
    page: () => const RedeemHistoryPage(),
    binding: RedeemHistoryBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.cardDrawHistory.sp,
    page: () => const CardDrawHistoryPage(),
    binding: CardDrawHistoryBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.transactionHistory.sp,
    page: () => const TransactionHistoryPage(),
    binding: TransactionHistoryBinding(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  // ...getProfilePages,
].toList();

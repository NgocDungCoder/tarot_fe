import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../configs/routes/route.dart';
import '../../../models/transaction.dart';
import '../../../widget/custom_snackbar.dart';
import '../transaction_history/transaction_history_controller.dart';
import '../transaction_history/transaction_history_page.dart';
import '../user/user_controller.dart';

class PaymentController extends GetxController {
  // Required amount from checkout (if any)
  double? get requiredAmount => Get.arguments?['requiredAmount'] as double?;

  // Amount to deposit (user input) - in USD
  final _depositAmount = Rx<double?>(null);
  double? get depositAmount => _depositAmount.value;

  // Confirmed amount (after user clicks confirm)
  final _confirmedAmount = Rx<double?>(null);
  double? get confirmedAmount => _confirmedAmount.value;

  // Is amount confirmed
  bool get isAmountConfirmed => _confirmedAmount.value != null;

  // Magic Points to receive (1 USD = 10 MP)
  double get magicPointsToReceive {
    final amount = _confirmedAmount.value ?? _depositAmount.value;
    if (amount == null) return 0.0;
    return amount * 10;
  }

  // Payment reference code (mã nội dung chuyển khoản)
  final _paymentReferenceCode = ''.obs;
  String get paymentReferenceCode => _paymentReferenceCode.value;

  // Expiry time (15 phút từ khi tạo)
  final _expiryTime = Rx<DateTime?>(null);
  DateTime? get expiryTime => _expiryTime.value;

  // Remaining time in seconds
  final _remainingSeconds = Rx<int>(0);
  int get remainingSeconds => _remainingSeconds.value;

  // Timer for countdown
  Timer? _countdownTimer;

  // Bank account info
  final bankAccountInfo = {
    'bankName': 'Ngân hàng ABC',
    'accountNumber': '1234567890',
    'accountHolder': 'CÔNG TY TAROT APP',
    'branch': 'Chi nhánh TP.HCM',
  };

  // Text controller for amount input
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Set initial amount if requiredAmount is provided (but don't auto-confirm)
    if (requiredAmount != null) {
      amountController.text = requiredAmount!.toStringAsFixed(0);
      _depositAmount.value = requiredAmount;
    }
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    amountController.dispose();
    super.onClose();
  }

  /// Set deposit amount from input
  void setDepositAmount(String value) {
    // Remove all non-digit characters except decimal point
    final cleanedValue = value.replaceAll(RegExp(r'[^\d.]'), '');
    if (cleanedValue.isEmpty) {
      _depositAmount.value = null;
      return;
    }
    
    final amount = double.tryParse(cleanedValue);
    if (amount != null && amount > 0) {
      _depositAmount.value = amount;
    } else {
      _depositAmount.value = null;
    }
  }

  /// Confirm deposit amount
  void confirmAmount() {
    if (_depositAmount.value == null || _depositAmount.value! <= 0) {
      CustomSnackbar.error(
        title: 'Error',
        message: 'Please enter the amount you want to deposit',
      );
      return;
    }

    _confirmedAmount.value = _depositAmount.value;
    _generatePaymentReferenceCode();
    _initializeExpiryTime();
    _startCountdown();
  }

  /// Edit deposit amount (reset confirmed state)
  void editAmount() {
    _confirmedAmount.value = null;
    _paymentReferenceCode.value = '';
    _countdownTimer?.cancel();
    _remainingSeconds.value = 0;
    _expiryTime.value = null;
  }

  /// Generate payment reference code (mã nội dung chuyển khoản)
  void _generatePaymentReferenceCode() {
    // Tạo mã từ timestamp và random
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final code = timestamp.substring(timestamp.length - 8);
    _paymentReferenceCode.value = 'TAROT$code';
  }

  /// Initialize expiry time (15 phút từ bây giờ)
  void _initializeExpiryTime() {
    _expiryTime.value = DateTime.now().add(const Duration(minutes: 15));
    _remainingSeconds.value = 15 * 60; // 15 phút = 900 giây
  }

  /// Start countdown timer
  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_expiryTime.value == null) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();
      final difference = _expiryTime.value!.difference(now);

      if (difference.isNegative) {
        _remainingSeconds.value = 0;
        timer.cancel();
        _onPaymentExpired();
      } else {
        _remainingSeconds.value = difference.inSeconds;
      }
    });
  }

  /// Format remaining time as MM:SS
  String get formattedRemainingTime {
    final minutes = _remainingSeconds.value ~/ 60;
    final seconds = _remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if payment is expired
  bool get isExpired => _remainingSeconds.value <= 0;

  /// Generate QR code data (VietQR format)
  String get qrCodeData {
    final amount = _confirmedAmount.value ?? _depositAmount.value;
    if (amount == null) return '';
    // Format: bank_account|amount|content
    return '${bankAccountInfo['accountNumber']}|${amount.toStringAsFixed(0)}|$paymentReferenceCode';
  }

  /// Handle payment expired
  void _onPaymentExpired() {
    CustomSnackbar.warning(
      title: 'Payment Expired',
      message: 'Payment time has expired. Please create a new transaction.',
    );
  }

  /// Confirm payment (nút tạm để pass qua)
  void confirmPayment() {
    if (_confirmedAmount.value == null || _confirmedAmount.value! <= 0) {
      CustomSnackbar.error(
        title: 'Error',
        message: 'Please confirm the amount first',
      );
      return;
    }

    if (isExpired) {
      CustomSnackbar.error(
        title: 'Expired',
        message: 'Payment time has expired. Please create a new transaction.',
      );
      return;
    }

    // Cancel countdown timer
    _countdownTimer?.cancel();

    // Add Magic Points to user
    if (Get.isRegistered<UserController>()) {
      Get.find<UserController>().addMagicPoints(magicPointsToReceive);
    }

    // Create transaction for deposit
    final transaction = Transaction(
      id: 'tx-deposit-${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.magicPointDeposit,
      amount: magicPointsToReceive,
      description: 'Deposit - Transaction Code: $paymentReferenceCode',
      createdAt: DateTime.now(),
      metadata: {
        'referenceCode': paymentReferenceCode,
        'depositAmount': _confirmedAmount.value,
      },
    );

    // Save transaction to history
    if (Get.isRegistered<TransactionHistoryController>()) {
      Get.find<TransactionHistoryController>().addTransaction(transaction);
    } else {
      // Initialize TransactionHistoryController if not registered
      TransactionHistoryBinding().dependencies();
      Get.find<TransactionHistoryController>().addTransaction(transaction);
    }

    CustomSnackbar.success(
      title: 'Deposit Successful',
      message: 'Deposited ${magicPointsToReceive.toStringAsFixed(0)} MP to your account',
    );

    // Navigate back or to checkout if requiredAmount was provided
    if (requiredAmount != null) {
      // Go back to checkout
      Get.back();
    } else {
      // Go back to previous page
      Get.back();
    }
  }

  /// Copy payment reference code to clipboard
  Future<void> copyReferenceCode() async {
    if (_paymentReferenceCode.value.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _paymentReferenceCode.value));
    CustomSnackbar.success(
      title: 'Copied',
      message: 'Transfer reference code has been copied',
    );
  }

  /// Copy bank account number to clipboard
  Future<void> copyBankAccount() async {
    await Clipboard.setData(ClipboardData(text: bankAccountInfo['accountNumber'] ?? ''));
    CustomSnackbar.success(
      title: 'Copied',
      message: 'Bank account number has been copied',
    );
  }
}

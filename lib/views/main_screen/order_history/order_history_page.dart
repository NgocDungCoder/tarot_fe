import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';
import 'order_history_controller.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderHistoryController>(() => OrderHistoryController());
  }
}

class OrderHistoryPage extends GetView<OrderHistoryController> {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: ThemeConfig.textGold,
            size: 28,
          ),
        ),
        title: const CustomText(
          'Đơn hàng của tôi',
          fontSize: 24,
          color: ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            _buildFilterChips(),

            // Orders list
            // Expanded(
            //   child: Obx(() {
            //     if (controller.isLoading) {
            //       return const Center(
            //         child: CircularProgressIndicator(
            //           color: ThemeConfig.textGold,
            //         ),
            //       );
            //     }
            //
            //     final orders = controller.filteredOrders;
            //     if (orders.isEmpty) {
            //       return Center(
            //         child: CustomText(
            //           'Chưa có đơn hàng nào',
            //           fontSize: 16,
            //           color: ThemeConfig.textWhite.withOpacity(0.7),
            //         ),
            //       );
            //     }
            //
            //     return ListView.builder(
            //       padding: const EdgeInsets.all(16),
            //       itemCount: orders.length,
            //       itemBuilder: (context, index) {
            //         return _buildOrderCard(orders[index]);
            //       },
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    ),);
  }

  /// Build filter chips
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // child: Row(
            //   children: controller.statuses.map((status) {
            //     final isSelected = controller.selectedStatus == status;
            //     return Padding(
            //       padding: const EdgeInsets.only(right: 8),
            //       child: FilterChip(
            //         label: CustomText(
            //           controller.getStatusDisplayName(status),
            //           fontSize: 14,
            //           color: isSelected ? Colors.black : ThemeConfig.textWhite,
            //           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            //         ),
            //         selected: isSelected,
            //         onSelected: (selected) {
            //           controller.setStatus(status);
            //         },
            //         selectedColor: ThemeConfig.textGold,
            //         backgroundColor: Colors.black.withOpacity(0.6),
            //         side: BorderSide(
            //           color: isSelected
            //               ? ThemeConfig.textGold
            //               : ThemeConfig.textGold.withOpacity(0.3),
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
          )),
    );
  }

  /// Build order card
  // Widget _buildOrderCard(Order order) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.black.withOpacity(0.6),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: ThemeConfig.textGold.withOpacity(0.3),
  //         width: 1,
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Order header
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 CustomText(
  //                   order.orderId,
  //                   fontSize: 18,
  //                   color: ThemeConfig.textGold,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 const SizedBox(height: 4),
  //                 CustomText(
  //                   _formatDate(order.createdAt),
  //                   fontSize: 12,
  //                   color: ThemeConfig.textWhite.withOpacity(0.7),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: _getStatusColor(order.status).withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(
  //                   color: _getStatusColor(order.status),
  //                   width: 1,
  //                 ),
  //               ),
  //               child: CustomText(
  //                 order.statusDisplayName,
  //                 fontSize: 12,
  //                 color: _getStatusColor(order.status),
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 16),
  //
  //         // Order items preview
  //         ...order.items.take(2).map((item) {
  //           return Padding(
  //             padding: const EdgeInsets.only(bottom: 8),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: 50,
  //                   height: 50,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     border: Border.all(
  //                       color: ThemeConfig.textGold.withOpacity(0.3),
  //                       width: 1,
  //                     ),
  //                   ),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(7),
  //                     child: Image.asset(
  //                       item.product.imagePath,
  //                       fit: BoxFit.cover,
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return Container(
  //                           color: ThemeConfig.deepPurple.withOpacity(0.5),
  //                           child: const Icon(
  //                             Icons.image_not_supported,
  //                             color: ThemeConfig.textGold,
  //                             size: 20,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       CustomText(
  //                         item.product.nameVi,
  //                         fontSize: 14,
  //                         color: ThemeConfig.textWhite,
  //                         fontWeight: FontWeight.w500,
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       CustomText(
  //                         'Số lượng: ${item.quantity}',
  //                         fontSize: 12,
  //                         color: ThemeConfig.textWhite.withOpacity(0.7),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //
  //         if (order.items.length > 2)
  //           Padding(
  //             padding: const EdgeInsets.only(top: 4),
  //             child: CustomText(
  //               'và ${order.items.length - 2} sản phẩm khác...',
  //               fontSize: 12,
  //               color: ThemeConfig.textGold,
  //             ),
  //           ),
  //
  //         const SizedBox(height: 16),
  //         const Divider(color: ThemeConfig.textGold, thickness: 0.5),
  //
  //         // Order summary
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 CustomText(
  //                   'Tổng thanh toán',
  //                   fontSize: 14,
  //                   color: ThemeConfig.textWhite.withOpacity(0.7),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 CustomText(
  //                   '${order.totalAmount.toStringAsFixed(0)} MP',
  //                   fontSize: 18,
  //                   color: ThemeConfig.textGold,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 CustomText(
  //                   'Điểm thưởng',
  //                   fontSize: 14,
  //                   color: ThemeConfig.textWhite.withOpacity(0.7),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 CustomText(
  //                   '+${order.rewardPoints.toStringAsFixed(0)} RP',
  //                   fontSize: 16,
  //                   color: Colors.green,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //
  //         // View detail button
  //         const SizedBox(height: 16),
  //         SizedBox(
  //           width: double.infinity,
  //           child: OutlinedButton(
  //             onPressed: (){},
  //             // onPressed: () => _showOrderDetail(order),
  //             style: OutlinedButton.styleFrom(
  //               foregroundColor: ThemeConfig.textGold,
  //               side: BorderSide(
  //                 color: ThemeConfig.textGold,
  //                 width: 1,
  //               ),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: const CustomText(
  //               'Xem chi tiết',
  //               fontSize: 14,
  //               color: ThemeConfig.textGold,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return ThemeConfig.textGold;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Show order detail dialog
  // void _showOrderDetail(Order order) {
  //   Get.dialog(
  //     Dialog(
  //       backgroundColor: Colors.transparent,
  //       child: Container(
  //         constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
  //         decoration: BoxDecoration(
  //           color: Colors.black87,
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(
  //             color: ThemeConfig.textGold.withOpacity(0.3),
  //             width: 1,
  //           ),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Header
  //             Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         CustomText(
  //                           order.orderId,
  //                           fontSize: 20,
  //                           color: ThemeConfig.textGold,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                         const SizedBox(height: 4),
  //                         CustomText(
  //                           _formatDate(order.createdAt),
  //                           fontSize: 12,
  //                           color: ThemeConfig.textWhite.withOpacity(0.7),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                     decoration: BoxDecoration(
  //                       color: _getStatusColor(order.status).withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(20),
  //                       border: Border.all(
  //                         color: _getStatusColor(order.status),
  //                         width: 1,
  //                       ),
  //                     ),
  //                     child: CustomText(
  //                       order.statusDisplayName,
  //                       fontSize: 12,
  //                       color: _getStatusColor(order.status),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             const Divider(color: ThemeConfig.textGold, thickness: 0.5),
  //
  //             // Content
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 padding: const EdgeInsets.all(20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Items
  //                     const CustomText(
  //                       'Sản phẩm',
  //                       fontSize: 16,
  //                       color: ThemeConfig.textGold,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     const SizedBox(height: 12),
  //                     ...order.items.map((item) {
  //                       return Padding(
  //                         padding: const EdgeInsets.only(bottom: 12),
  //                         child: Row(
  //                           children: [
  //                             Container(
  //                               width: 60,
  //                               height: 60,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 border: Border.all(
  //                                   color: ThemeConfig.textGold.withOpacity(0.3),
  //                                   width: 1,
  //                                 ),
  //                               ),
  //                               child: ClipRRect(
  //                                 borderRadius: BorderRadius.circular(7),
  //                                 child: Image.asset(
  //                                   item.product.imagePath,
  //                                   fit: BoxFit.cover,
  //                                   errorBuilder: (context, error, stackTrace) {
  //                                     return Container(
  //                                       color: ThemeConfig.deepPurple.withOpacity(0.5),
  //                                       child: const Icon(
  //                                         Icons.image_not_supported,
  //                                         color: ThemeConfig.textGold,
  //                                         size: 24,
  //                                       ),
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 12),
  //                             Expanded(
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   CustomText(
  //                                     item.product.nameVi,
  //                                     fontSize: 14,
  //                                     color: ThemeConfig.textWhite,
  //                                     fontWeight: FontWeight.w500,
  //                                   ),
  //                                   CustomText(
  //                                     'Số lượng: ${item.quantity} x ${item.product.price.toStringAsFixed(0)} MP',
  //                                     fontSize: 12,
  //                                     color: ThemeConfig.textWhite.withOpacity(0.7),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             CustomText(
  //                               '${item.totalPrice.toStringAsFixed(0)} MP',
  //                               fontSize: 14,
  //                               color: ThemeConfig.textGold,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     }),
  //
  //                     const SizedBox(height: 20),
  //
  //                     // Shipping info
  //                     const CustomText(
  //                       'Thông tin giao hàng',
  //                       fontSize: 16,
  //                       color: ThemeConfig.textGold,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     const SizedBox(height: 12),
  //                     _buildInfoRow('Người nhận', order.shippingInfo['name'] ?? ''),
  //                     const SizedBox(height: 8),
  //                     _buildInfoRow('Số điện thoại', order.shippingInfo['phone'] ?? ''),
  //                     const SizedBox(height: 8),
  //                     _buildInfoRow('Địa chỉ', order.shippingInfo['address'] ?? ''),
  //
  //                     const SizedBox(height: 20),
  //
  //                     // Summary
  //                     const CustomText(
  //                       'Tóm tắt',
  //                       fontSize: 16,
  //                       color: ThemeConfig.textGold,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                     const SizedBox(height: 12),
  //                     if (order.voucher != null) ...[
  //                       _buildSummaryRow('Giảm giá voucher', '-${order.voucher!['discount']}%'),
  //                       const SizedBox(height: 8),
  //                     ],
  //                     _buildSummaryRow('Tổng thanh toán', '${order.totalAmount.toStringAsFixed(0)} MP'),
  //                     const SizedBox(height: 8),
  //                     _buildSummaryRow('Điểm thưởng nhận được', '+${order.rewardPoints.toStringAsFixed(0)} RP', isReward: true),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //
  //             // Close button
  //             Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () => Get.back(),
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: ThemeConfig.textGold,
  //                     foregroundColor: Colors.black,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                   ),
  //                   child: const CustomText(
  //                     'Đóng',
  //                     fontSize: 16,
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: CustomText(
            label,
            fontSize: 12,
            color: ThemeConfig.textWhite.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: CustomText(
            value,
            fontSize: 14,
            color: ThemeConfig.textWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build summary row
  Widget _buildSummaryRow(String label, String value, {bool isReward = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          fontSize: 14,
          color: ThemeConfig.textWhite.withOpacity(0.8),
        ),
        CustomText(
          value,
          fontSize: 16,
          color: isReward ? Colors.green : ThemeConfig.textGold,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}


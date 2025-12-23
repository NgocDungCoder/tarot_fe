import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import 'package:tarot_fe/views/main_screen/explore/components/blog_item_widget.dart';
import 'package:tarot_fe/views/view_all_blogs/view_all_blogs_controller.dart';
import '../../../configs/routes/route.dart';
import '../../../configs/styles/theme_config.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/video_background.dart';

/// Binding for View All Cards page
class ViewAllBlogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewAllBlogsController>(
        () => ViewAllBlogsController(Get.find()));
  }
}

class ViewAllBlogsPage extends GetView<ViewAllBlogsController> {
  const ViewAllBlogsPage({super.key});

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
            "Blog",
            fontSize: 24,
            color: ThemeConfig.textGold,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.blogs.isEmpty) {
              return Center(
                child: CustomText(
                  'Không có blog nào',
                  fontSize: 18,
                  color: ThemeConfig.textGold,
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: controller.blogs.length,
              itemBuilder: (context, index) {
                final blog = controller.blogs[index];
                return SizedBox(
                  height: 200,
                  child: BlogItemWidget(blog: blog),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 15,),
            );
          }),
        ),
      ),
    );
  }
}

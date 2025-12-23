import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tarot_fe/models/blog_entity.dart';

import '../../providers/api_client.dart';

class ViewAllBlogsController {

  final ApiClient apiClient;
  final isLoading = false.obs;
  final errorMessage = "".obs;

  final RxList<BlogEntity> blogs = <BlogEntity>[].obs;

  ViewAllBlogsController(this.apiClient) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchBlogs();
    });
  }

  Future<void> fetchBlogs() async {
    developer.log(
      'Fetching blogs',
      name: 'ExploreController',
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiClient.getBlogs();

      if (response == null) {
        throw Exception('Blog detail response is null');
      }

      blogs.value = response.docs ?? [];

      developer.log(
        'Fetch blogs success',
        name: 'ploreController',
      );
    } catch (e, stackTrace) {
      errorMessage.value = 'Không thể tải list sản phẩm';

      developer.log(
        'Fetch blogs failed',
        name: 'Explore Controller',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
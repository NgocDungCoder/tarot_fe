import 'package:tarot_fe/models/address_entity.dart';
import 'package:tarot_fe/models/banner_entity.dart';
import 'package:tarot_fe/models/blog_entity.dart';
import 'package:tarot_fe/models/cart_entity.dart';
import 'package:tarot_fe/models/cart_item_entity.dart';
import 'package:tarot_fe/models/category_entity.dart';
import 'package:tarot_fe/models/discount_entity.dart';
import 'package:tarot_fe/models/gift_entity.dart';
import 'package:tarot_fe/models/paging_res_entity.dart';
import 'package:tarot_fe/models/tarot_card_entity.dart';
import 'package:tarot_fe/models/user_entity.dart';

import '../configs/interfaces/api_client_interface.dart';
import '../configs/interfaces/http_interface.dart';
import '../models/api_response_entity.dart';
import '../models/product_entity.dart';
import '../utils/json_util.dart';

class ApiClient extends IApiClient {
  ApiClient(super.api, super.storage);

  Future<ProductId?> getProductDetailById(String productId) async {
    final res = await request(ApiMethod.get, '/products/$productId');

    return await parseJsonUtil(
      res,
      (dynamic json) => ApiResponseEntity<ProductId>.fromJson(
        json,
        (data) => ProductId.fromJson(data),
      ).data,
    );
  }

  Future<TarotCardEntity?> getCardDetailById(String cardId) async {
    final res = await request(ApiMethod.get, '/cards/$cardId');

    return await parseJsonUtil(
      res,
          (dynamic json) => ApiResponseEntity<TarotCardEntity>.fromJson(
        json,
            (data) => TarotCardEntity.fromJson(data),
      ).data,
    );
  }

  Future<UserEntity?> getUserById(String userId) async {
    final res = await request(ApiMethod.get, '/users/$userId');

    return await parseJsonUtil(
      res,
          (dynamic json) => ApiResponseEntity<UserEntity>.fromJson(
        json,
            (data) => UserEntity.fromJson(data),
      ).data,
    );
  }

  Future<TarotCardEntity?> getRandomCard() async {
    final res = await request(ApiMethod.get, '/cards/random-card');

    return await parseJsonUtil(
      res,
          (dynamic json) => ApiResponseEntity<TarotCardEntity>.fromJson(
        json,
            (data) => TarotCardEntity.fromJson(data),
      ).data,
    );
  }

  Future<PagingResEntity<ProductId>?> getProducts() async {
    final res = await request(ApiMethod.get, '/products');

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
      (dynamic json) =>
          ApiResponseEntity<PagingResEntity<ProductId>>.fromJson(
        json,
        (dynamic data) => PagingResEntity<ProductId>.fromJson(
          data,
          (item) => ProductId.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<PagingResEntity<CategoryEntity>?> getCategories() async {
    final res = await request(ApiMethod.get, '/categories');

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
          (dynamic json) =>
      ApiResponseEntity<PagingResEntity<CategoryEntity>>.fromJson(
        json,
            (dynamic data) => PagingResEntity<CategoryEntity>.fromJson(
          data,
              (item) => CategoryEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<PagingResEntity<GiftEntity>?> getGifts({
    int page = 1,
    int limit = 10,
    String? search,
    String? categoryId,
  }) async {
    final res = await request(ApiMethod.get, '/gifts', {
      "page": page,
      "limit": limit,
      "search": search,
      "categoryId": categoryId
    });

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
          (dynamic json) =>
      ApiResponseEntity<PagingResEntity<GiftEntity>>.fromJson(
        json,
            (dynamic data) => PagingResEntity<GiftEntity>.fromJson(
          data,
              (item) => GiftEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<ApiResponseEntity<List<BannerEntity>>> getBanners() async {
    final res = await request(ApiMethod.get, '/banners/active');

    final apiResponse = await parseJsonUtil(
      res,
      (dynamic json) => ApiResponseEntity<List<BannerEntity>>.fromJson(
        json,
        (dynamic data) {
          // data ở đây chính là list JSON từ API
          if (data is List) {
            return data.map((item) => BannerEntity.fromJson(item)).toList();
          }
          return <BannerEntity>[];
        },
      ),
    );

    return apiResponse;
  }

  Future<PagingResEntity<BlogEntity>?> getBlogs({
    int page = 1,
    int limit = 10,
    String status = "published",
    bool? isFeatured,
    String? search,
    String? category,
    String? tag
}) async {
    final res = await request(ApiMethod.get, '/blogs', {
      "status": status,
      "isFeatured": isFeatured,
      "search": search,
      "category": category,
      "tag": tag
    });

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
          (dynamic json) =>
      ApiResponseEntity<PagingResEntity<BlogEntity>>.fromJson(
        json,
            (dynamic data) => PagingResEntity<BlogEntity>.fromJson(
          data,
              (item) => BlogEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<List<TarotCardEntity>> getTarotCards({
    int page = 1,
    int limit = 6,
    String? search,
    String? arcana,
    String? suit
  }) async {
    final res = await request(ApiMethod.get, '/cards', {
      "page": page,
      "limit": limit,
      "search": search,
      "arcana": arcana,
      "suit": suit
    });

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
          (dynamic json) =>
      ApiResponseEntity<PagingResEntity<TarotCardEntity>>.fromJson(
        json,
            (dynamic data) => PagingResEntity<TarotCardEntity>.fromJson(
          data,
              (item) => TarotCardEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data?.docs ?? [];
  }

  Future<PagingResEntity<CartEntity>?> getCartOfUser({
    int page = 1,
    int limit = 15,
    String? userId,
  }) async {
    final res = await request(
      ApiMethod.get,
      '/carts',
      {
        "page": page,
        "limit": limit,
        "userId": userId,
      },
    );

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
      (dynamic json) => ApiResponseEntity<PagingResEntity<CartEntity>>.fromJson(
        json,
        (dynamic data) => PagingResEntity<CartEntity>.fromJson(
          data,
          (item) => CartEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<AddressEntity?> getAddressOfUser({
    int page = 1,
    int limit = 1,
    String? userId,
  }) async {
    final res = await request(
      ApiMethod.get,
      '/addresses',
      {
        "page": page,
        "limit": limit,
        "search": userId,
      },
    );

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
          (dynamic json) => ApiResponseEntity<PagingResEntity<AddressEntity>>.fromJson(
        json,
            (dynamic data) => PagingResEntity<AddressEntity>.fromJson(
          data,
              (item) => AddressEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data?.docs?.first;
  }

  Future<PagingResEntity<DiscountEntity>?> getDiscounts({
    int page = 1,
    int limit = 15,
  }) async {
    final res = await request(
      ApiMethod.get,
      '/discounts',
      {
        "page": page,
        "limit": limit,
      },
    );

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
          (dynamic json) => ApiResponseEntity<PagingResEntity<DiscountEntity>>.fromJson(
        json,
            (dynamic data) => PagingResEntity<DiscountEntity>.fromJson(
          data,
              (item) => DiscountEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<PagingResEntity<CartItemEntity>?> getCartItems({
    int page = 1,
    int limit = 15,
    String? cartId,
  }) async {
    final res = await request(ApiMethod.get, '/cart-items', {
      "page": page,
      "limit": limit,
      "cartId": cartId,
    });

    //viết trung gian
    final apiResponse = await parseJsonUtil(
      res,
      (dynamic json) =>
          ApiResponseEntity<PagingResEntity<CartItemEntity>>.fromJson(
        json,
        (dynamic data) => PagingResEntity<CartItemEntity>.fromJson(
          data,
          (item) => CartItemEntity.fromJson(item),
        ),
      ),
    );

    return apiResponse.data;
  }

  Future<void> updateQuantityCartItem({
    required String cartItemId,
    required int quantity,
  }) async {
    await request(ApiMethod.patch, '/cart-items/$cartItemId', {
      "quantity": quantity,
    });
  }

  Future<void> removeCartItem({
    required String cartItemId,
  }) async {
    await request(ApiMethod.delete, '/cart-items/$cartItemId');
  }
}

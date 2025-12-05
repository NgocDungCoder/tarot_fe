import 'package:dio/dio.dart';
import '../models/tarot_card.dart';
import 'api_service.dart';

/// Tarot API service
/// 
/// Cung cấp các API calls cho tarot cards từ MongoDB backend
class TarotApiService extends ApiService {
  // Base path cho tarot endpoints
  static const String _basePath = '/tarot';

  /// Get all tarot cards
  /// 
  /// Returns: List of TarotCard
  Future<List<TarotCard>> getAllCards({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await get<Map<String, dynamic>>(
        '$_basePath/cards',
        queryParameters: queryParams,
      );

      // Parse response data
      // Giả sử API trả về format: { "data": [...], "meta": {...} }
      final responseData = response.data;
      if (responseData == null) {
        return [];
      }

      final List<dynamic> cardsData = responseData['data'] ?? [];
      return cardsData
          .map((json) => TarotCard.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting tarot cards: $e');
      rethrow;
    }
  }

  /// Get tarot card by ID
  /// 
  /// [cardId] - ID của lá bài
  /// Returns: TarotCard
  Future<TarotCard> getCardById(String cardId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '/cards/$cardId',
      );

      final responseData = response.data;
      if (responseData == null) {
        throw ApiException(
          message: 'Không tìm thấy dữ liệu',
          statusCode: response.statusCode,
        );
      }

      // Log response structure để debug
      print('🔍 [TarotApiService] Response structure:');
      print('   Keys: ${responseData.keys.toList()}');
      print('   Has "data" key: ${responseData.containsKey('data')}');

      // Nếu API trả về { "data": {...} } hoặc trực tiếp object
      final cardData = responseData['data'] ?? responseData;
      
      // Validate cardData
      if (cardData == null) {
        throw ApiException(
          message: 'Dữ liệu lá bài không hợp lệ',
          statusCode: response.statusCode,
          data: responseData,
        );
      }

      if (cardData is! Map<String, dynamic>) {
        print('⚠️ [TarotApiService] cardData is not Map: ${cardData.runtimeType}');
        throw ApiException(
          message: 'Định dạng dữ liệu không đúng',
          statusCode: response.statusCode,
          data: cardData,
        );
      }

      // Log card data keys để debug
      print('🔍 [TarotApiService] Card data keys: ${cardData.keys.toList()}');

      return TarotCard.fromJson(cardData);
    } catch (e) {
      print('❌ [TarotApiService] Error getting tarot card by ID: $e');
      rethrow;
    }
  }

  /// Create new tarot card
  /// 
  /// [card] - TarotCard object to create
  /// Returns: Created TarotCard
  Future<TarotCard> createCard(TarotCard card) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '$_basePath/cards',
        data: card.toJson(),
      );

      final responseData = response.data;
      if (responseData == null) {
        throw ApiException(
          message: 'Không thể tạo lá bài',
          statusCode: response.statusCode,
        );
      }

      final cardData = responseData['data'] ?? responseData;
      return TarotCard.fromJson(cardData as Map<String, dynamic>);
    } catch (e) {
      print('Error creating tarot card: $e');
      rethrow;
    }
  }

  /// Update tarot card
  /// 
  /// [cardId] - ID của lá bài cần update
  /// [card] - Updated TarotCard object
  /// Returns: Updated TarotCard
  Future<TarotCard> updateCard(String cardId, TarotCard card) async {
    try {
      final response = await put<Map<String, dynamic>>(
        '$_basePath/cards/$cardId',
        data: card.toJson(),
      );

      final responseData = response.data;
      if (responseData == null) {
        throw ApiException(
          message: 'Không thể cập nhật lá bài',
          statusCode: response.statusCode,
        );
      }

      final cardData = responseData['data'] ?? responseData;
      return TarotCard.fromJson(cardData as Map<String, dynamic>);
    } catch (e) {
      print('Error updating tarot card: $e');
      rethrow;
    }
  }

  /// Delete tarot card
  /// 
  /// [cardId] - ID của lá bài cần xóa
  Future<void> deleteCard(String cardId) async {
    try {
      await delete('$_basePath/cards/$cardId');
    } catch (e) {
      print('Error deleting tarot card: $e');
      rethrow;
    }
  }

  /// Get random tarot card
  /// 
  /// Returns: Random TarotCard
  Future<TarotCard> getRandomCard() async {
    try {
      final response = await get<Map<String, dynamic>>(
        '$_basePath/cards/random',
      );

      final responseData = response.data;
      if (responseData == null) {
        throw ApiException(
          message: 'Không thể lấy lá bài ngẫu nhiên',
          statusCode: response.statusCode,
        );
      }

      final cardData = responseData['data'] ?? responseData;
      return TarotCard.fromJson(cardData as Map<String, dynamic>);
    } catch (e) {
      print('Error getting random tarot card: $e');
      rethrow;
    }
  }
}


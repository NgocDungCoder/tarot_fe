# API Services Documentation

## Cấu hình Dio cho MongoDB API Local

### 1. Cài đặt dependencies

Đã thêm `dio: ^5.4.0` vào `pubspec.yaml`. Chạy:
```bash
flutter pub get
```

### 2. Cấu hình Base URL

Base URL mặc định được set trong `lib/env.dart`:
- Development: `http://localhost:3000/api`
- Có thể override bằng environment variable `API_URL`

### 3. Sử dụng API Service

#### Khởi tạo Dio (tự động khi gọi lần đầu)
```dart
final dioConfig = DioConfig();
final dio = dioConfig.dio;
```

#### Sử dụng TarotApiService
```dart
final tarotApi = TarotApiService();

// Get all cards
try {
  final cards = await tarotApi.getAllCards();
  print('Total cards: ${cards.length}');
} catch (e) {
  print('Error: $e');
}

// Get card by ID
try {
  final card = await tarotApi.getCardById('card123');
  print('Card name: ${card.nameVi}');
} catch (e) {
  print('Error: $e');
}

// Get random card
try {
  final randomCard = await tarotApi.getRandomCard();
  print('Random card: ${randomCard.nameVi}');
} catch (e) {
  print('Error: $e');
}
```

### 4. Custom API Service

Tạo service mới bằng cách extend `ApiService`:

```dart
class MyApiService extends ApiService {
  static const String _basePath = '/my-endpoint';

  Future<List<MyModel>> getAll() async {
    final response = await get<Map<String, dynamic>>(_basePath);
    // Parse response...
    return [];
  }
}
```

### 5. Authentication

Để thêm authentication token:
```dart
final dioConfig = DioConfig();
dioConfig.setAuthToken('your-token-here');
```

Để remove token:
```dart
dioConfig.removeAuthToken();
```

### 6. Error Handling

API services tự động handle errors và throw `ApiException`:
```dart
try {
  final cards = await tarotApi.getAllCards();
} on ApiException catch (e) {
  print('API Error: ${e.message}');
  print('Status Code: ${e.statusCode}');
} catch (e) {
  print('Other error: $e');
}
```

## API Endpoints Structure (MongoDB/Mongoose)

Giả sử backend NestJS có cấu trúc như sau:

```
GET    /api/tarot/cards          - Get all cards (with pagination)
GET    /api/tarot/cards/:id      - Get card by ID
POST   /api/tarot/cards           - Create new card
PUT    /api/tarot/cards/:id       - Update card
DELETE /api/tarot/cards/:id       - Delete card
GET    /api/tarot/cards/random    - Get random card
```

Response format:
```json
{
  "data": [...],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 10
  }
}
```

## Notes

- Dio instance là singleton, được quản lý bởi `DioConfig`
- Tất cả requests đều có logging trong debug mode
- Timeout được set là 30 giây cho connect, receive, send
- Headers mặc định: `Content-Type: application/json`, `Accept: application/json`


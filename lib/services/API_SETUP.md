# API Setup Guide

## Vấn đề Connection Refused trên Android Emulator

Khi chạy app trên Android emulator, `localhost` hoặc `127.0.0.1` không trỏ đến máy host mà trỏ đến chính emulator.

## Giải pháp đã implement

DioConfig tự động detect platform và sử dụng URL phù hợp:

- **Android Emulator**: `http://10.0.2.2:3000/api` (địa chỉ đặc biệt để truy cập localhost của máy host)
- **iOS Simulator**: `http://localhost:3000/api`
- **Web/Desktop**: `http://localhost:3000/api`

## Cách sử dụng

### 1. Tự động (Recommended)
Code đã tự động detect platform, không cần làm gì thêm.

### 2. Override bằng Environment Variable
Nếu muốn override URL, set environment variable khi chạy:

```bash
# Android
flutter run --dart-define=API_URL=http://10.0.2.2:3000/api

# Hoặc dùng IP address thực của máy tính
flutter run --dart-define=API_URL=http://192.168.1.100:3000/api
```

### 3. Override bằng code
```dart
final dioConfig = DioConfig();
dioConfig.updateBaseUrl('http://10.0.2.2:3000/api');
```

## Lấy IP Address của máy tính (nếu cần)

### Windows:
```cmd
ipconfig
```
Tìm "IPv4 Address" trong kết quả (ví dụ: 192.168.1.100)

### Mac/Linux:
```bash
ifconfig | grep "inet "
```
Hoặc:
```bash
ip addr show
```

Sau đó sử dụng IP này trong URL:
```
http://192.168.1.100:3000/api
```

## Test API Connection

1. Đảm bảo backend đang chạy trên port 3000
2. Chạy app trên Android emulator
3. Vào trang Explore để test API call
4. Xem console log để kiểm tra URL được sử dụng:
   ```
   📱 [DioConfig] Android detected - Using: http://10.0.2.2:3000/api
   🌐 [DioConfig] Base URL: http://10.0.2.2:3000/api
   ```

## Troubleshooting

### Vẫn bị Connection Refused:

1. **Kiểm tra backend có đang chạy không:**
   ```bash
   # Test bằng browser hoặc curl
   curl http://localhost:3000/api/tarot/cards
   ```

2. **Kiểm tra firewall:**
   - Đảm bảo firewall không block port 3000
   - Windows: Kiểm tra Windows Firewall
   - Mac: Kiểm tra System Preferences > Security & Privacy > Firewall

3. **Thử dùng IP address thực:**
   - Lấy IP address của máy tính
   - Update base URL: `http://YOUR_IP:3000/api`

4. **Kiểm tra backend có bind đúng không:**
   - Backend phải bind `0.0.0.0` hoặc `localhost`, không phải `127.0.0.1`
   - Ví dụ NestJS: `app.listen(3000, '0.0.0.0')`

## Notes

- `10.0.2.2` là địa chỉ đặc biệt của Android emulator để truy cập localhost của máy host
- Không hoạt động trên Android device thật (cần dùng IP thực)
- iOS simulator không có vấn đề này, có thể dùng `localhost` trực tiếp


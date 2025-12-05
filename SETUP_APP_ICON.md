# Setup App Icon Guide

## Cách thiết lập logo cho app

### 1. Cài đặt dependencies

Đã thêm `flutter_launcher_icons` vào `dev_dependencies` trong `pubspec.yaml`.

Chạy lệnh:
```bash
flutter pub get
```

### 2. Generate app icons

Chạy lệnh sau để tự động generate tất cả các kích thước icon cần thiết:

```bash
flutter pub run flutter_launcher_icons
```

Lệnh này sẽ:
- Tự động tạo các icon với kích thước khác nhau cho Android (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Tạo icon cho iOS
- Tạo adaptive icon cho Android (Android 8.0+)

### 3. Rebuild app

Sau khi generate icons, rebuild app để áp dụng:

```bash
flutter clean
flutter run
```

## Cấu hình hiện tại

- **Image path**: `assets/icons/tarot_logo.jpg`
- **Android**: Enabled
- **iOS**: Enabled
- **Adaptive icon background**: Black (#000000)
- **Adaptive icon foreground**: Same logo image

## Lưu ý

1. **Logo format**: 
   - Nên sử dụng PNG với nền trong suốt hoặc JPG
   - Kích thước khuyến nghị: 1024x1024px
   - Logo sẽ được tự động resize cho các kích thước khác nhau

2. **Adaptive Icon (Android 8.0+)**:
   - Background color: Black (#000000)
   - Có thể thay đổi trong `pubspec.yaml` nếu muốn

3. **iOS**:
   - Icon sẽ tự động được tạo với các kích thước cần thiết
   - Alpha channel sẽ được remove để tương thích tốt hơn

## Troubleshooting

Nếu gặp lỗi khi generate icons:

1. Kiểm tra file logo có tồn tại tại `assets/icons/tarot_logo.jpg`
2. Đảm bảo file logo có kích thước hợp lý (khuyến nghị 1024x1024px)
3. Chạy `flutter clean` trước khi generate lại
4. Kiểm tra `pubspec.yaml` có cấu hình đúng không

## Thay đổi logo sau này

1. Thay file logo mới vào `assets/icons/tarot_logo.jpg`
2. Chạy lại: `flutter pub run flutter_launcher_icons`
3. Rebuild app: `flutter clean && flutter run`


# Hướng dẫn sử dụng Velocity X và Asset Generation trong Flutter Project

## 📋 Mục lục
1. [Phân tích cách viết Velocity cho Text và SizedBox](#phân-tích-velocity)
2. [Cách tự động generate assets](#cách-gen-asset)
3. [Prompt hướng dẫn AI viết lại code](#prompt-cho-ai)

---

## 🔍 Phân tích cách viết Velocity cho Text và SizedBox

### 1. **Extension Methods cho Responsive Sizing**

Dự án sử dụng custom extensions dựa trên `velocity_x` package kết hợp với `responsive_framework`:

#### **File: `lib/configs/styles/size.dart`**

```dart
// Extension cho num để tạo responsive values
extension NumExt on num {
  ResponsiveExtension get resp => ResponsiveExtension(this);
  
  // SizedBox widgets
  Widget get hHeightBox => resp.responsive.heightBox;  // SizedBox(height: value)
  Widget get hWidthBox => resp.responsive.widthBox;    // SizedBox(width: value)
  
  // Responsive double values
  double get hh => resp.responsive;  // Height responsive
  double get hw => resp.responsive;  // Width responsive
  double get hr => resp.responsive;  // Radius responsive
  
  // Screen dimensions
  double get sw => Get.context != null 
      ? MediaQuery.of(Get.context!).size.width 
      : Get.width;
  double get sh => Get.context != null
      ? MediaQuery.of(Get.context!).size.height
      : Get.height;
  
  // Padding shortcuts
  EdgeInsets get hPadHor => EdgeInsets.symmetric(horizontal: hw);
  EdgeInsets get hPadVer => EdgeInsets.symmetric(vertical: hh);
  EdgeInsets get hPadAll => EdgeInsets.all(hw);
  EdgeInsets get hPadSym => EdgeInsets.symmetric(horizontal: hw, vertical: hh);
  
  // BorderRadius
  BorderRadius get hRadius => BorderRadius.circular(hr);
}
```

#### **Responsive Logic:**
- **MOBILE**: Base size × 1.0
- **TABLET**: Base size × 1.15
- **DESKTOP**: Base size × 1.3
- **4K**: Base size × 1.45

### 2. **Cách sử dụng SizedBox với Velocity**

#### **Ví dụ từ `promo_page.dart`:**

```dart
// Spacing giữa các widgets
20.hWidthBox,   // SizedBox(width: 20) - responsive
10.hHeightBox,  // SizedBox(height: 10) - responsive
8.hWidthBox,    // SizedBox(width: 8) - responsive
4.hHeightBox,   // SizedBox(height: 4) - responsive

// Trong Column/Row
Column(
  children: [
    Text('Title'),
    16.hHeightBox,  // Spacing sau text
    Text('Subtitle'),
    8.hHeightBox,
  ],
)

Row(
  children: [
    Icon(Icons.star),
    8.hWidthBox,  // Spacing giữa icon và text
    Text('Rating'),
  ],
)
```

### 3. **Cách sử dụng Text với Velocity**

#### **Extension cho Text Size:**

```dart
extension TextSizeExt on VxTextBuilder {
  VxTextBuilder get hXSmall => size(HTextSize.xSmall);      // 12px
  VxTextBuilder get hSmall => size(HTextSize.small);        // 14px
  VxTextBuilder get hSNormal => size(HTextSize.sNormal);    // 16px
  VxTextBuilder get hNormal => size(HTextSize.normal);      // 18px
  VxTextBuilder get hXNormal => size(HTextSize.xnormal);   // 20px
  VxTextBuilder get hMedium => size(HTextSize.medium);      // 22px
  VxTextBuilder get hLarge => size(HTextSize.large);       // 32px
  VxTextBuilder get hXLarge => size(HTextSize.xLarge);      // 36px
  VxTextBuilder get hXXLarge => size(HTextSize.xxLarge);    // 46px
}
```

#### **Ví dụ sử dụng Text với Velocity:**

```dart
// Cách 1: Sử dụng Velocity X text builder (Recommended)
'Hello World'
  .text                    // Bắt đầu text builder
  .hSNormal                // Font size 16 (responsive)
  .bold                    // Font weight bold
  .color(Colors.blue)      // Text color
  .make()                  // Tạo widget

// Cách 2: Text với nhiều modifiers
(discount.code ?? "")
  .text
  .hSNormal
  .bold
  .color(isValid ? ThemeConfig.textBlack : Colors.grey)
  .make()

// Cách 3: Text với maxLines và ellipsis
(discount.description ?? "")
  .text
  .hSmall
  .maxLines(3)
  .ellipsis
  .color(ThemeConfig.textHint)
  .make()

// Cách 4: Text với primary color
'Giảm ${discount.discountDisplayText}'
  .text
  .hSmall
  .primary                // Sử dụng theme primary color
  .bold
  .make()
```

#### **Velocity Text Modifiers phổ biến:**

```dart
.text                    // Bắt đầu text builder
.hXSmall / .hSmall / .hSNormal / .hNormal / .hMedium / .hLarge
.bold / .semiBold        // Font weight
.color(Color)            // Text color
.primary                 // Theme primary color
.textBlack / .textWhite / .textHint  // Theme colors
.maxLines(int)           // Giới hạn số dòng
.ellipsis                // Text overflow ellipsis
.center                  // Text align center
.make()                  // Tạo widget Text
```

### 4. **Cách sử dụng Padding với Velocity**

```dart
// Padding responsive
Container(
  padding: EdgeInsets.all(12.hw),           // All sides
  padding: EdgeInsets.symmetric(
    horizontal: 16.hw, 
    vertical: 12.hh
  ),
  padding: EdgeInsets.only(
    left: 8.hw,
    top: 10.hh,
  ),
)

// Hoặc sử dụng extension methods
Widget.hPadAll(12)      // EdgeInsets.all(12.hw)
Widget.hPadHor(16)      // EdgeInsets.symmetric(horizontal: 16.hw)
Widget.hPadVer(8)       // EdgeInsets.symmetric(vertical: 8.hh)
```

### 5. **Cách sử dụng BorderRadius với Velocity**

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15.hw),  // Responsive radius
    // Hoặc
    borderRadius: 15.hRadius,                    // Sử dụng extension
  ),
)
```

### 6. **Ví dụ thực tế từ codebase**

```dart
// Từ promo_page.dart
Container(
  padding: EdgeInsets.all(12.hw),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15.hw),
  ),
  child: Row(
    children: [
      Icon(
        Icons.local_offer,
        size: 24.hw,
      ),
      8.hWidthBox,
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (discount.code ?? "")
              .text
              .hSNormal
              .bold
              .color(ThemeConfig.textBlack)
              .make(),
            2.hHeightBox,
            'Giảm ${discount.discountDisplayText}'
              .text
              .hSmall
              .primary
              .bold
              .make(),
          ],
        ),
      ),
    ],
  ),
)
```

---

## 🎨 Cách tự động Generate Assets

### 1. **Cấu hình trong `pubspec.yaml`**

```yaml
dev_dependencies:
  build_runner: ^2.4.9
  flutter_gen_runner: 5.8.0

flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/
    - assets/icons/
    - assets/images/
    - assets/images/navigations/
    - assets/images/intro/
    - assets/images/categories/
    - assets/images/home/
    - assets/images/temp/
    - assets/images/location_marker/
    - assets/images/courts/
    - assets/lottie/

flutter_gen:
  output: lib/generated/assets
  
  integrations:
    flutter_svg: true
    flare_flutter: false
    rive: false
    lottie: false
  
  assets:
    outputs:
      enabled: true
      style: dot-delimiter
      package_parameter_enabled: false
```

### 2. **Cấu hình trong `build.yaml`**

```yaml
targets:
  $default:
    builders:
      flutter_gen_runner|flutter_gen:
        enabled: true
        generate_for:
          include:
            - assets/**
        options:
          output: lib/generated/
          integrations:
            flutter_svg: true
          assets:
            outputs:
              enabled: true
              style: dot-delimiter
```

### 3. **Command để generate assets**

```bash
# Generate assets (chạy lần đầu hoặc sau khi thêm assets mới)
flutter pub run build_runner build --delete-conflicting-outputs

# Hoặc watch mode (tự động generate khi có thay đổi)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. **Cách sử dụng generated assets**

#### **Import:**
```dart
import 'package:pickleball_app/generated/assets/assets.gen.dart';
```

#### **Sử dụng PNG/JPG:**
```dart
// Cách 1: Sử dụng .image() method
Assets.images.defaultImage.image(
  fit: BoxFit.contain,
  width: 100,
  height: 100,
)

// Cách 2: Sử dụng AssetImage
Image(
  image: Assets.images.appIcon.provider(),
  width: 50,
  height: 50,
)
```

#### **Sử dụng SVG:**
```dart
// SVG được tự động convert thành widget
Assets.icons.icClear.svg(
  width: 24,
  height: 24,
  color: Colors.blue,
)
```

#### **Sử dụng assets trong nested folders:**
```dart
// assets/images/categories/img_ball.png
Assets.images.categories.imgBall.image()

// assets/images/courts/ic_time.png
Assets.images.courts.icTime.image()
```

### 5. **Cấu trúc file generated**

File `lib/generated/assets/assets.gen.dart` sẽ có cấu trúc:

```dart
class Assets {
  Assets._();
  
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();
  
  AssetGenImage get defaultImage => 
    const AssetGenImage('assets/images/default_image.png');
  
  $AssetsImagesCategoriesGen get categories => 
    const $AssetsImagesCategoriesGen();
}

class $AssetsImagesCategoriesGen {
  const $AssetsImagesCategoriesGen();
  
  AssetGenImage get imgBall => 
    const AssetGenImage('assets/images/categories/img_ball.png');
}
```

### 6. **Lưu ý khi thêm assets mới**

1. **Thêm file vào thư mục `assets/`** (theo cấu trúc đã định nghĩa)
2. **Chạy build_runner:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. **Import và sử dụng:**
   ```dart
   import 'package:pickleball_app/generated/assets/assets.gen.dart';
   
   Assets.images.newImage.image()
   ```

### 7. **Naming Convention**

- File names: `snake_case` (ví dụ: `ic_back.png`, `img_ball.png`)
- Generated properties: `camelCase` (ví dụ: `icBack`, `imgBall`)
- Folder names: `snake_case` (ví dụ: `location_marker/`)

---

## 🤖 Prompt hướng dẫn AI viết lại code

### **PROMPT CHO AI:**

```
Bạn là một Flutter developer chuyên nghiệp. Hãy viết lại code Flutter widget theo các quy tắc sau:

## QUY TẮC SỬ DỤNG VELOCITY X VÀ RESPONSIVE SIZING

### 1. TEXT WIDGETS - Luôn sử dụng Velocity X text builder:

✅ ĐÚNG:
```dart
'Hello World'
  .text
  .hSNormal          // Font size 16 (responsive)
  .bold
  .color(Colors.blue)
  .make()
```

❌ SAI:
```dart
Text(
  'Hello World',
  style: TextStyle(fontSize: 16),
)
```

### 2. SIZEDBOX - Sử dụng extension methods:

✅ ĐÚNG:
```dart
Column(
  children: [
    Text('Title'),
    16.hHeightBox,    // SizedBox(height: 16) - responsive
    Text('Subtitle'),
    8.hWidthBox,      // SizedBox(width: 8) - responsive
  ],
)
```

❌ SAI:
```dart
Column(
  children: [
    Text('Title'),
    SizedBox(height: 16),
    Text('Subtitle'),
  ],
)
```

### 3. PADDING - Sử dụng responsive values:

✅ ĐÚNG:
```dart
Container(
  padding: EdgeInsets.all(12.hw),           // All sides responsive
  padding: EdgeInsets.symmetric(
    horizontal: 16.hw, 
    vertical: 12.hh
  ),
)
```

❌ SAI:
```dart
Container(
  padding: EdgeInsets.all(12),
)
```

### 4. BORDER RADIUS - Sử dụng responsive values:

✅ ĐÚNG:
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15.hw),
  ),
)
```

❌ SAI:
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15),
  ),
)
```

### 5. ICON SIZE - Sử dụng responsive values:

✅ ĐÚNG:
```dart
Icon(
  Icons.star,
  size: 24.hw,
)
```

❌ SAI:
```dart
Icon(
  Icons.star,
  size: 24,
)
```

### 6. ASSETS - Sử dụng generated assets:

✅ ĐÚNG:
```dart
import 'package:pickleball_app/generated/assets/assets.gen.dart';

Assets.images.defaultImage.image(
  fit: BoxFit.contain,
  width: 100.hw,
  height: 100.hh,
)
```

❌ SAI:
```dart
Image.asset(
  'assets/images/default_image.png',
  width: 100,
  height: 100,
)
```

### 7. TEXT SIZE OPTIONS:

Sử dụng các text size sau (tất cả đều responsive):
- `.hXSmall` - 12px (mobile) → 17.4px (4K)
- `.hSmall` - 14px (mobile) → 20.3px (4K)
- `.hSNormal` - 16px (mobile) → 23.2px (4K) ⭐ Most common
- `.hNormal` - 18px (mobile) → 26.1px (4K)
- `.hXNormal` - 20px (mobile) → 29px (4K)
- `.hMedium` - 22px (mobile) → 31.9px (4K)
- `.hLarge` - 32px (mobile) → 46.4px (4K)
- `.hXLarge` - 36px (mobile) → 52.2px (4K)
- `.hXXLarge` - 46px (mobile) → 66.7px (4K)

### 8. TEXT MODIFIERS:

```dart
.text                    // Bắt đầu text builder
.hSNormal                // Font size
.bold / .semiBold        // Font weight
.color(Color)            // Text color
.primary                 // Theme primary color
.textBlack / .textWhite / .textHint  // Theme colors
.maxLines(int)           // Giới hạn số dòng
.ellipsis                // Text overflow
.center                  // Text align
.make()                  // Tạo widget
```

### 9. RESPONSIVE VALUES:

- `.hw` - Width responsive (horizontal)
- `.hh` - Height responsive (vertical)
- `.hr` - Radius responsive
- `.sw` - Screen width
- `.sh` - Screen height

### 10. SPACING PATTERNS:

```dart
// Small spacing
2.hHeightBox
4.hWidthBox

// Medium spacing
8.hHeightBox
8.hWidthBox
10.hHeightBox

// Large spacing
16.hHeightBox
20.hWidthBox
```

## YÊU CẦU:

1. **Luôn import:**
   ```dart
   import 'package:velocity_x/velocity_x.dart';
   import 'package:pickleball_app/configs/styles/size.dart';
   import 'package:pickleball_app/generated/assets/assets.gen.dart';
   ```

2. **Tất cả Text widgets phải dùng Velocity X text builder**

3. **Tất cả SizedBox phải dùng `.hHeightBox` hoặc `.hWidthBox`**

4. **Tất cả padding, margin, size, radius phải dùng `.hw`, `.hh`, `.hr`**

5. **Tất cả assets phải dùng generated assets từ `Assets.images.*` hoặc `Assets.icons.*`**

6. **Code phải responsive trên tất cả breakpoints (MOBILE, TABLET, DESKTOP, 4K)**

7. **Sử dụng text size phù hợp:**
   - Body text: `.hSNormal` hoặc `.hSmall`
   - Title: `.hNormal` hoặc `.hMedium`
   - Heading: `.hLarge` hoặc `.hXLarge`

8. **Comment code bằng tiếng Anh, ngắn gọn và rõ ràng**

Hãy viết lại code widget theo các quy tắc trên.
```

---

## 📝 Tóm tắt

### **Velocity X Patterns:**

1. **Text:** `'text'.text.hSNormal.bold.color(Colors.blue).make()`
2. **SizedBox:** `16.hHeightBox`, `8.hWidthBox`
3. **Padding:** `EdgeInsets.all(12.hw)`, `EdgeInsets.symmetric(horizontal: 16.hw, vertical: 12.hh)`
4. **BorderRadius:** `BorderRadius.circular(15.hw)`
5. **Icon Size:** `size: 24.hw`
6. **Image Size:** `width: 100.hw, height: 100.hh`

### **Asset Generation:**

1. **Command:** `flutter pub run build_runner build --delete-conflicting-outputs`
2. **Import:** `import 'package:pickleball_app/generated/assets/assets.gen.dart';`
3. **Usage:** `Assets.images.imageName.image()`

### **Best Practices:**

- ✅ Luôn sử dụng responsive values (`.hw`, `.hh`, `.hr`)
- ✅ Luôn sử dụng Velocity X text builder
- ✅ Luôn sử dụng generated assets
- ✅ Sử dụng text size phù hợp với context
- ✅ Comment code rõ ràng bằng tiếng Anh

---

**Done nha bro** ✅


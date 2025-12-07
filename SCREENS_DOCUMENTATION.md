# 📱 Báo Cáo Các Màn Hình Ứng Dụng Tarot

## 

---

## 📦 Main Screen (Bottom Navigation)

- Quản lý 4 tab chính: Home, Explore, Shop, User
- Video background chung cho tất cả tabs
- Lazy loading controllers cho từng tab
- Bottom navigation bar trong suốt với viền vàng
- Xử lý double back press để thoát app
- Quản lý state của tab hiện tại
- Transition mượt mà giữa các tabs
- Background fallback khi video lỗi

---

## 📦 Home Screen

- Hiển thị lá bài Tarot ngẫu nhiên mỗi ngày
- Animation flip card khi lật bài
- Hiển thị chi tiết lá bài sau khi lật
- Nút "Rút bài mới" để random lá bài khác
- Hero animation khi navigate đến card detail
- Video background với fallback
- Loading state khi đang random bài
- Hiển thị ý nghĩa lá bài (upright và reversed)

---

## 📦 Explore Screen

- Hiển thị danh sách blog với horizontal scroll
- Phân loại lá bài theo 4 nhóm: Major Arcana, Cup, Wand, Sword
- Grid view 2x2 cho mỗi nhóm lá bài
- Nút "View All" để xem tất cả lá bài của từng nhóm
- Hero animation khi click vào lá bài
- Lazy loading dữ liệu lá bài
- Blog items với hình ảnh và mô tả
- Gradient overlay cho text dễ đọc
- Navigate đến card detail khi click lá bài

---

## 📦 Shop Screen

- Banner carousel tự động chuyển slide
- Hiển thị danh sách sản phẩm với grid layout
- Filter theo category
- Tìm kiếm sản phẩm theo tên
- Thêm sản phẩm vào giỏ hàng
- Navigate đến product detail
- Hiển thị giá sản phẩm (Magic Points)
- Loading state khi load sản phẩm
- Empty state khi không có sản phẩm
- Badge số lượng items trong giỏ hàng

---

## 📦 User/Setting Screen

- Hiển thị thông tin người dùng (avatar, tên, email, phone)
- Magic Points và Reward Points
- Cung hoàng đạo
- Click vào user header để navigate đến profile
- Menu items: Lịch sử rút bài, Lịch sử giao dịch, Đơn hàng
- Menu cài đặt: Chính sách, Điều khoản, Quyền riêng tư, Trợ giúp, Về chúng tôi
- Nút đăng xuất
- Loading state khi load user data
- Navigate đến profile page để chỉnh sửa

---

## 📦 Card Detail Screen

- Hiển thị chi tiết đầy đủ của lá bài Tarot
- Hero animation khi navigate từ explore/home
- Video background với fallback
- Hiển thị tên lá bài (tiếng Anh và tiếng Việt)
- Mô tả chi tiết về lá bài
- Ý nghĩa khi lá bài upright
- Ý nghĩa khi lá bài reversed
- Nút back để quay lại
- Animation fade khi load
- Full screen image của lá bài

---

## 📦 Card Draw Screen

- Rút bài Tarot với animation flip card
- Random lá bài từ danh sách có sẵn
- Hiển thị kết quả sau khi lật bài
- Animation mượt mà khi flip card
- Video background với fallback
- Nút "Rút bài mới" để random lại
- Hiển thị ý nghĩa lá bài
- Loading state khi đang random
- Sound effects (optional)
- Lưu lịch sử rút bài

---

## 📦 Cart Screen

- Hiển thị danh sách sản phẩm trong giỏ hàng
- Tăng/giảm số lượng sản phẩm
- Xóa sản phẩm khỏi giỏ hàng
- Tính tổng số items và tổng giá
- Hiển thị giá từng sản phẩm (Magic Points)
- Empty state khi giỏ hàng trống
- Nút checkout để thanh toán
- Loading state khi xử lý
- Snackbar thông báo khi thêm/xóa sản phẩm
- Navigate đến checkout confirmation

---

## 📦 Product Detail Screen

- Hiển thị chi tiết sản phẩm đầy đủ
- Hình ảnh sản phẩm
- Tên sản phẩm (tiếng Anh và tiếng Việt)
- Mô tả sản phẩm
- Giá sản phẩm (Magic Points)
- Nút thêm vào giỏ hàng
- Navigate từ shop screen
- Loading state khi load chi tiết
- Error handling khi không tìm thấy sản phẩm
- Hero animation (optional)

---

## 📦 View All Cards Screen

- Hiển thị tất cả lá bài của một loại (Major/Cup/Wand/Sword)
- Grid layout với scroll
- Filter và search lá bài
- Navigate đến card detail khi click
- Loading state khi load danh sách
- Empty state khi không có lá bài
- Title động theo loại lá bài
- Hero animation khi navigate
- Pagination (optional)

---

## 📦 Profile Screen

- Hiển thị thông tin cá nhân đầy đủ
- Avatar với nút chỉnh sửa
- Tên, email, số điện thoại
- Magic Points và Reward Points
- Cung hoàng đạo
- Chỉnh sửa từng field thông tin
- Dialog để edit name, email, phone, zodiac
- Validation khi chỉnh sửa
- Lưu thông tin sau khi chỉnh sửa
- Navigate từ user screen
- Loading state khi load/save data

---

## 📦 Checkout Confirmation Screen

- Hiển thị danh sách sản phẩm sẽ mua
- Tổng tiền trước giảm giá
- Chọn voucher từ danh sách
- Tính giảm giá từ voucher (%)
- Tính điểm thưởng (10% của tổng sau giảm giá)
- Tổng tiền cuối cùng sau giảm giá
- Thông tin giao hàng (tên, phone, địa chỉ)
- Chỉnh sửa thông tin giao hàng
- Validation đầy đủ thông tin trước khi xác nhận
- Dialog xác nhận thanh toán
- Xử lý thanh toán và clear cart
- Navigate đến payment success sau khi thanh toán

---

## 📦 Payment Success Screen

- Hiển thị icon thành công
- Thông báo thanh toán thành công
- Thông tin đơn hàng (mã đơn, tổng tiền, điểm thưởng)
- Voucher đã sử dụng (nếu có)
- Thẻ hiển thị điểm thưởng nhận được
- Nút "Về trang chủ" - quay về main page tab home
- Nút "Xem đơn hàng" - chuyển sang tab user
- Animation fade khi load
- Không thể quay lại trang checkout (offNamed)
- Hiển thị thông tin từ arguments

---

## 📦 Splash Screen (Initial)

- Logo và branding
- Video background với fallback
- Loading indicator
- Auto navigate sau khi load
- Check authentication state
- Initialize app data
- Error handling


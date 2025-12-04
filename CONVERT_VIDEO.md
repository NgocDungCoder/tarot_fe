# Hướng dẫn Convert Video cho Splash Screen

## Vấn đề
Video hiện tại gặp lỗi `MediaCodecVideoRenderer error` do codec profile không tương thích với một số thiết bị Android.

## Giải pháp: Convert video với H.264 Baseline Profile

### Cách 1: Sử dụng FFmpeg (Khuyến nghị)

#### Bước 1: Cài đặt FFmpeg

**Windows:**
```powershell
# Sử dụng winget (Windows 10/11)
winget install ffmpeg

# Hoặc Chocolatey
choco install ffmpeg

# Hoặc tải từ: https://www.gyan.dev/ffmpeg/builds/
```

**macOS:**
```bash
brew install ffmpeg
```

**Linux:**
```bash
sudo apt update
sudo apt install ffmpeg
```

#### Bước 2: Convert video với Baseline Profile

Chạy lệnh sau trong terminal tại thư mục project:

```bash
# Convert xuống 720p với Baseline profile (tương thích tốt nhất)
ffmpeg -i assets/videos/video_splash.mp4 \
  -vf scale=1280:720 \
  -c:v libx264 \
  -profile:v baseline \
  -level 3.0 \
  -pix_fmt yuv420p \
  -crf 23 \
  -preset medium \
  -c:a aac \
  -b:a 128k \
  -movflags +faststart \
  assets/videos/video_splash_converted.mp4
```

**Giải thích các tham số:**
- `-vf scale=1280:720`: Giảm độ phân giải xuống 720p
- `-c:v libx264`: Sử dụng codec H.264
- `-profile:v baseline`: Baseline profile (tương thích tốt nhất với mọi thiết bị)
- `-level 3.0`: Level 3.0 (hỗ trợ tốt cho 720p)
- `-pix_fmt yuv420p`: Pixel format chuẩn (tương thích tốt)
- `-crf 23`: Chất lượng video (18-28, số càng thấp chất lượng càng cao)
- `-preset medium`: Tốc độ encode (medium = cân bằng)
- `-c:a aac`: Codec audio AAC
- `-b:a 128k`: Bitrate audio 128kbps
- `-movflags +faststart`: Tối ưu cho streaming/web

#### Bước 3: Thay thế file video

```bash
# Backup file gốc
mv assets/videos/video_splash.mp4 assets/videos/video_splash_original.mp4

# Đổi tên file đã convert
mv assets/videos/video_splash_converted.mp4 assets/videos/video_splash.mp4
```

### Cách 2: Sử dụng công cụ online

1. Truy cập: https://www.freeconvert.com/video-compressor
2. Upload file video
3. Chọn độ phân giải: 720p hoặc 1080p
4. Download và thay thế file trong `assets/videos/`

### Cách 3: Sử dụng HandBrake (GUI)

1. Tải HandBrake: https://handbrake.fr/
2. Mở file video
3. Preset: Chọn "Fast 720p30" hoặc "Fast 1080p30"
4. Video tab:
   - Encoder: H.264 (x264)
   - Framerate: Same as source hoặc 30
   - Quality: RF 23
5. Dimensions tab:
   - Resolution: 1280x720 hoặc 1920x1080
6. Encode và thay thế file

## Kiểm tra sau khi convert

1. Chạy app: `flutter run`
2. Kiểm tra console log:
   - ✅ Nếu thấy "Video initialized OK" → Thành công!
   - ❌ Nếu vẫn lỗi → Thử convert với độ phân giải thấp hơn (480p)

## Độ phân giải khuyến nghị

- **720p (1280x720)**: Tốt nhất cho splash screen, tương thích cao, file nhỏ
- **1080p (1920x1080)**: Chất lượng tốt nhưng file lớn hơn
- **480p (854x480)**: Dự phòng nếu 720p vẫn lỗi

## Lưu ý

- Luôn backup file gốc trước khi thay thế
- Test trên nhiều thiết bị khác nhau nếu có thể
- File video nên ngắn (< 10 giây) để giảm kích thước app


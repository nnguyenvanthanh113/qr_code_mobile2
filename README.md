🔥 Ứng dụng quét mã QR dánh cho tài xế.

- Ứng dụng dùng để tài xế quét mã QR chấm công nhân viên hằng ngày
- Viết bằng flutter.

## Tính năng

✏️ pubspec.yaml

    http: 0.12.1

    qr_code_scanner: 0.0.12

    shared_preferences: ^0.4.3

    audioplayers: ^0.13.2

    connectivity: ^0.4.8

    sqflite: any

    path_provider: any

    rich_alert: ^0.1.32

    flutter_launcher_icons: ^0.7.0
    
  ✔️ Splash
  
  ![10](https://user-images.githubusercontent.com/46096171/198833627-3d4aac55-eaa5-41e4-8561-41dac50d6a40.jpg)
  
  ✔️ Đăng nhập sử dụng restful api kết nối server Kintone (clounds computing).
  
  ![7](https://user-images.githubusercontent.com/46096171/198834209-62794987-79f5-4377-90e8-d02b05fa6875.jpg)

  ✔️ Hiện thị timeline nhân viên trong ngày đã check in/check out 
  
  - check internet.
      
   ![1](https://user-images.githubusercontent.com/46096171/198834221-b13eff85-dc47-47ee-9cc6-8e11bff738b2.jpg)
   ![11](https://user-images.githubusercontent.com/46096171/198834226-fdf70f46-91ad-4e17-9c1c-2c49db9bcb66.jpg)
  
  ✔️ Quét mã QR code.
  
  - kiểm tra tồn tại của nhân viên trên clouds.
    
  - kiểm tra check in/ check out.
    
  - Lưu check in / check out vào hệ thông database clouds nếu có internet.
    
  - Nếu không có internet lưu vào sqflite.
    
![8](https://user-images.githubusercontent.com/46096171/198834261-a799c5ef-19f0-4ab2-ae84-a63654f3e7c6.jpg)
![9](https://user-images.githubusercontent.com/46096171/198834263-7d39fa98-17b4-4bd1-98dc-e8d5d96f1aaf.jpg)
![2](https://user-images.githubusercontent.com/46096171/198834265-69d326eb-ea57-4360-97f2-6ff51c590b71.jpg)
![3](https://user-images.githubusercontent.com/46096171/198834266-08611899-930e-4288-9a66-57c124d458d1.jpg)
![4](https://user-images.githubusercontent.com/46096171/198834269-7c866c15-43bf-493a-945f-182d9f0e9daf.jpg)

  ✔️ Lưu check in/check out khi không có internet từ quét QR code.
  
  - Xóa thông tin check in/ check out.
    
  - Lưu thông tin toàn bộ lên database clouds.
  
![6](https://user-images.githubusercontent.com/46096171/198834448-0b80a987-c373-4aab-a808-22d9f36b87cc.jpg)




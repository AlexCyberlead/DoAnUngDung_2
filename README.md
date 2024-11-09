# CyberScore - Ứng dụng dự đoán điểm số học sinh bằng AI 

CyberScore là một ứng dụng mạnh mẽ, sử dụng trí tuệ nhân tạo (AI) để hỗ trợ giáo viên và phụ huynh dự đoán điểm số học tập của học sinh. Ứng dụng có mục tiêu giúp người dùng có cái nhìn sớm về kết quả học tập, từ đó đưa ra những điều chỉnh kịp thời trong quá trình giảng dạy và học tập.

## 🎯 Mục tiêu của ứng dụng:

- 🧠 **Dự đoán điểm số chính xác** dựa trên mô hình Machine Learning.
- 📈 **Cung cấp thông tin sớm** về kết quả học tập để giúp đưa ra điều chỉnh kịp thời.
- 👩‍🏫 **Hỗ trợ giáo viên và phụ huynh** trong việc theo dõi sự tiến bộ của học sinh.

---

## 🚪 Tính năng chính:

- ✏️ **Nhập dữ liệu thủ công** hoặc từ file CSV.
- 🎨 **Giao diện hiện đại** dựa trên tiêu chuẩn Material Design.
- 🌍 **Tương thích đa nền tảng**, hoạt động trên Web, Android, iOS, Windows, Linux và macOS.
- 💻 **Animation mượt mà**, dễ sử dụng.
- 🔮 **Tích hợp AI** cho phép dự đoán điểm số học sinh.

---

## 🛠️ Công Nghệ Sử Dụng:

### Frontend:
- **🖼️ Flutter/Dart**: Framework chính cho giao diện đa nền tảng.
- **🎨 Material Design**: Thiết kế UI tối ưu cho trải nghiệm người dùng.
- **🔗 HTTP Package**: Kết nối với API.

### Backend:
- **🐍 Python 3.8+**: Ngôn ngữ lập trình backend chính.
- **🍶 Flask**: Web framework nhẹ nhàng và tùy chỉnh.
- **🤖 Scikit-learn**: Thư viện máy học mạnh mẽ.
- **📊 Pandas & NumPy**: Xử lý và phân tích dữ liệu.
- **📦 Joblib**: Lưu và tải mô hình AI.
  
---

## 🔧 Yêu Cầu Hệ Thống

### Frontend:

- 🌐 **Flutter SDK**: Cài đặt phiên bản mới nhất từ trang chính thức.
- 🛠️ **Dart SDK**: Tích hợp với Flutter.
- 🖥️ **IDE**: Visual Studio Code hoặc Android Studio.
- 🧰 **Git**: Quản lý mã nguồn.

### Backend:

- 🐍 **Python 3.8 trở lên**.
- 📦 **pip**: Python package manager.
- 📚 Nhóm thư viện:
  - flask
  - pandas
  - scikit-learn
  - joblib
  - numpy.

---

## 📥 Hướng Dẫn Cài Đặt

### 1. **Cài Đặt Backend:**

- Cài đặt **Python 3.8+** và **pip**.
- Tạo môi trường ảo:

    ```bash
    python -m venv venv
    source venv/bin/activate  # Linux/Mac
    venv\Scripts\activate     # Windows
    ```

- Cài đặt các thư viện cần thiết:

    ```bash
    pip install flask pandas scikit-learn joblib numpy
    ```

- Khởi động server:

    ```bash
    cd backend
    python app.py
    ```

### 2. **Cài Đặt Frontend:**

- Cài đặt **Flutter SDK** và **Dart SDK** theo hướng dẫn chính thức.
- Clone repository:

    ```bash
    git clone https://github.com/petervlu/DoAnUngDung_2
    cd doanlaptrinh
    ```

- Cài đặt dependencies cho dự án:

    ```bash
    flutter pub get
    ```

- Khởi chạy ứng dụng:

    ```bash
    flutter run
    ```

### 3. **Lưu Ý Quan Trọng:**

- Backend phải được chạy **trước** khi khởi động frontend.
- Đảm bảo file model AI (**decision_tree_model.pkl**) đã nằm trong thư mục `backend/models/`.
- Kiểm tra URL API trong frontend (mặc định là `http://localhost:5000`) và đảm bảo nó phù hợp với cấu hình backend.

---

## 🖼️ Screenshot - Ảnh chụp màn hình
Dưới đây là một số ảnh chụp màn hình của ứng dụng:

### Màn Hình Chính
![Screenshot 1](assets/screenshots/Screenshot_1.jpg)

### Màn Hình Nhập Dữ Liệu
![Screenshot 2](assets/screenshots/Screenshot_2.jpg)

### Màn Hình Dự Đoán
![Screenshot 3](assets/screenshots/Screenshot_3.jpg)

### Màn Hình Kết Quả
![Screenshot 4](assets/screenshots/Screenshot_4.jpg)

---

## 👥 Tác Giả:

- **Lê Tuấn Anh (2274801030005)**
- **Trần Tuấn Anh (2274801030009)**
- **Bùi Thảo Duyên (2274801030026)**

Lớp: **K28KTPM03 - Trường đại học Văn Lang** 🎓


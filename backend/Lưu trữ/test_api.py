import requests
import json

def test_prediction():
    print("Bắt đầu test prediction...")
    
    # URL của API
    url = 'http://localhost:5000/predict'
    print(f"Gửi request đến: {url}")

    # Dữ liệu mẫu
    sample_data = {
        "school": "GP",
        "sex": "F", 
        "age": 18,
        "address": "U",
        "famsize": "GT3",
        "Pstatus": "A",
        "Medu": 4,
        "Fedu": 4,
        "Mjob": "at_home",
        "Fjob": "teacher",
        "reason": "course",
        "guardian": "mother",
        "traveltime": 2,
        "studytime": 2,
        "failures": 0,
        "schoolsup": "yes",
        "famsup": "no",
        "paid": "no",
        "activities": "no",
        "nursery": "yes",
        "higher": "yes",
        "internet": "no",
        "romantic": "no",
        "famrel": 4,
        "freetime": 3,
        "goout": 4,
        "Dalc": 1,
        "Walc": 1,
        "health": 5,
        "absences": 6,
        "G1": 5,
        "G2": 6
    }

    print("Dữ liệu gửi đi:", json.dumps(sample_data, indent=2))

    try:
        print("Đang gửi request...")
        response = requests.post(url, json=sample_data)
        print("Đã nhận response!")
        
        print("Status Code:", response.status_code)
        print("Response Headers:", response.headers)
        print("Response Body:", response.text)
        
        if response.status_code == 200:
            print("Response JSON:", response.json())
        
    except requests.exceptions.ConnectionError:
        print("Lỗi kết nối! Hãy đảm bảo Flask server đang chạy ở port 5000")
    except Exception as e:
        print("Có lỗi xảy ra:", str(e))
        print("Loại lỗi:", type(e).__name__)

if __name__ == "__main__":
    print("=== Bắt đầu test API ===")
    test_prediction()
    print("=== Kết thúc test API ===")
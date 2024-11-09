import joblib
import pandas as pd

# Đường dẫn tới file mô hình 
model_path = 'models/decision_tree_model.pkl'

# Tải mô hình
try:
    model = joblib.load(model_path)
    print("Model loaded successfully.")
except Exception as e:
    print(f"Error loading model: {str(e)}")
    exit()

# Dữ liệu mẫu để kiểm tra
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

# Tạo DataFrame từ dữ liệu mẫu
df = pd.DataFrame([sample_data])

# One-hot encoding
df_encoded = pd.get_dummies(df)

# Đảm bảo có đủ cột như lúc training
try:
    missing_cols = set(model.feature_names_in_) - set(df_encoded.columns)
    for col in missing_cols:
        df_encoded[col] = 0

    # Sắp xếp cột theo thứ tự của model
    df_encoded = df_encoded[model.feature_names_in_]

    # Thực hiện dự đoán
    prediction = model.predict(df_encoded)
    print("Prediction:", prediction)
except Exception as e:
    print(f"Error during prediction: {str(e)}")
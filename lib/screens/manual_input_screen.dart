import 'package:flutter/material.dart';
import '../../widgets/prediction_result.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  String _prediction = "Chưa có kết quả";
  bool _isLoading = false;
  int _currentSection = 0;
  final List<String> _sectionTitles = [
    'Thông tin cơ bản',
    'Thông tin gia đình',
    'Thông tin học tập',
    'Thông tin khác',
    'Điểm số'
  ];

  final List<String> _sectionDescriptions = [
    'Chào mừng bạn! Hãy bắt đầu bằng việc cung cấp một số thông tin cơ bản nhé.',
    'Tuyệt vời! Tiếp theo, hãy chia sẻ một chút về môi trường gia đình của học sinh.',
    'Bước tiếp theo, chúng tôi cần biết về tình hình học tập hiện tại.',
    'Sắp hoàn thành rồi! Hãy cho chúng tôi biết thêm một số thông tin khác.',
    'Cuối cùng, hãy nhập điểm số của các kỳ trước để chúng tôi dự đoán kết quả nhé!'
  ];

  // Controllers cho các trường input số
  final TextEditingController _ageController =
      TextEditingController(text: '18');
  final TextEditingController _meduController =
      TextEditingController(text: '4');
  final TextEditingController _feduController =
      TextEditingController(text: '4');
  final TextEditingController _traveltimeController =
      TextEditingController(text: '2');
  final TextEditingController _failuresController =
      TextEditingController(text: '0');
  final TextEditingController _famrelController =
      TextEditingController(text: '4');
  final TextEditingController _freetimeController =
      TextEditingController(text: '3');
  final TextEditingController _gooutController =
      TextEditingController(text: '4');
  final TextEditingController _dalcController =
      TextEditingController(text: '1');
  final TextEditingController _walcController =
      TextEditingController(text: '1');
  final TextEditingController _healthController =
      TextEditingController(text: '5');
  final TextEditingController _absencesController =
      TextEditingController(text: '6');
  final TextEditingController _g1Controller = TextEditingController(text: '5');
  final TextEditingController _g2Controller = TextEditingController(text: '6');

  // Giá trị cho các dropdown
  String _school = "GP";
  String _sex = "F";
  String _address = "U";
  String _famsize = "GT3";
  String _pstatus = "A";
  String _mjob = "at_home";
  String _fjob = "teacher";
  final String _reason = "course";
  String _guardian = "mother";
  int _studytime = 2;
  String _schoolsup = "yes";
  String _famsup = "no";
  String _paid = "no";
  String _activities = "no";
  String _nursery = "yes";
  String _higher = "yes";
  String _internet = "no";
  String _romantic = "no";

  String _errorMessage = '';

  // Hàm kiểm tra dữ liệu trước khi gửi
  bool _validateInputs() {
    // Reset error state
    setState(() {
      _errorMessage = '';
    });

    // Kiểm tra các trường số
    try {
      // Kiểm tra age
      int age = int.parse(_ageController.text);
      if (age < 15 || age > 22) {
        _errorMessage = 'Tuổi phải từ 15-22';
        return false;
      }

      // Kiểm tra điểm số
      int g1 = int.parse(_g1Controller.text);
      int g2 = int.parse(_g2Controller.text);
      if (g1 < 0 || g1 > 20 || g2 < 0 || g2 > 20) {
        _errorMessage = 'Điểm số phải từ 0-20';
        return false;
      }

      // Kiểm tra các trường số khác
      if (_meduController.text.isEmpty ||
          _feduController.text.isEmpty ||
          _traveltimeController.text.isEmpty ||
          _failuresController.text.isEmpty ||
          _famrelController.text.isEmpty ||
          _freetimeController.text.isEmpty ||
          _gooutController.text.isEmpty ||
          _dalcController.text.isEmpty ||
          _walcController.text.isEmpty ||
          _healthController.text.isEmpty ||
          _absencesController.text.isEmpty) {
        _errorMessage = 'Vui lòng điền đầy đủ thông tin';
        return false;
      }

      // Validate ranges cho các trường khác
      int medu = int.parse(_meduController.text);
      int fedu = int.parse(_feduController.text);
      int traveltime = int.parse(_traveltimeController.text);
      int failures = int.parse(_failuresController.text);
      int famrel = int.parse(_famrelController.text);
      int freetime = int.parse(_freetimeController.text);
      int goout = int.parse(_gooutController.text);
      int dalc = int.parse(_dalcController.text);
      int walc = int.parse(_walcController.text);
      int health = int.parse(_healthController.text);
      int absences = int.parse(_absencesController.text);

      if (medu < 0 || medu > 4 || fedu < 0 || fedu > 4) {
        _errorMessage = 'Trình độ học vấn phải từ 0-4';
        return false;
      }

      if (traveltime < 1 || traveltime > 4) {
        _errorMessage = 'Thời gian di chuyển phải từ 1-4';
        return false;
      }

      if (failures < 0 || failures > 3) {
        _errorMessage = 'Số lần trượt phải từ 0-3';
        return false;
      }

      if (famrel < 1 ||
          famrel > 5 ||
          freetime < 1 ||
          freetime > 5 ||
          goout < 1 ||
          goout > 5 ||
          dalc < 1 ||
          dalc > 5 ||
          walc < 1 ||
          walc > 5 ||
          health < 1 ||
          health > 5) {
        _errorMessage = 'Các chỉ số đánh giá phải từ 1-5';
        return false;
      }

      if (absences < 0 || absences > 93) {
        _errorMessage = 'Số buổi vắng phải từ 0-93';
        return false;
      }

      return true;
    } catch (e) {
      _errorMessage = 'Vui lòng kiểm tra lại định dạng số';
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.edit_document, color: Colors.blue[800]),
            const SizedBox(width: 12),
            const Text('Nhập dữ liệu thủ công'),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.blue.withOpacity(0.2),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[100]!,
                  Colors.blue[50]!,
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value:
                                  (_currentSection + 1) / _sectionTitles.length,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Bước ${_currentSection + 1} / ${_sectionTitles.length}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          _sectionDescriptions[_currentSection],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildCurrentSection(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_prediction != "Chưa có kết quả")
                        PredictionResult(prediction: _prediction),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentSection > 0)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _currentSection--;
                                });
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Quay lại'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      if (_currentSection < _sectionTitles.length - 1)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _currentSection++;
                                });
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text(
                                'Tiếp tục',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (_currentSection == _sectionTitles.length - 1)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _predictScore,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.analytics),
                            label: const Text(
                              'Dự đoán điểm',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 16),
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDropdown(String label, String value, Map<String, String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[800]!),
          ),
          filled: true,
          fillColor: Colors.blue[50],
        ),
        items: items.entries.map((entry) {
          return DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Future<void> _predictScore() async {
    if (!_validateInputs()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: 'Đóng',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        "school": _school,
        "sex": _sex,
        "age": int.parse(_ageController.text),
        "address": _address,
        "famsize": _famsize,
        "Pstatus": _pstatus,
        "Medu": int.parse(_meduController.text),
        "Fedu": int.parse(_feduController.text),
        "Mjob": _mjob,
        "Fjob": _fjob,
        "reason": _reason,
        "guardian": _guardian,
        "traveltime": int.parse(_traveltimeController.text),
        "studytime": _studytime,
        "failures": int.parse(_failuresController.text),
        "schoolsup": _schoolsup,
        "famsup": _famsup,
        "paid": _paid,
        "activities": _activities,
        "nursery": _nursery,
        "higher": _higher,
        "internet": _internet,
        "romantic": _romantic,
        "famrel": int.parse(_famrelController.text),
        "freetime": int.parse(_freetimeController.text),
        "goout": int.parse(_gooutController.text),
        "Dalc": int.parse(_dalcController.text),
        "Walc": int.parse(_walcController.text),
        "health": int.parse(_healthController.text),
        "absences": int.parse(_absencesController.text),
        "G1": int.parse(_g1Controller.text),
        "G2": int.parse(_g2Controller.text)
      };

      final response = await http.post(
        Uri.parse('http://localhost:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          _prediction = result['message'];
        } else {
          _prediction = 'Lỗi: Không thể kết nối với server';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Không thể kết nối với server'),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _prediction = 'Lỗi: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra: $e'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  Widget _buildCurrentSection() {
    switch (_currentSection) {
      case 0:
        return _buildSection('Thông tin cơ bản', [
          _buildDropdown(
              'Trường',
              _school,
              {'GP': 'Gabriel Pereira', 'MS': 'Mousinho da Silveira'},
              (value) => setState(() => _school = value!)),
          _buildDropdown('Giới tính', _sex, {'F': 'Nữ', 'M': 'Nam'},
              (value) => setState(() => _sex = value!)),
          _buildTextField('Tuổi', _ageController),
          _buildDropdown(
              'Địa chỉ',
              _address,
              {'U': 'Thành thị', 'R': 'Nông thôn'},
              (value) => setState(() => _address = value!)),
          _buildDropdown(
              'Quy mô gia đình',
              _famsize,
              {'LE3': '≤3 người', 'GT3': '>3 người'},
              (value) => setState(() => _famsize = value!)),
          _buildDropdown(
              'Tình trạng chung sống của bố mẹ',
              _pstatus,
              {'T': 'Sống cùng nhau', 'A': 'Ly thân'},
              (value) => setState(() => _pstatus = value!)),
        ]);
      case 1:
        return _buildSection('Thông tin gia đình', [
          _buildTextField('Trình độ học vấn của mẹ (0-4)', _meduController),
          _buildTextField('Trình độ học vấn của bố (0-4)', _feduController),
          _buildDropdown(
              'Nghề nghiệp của mẹ',
              _mjob,
              {
                'teacher': 'Giáo viên',
                'health': 'Y tế',
                'services': 'Dịch vụ',
                'at_home': 'Nội trợ',
                'other': 'Khác'
              },
              (value) => setState(() => _mjob = value!)),
          _buildDropdown(
              'Nghề nghiệp của bố',
              _fjob,
              {
                'teacher': 'Giáo viên',
                'health': 'Y tế',
                'services': 'Dịch vụ',
                'at_home': 'Ở nhà',
                'other': 'Khác'
              },
              (value) => setState(() => _fjob = value!)),
          _buildDropdown(
              'Người giám hộ',
              _guardian,
              {'mother': 'Mẹ', 'father': 'Bố', 'other': 'Khác'},
              (value) => setState(() => _guardian = value!)),
        ]);
      case 2:
        return _buildSection('Thông tin học tập', [
          _buildTextField(
              'Thời gian di chuyển đến trường (1-4)', _traveltimeController),
          _buildDropdown(
              'Thời gian học (giờ/tuần)',
              _studytime.toString(),
              {'1': '<2 giờ', '2': '2-5 giờ', '3': '5-10 giờ', '4': '>10 giờ'},
              (value) => setState(() => _studytime = int.parse(value!))),
          _buildTextField('Số lần trượt (0-3)', _failuresController),
          _buildSwitchField(
            'Hỗ trợ học tập từ trường',
            _schoolsup,
            (value) => setState(() => _schoolsup = value ? 'yes' : 'no'),
            trueValue: 'yes',
            falseValue: 'no',
          ),
          _buildSwitchField(
            'Hỗ trợ học tập từ gia đình',
            _famsup,
            (value) => setState(() => _famsup = value ? 'yes' : 'no'),
            trueValue: 'yes',
            falseValue: 'no',
          ),
          _buildSwitchField(
            'Học thêm trả phí',
            _paid,
            (value) => setState(() => _paid = value ? 'yes' : 'no'),
            trueValue: 'yes',
            falseValue: 'no',
          ),
        ]);
      case 3:
        return _buildSection('Thông tin khác', [
          _buildDropdown(
              'Hoạt động ngoại khóa',
              _activities,
              {'yes': 'Có', 'no': 'Không'},
              (value) => setState(() => _activities = value!)),
          _buildDropdown(
              'Đã học mẫu giáo',
              _nursery,
              {'yes': 'Có', 'no': 'Không'},
              (value) => setState(() => _nursery = value!)),
          _buildDropdown(
              'Muốn học đại học',
              _higher,
              {'yes': 'Có', 'no': 'Không'},
              (value) => setState(() => _higher = value!)),
          _buildDropdown(
              'Có Internet ở nhà',
              _internet,
              {'yes': 'Có', 'no': 'Không'},
              (value) => setState(() => _internet = value!)),
          _buildDropdown(
              'Có người yêu',
              _romantic,
              {'yes': 'Có', 'no': 'Không'},
              (value) => setState(() => _romantic = value!)),
          _buildTextField('Quan hệ gia đình (1-5)', _famrelController),
          _buildTextField('Thời gian rảnh (1-5)', _freetimeController),
          _buildTextField('Thời gian đi chơi (1-5)', _gooutController),
          _buildTextField('Uống rượu ngày thường (1-5)', _dalcController),
          _buildTextField('Uống rượu cuối tuần (1-5)', _walcController),
          _buildTextField('Tình trạng sức khỏe (1-5)', _healthController),
          _buildTextField('Số buổi vắng mặt', _absencesController),
        ]);
      case 4:
        return _buildSection('Điểm số', [
          _buildTextField('Điểm kỳ 1 (G1) (1 - 20)', _g1Controller),
          _buildTextField('Điểm kỳ 2 (G2) (1 - 20)', _g2Controller),
        ]);
      default:
        return Container();
    }
  }

  Widget _buildSwitchField(String label, String value, Function(bool) onChanged,
      {required String trueValue, required String falseValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  value == trueValue ? 'Có' : 'Không',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: value == trueValue,
                  onChanged: (bool newValue) {
                    onChanged(newValue);
                  },
                  activeColor: Colors.blue[700],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

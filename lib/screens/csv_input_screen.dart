import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/web_download.dart';

class CSVInputScreen extends StatefulWidget {
  const CSVInputScreen({super.key});

  @override
  State<CSVInputScreen> createState() => _CSVInputScreenState();
}

class _CSVInputScreenState extends State<CSVInputScreen> {
  bool _isProcessing = false;
  bool _isProcessingComplete = false;
  List<List<dynamic>>? _processedData;

  Future<void> _pickAndProcessCSV() async {
    try {
      setState(() {
        _isProcessing = true;
        _isProcessingComplete = false;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        String csvString;
        if (kIsWeb) {
          final bytes = result.files.single.bytes!;
          csvString = String.fromCharCodes(bytes);
        } else {
          final file = File(result.files.single.path!);
          csvString = await file.readAsString();
        }

        List<List<dynamic>> rowsAsListOfValues =
            const CsvToListConverter().convert(csvString);

        if (rowsAsListOfValues.isEmpty) {
          throw Exception('File CSV trống');
        }

        List<String> headers = rowsAsListOfValues[0]
            .map((e) => e.toString().toLowerCase())
            .toList();

        List<String> requiredColumns = [
          'student_code',
          'school',
          'sex',
          'age',
          'address',
          'famsize',
          'pstatus',
          'medu',
          'fedu',
          'mjob',
          'fjob',
          'reason',
          'guardian',
          'traveltime',
          'studytime',
          'failures',
          'schoolsup',
          'famsup',
          'paid',
          'activities',
          'nursery',
          'higher',
          'internet',
          'romantic',
          'famrel',
          'freetime',
          'goout',
          'dalc',
          'walc',
          'health',
          'absences',
          'g1',
          'g2',
          'g3'
        ];

        for (String column in requiredColumns) {
          if (!headers.contains(column)) {
            throw Exception('Thiếu cột bắt buộc: $column');
          }
        }

        int studentCodeIndex = headers.indexOf('student_code');
        int ageIndex = headers.indexOf('age');
        int g1Index = headers.indexOf('g1');
        int g2Index = headers.indexOf('g2');
        int g3Index = headers.indexOf('g3');

        for (int i = 1; i < rowsAsListOfValues.length; i++) {
          var row = rowsAsListOfValues[i];

          if (row[studentCodeIndex] == null ||
              row[studentCodeIndex].toString().isEmpty ||
              int.tryParse(row[studentCodeIndex].toString()) == null) {
            throw Exception(
                'student_code không hợp lệ ở dòng ${i + 1}. Phải là số nguyên.');
          }

          int age = int.tryParse(row[ageIndex].toString()) ?? 0;
          if (age < 15 || age > 22) {
            throw Exception(
                'Tuổi không hợp lệ ở dòng ${i + 1}. Phải từ 15-22.');
          }

          for (var index in [g1Index, g2Index, g3Index]) {
            int grade = int.tryParse(row[index].toString()) ?? -1;
            if (grade < 0 || grade > 20) {
              throw Exception(
                  'Điểm số không hợp lệ ở dòng ${i + 1}. Phải từ 0-20.');
            }
          }
        }

        _processedData = rowsAsListOfValues;

        setState(() {
          _isProcessing = false;
          _isProcessingComplete = true;
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Xử lý file CSV thành công!'),
            backgroundColor:const Color(0xFF34C759),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 500, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      } else {
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
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

  Future<void> _downloadProcessedCSV() async {
    if (_processedData == null) return;

    try {
      final csvData = const ListToCsvConverter().convert(_processedData!);

      if (kIsWeb) {
        WebDownloadHelper.downloadFile(csvData, 'processed_students.csv');
      } else {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Chọn nơi lưu file',
          fileName: 'processed_students.csv',
          type: FileType.custom,
          allowedExtensions: ['csv'],
        );

        if (outputFile == null) return;
        
        final file = File(outputFile);
        await file.writeAsString(csvData);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('File đã được lưu thành công!'),
          backgroundColor: const Color(0xFF34C759),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 500, vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lưu file: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 500, vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2969FF).withOpacity(0.2),
                  width: 6,
                ),
              ),
              child: Center(
                child: Container(
                  height: 54,
                  width: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2969FF),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Nhập liệu từ file CSV',
            style: TextStyle(
              color: Color(0xFF2969FF),
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF1F9FF),
                  Colors.white,
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(150.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Container(
                          width: 493,
                          height: 240,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Tải lên file CSV của bạn',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:  Color(0xFF2969FF),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Hãy chọn file CSV chứa dữ liệu học sinh để phân tích',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2969FF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFF2969FF).withOpacity(0.1),
                                    width: 8,
                                  ),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed:
                                      _isProcessing ? null : _pickAndProcessCSV,
                                  icon: const Icon(
                                    Icons.upload_file,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Chọn file CSV',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Fz Poppins',
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2969FF),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_isProcessing)
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11.78),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(24), 
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2969FF),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Đang xử lý dữ liệu...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF2969FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (_isProcessingComplete)
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Container(
                            width: 493,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF34C759),
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Xử lý hoàn tất!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF34C759),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFF2969FF)
                                          .withOpacity(0.1),
                                      width: 8,
                                    ),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: _downloadProcessedCSV,
                                    icon: const Icon(Icons.download),
                                    label: const Text(
                                      'Tải file CSV đã xử lý',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Fz Poppins',
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF34C759),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 24,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18),
                                      ),
                                      side: BorderSide(
                                        color: const Color(0xFF34C759)
                                            .withOpacity(0.1), // Viền mờ
                                        width: 8, // Độ dày viền
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
}

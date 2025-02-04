import 'package:app/Provider/dang_ky_email_provider.dart';
import 'package:app/Provider/gui_data_provider.dart';
import 'package:app/Services/dang_ky_email_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDateOfBirth extends StatefulWidget {
  const CreateDateOfBirth({super.key});

  @override
  State<CreateDateOfBirth> createState() => _MyCreateDateOfBirthState();
}

class _MyCreateDateOfBirthState extends State<CreateDateOfBirth> {
  DateTime selectedDate = DateTime.now();
  late int yearNow = DateTime.now().year;
  int? ageUser;
  bool isButtonEnabled = false;
  bool isCheckAge = false;
  String? dateErrorText;
  Color colorDate = Colors.grey;
  TextEditingController dateController =
      TextEditingController(text: 'Ngày sinh');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DangKyEmailProvider>(context);
    final myData = Provider.of<MyData>(context);
    DangKyEmailService dangKyEmailService = DangKyEmailService();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Đăng ký',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: const Column(
                      children: [
                        Text(
                          'Ngày sinh của bạn là ngày nào?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ngày sinh của bạn sẽ không được \nhiển thị công khai?',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/3004/3004659.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              TextField(
                enabled: false,
                controller: dateController,
                style: TextStyle(
                  // Tùy chỉnh kiểu dáng cho nội dung trong TextField
                  color: colorDate, // Màu chữ
                  fontSize: 18.0, // Kích thước chữ
                  fontWeight: FontWeight.bold, // Độ đậm của chữ
                ),
                decoration: InputDecoration(
                  errorStyle:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  errorText: dateErrorText = isCheckAge == true
                      ? null
                      : 'Bạn chưa đủ tuổi để tham gia ứng dụng!!!',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isCheckAge
                    ? () async {
                        String dayOfBirth = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                        final result = await dangKyEmailService.dangKyBangEmail(
                          myData.email,
                          myData.password,
                          ageUser!,
                          dayOfBirth
                        );
                        if (result == null) {
                          // Đăng ký thành công, bạn có thể thực hiện các hành động sau đăng ký ở đây
                          // Ví dụ: Điều hướng người dùng đến màn hình chính của ứng dụng
                        } else {

                          // Đăng ký thất bại, hiển thị thông báo lỗi cho người dùng
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: $result'),
                            ),
                          );
                        }
                      }
                    : null, // Vô hiệu hóa nút nếu ô input rỗng
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // Đường viền cong
                  ),
                  backgroundColor: isButtonEnabled
                      ? Colors
                          .pinkAccent // Màu nền của nút khi có dữ liệu trong ô input
                      : const Color.fromARGB(255, 219, 219,
                          219), // Màu nền của nút khi ô input rỗng
                  minimumSize: const Size(500, 50), // Kích thước nút
                ),
                child: const Text(
                  'Tiếp',
                  style: TextStyle(
                    color: Colors.white, // Màu chữ
                    fontSize: 18.0, // Kích thước chữ
                  ),
                ),
              ),
              const SizedBox(height: 180),
              Container(
                height: 300, // Hoặc kích thước cố định khác tùy bạn chọn
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = newDate;
                      String dateChosse =
                          'ngày ${selectedDate.day} tháng ${selectedDate.month}, ${selectedDate.year}';
                      dateController.text = dateChosse;
                      colorDate = Colors.black;
                      isButtonEnabled = true;

                      isCheckAge =
                          yearNow - selectedDate.year >= 16 ? true : false;
                      ageUser = yearNow - selectedDate.year;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // FUCK THUY
  }
}

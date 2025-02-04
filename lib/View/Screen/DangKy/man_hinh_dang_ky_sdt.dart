import 'package:app/View/Widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';
import '../../../Provider/dang_ky_sdt_provider.dart';

class ManHinhDangKySDT extends StatefulWidget {
  @override
  State<ManHinhDangKySDT> createState() => _ManHinhDangKySDTState();
}

class _ManHinhDangKySDTState extends State<ManHinhDangKySDT> {
  late DangKySdtProvider provider =
      Provider.of<DangKySdtProvider>(context);


  @override
  void dispose() {
    // TODO: implement dispose
    provider.isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(

      children: [
        Container(
          height: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                PhoneFormField(
                  defaultCountry: IsoCode.VN,
                  // default
                  cursorColor: Colors.grey,
                  decoration: const InputDecoration(
                    hintText: 'Số điện thoại',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Màu đường viền khi focus
                    ),
                  ),
                  validator: PhoneValidator.compose([
                    PhoneValidator.valid(errorText: "Không đúng định dạng"),
                    PhoneValidator.required(errorText: "Không được để trống"),
                  ]),
                  countrySelectorNavigator:
                      const CountrySelectorNavigator.draggableBottomSheet(),
                  onChanged: (p) {
                    provider.changePhone(p!.nsn.toString());
                  }, // default null
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        provider.changeChecked(!provider.isChecked);
                      },
                      child: Container(
                        width: 18,
                        // Điều chỉnh kích thước của hình tròn
                        height: 18,
                        // Điều chỉnh kích thước của hình tròn
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Để tạo hình tròn
                          border: Border.all(
                              color: Colors.grey,
                              width: 2 // Màu đường viền khi không được chọn
                              ),
                          color: provider.isChecked
                              ? Colors.grey
                              : Colors.transparent, // Màu nền khi được chọn
                        ),
                        child: provider.isChecked
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors
                                    .white, // Màu của biểu tượng kiểm tra khi được chọn
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Lưu thông tin đăng nhập',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              provider.phone.length < 1
                                  ? Colors.black12
                                  : Colors.pinkAccent)),
                      onPressed: provider.phone.length < 1
                          ? null
                          : () {
                              provider.dangKyPhone(context);
                            },
                      child: const Text(
                        'Gửi mã',
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: provider.isPhoneNumberCheck,
                  // Ẩn hoặc hiển thị dựa trên giá trị của isTextVisible
                  child: Text(
                    '${provider.message}',
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: provider.isLoading),
      ],
    ));
  }
}

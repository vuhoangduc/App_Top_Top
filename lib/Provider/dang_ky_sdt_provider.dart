import 'package:app/Services/dang_ky_sdt_service.dart';
import 'package:app/View/Screen/DangKy/man_hinh_dang_ky_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DangKySdtProvider extends ChangeNotifier{
  bool isPhoneNumberCheck= false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isChecked = false;
  String phone = '';
  String error = '';
  bool isLoading = false;
  String verificationId = '';
  bool isCheckOtp = false;
  String smsCode = '';
  String message = '';

  void changeChecked(bool check){
    isChecked = check;
    notifyListeners();
  }

  void setMessage(String s){
    message = s;
    notifyListeners();
  }

  void setSmsCode(String s){
    smsCode = s;
    notifyListeners();
  }

  void changCheckOTP(bool check){
    isCheckOtp = check;
    notifyListeners();
  }

  void changePhone(String phone){
    this.phone = phone;
    notifyListeners();
  }

  void changeLoading(bool loading){
    this.isLoading = loading;
    notifyListeners();
  }


  void changePhoneNumberCheck(bool isPhoneNumberCheck){
    this.isPhoneNumberCheck = isPhoneNumberCheck;
    notifyListeners();
  }

  Future<void> dangKyPhone(BuildContext context) async {
    changeLoading(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84$phone',
      verificationCompleted: (PhoneAuthCredential credential) { },
      verificationFailed: (FirebaseAuthException e) {
        setMessage('Lỗi. Thử lại!');
        changePhoneNumberCheck(true);
        changeLoading(false);
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        changeLoading(false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManHinhDangKyOTP())
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP(BuildContext context,String otp) async {
    try {
      changeLoading(true);
      // Tạo một PhoneAuthCredential từ OTP và verificationId
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      // Xác minh OTP và đăng nhập người dùng
      UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
      DangKySdtService service = DangKySdtService();
      bool check = await service.KiemTraDangKySdt(authResult,phone);
      if(check){
        setMessage('Số điện thoại đã được đăng ký');
        changCheckOTP(true);
        changeLoading(false);
      }else{
        print('vào đây ===========2');
        // đăng ký thành công và chuyển sang màn hình home()
        changCheckOTP(false);
        changeLoading(false);
      }

      // Đăng nhập thành công, bạn có thể thực hiện các hành động sau đây.
    } catch (e) {
      changeLoading(false);
      changCheckOTP(true);
      setMessage('Xác minh OTP thất bại!');
    }
  }

  void guiLaiMaOTP(BuildContext context){
    dangKyPhone(context);
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  //TODO: Implement NewPasswordController
  TextEditingController newPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async{
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        try {
          
        String email = auth.currentUser!.email!;

        await auth.currentUser!.updatePassword(newPassC.text);

        await auth.signOut();

        await auth.signInWithEmailAndPassword(
          email: email, 
          password: newPassC.text
        );

        Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi Kesalahan", "Password harus lebih dari 6 karakter");
          }
        } catch (e){
            Get.snackbar("Terjadi Kesalahan", "Tidak dapat membuat password baru, hubungi Admin atau Customer Service");
        }
      }else{
        Get.snackbar("Terjadi Kesalahan", "Password baru harus diubah");
      }
    }else{
        Get.snackbar("Terjadi Kesalahan", "Password baru wajib diisi");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async{
    isLoading.value = true;
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      //eksekusi
     try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );
      // print(userCredential);

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified == true) {
          isLoading.value = false;
          //jika dia masih memiliki password = "password" maka akan diarahkan ke halaman new_password
          if (passC.text == "password") {
            Get.offAllNamed(Routes.NEW_PASSWORD);
          }else{
            Get.offAllNamed(Routes.HOME);
          }
        }else {
          Get.defaultDialog(
            title: "Belum Verifikasi",
            middleText: "Kamu belum verifikasi akun ini. Lakukan verifikasi terlebih dahulu",
            actions: [
              OutlinedButton(
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                }, 
                child: Text("Cancel"),
              ),
              //untuk mengirim ulang email verifikasi apabila user tidak sengaja menghapus verifikasi
              ElevatedButton(onPressed: () async{
                try {
                    await userCredential.user!.sendEmailVerification();
                    Get.back();
                    Get.snackbar("Berhasil", "Kami telah mengirim ulang verifikasi ke akun Email anda.");
                    isLoading.value = false;
                } catch (e) {
                    isLoading.value = false;
                    Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengirim email verifikasi. Hubungi Admin atau Customer Service.");
                }
              }, 
              child: Text("Kirim Ulang")
              ),
            ]
          );
        }
      }
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar!");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Password tidak terdaftar!");
        }
      }catch(e){
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat login.");
      }
    }else{
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib diisi!");
    }
  }
}

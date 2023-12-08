import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    // pageIndex.value = i;
      switch (i) {
        case 1:
        print("ABSENSI");
        Map<String, dynamic> dataResponse = await determinePosition();
        if(dataResponse["error"] != true){
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
          //masih belum fix karena terkadang nama jalan jadi symbol maps
          // print(placemarks);
          String address = "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].subLocality}";
          await updatePosition(position, address);

          //cek distance between 2 position
          // posisi UNIMED gedung jurusan
          double distance = Geolocator.distanceBetween(3.6100597,98.713148, position.latitude, position.longitude);

          //presensi
          await presensi(position, address, distance);

          // Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir.");
        }else {
          Get.snackbar("Terjadi kesalahan", dataResponse["message"]);
        }
          break;
        case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
          break;
        default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
      }

  }

  Future<void> presensi(Position position, String address, double distance) async{
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence = await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresence =  await colPresence.get();
    // print(snapPresence.docs.length);
    DateTime now = DateTime.now();
    String todayDocID = (DateFormat.yMd().format(now)).replaceAll("/", "-");

    // print(todayDocID);

    //default di luar area
    String status = "Di luar area";
    
    //area unimed
    if (distance <= 30) {
      // didalam area // per meter
      status = "Di dalam area";
    }

    if (snapPresence.docs.length == 0) {
      //belum pernah absen & set absen masuk pertama kali

      await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText: "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(), 
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () async{
              await colPresence.doc(todayDocID).set({
              "date": now.toIso8601String(),
              "masuk": {
                "date" : now.toIso8601String(),
                "lat" : position.latitude,
                "long" : position.longitude,
                "address" : address,
                "status" : status,
                "distance": distance,
              }
            });
            Get.back();
            Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir (MASUK).");
            }, 
            child: Text("YES"),
          ),
        ],
      );
    } else {
      // sudah pernah absen, tinggal cek sudah absen masuk/keluar 
      DocumentSnapshot<Map<String, dynamic>> todayDoc = await colPresence.doc(todayDocID).get();
      // print(todayDoc.exists);

      if (todayDoc.exists == true) {
        // tinggal absen keluar atau sudah absen masuk dan keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();

        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk dan keluar
          Get.snackbar("PERHATIAN", "Kamu telah absen masuk & keluar, absen lagi besok.");
        }else {
          // absen keluar
          await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText: "Apakah kamu yakin akan mengisi daftar hadir (KELUAR) sekarang?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(), 
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () async{
               await colPresence.doc(todayDocID).update({
                "date": now.toIso8601String(),
                "keluar": {
                  "date" : now.toIso8601String(),
                  "lat" : position.latitude,
                  "long" : position.longitude,
                  "address" : address,
                  "status" : status,
                  }
              });
            Get.back();
            Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir (KELUAR).");
            }, 
            child: Text("YES"),
          ),
        ],
      );
         
        }

      } else {
        // absen masuk
        await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText: "Apakah kamu yakin akan mengisi daftar hadir (MASUK) sekarang?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(), 
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () async{
              await colPresence.doc(todayDocID).set({
              "date": now.toIso8601String(),
              "masuk": {
                "date" : now.toIso8601String(),
                "lat" : position.latitude,
                "long" : position.longitude,
                "address" : address,
                "status" : status,
            }
        });
            Get.back();
            Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir (MASUK).");
            }, 
            child: Text("YES"),
          ),
        ],
      );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection("pegawai").doc(uid).update({
      "position" : {
        "lat" : position.latitude,
        "long" : position.longitude,
      },
      "address": address,
    });

  }

  Future<Map<String,dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return {
          "message" : "Device tidak memiliki GPS",
          "error" : true,
        };
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
          return {
          "message" : "Izin menggunakan GPS ditolak!",
          "error" : true,
        };
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return {
        "message" : "Nyalakan akses lokasi di HP kamu!",
        "error" : true,
      };
      // return Future.error(
      //   'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "position" : position,
      "message" : "Berhasil mendapatkan posisi device",
      "error" : "false",
    };
  }
}

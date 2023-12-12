import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pegawai'),
         backgroundColor: Color(0xff3D9970),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nipC,
            decoration: InputDecoration(
              labelText: "NIP",
              labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: "Nama",
             labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.jobC,
            decoration: InputDecoration(
              labelText: "Job",
              labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: Color(0xff3D9970)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff3D9970))),
            ),
          ),
          SizedBox(height: 30),
          Obx(() => 
            ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3D9970), shape: StadiumBorder()),
              onPressed: () async{
                if (controller.isLoading.isFalse) {
                    await controller.addPegawai();
                  }
                }, 
              child: Text(controller.isLoading.isFalse ? "Tambah Pegawai" : "Loading..."),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cek_ongkir/app/data/models/ongkir_model.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkosKirim = [];
  RxBool isLoading = false.obs;
  RxString provAsalId = "0".obs;
  RxString kotaAsalId = "0".obs;
  RxString kotaTujuanId = "0".obs;
  RxString provTujuanId = "0".obs;
  RxString codeKurir = "".obs;

  void cekOngkir() async {
    if (provAsalId != "0" &&
        kotaAsalId != "0" &&
        kotaTujuanId != "0" &&
        provTujuanId != "0" &&
        codeKurir != "" &&
        beratC.text != "") {
      try {
        isLoading.value = true;
        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {
            "key": "78b30bfd2f04b4d513bf24300a580439",
            "content-type": "application/x-www-form-urlencoded"
          },
          body: {
            "origin": kotaAsalId.value,
            "destination": kotaTujuanId.value,
            "weight": beratC.text,
            "courier": codeKurir.value
          },
        );
        isLoading.value = false;
        List ongkir = json.decode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;
        ongkosKirim = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
          title: "ONGKOS KIRIM",
          content: Column(
            children: ongkosKirim
                .map(
                  (e) => ListTile(
                    title: Text("${e.service!.toUpperCase()}"),
                    subtitle: Text("Rp.${e.cost![0].value}"),
                  ),
                )
                .toList(),
          ),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak Dapat Mengecek Ongkir",
        );
      }
    }
  }
}

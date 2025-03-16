import 'dart:math';
import 'dart:typed_data';

import 'package:face_net_authentication/globals.dart';
import 'package:face_net_authentication/pages/MealSheet/mealsheet_const.dart';
import 'package:image/image.dart' as imglib;

String? classifyMealTime(DateTime dateTime) {
  // Mapping rentang waktu dalam format "HH:mm"
  final timeRanges = mealSheetSchedule;

  // Ambil jam dan menit dari DateTime
  String formattedTime =
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  DateTime inputTime = DateTime.parse("2025-01-01 $formattedTime:00");

  for (var entry in timeRanges.entries) {
    DateTime start = DateTime.parse("2025-01-01 ${entry.value[0]}:00");
    DateTime end = DateTime.parse("2025-01-01 ${entry.value[1]}:00");

    // Jika rentang waktu melewati tengah malam, atur tanggal akhir ke hari berikutnya
    if (entry.value[1] == "01:00") {
      end = end.add(Duration(days: 1));
    }

    // Cek apakah waktu masuk dalam rentang
    if (inputTime.isAfter(start) && inputTime.isBefore(end) ||
        inputTime.isAtSameMomentAs(start)) {
      return entry.key;
    }
  }

  return null;
}

int randomIndex(int length) {
  Random random = Random();
  int angkaRandom = random.nextInt(length);
  return angkaRandom;
}

Uint8List dummyFaceImage() {
  imglib.Image blackImage = imglib.Image(100, 100);

  // Mengisi gambar dengan warna hitam
  for (int y = 0; y < 100; y++) {
    for (int x = 0; x < 100; x++) {
      blackImage.setPixel(x, y, 0xFF000000); // Warna hitam (ARGB)
    }
  }
  return convertImagelibToUint8List(blackImage);
}

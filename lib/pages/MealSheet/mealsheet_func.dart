String classifyMealTime(DateTime dateTime) {
  // Mapping rentang waktu dalam format "HH:mm"
  final timeRanges = {
    "B_FAST": ["05:00", "07:00"],
    "LUNCH": ["07:01", "13:00"],
    "DINNER": ["13:01", "20:00"],
    "SUPPER": ["20:01", "01:00"]
  };

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

  return "OUT_OF_TIME";
}

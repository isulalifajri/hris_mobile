class TodayAttendanceModel {
  final String? clockIn;
  final String? clockOut;

  TodayAttendanceModel({
    this.clockIn,
    this.clockOut,
  });

  factory TodayAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceModel(
      clockIn: json['clock_in'],
      clockOut: json['clock_out'],
    );
  }

  bool get hasClockIn => clockIn != null;
  bool get hasClockOut => clockOut != null;
}

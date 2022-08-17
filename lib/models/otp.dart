class Otp {
  final String pin;
  Otp(this.pin);

  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(json['pin']);
  }
}

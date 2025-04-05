class VendorModel {
  final bool approved;
  final String bussinessName;
  final String cityValue;
  final String stateValue;
  final String countryValue;
  final String vendorId;
  final String storeImage;
  final String emailAddress;

  VendorModel(
      {required this.approved,
      required this.bussinessName,
      required this.cityValue,
      required this.stateValue,
      required this.countryValue,
      required this.vendorId,
      required this.emailAddress,
      required this.storeImage});

  VendorModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          bussinessName: json['businessName']! as String,
          cityValue: json['cityValue']! as String,
          stateValue: json['stateValue']! as String,
          countryValue: json['countryValue']! as String,
          vendorId: json['vendorId']! as String,
          storeImage: json['storeImage']! as String,
          emailAddress: json['emailAddress']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'bussinessName': bussinessName,
      'cityValue': cityValue,
      'stateValue': stateValue,
      'countryValue': countryValue,
      'vendorId': vendorId,
      'storeImage': storeImage,
      'emailAddress': emailAddress,
    };
  }
}

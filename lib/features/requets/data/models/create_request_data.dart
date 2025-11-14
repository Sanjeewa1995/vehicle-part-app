class CreateRequestData {
  final String vehicleType;
  final String vehicleModel;
  final int vehicleYear;
  final String province;
  final String partName;
  final String? partNumber;
  final String description;
  final String? vehicleImagePath;
  final String? partImagePath;
  final String? partVideoPath;

  CreateRequestData({
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.province,
    required this.partName,
    this.partNumber,
    required this.description,
    this.vehicleImagePath,
    this.partImagePath,
    this.partVideoPath,
  });
}


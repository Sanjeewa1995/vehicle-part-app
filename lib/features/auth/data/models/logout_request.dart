import 'package:json_annotation/json_annotation.dart';

part 'logout_request.g.dart';

@JsonSerializable()
class LogoutRequest {
  final String refresh;

  LogoutRequest({required this.refresh});

  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
}


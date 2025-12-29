import 'package:json_annotation/json_annotation.dart';

part 'delete_account_request.g.dart';

@JsonSerializable()
class DeleteAccountRequest {
  final String password;
  @JsonKey(name: 'refresh')
  final String? refresh;

  DeleteAccountRequest({
    required this.password,
    this.refresh,
  });

  Map<String, dynamic> toJson() => _$DeleteAccountRequestToJson(this);

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestFromJson(json);
}



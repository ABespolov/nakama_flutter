// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apigrpc.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiAccountDeviceColyseus _$ApiAccountDeviceColyseusFromJson(
    Map<String, dynamic> json) {
  return ApiAccountDeviceColyseus(
    deviceId: json['deviceId'] as String?,
    username: json['username'] as String?,
  );
}

Map<String, dynamic> _$ApiAccountDeviceColyseusToJson(
        ApiAccountDeviceColyseus instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'username': instance.username,
    };

ApiSessionColyseus _$ApiSessionColyseusFromJson(Map<String, dynamic> json) {
  return ApiSessionColyseus(
    status: json['status'] as bool?,
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : ApiSessionColyseus$Data.fromJson(
            json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ApiSessionColyseusToJson(ApiSessionColyseus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

ApiJoinOrCreateMatch _$ApiJoinOrCreateMatchFromJson(Map<String, dynamic> json) {
  return ApiJoinOrCreateMatch(
    room: json['room'] == null
        ? null
        : ApiJoinOrCreateMatch$Room.fromJson(
            json['room'] as Map<String, dynamic>),
    sessionId: json['sessionId'] as String?,
  );
}

Map<String, dynamic> _$ApiJoinOrCreateMatchToJson(
        ApiJoinOrCreateMatch instance) =>
    <String, dynamic>{
      'room': instance.room?.toJson(),
      'sessionId': instance.sessionId,
    };

ApiSessionRefreshRequest _$ApiSessionRefreshRequestFromJson(
    Map<String, dynamic> json) {
  return ApiSessionRefreshRequest(
    refreshToken: json['refreshToken'] as String?,
  );
}

Map<String, dynamic> _$ApiSessionRefreshRequestToJson(
        ApiSessionRefreshRequest instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

ApiJoinOrCreateMatchRequest _$ApiJoinOrCreateMatchRequestFromJson(
    Map<String, dynamic> json) {
  return ApiJoinOrCreateMatchRequest(
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$ApiJoinOrCreateMatchRequestToJson(
        ApiJoinOrCreateMatchRequest instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

ProtobufAny _$ProtobufAnyFromJson(Map<String, dynamic> json) {
  return ProtobufAny(
    typeUrl: json['typeUrl'] as String?,
    value: json['value'] as String?,
  );
}

Map<String, dynamic> _$ProtobufAnyToJson(ProtobufAny instance) =>
    <String, dynamic>{
      'typeUrl': instance.typeUrl,
      'value': instance.value,
    };

RpcStatus _$RpcStatusFromJson(Map<String, dynamic> json) {
  return RpcStatus(
    code: json['code'] as int?,
    message: json['message'] as String?,
    details: (json['details'] as List<dynamic>?)
            ?.map((e) => ProtobufAny.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$RpcStatusToJson(RpcStatus instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details?.map((e) => e.toJson()).toList(),
    };

ApiSessionColyseus$Data _$ApiSessionColyseus$DataFromJson(
    Map<String, dynamic> json) {
  return ApiSessionColyseus$Data(
    token: json['token'] as String?,
    expiresAt: json['expires_at'] as String?,
    refreshToken: json['refresh_token'] as String?,
    refreshExpiresAt: json['refresh_expires_at'] as String?,
    userUuid: json['user_uuid'] as String?,
  );
}

Map<String, dynamic> _$ApiSessionColyseus$DataToJson(
        ApiSessionColyseus$Data instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expires_at': instance.expiresAt,
      'refresh_token': instance.refreshToken,
      'refresh_expires_at': instance.refreshExpiresAt,
      'user_uuid': instance.userUuid,
    };

ApiJoinOrCreateMatch$Room _$ApiJoinOrCreateMatch$RoomFromJson(
    Map<String, dynamic> json) {
  return ApiJoinOrCreateMatch$Room(
    roomId: json['roomId'] as String?,
    processId: json['processId'] as String?,
  );
}

Map<String, dynamic> _$ApiJoinOrCreateMatch$RoomToJson(
        ApiJoinOrCreateMatch$Room instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'processId': instance.processId,
    };

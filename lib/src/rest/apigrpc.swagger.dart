import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

import 'package:chopper/chopper.dart';
import 'package:chopper/chopper.dart' as chopper;

part 'apigrpc.swagger.chopper.dart';
part 'apigrpc.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Apigrpc extends ChopperService {
  static Apigrpc create([ChopperClient? client]) {
    if (client != null) {
      return _$Apigrpc(client);
    }

    final newClient = ChopperClient(
        services: [_$Apigrpc()],
        converter: JsonSerializableConverter(),
        baseUrl: 'https://127.0.0.1:7350');
    return _$Apigrpc(newClient);
  }

  ///A healthcheck which load balancers can use to check the service.

  @Get(path: '/healthcheck')
  Future<chopper.Response> nakamaHealthcheck();

  ///Authenticate a user with a device id against the server.
  ///@param body The device account details.

  @Post(path: '/auth/signin/device')
  Future<chopper.Response<ApiSessionColyseus>> colyseusAuthenticateDevice(
      {@Body() @required ApiAccountDeviceColyseus? body});
}

final Map<Type, Object Function(Map<String, dynamic>)>
    ApigrpcJsonDecoderMappings = {
  GetMatch: GetMatch.fromJsonFactory,
  ApiAccountDeviceColyseus: ApiAccountDeviceColyseus.fromJsonFactory,
  ApiSessionColyseus: ApiSessionColyseus.fromJsonFactory,
  ProtobufAny: ProtobufAny.fromJsonFactory,
  RpcStatus: RpcStatus.fromJsonFactory,
};

@JsonSerializable(explicitToJson: true)
class GetMatch {
  GetMatch({
    this.payload,
  });

  factory GetMatch.fromJson(Map<String, dynamic> json) =>
      _$GetMatchFromJson(json);

  @JsonKey(name: 'payload', includeIfNull: true)
  final String? payload;
  static const fromJsonFactory = _$GetMatchFromJson;
  static const toJsonFactory = _$GetMatchToJson;
  Map<String, dynamic> toJson() => _$GetMatchToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is GetMatch &&
            (identical(other.payload, payload) ||
                const DeepCollectionEquality().equals(other.payload, payload)));
  }
}

extension $GetMatchExtension on GetMatch {
  GetMatch copyWith({String? payload}) {
    return GetMatch(payload: payload ?? this.payload);
  }
}

@JsonSerializable(explicitToJson: true)
class ApiAccountDeviceColyseus {
  ApiAccountDeviceColyseus({
    this.deviceId,
    this.username,
  });

  factory ApiAccountDeviceColyseus.fromJson(Map<String, dynamic> json) =>
      _$ApiAccountDeviceColyseusFromJson(json);

  @JsonKey(name: 'deviceId', includeIfNull: true)
  final String? deviceId;
  @JsonKey(name: 'username', includeIfNull: true)
  final String? username;
  static const fromJsonFactory = _$ApiAccountDeviceColyseusFromJson;
  static const toJsonFactory = _$ApiAccountDeviceColyseusToJson;
  Map<String, dynamic> toJson() => _$ApiAccountDeviceColyseusToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ApiAccountDeviceColyseus &&
            (identical(other.deviceId, deviceId) ||
                const DeepCollectionEquality()
                    .equals(other.deviceId, deviceId)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)));
  }
}

extension $ApiAccountDeviceColyseusExtension on ApiAccountDeviceColyseus {
  ApiAccountDeviceColyseus copyWith({String? deviceId, String? username}) {
    return ApiAccountDeviceColyseus(
        deviceId: deviceId ?? this.deviceId,
        username: username ?? this.username);
  }
}

@JsonSerializable(explicitToJson: true)
class ApiSessionColyseus {
  ApiSessionColyseus({
    this.status,
    this.message,
    this.data,
  });

  factory ApiSessionColyseus.fromJson(Map<String, dynamic> json) =>
      _$ApiSessionColyseusFromJson(json);

  @JsonKey(name: 'status', includeIfNull: true)
  final bool? status;
  @JsonKey(name: 'message', includeIfNull: true)
  final String? message;
  @JsonKey(name: 'data', includeIfNull: true)
  final ApiSessionColyseus$Data? data;
  static const fromJsonFactory = _$ApiSessionColyseusFromJson;
  static const toJsonFactory = _$ApiSessionColyseusToJson;
  Map<String, dynamic> toJson() => _$ApiSessionColyseusToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ApiSessionColyseus &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }
}

extension $ApiSessionColyseusExtension on ApiSessionColyseus {
  ApiSessionColyseus copyWith(
      {bool? status, String? message, ApiSessionColyseus$Data? data}) {
    return ApiSessionColyseus(
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data);
  }
}

@JsonSerializable(explicitToJson: true)
class ProtobufAny {
  ProtobufAny({
    this.typeUrl,
    this.value,
  });

  factory ProtobufAny.fromJson(Map<String, dynamic> json) =>
      _$ProtobufAnyFromJson(json);

  @JsonKey(name: 'typeUrl', includeIfNull: true)
  final String? typeUrl;
  @JsonKey(name: 'value', includeIfNull: true)
  final String? value;
  static const fromJsonFactory = _$ProtobufAnyFromJson;
  static const toJsonFactory = _$ProtobufAnyToJson;
  Map<String, dynamic> toJson() => _$ProtobufAnyToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ProtobufAny &&
            (identical(other.typeUrl, typeUrl) ||
                const DeepCollectionEquality()
                    .equals(other.typeUrl, typeUrl)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }
}

extension $ProtobufAnyExtension on ProtobufAny {
  ProtobufAny copyWith({String? typeUrl, String? value}) {
    return ProtobufAny(
        typeUrl: typeUrl ?? this.typeUrl, value: value ?? this.value);
  }
}

@JsonSerializable(explicitToJson: true)
class RpcStatus {
  RpcStatus({
    this.code,
    this.message,
    this.details,
  });

  factory RpcStatus.fromJson(Map<String, dynamic> json) =>
      _$RpcStatusFromJson(json);

  @JsonKey(name: 'code', includeIfNull: true)
  final int? code;
  @JsonKey(name: 'message', includeIfNull: true)
  final String? message;
  @JsonKey(name: 'details', includeIfNull: true, defaultValue: <ProtobufAny>[])
  final List<ProtobufAny>? details;
  static const fromJsonFactory = _$RpcStatusFromJson;
  static const toJsonFactory = _$RpcStatusToJson;
  Map<String, dynamic> toJson() => _$RpcStatusToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is RpcStatus &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality()
                    .equals(other.message, message)) &&
            (identical(other.details, details) ||
                const DeepCollectionEquality().equals(other.details, details)));
  }
}

extension $RpcStatusExtension on RpcStatus {
  RpcStatus copyWith({int? code, String? message, List<ProtobufAny>? details}) {
    return RpcStatus(
        code: code ?? this.code,
        message: message ?? this.message,
        details: details ?? this.details);
  }
}

@JsonSerializable(explicitToJson: true)
class ApiSessionColyseus$Data {
  ApiSessionColyseus$Data({
    this.token,
    this.expiresAt,
    this.refreshToken,
    this.refreshExpiresAt,
  });

  factory ApiSessionColyseus$Data.fromJson(Map<String, dynamic> json) =>
      _$ApiSessionColyseus$DataFromJson(json);

  @JsonKey(name: 'token', includeIfNull: true)
  final String? token;
  @JsonKey(name: 'expires_at', includeIfNull: true)
  final String? expiresAt;
  @JsonKey(name: 'refresh_token', includeIfNull: true)
  final String? refreshToken;
  @JsonKey(name: 'refresh_expires_at', includeIfNull: true)
  final String? refreshExpiresAt;
  static const fromJsonFactory = _$ApiSessionColyseus$DataFromJson;
  static const toJsonFactory = _$ApiSessionColyseus$DataToJson;
  Map<String, dynamic> toJson() => _$ApiSessionColyseus$DataToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ApiSessionColyseus$Data &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.expiresAt, expiresAt) ||
                const DeepCollectionEquality()
                    .equals(other.expiresAt, expiresAt)) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality()
                    .equals(other.refreshToken, refreshToken)) &&
            (identical(other.refreshExpiresAt, refreshExpiresAt) ||
                const DeepCollectionEquality()
                    .equals(other.refreshExpiresAt, refreshExpiresAt)));
  }
}

extension $ApiSessionColyseus$DataExtension on ApiSessionColyseus$Data {
  ApiSessionColyseus$Data copyWith(
      {String? token,
      String? expiresAt,
      String? refreshToken,
      String? refreshExpiresAt}) {
    return ApiSessionColyseus$Data(
        token: token ?? this.token,
        expiresAt: expiresAt ?? this.expiresAt,
        refreshToken: refreshToken ?? this.refreshToken,
        refreshExpiresAt: refreshExpiresAt ?? this.refreshExpiresAt);
  }
}

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class CustomJsonDecoder {
  CustomJsonDecoder(this.factories);

  final Map<Type, JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class JsonSerializableConverter extends chopper.JsonConverter {
  @override
  chopper.Response<ResultType> convertResponse<ResultType, Item>(
      chopper.Response response) {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    final jsonRes = super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final jsonDecoder = CustomJsonDecoder(ApigrpcJsonDecoderMappings);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

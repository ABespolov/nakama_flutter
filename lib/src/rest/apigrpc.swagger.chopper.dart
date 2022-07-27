// Generated code

part of 'apigrpc.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$Apigrpc extends Apigrpc {
  _$Apigrpc([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = Apigrpc;

  @override
  Future<Response<dynamic>> nakamaHealthcheck() {
    final $url = '/healthcheck';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ApiSessionColyseus>> colyseusAuthenticateDevice(
      {ApiAccountDeviceColyseus? body}) {
    final $url = '/auth/signin/device';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiSessionColyseus, ApiSessionColyseus>($request);
  }
}

///
//  Generated code. Do not modify.
//  source: github.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'github.pb.dart' as $0;
export 'github.pb.dart';

class GitHubRouteClient extends $grpc.Client {
  static final _$getListError = $grpc.ClientMethod<$0.Integer, $0.Integer>(
      '/github.GitHubRoute/getListError',
      ($0.Integer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Integer.fromBuffer(value));
  static final _$listFeatures = $grpc.ClientMethod<$0.Integer, $0.Integer>(
      '/github.GitHubRoute/listFeatures',
      ($0.Integer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Integer.fromBuffer(value));
  static final _$recordRoute = $grpc.ClientMethod<$0.Integer, $0.Integer>(
      '/github.GitHubRoute/RecordRoute',
      ($0.Integer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Integer.fromBuffer(value));

  GitHubRouteClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Integer> getListError($0.Integer request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getListError, request, options: options);
  }

  $grpc.ResponseFuture<$0.Integer> listFeatures($0.Integer request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listFeatures, request, options: options);
  }

  $grpc.ResponseFuture<$0.Integer> recordRoute($0.Integer request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$recordRoute, request, options: options);
  }
}

abstract class GitHubRouteServiceBase extends $grpc.Service {
  $core.String get $name => 'github.GitHubRoute';

  GitHubRouteServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Integer, $0.Integer>(
        'getListError',
        getListError_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Integer.fromBuffer(value),
        ($0.Integer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Integer, $0.Integer>(
        'listFeatures',
        listFeatures_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Integer.fromBuffer(value),
        ($0.Integer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Integer, $0.Integer>(
        'RecordRoute',
        recordRoute_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Integer.fromBuffer(value),
        ($0.Integer value) => value.writeToBuffer()));
  }

  $async.Future<$0.Integer> getListError_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Integer> request) async {
    return getListError(call, await request);
  }

  $async.Future<$0.Integer> listFeatures_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Integer> request) async {
    return listFeatures(call, await request);
  }

  $async.Future<$0.Integer> recordRoute_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Integer> request) async {
    return recordRoute(call, await request);
  }

  $async.Future<$0.Integer> getListError(
      $grpc.ServiceCall call, $0.Integer request);
  $async.Future<$0.Integer> listFeatures(
      $grpc.ServiceCall call, $0.Integer request);
  $async.Future<$0.Integer> recordRoute(
      $grpc.ServiceCall call, $0.Integer request);
}

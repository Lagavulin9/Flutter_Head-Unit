import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

// final class InfoStruct extends Struct {
//   @Double()
//   external double vol;
//   @Double()
//   external double cur;
//   @Double()
//   external double pwr;
//   @Double()
//   external double bat;
// }

class CommonAPI {
  static final CommonAPI _instance = CommonAPI._privateConstructor();
  late final DynamicLibrary libffi;
  late final Function _init;
  // late final Function _subscribeSpeed;
  late final Function _subscribeControl;
  // late final Function _subscribeInfo;
  // late final Function getSpeed;
  late final Function _getGearUtf8;
  late final Function _setGear;
  // late final Function _getIndicatorUtf8;
  // late final Function getInfo;
  late final Function _setLightMode;
  late final Function _setUnit;
  late final Function _setMetaData;

  bool _initializeFFI() {
    libffi = DynamicLibrary.open("libHeadUnit-someip.so");
    _init = libffi
        .lookup<NativeFunction<Void Function()>>('init')
        .asFunction<void Function()>();
    // _subscribeSpeed = libffi
    //     .lookup<NativeFunction<Void Function()>>('subscribe_speed')
    //     .asFunction<void Function()>();
    _subscribeControl = libffi
        .lookup<NativeFunction<Void Function()>>('subscribe_control')
        .asFunction<void Function()>();
    // _subscribeInfo = libffi
    //     .lookup<NativeFunction<Void Function()>>('subscribe_info')
    //     .asFunction<void Function()>();
    // getSpeed = libffi
    //     .lookup<NativeFunction<Int32 Function()>>('getSpeed')
    //     .asFunction<int Function()>();
    _getGearUtf8 = libffi
        .lookup<NativeFunction<Pointer<Utf8> Function()>>('getGear')
        .asFunction<Pointer<Utf8> Function()>();
    _setGear = libffi
        .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('setGear')
        .asFunction<void Function(Pointer<Utf8>)>();
    // _getIndicatorUtf8 = libffi
    //     .lookup<NativeFunction<Pointer<Utf8> Function()>>('getIndicator')
    //     .asFunction<Pointer<Utf8> Function()>();
    // getInfo = libffi
    //     .lookup<NativeFunction<InfoStruct Function()>>("getInfo")
    //     .asFunction<InfoStruct Function()>();
    _setLightMode = libffi
        .lookup<NativeFunction<Void Function(Bool)>>('setLightMode')
        .asFunction<void Function(bool)>();
    _setUnit = libffi
        .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('setUnit')
        .asFunction<void Function(Pointer<Utf8>)>();
    _setMetaData = libffi
        .lookup<
            NativeFunction<
                Void Function(Pointer<Uint8>, Int, Pointer<Utf8>,
                    Pointer<Utf8>)>>('setMetaData')
        .asFunction<
            void Function(Pointer<Uint8>, int, Pointer<Utf8>, Pointer<Utf8>)>();
    return true;
  }

  CommonAPI._privateConstructor() {
    _initializeFFI();
    _init();
    // _subscribeSpeed();
    _subscribeControl();
    // _subscribeInfo();
  }

  factory CommonAPI() {
    return _instance;
  }

  String getGear() {
    Pointer<Utf8> raw = _getGearUtf8();
    return raw.toDartString();
  }

  void setGear(String gear) {
    Pointer<Utf8> gear_ptr = gear.toNativeUtf8();
    _setGear(gear_ptr);
  }

  // String getIndicator() {
  //   Pointer<Utf8> raw = _getIndicatorUtf8();
  //   return raw.toDartString();
  // }

  void setLightMode(bool value) {
    _setLightMode(value);
  }

  void setUnit(String unit) {
    Pointer<Utf8> unit_ptr = unit.toNativeUtf8();
    _setUnit(unit_ptr);
  }

  void setMetaData(Uint8List image, String artist, String title) {
    Pointer<Uint8> uint8_ptr = malloc.allocate<Uint8>(image.length);
    for (int i = 0; i < image.length; i++) {
      uint8_ptr[i] = image[i];
    }
    _setMetaData(
        uint8_ptr, image.length, artist.toNativeUtf8(), title.toNativeUtf8());
    malloc.free(uint8_ptr);
    debugPrint("setMetaData called");
  }
}

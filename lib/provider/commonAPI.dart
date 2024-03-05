import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

final class SonarStruct extends Struct {
  @Uint32()
  external int left;
  @Uint32()
  external int middle;
  @Uint32()
  external int right;
}

class CommonAPI {
  static final CommonAPI _instance = CommonAPI._privateConstructor();
  late final DynamicLibrary libffi;
  late final Function _init;
  late final Function _subscribeControl;
  late final Function _subscribePDC;
  late final Function _getGearUtf8;
  late final Function _getSonar;
  late final Function _setGear;
  late final Function _setLightMode;
  late final Function _setUnit;
  late final Function _setMetaData;

  bool _initializeFFI() {
    libffi = DynamicLibrary.open("libHeadUnit-someip.so");
    _init = libffi
        .lookup<NativeFunction<Void Function()>>('init')
        .asFunction<void Function()>();
    _subscribeControl = libffi
        .lookup<NativeFunction<Void Function()>>('subscribe_control')
        .asFunction<void Function()>();
    _subscribePDC = libffi
        .lookup<NativeFunction<Void Function()>>('subscribe_pdc')
        .asFunction<void Function()>();
    _getGearUtf8 = libffi
        .lookup<NativeFunction<Pointer<Utf8> Function()>>('getGear')
        .asFunction<Pointer<Utf8> Function()>();
    _getSonar = libffi
        .lookup<NativeFunction<SonarStruct Function()>>('getSonar')
        .asFunction<SonarStruct Function()>();
    _setGear = libffi
        .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>('setGear')
        .asFunction<void Function(Pointer<Utf8>)>();
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
    _subscribeControl();
    _subscribePDC();
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

  SonarStruct getSonar() {
    return _getSonar();
  }
}

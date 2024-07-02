import 'dart:async';

import 'package:_9jahotel/core/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_splendid_ble/central/models/ble_characteristic.dart';
import 'package:flutter_splendid_ble/central/models/ble_characteristic_permission.dart';
import 'package:flutter_splendid_ble/central/models/ble_characteristic_value.dart';
import 'package:flutter_splendid_ble/central/models/ble_connection_state.dart';
import 'package:flutter_splendid_ble/central/models/ble_service.dart';
import 'package:flutter_splendid_ble/central/splendid_ble_central.dart';
import 'package:flutter_splendid_ble/shared/models/ble_device.dart';
import 'package:flutter_splendid_ble/shared/models/bluetooth_status.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothApp extends StatefulWidget {
  const BluetoothApp({super.key});

  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  final SplendidBleCentral _ble = SplendidBleCentral();
  StreamSubscription<BleDevice>? _scanStream;
  StreamSubscription<List<BleService>>? _servicesDiscoveredStream;
  StreamSubscription<BleCharacteristicValue>? _characteristicValueListener;
  List<BleDevice> discoveredDevices = [];
  BleCharacteristicValue? _characteristicValue;
  StreamSubscription<BleConnectionState>? _connectionStream;

  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _requestBluetoothPermission();
    _checkAdapterStatus();
  }

  Future<void> _requestBluetoothPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();

    if (statuses[Permission.bluetooth]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.bluetoothScan]!.isGranted) {
      debugPrint('Bluetooth permissions granted');
    } else {
      debugPrint('Bluetooth permissions denied');
    }
  }

  void _checkAdapterStatus() async {
    try {
      _ble.emitCurrentBluetoothStatus().listen((status) {
        // Handle Bluetooth status updates here
        if (status == BluetoothStatus.enabled) {
          startScan();
        } else {
          debugPrint('Bluetooth is off');
        }
      });
    } catch (e) {
      debugPrint('Unable to get Bluetooth status with exception, $e');
    }
  }

  void startScan() {
    _scanStream = _ble.startScan().listen(
          (device) => _onDeviceDetected(device),
      onError: (error) {
        _handleScanError(error);
      },
    );

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        stopScan();
      }
    });
  }

  void _onDeviceDetected(BleDevice device) {
    setState(() {
      if (!discoveredDevices.any((d) => d.address == device.address)) {
        discoveredDevices.add(device);
      }
    });
  }

  void stopScan() {
    _ble.stopScan();
    _scanStream?.cancel();
  }

  void _handleScanError(error) {
    final snackBar = SnackBar(
      content: Text('Error scanning for Bluetooth devices: $error'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  void connect(BleDevice device) {
    try {
      _ble.connect(deviceAddress: device.address).listen((state) {
        if (state == BleConnectionState.connected) {
          debugPrint('Connected to device: ${device.name}');
          discoverServices(device);
        }
        else if (state == BleConnectionState.connecting) {
          debugPrint('Connecting to device: ${device.name}');
        }
        else if (state == BleConnectionState.disconnected) {
          debugPrint('Disconnected from device: ${device.name}');
        }
      }, onError: (error) {
        debugPrint('Failed to connect to device ${device.address} with exception: $error');
      });
    } catch (e) {
      debugPrint('Failed to connect to device ${device.address} with exception: $e');
    }
  }

  void discoverServices(BleDevice device) {
    _servicesDiscoveredStream = _ble.discoverServices(device.address).listen(
          (services) {
        debugPrint('Discovered services for device: ${device.name}');
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            if (requiresPairing(characteristic)) {
              debugPrint('Characteristic ${characteristic.uuid} requires pairing');
            } else {
              _readCharacteristicValue(characteristic);
              subscribeToCharacteristic(characteristic);
            }
          }
        }
      },
      onError: (error) {
        debugPrint('Error discovering services for device ${device.address}: $error');
      },
    );
  }

  bool requiresPairing(BleCharacteristic characteristic) {
    bool? requiresPairingForRead = characteristic.permissions?.contains(BleCharacteristicPermission.readEncrypted);
    bool? requiresPairingForWrite = characteristic.permissions?.contains(BleCharacteristicPermission.writeEncrypted);
    bool? requiresPairingForReadMitm = characteristic.permissions?.contains(BleCharacteristicPermission.readEncryptedMitm);
    bool? requiresPairingForWriteMitm = characteristic.permissions?.contains(BleCharacteristicPermission.writeEncryptedMitm);

    return requiresPairingForRead == true ||
        requiresPairingForWrite == true ||
        requiresPairingForReadMitm == true ||
        requiresPairingForWriteMitm == true;
  }

  Future<void> _readCharacteristicValue(BleCharacteristic characteristic) async {
    try {
      BleCharacteristicValue characteristicValue = await characteristic.readValue<BleCharacteristicValue>();

      setState(() {
        _characteristicValue = characteristicValue;
      });
      debugPrint('Read value from characteristic ${characteristic.uuid}: ${characteristicValue.value}');
    } catch (e) {
      debugPrint('Failed to read characteristic value with exception: $e');
    }
  }

  void subscribeToCharacteristic(BleCharacteristic characteristic) {
    _characteristicValueListener = characteristic.subscribe().listen(
          (event) {
        debugPrint('Characteristic value changed for ${characteristic.uuid}: ${event.value}');
        // Handle characteristic value changes here
      },
      onError: (error) {
        debugPrint('Failed to subscribe to characteristic ${characteristic.uuid} with exception: $error');
      },
    );
  }

  @override
  void dispose() {
    stopScan();
    _servicesDiscoveredStream?.cancel();
    _characteristicValueListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffB02700),
        title: const Text('IOT Devices',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          const Gap(20),
          CustomButton(isLoading: isLoading.value, color: const Color(0xffEA5232), text: "Start Scan", onTap: startScan, borderRadius: 5,
            borderColor: const Color(0xffEA5232),
            textColor: Colors.white,),
          Expanded(
            child: ListView.builder(
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                final device = discoveredDevices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address),
                  onTap: () {
                    connect(device);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

/// Wraps `print_bluetooth_thermal` so the rest of the app never talks to the
/// plugin directly. Handles remembering the last-used printer (SharedPreferences)
/// and reconnecting automatically before a print job.
class PrinterService {
  PrinterService._internal();
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;

  static const _prefMac = 'printer_mac_address';
  static const _prefName = 'printer_name';

  static const EventChannel _scanChannel = EventChannel('com.nkrslanka.nkrs_app/bluetooth_scan');

  /// Start scanning for unpaired devices. Returns a stream of devices found.
  Stream<BluetoothInfo> startScan() {
    return _scanChannel.receiveBroadcastStream().map((event) {
      final data = Map<String, dynamic>.from(event);
      return BluetoothInfo(
        name: data['name'] ?? 'Unknown',
        macAdress: data['mac'] ?? '',
      );
    });
  }

  /// Whether the phone's Bluetooth radio is on.
  Future<bool> isBluetoothEnabled() async {
    try {
      return await PrintBluetoothThermal.bluetoothEnabled;
    } catch (_) {
      return false;
    }
  }

  /// Printers already paired at the OS level (Settings > Bluetooth).
  /// `print_bluetooth_thermal` only sees paired classic-Bluetooth devices,
  /// so the user must pair the printer once in system settings first.
  Future<List<BluetoothInfo>> getPairedPrinters() async {
    try {
      return await PrintBluetoothThermal.pairedBluetooths;
    } catch (_) {
      return <BluetoothInfo>[];
    }
  }

  Future<bool> get isConnected async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (_) {
      return false;
    }
  }

  /// The printer the user picked in AddPrinterPage, if any.
  Future<Map<String, String>?> getSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final mac = prefs.getString(_prefMac);
    if (mac == null || mac.isEmpty) return null;
    return {
      'mac': mac,
      'name': prefs.getString(_prefName) ?? 'Saved printer',
    };
  }

  Future<void> savePrinter({required String mac, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefMac, mac);
    await prefs.setString(_prefName, name);
  }

  Future<void> forgetPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefMac);
    await prefs.remove(_prefName);
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {
      // ignore - nothing to disconnect from
    }
  }

  Future<bool> connect(String mac) async {
    try {
      return await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    } catch (_) {
      return false;
    }
  }

  /// Connects to whichever printer was saved, unless we're already connected.
  Future<bool> connectToSavedPrinter() async {
    final saved = await getSavedPrinter();
    if (saved == null) return false;
    if (await isConnected) return true;
    return connect(saved['mac']!);
  }

  /// Sends raw ESC/POS bytes to the printer, reconnecting first if needed.
  /// Returns false (never throws) so calling UI code can just show a message.
  Future<bool> printBytes(List<int> bytes) async {
    try {
      if (!await isConnected) {
        final reconnected = await connectToSavedPrinter();
        if (!reconnected) return false;
      }
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (_) {
      return false;
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:nkrs_app/data/services/printer_service.dart';
import 'package:nkrs_app/utility/constanst.dart';

class AddPrinterPage extends StatefulWidget {
  const AddPrinterPage({super.key});

  @override
  State<AddPrinterPage> createState() => _AddPrinterPageState();
}

class _AddPrinterPageState extends State<AddPrinterPage> {
  final PrinterService _printerService = PrinterService();

  bool _loading = true;
  bool _bluetoothOn = false;
  String? _connectingMac;
  String? _errorMessage;
  List<BluetoothInfo> _pairedPrinters = [];
  List<BluetoothInfo> _scannedPrinters = [];
  Map<String, String>? _savedPrinter;
  StreamSubscription<BluetoothInfo>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    await _requestPermissions();

    final bluetoothOn = await _printerService.isBluetoothEnabled();
    final saved = await _printerService.getSavedPrinter();
    final paired = bluetoothOn
        ? await _printerService.getPairedPrinters()
        : <BluetoothInfo>[];

    _scannedPrinters.clear();
    await _scanSubscription?.cancel();

    if (bluetoothOn) {
      _scanSubscription = _printerService.startScan().listen((device) {
        if (!mounted) return;
        setState(() {
          // Avoid duplicates with paired list and already scanned
          if (!_pairedPrinters.any((p) => p.macAdress == device.macAdress) &&
              !_scannedPrinters.any((p) => p.macAdress == device.macAdress)) {
            _scannedPrinters.add(device);
          }
        });
      });
      // Scan for 12 seconds
      await Future.delayed(const Duration(seconds: 12));
    }

    if (!mounted) return;
    setState(() {
      _bluetoothOn = bluetoothOn;
      _savedPrinter = saved;
      _pairedPrinters = paired;
      _loading = false;
      if (!bluetoothOn) {
        _errorMessage = 'Bluetooth is off. Please turn it on and refresh.';
        // Attempt to prompt the user to turn on Bluetooth natively
        try {
          const MethodChannel(
            'com.nkrslanka.nkrs_app/bluetooth',
          ).invokeMethod('turnOnBluetooth');
        } catch (_) {}
      } else if (paired.isEmpty) {
        _errorMessage =
            'No paired printers found. Pair your printer in system Bluetooth settings first, then refresh here.';
      }
    });
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      // Location is strictly required by Android 11 and below to discover unpaired Bluetooth devices
      Permission.locationWhenInUse,
    ].request();
  }

  Future<void> _connectTo(BluetoothInfo device) async {
    // Make sure it's a printer before attempting to connect.
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Printer'),
        content: Text(
          'Are you sure "${device.name}" is a Bluetooth thermal printer?\n\nConnecting to audio devices or other Bluetooth peripherals may fail.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Yes, Connect'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _connectingMac = device.macAdress;
      _errorMessage = null;
    });

    final connected = await _printerService.connect(device.macAdress);

    if (!mounted) return;

    if (connected) {
      // Post-connection verification: Send an ESC @ (Initialize Printer) command.
      // This is silent and doesn't feed paper, but verifies the SPP socket accepts print bytes.
      bool isPrinter = false;
      try {
        isPrinter = await PrintBluetoothThermal.writeBytes([27, 64]);
      } catch (_) {}

      if (!isPrinter) {
        await _printerService.forgetPrinter();
        if (!mounted) return;
        setState(() {
          _connectingMac = null;
          _errorMessage =
              'Device "${device.name}" connected but is not responding as a printer. Disconnected.';
        });
        return;
      }

      await _printerService.savePrinter(
        mac: device.macAdress,
        name: device.name,
      );
      setState(() {
        _savedPrinter = {'mac': device.macAdress, 'name': device.name};
        _connectingMac = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Connected to ${device.name}')));
      }
    } else {
      setState(() {
        _connectingMac = null;
        _errorMessage =
            'Could not connect to ${device.name}. Make sure it is powered on and in range.';
      });
    }
  }

  Future<void> _forgetPrinter() async {
    await _printerService.forgetPrinter();
    if (!mounted) return;
    setState(() => _savedPrinter = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: safeAreaC,
      appBar: AppBar(
        backgroundColor: appBarC,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bluetooth Printers'),
        titleTextStyle: TextStyle(
          color: btnC,
          fontSize: appBarFontS,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
        ),
        actions: [
          IconButton(
            onPressed: _loading ? null : _initialize,
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RadarPulse(),
                    SizedBox(height: 48),
                    Text(
                      "Scanning for nearby printers...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _initialize,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  children: [
                    if (_errorMessage != null) _errorBanner(),
                    if (_savedPrinter != null) _savedPrinterCard(),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'AVAILABLE DEVICES',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_pairedPrinters.isEmpty && _scannedPrinters.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.print_disabled_rounded,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No printers found.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Make sure your thermal printer is turned on and in range, then refresh.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      if (_pairedPrinters.isNotEmpty) ...[
                        ..._pairedPrinters.map(_printerTile),
                      ],
                      if (_scannedPrinters.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'UNPAIRED (NEARBY)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._scannedPrinters.map(_printerTile),
                      ]
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _savedPrinterCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTIVE PRINTER',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _savedPrinter!['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    // Quick test print
                    final connected = await _printerService.connect(
                      _savedPrinter!['mac']!,
                    );
                    if (connected) {
                      await PrintBluetoothThermal.writeString(
                        printText: PrintTextSize(
                          size: 2,
                          text: "Test Print OK\n\n\n",
                        ),
                      );
                      if (mounted)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Test print sent!')),
                        );
                    }
                  },
                  icon: const Icon(Icons.print_rounded, size: 18),
                  label: const Text("Test Print"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade700,
                    side: BorderSide(color: Colors.green.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _forgetPrinter,
                  icon: const Icon(Icons.link_off_rounded, size: 18),
                  label: const Text("Disconnect"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _errorBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_rounded, size: 24, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _printerTile(BluetoothInfo device) {
    final isSaved = _savedPrinter?['mac'] == device.macAdress;
    final isConnecting = _connectingMac == device.macAdress;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: isSaved
            ? Border.all(color: Colors.green, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isSaved || isConnecting ? null : () => _connectTo(device),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSaved ? Colors.green.shade50 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.print_rounded,
                    color: isSaved ? Colors.green : Colors.blue.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.macAdress,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isConnecting)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                else if (isSaved)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Connected",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadarPulse extends StatefulWidget {
  const _RadarPulse();

  @override
  State<_RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<_RadarPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_controller.value * 2.0),
              child: Opacity(
                opacity: 1.0 - _controller.value,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.4),
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delayedValue = (_controller.value - 0.4) % 1.0;
            final val = delayedValue < 0 ? delayedValue + 1.0 : delayedValue;
            return Transform.scale(
              scale: 1.0 + (val * 2.0),
              child: Opacity(
                opacity: 1.0 - val,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.bluetooth_searching_rounded,
            size: 38,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nkrs_app/data/view_model/check_connection.dart';
import 'package:nkrs_app/utility/constanst.dart';

class ConnectionView {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return const _OfflineDialogContent();
      },
    );
  }
}

class _OfflineDialogContent extends StatefulWidget {
  const _OfflineDialogContent();

  @override
  State<_OfflineDialogContent> createState() => _OfflineDialogContentState();
}

class _OfflineDialogContentState extends State<_OfflineDialogContent> {
  @override
  void initState() {
    super.initState();
    CheckConnection.initialize();
  }

  @override
  void dispose() {
    CheckConnection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            const SizedBox(height: 15),
            _modeSwitch(),
            const SizedBox(height: 3),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                color: Color.fromARGB(40, 51, 51, 51),
                thickness: 1.5,
              ),
            ),
            const SizedBox(height: 5),
            _statusText(),
            _refreshButton(),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Internet Connection",
            style: TextStyle(
              fontWeight: FontWeight(HeaderFW),
              fontSize: headerFontSize,
              color: headerTextC,
            ),
          ),
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color.fromARGB(40, 120, 120, 120),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Color.fromARGB(149, 0, 0, 0),
              size: 21,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _modeSwitch() {
    return ValueListenableBuilder<bool>(
      valueListenable: CheckConnection.autoMode,
      builder: (context, auto, child) {
        return SwitchListTile(
          title: Text(
            auto ? "Auto Mode ON" : "Device Offline",
            style: TextStyle(
              fontWeight: FontWeight(HeaderFW),
              fontSize: cardHeaderFS - 3,
              color: cardDescriptionFC,
            ),
          ),
          value: auto,
          onChanged: (value) async {
            await CheckConnection.setAutoMode(value);
          },
        );
      },
    );
  }

  Widget _statusText() {
    return ValueListenableBuilder<bool>(
      valueListenable: CheckConnection.isOnline,
      builder: (context, online, child) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            online ? "Online Mode" : "Offline Mode",
            style: TextStyle(
              fontSize: 16,
              color: online
                  ? const Color.fromARGB(255, 4, 184, 55)
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _refreshButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: CheckConnection.autoMode,
      builder: (context, auto, child) {
        return ElevatedButton.icon(
          onPressed: auto
              ? () async {
                  await CheckConnection.refreshConnection();
                }
              : null,
          icon: const Icon(Icons.refresh),
          label: const Text("Refresh Connection"),
        );
      },
    );
  }
}

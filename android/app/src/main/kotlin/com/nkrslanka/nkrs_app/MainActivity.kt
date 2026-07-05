package com.nkrslanka.nkrs_app

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val METHOD_CHANNEL = "com.nkrslanka.nkrs_app/bluetooth"
    private val EVENT_CHANNEL = "com.nkrslanka.nkrs_app/bluetooth_scan"
    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    
    private var scanEventSink: EventChannel.EventSink? = null
    
    private val bluetoothReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val action = intent.action
            if (BluetoothDevice.ACTION_FOUND == action) {
                val device: BluetoothDevice? = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                
                // Fetch name and mac
                val name = device?.name ?: "Unknown Device"
                val mac = device?.address ?: ""
                
                if (mac.isNotEmpty()) {
                    scanEventSink?.success(mapOf("name" to name, "mac" to mac))
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "turnOnBluetooth") {
                try {
                    val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                    startActivityForResult(enableBtIntent, 1)
                    result.success(true)
                } catch (e: Exception) {
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
        
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    scanEventSink = events
                    try {
                        val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
                        registerReceiver(bluetoothReceiver, filter)
                        bluetoothAdapter?.startDiscovery()
                    } catch (e: Exception) {
                        events?.error("SCAN_ERROR", e.message, null)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    scanEventSink = null
                    try {
                        bluetoothAdapter?.cancelDiscovery()
                        unregisterReceiver(bluetoothReceiver)
                    } catch (e: Exception) {
                        // Ignore
                    }
                }
            }
        )
    }
}

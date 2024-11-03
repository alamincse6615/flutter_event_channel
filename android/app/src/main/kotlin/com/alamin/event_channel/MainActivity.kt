package com.alamin.event_channel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager

import android.content.BroadcastReceiver
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val BATTERY_CHANNEL = "battery_channel"
    private var batteryReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    batteryReceiver = createBatteryReceiver(events)
                    registerReceiver(batteryReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                }

                override fun onCancel(arguments: Any?) {
                    unregisterReceiver(batteryReceiver)
                }
            }
        )
    }

    private fun createBatteryReceiver(events: EventChannel.EventSink): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val batteryLevel = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                val batteryScale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                val levelPercentage = if (batteryLevel != -1 && batteryScale != -1) {
                    (batteryLevel.toFloat() / batteryScale.toFloat() * 100).toInt()
                } else {
                    -1
                }
                val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING || status == BatteryManager.BATTERY_STATUS_FULL
                events.success(mapOf(
                    "batteryLevel" to levelPercentage,
                    "isCharging" to isCharging
                ))
            }
        }
    }
}

package com.realtorworks.agent
import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat

import com.moengage.core.DataCenter
import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.MoEngageEnvironmentConfig
import com.moengage.core.model.environment.MoEngageEnvironment

import com.moengage.core.config.LogConfig


import com.moengage.flutter.MoEInitializer
import com.moengage.flutter.MoEInitializer.Companion.initialiseDefaultInstance
import com.moengage.pushbase.MoEPushHelper
import io.flutter.app.FlutterApplication


class MainApplication : FlutterApplication() {



    override fun onCreate() {
        super.onCreate()


        val moEngage: MoEngage.Builder = MoEngage.Builder(this, "CAS6Y3UYSRYJ3CNHZMZ8WTCA",DataCenter.DATA_CENTER_3)
                       .configureLogs(LogConfig(LogLevel.VERBOSE, true))
                       .configureMoEngageEnvironment(MoEngageEnvironmentConfig(MoEngageEnvironment.LIVE)) 
                       initialiseDefaultInstance(context = this, builder = moEngage)
                       
    }
}
                       

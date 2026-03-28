package com.realtorworks.agent

import android.app.Application
import com.moengage.core.DataCenter
import com.moengage.core.LogLevel
import com.moengage.core.MoEngage
import com.moengage.core.config.LogConfig
import com.moengage.core.config.MoEngageEnvironmentConfig
import com.moengage.core.model.environment.MoEngageEnvironment
import com.moengage.flutter.MoEInitializer

class MainApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        val moEngage = MoEngage.Builder(
            this,
            "CAS6Y3UYSRYJ3CNHZMZ8WTCA",
            DataCenter.DATA_CENTER_3
        )
            .configureLogs(LogConfig(LogLevel.VERBOSE, true))
            .configureMoEngageEnvironment(
                MoEngageEnvironmentConfig(MoEngageEnvironment.LIVE)
            )

        initialiseDefaultInstance(this, moEngage)
    }
}

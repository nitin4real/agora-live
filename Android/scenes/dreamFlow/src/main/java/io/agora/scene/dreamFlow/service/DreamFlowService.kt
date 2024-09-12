package io.agora.scene.dreamFlow.service

import android.util.Log
import io.agora.scene.base.BuildConfig
import kotlinx.coroutines.*
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.logging.HttpLoggingInterceptor
import org.json.JSONArray
import org.json.JSONObject

class DreamFlowService(
    private val domain: String,
    private val region: String,
    private val appId: String,
    private val channelName: String,
) {

    private val tag = "DreamFlowService"

    data class SettingBean constructor(
        var isEffectOn: Boolean = false,
        var isFaceModeOn: Boolean = false,
        var strength: Float = 0.2f,
        var style: String? = null,
        var effect: String? = null,
        var description: String = ""
    )

    enum class ServiceStatus(val value: String) {
        STARTING("starting"),
        STARTED("started"),
        INACTIVE("inactive");

        companion object {
            private val map = values().associateBy { it.value }

            fun fromString(value: String): ServiceStatus {
                return map[value] ?: INACTIVE
            }
        }
    }

    var inUid: Int = 0
    var inRole: Int = 0
    val genaiUid: Int = 999

    var currentSetting: SettingBean = SettingBean()
        private set

    private var status: ServiceStatus = ServiceStatus.INACTIVE

    private var workerId: String = ""

    private val scope = CoroutineScope(Job() + Dispatchers.Main)
    private val okHttpClient by lazy {
        val builder = OkHttpClient.Builder()
        if (BuildConfig.DEBUG) {
            builder.addInterceptor(HttpLoggingInterceptor().setLevel(HttpLoggingInterceptor.Level.BODY))
        }
        builder.build()
    }

    private var listener: IDreamFlowStateListener? = null
    fun setListener(l: IDreamFlowStateListener) {
        listener = l
    }

    fun clean() {
        listener = null
    }

    fun forceStarted() {
        updateStatus(ServiceStatus.STARTED)
    }

    private fun updateStatus(s: ServiceStatus) {
        if (status != s) {
            status = s
            listener?.onStatusChanged(status)
        }
    }

    fun save(settingBean: SettingBean,
             success: () -> Unit,
             failure: ((Exception?) -> Unit)? = null) {
        scope.launch(Dispatchers.Main) {
            try {
                if (settingBean.isEffectOn) {
                    // turn effect on
                    if (status == DreamFlowService.ServiceStatus.STARTING ||
                        status == DreamFlowService.ServiceStatus.STARTED) {
                        update(settingBean)
                        currentSetting = settingBean
                        success.invoke()
                    } else {
                        create(settingBean)
                        currentSetting = settingBean
                        success.invoke()
                    }
                } else {
                    // turn effect off
                    if (status == DreamFlowService.ServiceStatus.STARTING ||
                        status == DreamFlowService.ServiceStatus.STARTED) {
                        delete()
                        currentSetting = settingBean
                        success.invoke()
                    } else {
                        currentSetting = settingBean
                        success.invoke()
                    }
                }
            } catch (e: Exception) {
                failure?.invoke(e)
            }
        }
    }

    private fun create(
        settingBean: SettingBean,
        success: () -> Unit,
        failure: ((Exception?) -> Unit)? = null
    ) {
        scope.launch(Dispatchers.Main) {
            try {
                create(settingBean)
                success.invoke()
            } catch (e: Exception) {
                failure?.invoke(e)
            }
        }
    }

    private fun delete(
        success: () -> Unit,
        failure: ((Exception?) -> Unit)? = null
    ) {
        scope.launch(Dispatchers.Main) {
            try {
                delete()
                success.invoke()
            } catch (e: Exception) {
                failure?.invoke(e)
            }
        }
    }

    private fun update(
        settingBean: SettingBean,
        success: () -> Unit,
        failure: ((Exception?) -> Unit)? = null
    ) {
        scope.launch(Dispatchers.Main) {
            try {
                update(settingBean)
                success.invoke()
            } catch (e: Exception) {
                failure?.invoke(e)
            }
        }
    }

    fun getStatus(
        success: (ServiceStatus) -> Unit,
        failure: ((Exception?) -> Unit)? = null
    ) {
        scope.launch(Dispatchers.Main) {
            try {
                success.invoke(getStatus())
            } catch (e: Exception) {
                failure?.invoke(e)
            }
        }
    }

    private suspend fun create(settingBean: SettingBean) = withContext(Dispatchers.IO) {
        val postBody = JSONObject().apply {
            put("name", "agoralive")
            put("rtcConfigure", JSONObject().apply {
                put("userids", JSONArray().apply {
                    put(JSONObject().apply {
                        put("inUid", inUid)
                        put("inToken", appId)
                        put("inChannelName", channelName) // 频道名
                        put("inRole", inRole) // ?
                        put("inVideo", "") // ?
                        put("genaiUid", genaiUid) // 是否要给个定值
                        put("genaiToken", "") // 是否需要获取？
                        put("genaiChannelName", "") // ?
                        put("genaiRole", 0) // 是否需要在风格选择时指定？
                        put("genaiVideo", "") // ?
                        put("prompt", "Best quality") // 是否需要在config中获取?
                    })
                })
            })
            put("prompt", "Best quality") // 和上边的是否相同？
            put("style", settingBean.style)
            put("strength", settingBean.strength)
            put("face_mode", settingBean.isFaceModeOn)
        }
        // region 如何获取到
        val request = Request.Builder().url("$domain/$region/v1/projects/$appId/stylize").
        addHeader("Content-Type", "application/json").post(postBody.toString().toRequestBody()).build()
        val execute = okHttpClient.newCall(request).execute()
        if (execute.isSuccessful) {
            val body = execute.body
                ?: throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, body is null")
            val bodyJobj = JSONObject(body.string())
            Log.d(tag, "graspSong: $bodyJobj")
            if (bodyJobj["code"] != 0 && bodyJobj["code"] != 1) {
                throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, reqCode=${bodyJobj["code"]}, reqMsg=${bodyJobj["msg"]},")
            } else {
                val data = bodyJobj["data"] as JSONObject
                workerId = data["id"] as String
                updateStatus(ServiceStatus.fromString((data["stat"] as String)))
            }
        } else {
            throw RuntimeException("Fetch token error: httpCode=${execute.code}, httpMsg=${execute.message}")
        }
    }

    private suspend fun delete() = withContext(Dispatchers.IO) {
        val request = Request.Builder().url("$domain/$region/v1/projects/$appId/stylize/$workerId").
        addHeader("Content-Type", "application/json").delete().build()
        val execute = okHttpClient.newCall(request).execute()
        if (execute.isSuccessful) {
            val body = execute.body
                ?: throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, body is null")
            val bodyJobj = JSONObject(body.string())
            Log.d(tag, "graspSong: $bodyJobj")
            if (bodyJobj["code"] != 0) {
                throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, reqCode=${bodyJobj["code"]}, reqMsg=${bodyJobj["msg"]},")
            } else {
                // update state
                workerId = ""
                updateStatus(ServiceStatus.INACTIVE)
            }
        } else {
            throw RuntimeException("Fetch token error: httpCode=${execute.code}, httpMsg=${execute.message}")
        }
    }

    private suspend fun update(settingBean: SettingBean) = withContext(Dispatchers.IO) {
        val postBody = JSONObject().apply {
            put("name", "lhz")
            put("rtcConfigure", JSONObject().apply {
                put("userids", JSONArray().apply {
                    put(JSONObject().apply {
                        put("inUid", inUid)
                        put("inToken", "")
                        put("inChannelName", "stylize1")
                        put("inRole", inRole)
                        put("inVideo", "")
                        put("genaiUid", genaiUid)
                        put("genaiToken", "")
                        put("genaiChannelName", "")
                        put("genaiRole", 0)
                        put("genaiVideo", "")
                        put("prompt", "Best quality")
                    })
                })
            })
            put("prompt", "Best quality")
            put("style", settingBean.style)
            put("strength", settingBean.strength)
            put("face_mode", settingBean.isFaceModeOn)
        }
        val request = Request.Builder().url("$domain/$region/v1/projects/$appId/stylize").
        addHeader("Content-Type", "application/json").post(postBody.toString().toRequestBody()).build()
        val execute = okHttpClient.newCall(request).execute()
        if (execute.isSuccessful) {
            val body = execute.body
                ?: throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, body is null")
            val bodyJobj = JSONObject(body.string())
            Log.d(tag, "graspSong: $bodyJobj")
            if (bodyJobj["code"] != 0) {
                throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, reqCode=${bodyJobj["code"]}, reqMsg=${bodyJobj["msg"]},")
            } else {
                (bodyJobj["data"] as JSONObject)["userId"] as String
            }
        } else {
            throw RuntimeException("Fetch token error: httpCode=${execute.code}, httpMsg=${execute.message}")
        }
    }

    private suspend fun getStatus() = withContext(Dispatchers.IO) {
        val request = Request.Builder().url("$domain/$region/v1/projects/$appId/stylize/$workerId").
        addHeader("Content-Type", "application/json").get().build()
        val execute = okHttpClient.newCall(request).execute()
        if (execute.isSuccessful) {
            val body = execute.body
                ?: throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, body is null")
            val bodyJobj = JSONObject(body.string())
            Log.d(tag, "graspSong: $bodyJobj")
            if (bodyJobj["code"] != 0) {
                throw RuntimeException("graspSong error: httpCode=${execute.code}, httpMsg=${execute.message}, reqCode=${bodyJobj["code"]}, reqMsg=${bodyJobj["msg"]},")
            } else {
                ServiceStatus.STARTED
                // TODO: Analysis status
            }
        } else {
            throw RuntimeException("Fetch token error: httpCode=${execute.code}, httpMsg=${execute.message}")
        }
    }
}
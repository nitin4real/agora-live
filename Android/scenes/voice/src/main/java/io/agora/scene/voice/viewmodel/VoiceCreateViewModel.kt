package io.agora.scene.voice.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import io.agora.CallBack
import io.agora.chat.adapter.EMAError
import io.agora.rtmsyncmanager.model.AUIRoomInfo
import io.agora.scene.base.component.AgoraApplication
import io.agora.scene.base.utils.ToastUtils
import io.agora.scene.voice.R
import io.agora.scene.voice.global.VoiceBuddyFactory
import io.agora.scene.voice.imkit.manager.ChatroomIMManager
import io.agora.scene.voice.model.VoiceCreateRoomModel
import io.agora.scene.voice.netkit.VRCreateRoomResponse
import io.agora.scene.voice.netkit.VoiceToolboxServerHttpManager
import io.agora.scene.voice.service.VoiceServiceProtocol
import io.agora.voice.common.net.callback.VRValueCallBack
import io.agora.voice.common.viewmodel.SingleSourceLiveData

class VoiceCreateViewModel : ViewModel() {

    /**
     * voice chat protocol
     */
    private val voiceServiceProtocol by lazy {
        VoiceServiceProtocol.serviceProtocol
    }

    private val _roomListObservable: SingleSourceLiveData<List<AUIRoomInfo>?> = SingleSourceLiveData()

    private val _createRoomObservable: SingleSourceLiveData<AUIRoomInfo?> = SingleSourceLiveData()

    private val _joinRoomObservable: SingleSourceLiveData<AUIRoomInfo?> = SingleSourceLiveData()

    val roomListObservable: LiveData<List<AUIRoomInfo>?> get() = _roomListObservable

    val createRoomObservable: LiveData<AUIRoomInfo?> get() = _createRoomObservable

    val joinRoomObservable: LiveData<AUIRoomInfo?> get() = _joinRoomObservable

    fun checkLoginIm(completion: (error: Exception?) -> Unit) {
        VoiceToolboxServerHttpManager.createImRoom(
            roomName = "",
            roomOwner = "",
            chatroomId = "",
            type = 1,
            callBack = object : VRValueCallBack<VRCreateRoomResponse> {
                override fun onSuccess(response: VRCreateRoomResponse?) {
                    response?.chatToken?.let {
                        VoiceBuddyFactory.get().getVoiceBuddy().setupChatToken(it)
                    }
                    val chatUsername = VoiceBuddyFactory.get().getVoiceBuddy().chatUserName()
                    val chatToken = VoiceBuddyFactory.get().getVoiceBuddy().chatToken()
                    ChatroomIMManager.getInstance().login(chatUsername, chatToken, object : CallBack {
                        override fun onSuccess() {
                            completion.invoke(null)
                        }

                        override fun onError(code: Int, desc: String) {
                            if (code == EMAError.USER_ALREADY_LOGIN) {
                                completion.invoke(null)
                            } else {
                                completion.invoke(Exception(desc))
                                ToastUtils.showToast(R.string.voice_room_login_exception)
                            }
                        }
                    })
                }

                override fun onError(code: Int, message: String?) {
                    completion.invoke(Exception(message ?: ""))
                }
            })
    }


    fun getRoomList() {
        voiceServiceProtocol.getRoomList(completion = { error, result ->
            _roomListObservable.postValue(result)
            error?.message?.let {
                ToastUtils.showToast(it)
            }
        })
    }

    /**
     * Create room
     *
     * @param roomName
     * @param soundEffect
     * @param password
     */
    fun createRoom(roomName: String, soundEffect: Int = 0, password: String? = null) {
        val voiceCreateRoomModel = VoiceCreateRoomModel(
            roomName = roomName,
            soundEffect = soundEffect,
            password = password ?: "",
        )
        voiceServiceProtocol.createRoom(voiceCreateRoomModel, completion = { err, result ->
            if (err == null && result != null) {
                _createRoomObservable.postValue(result)
            } else {
                _createRoomObservable.postValue(null)
                ToastUtils.showToast(
                    AgoraApplication.the().getString(R.string.voice_create_room_failed, err?.message ?: "")
                )
            }
        })
    }

    /**
     * Join room
     *
     * @param roomId
     * @param password
     */
    fun joinRoom(roomId: String, password: String? = null) {
        voiceServiceProtocol.joinRoom(roomId, password, completion = { err, result ->
            if (err == null && result != null) { // success
                _joinRoomObservable.postValue(result)
            } else {
                _joinRoomObservable.postValue(null)
                ToastUtils.showToast(
                    AgoraApplication.the().getString(R.string.voice_join_room_failed, err?.message ?: "")
                )
            }
        })
    }
}
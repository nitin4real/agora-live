package io.agora.scene.voice.global

/**
 * @author create by zhangwei03
 */
interface IVoiceBuddy {

    /** user avatar */
    fun headUrl(): String

    /** user nickname */
    fun nickName(): String

    /** user id */
    fun userId(): String

    /** user token */
    fun userToken(): String

    /** rtc user id */
    fun rtcUid(): Int

    /** rtc app id*/
    fun rtcAppId(): String

    /** rtc channel token */
    fun rtcToken(): String

    /** Rtm token */
    fun rtmToken(): String

    /** im app key */
    fun chatAppKey(): String

    /** im user login token */
    fun chatToken(): String

    /** im user id */
    fun chatUserName(): String

    fun setupRtcToken(rtcToken: String)

    fun setupChatToken(chatToken: String)

    fun setupRtmToken(rtmToken: String)
}
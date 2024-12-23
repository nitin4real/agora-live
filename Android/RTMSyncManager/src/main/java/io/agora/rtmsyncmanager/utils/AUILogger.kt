package io.agora.rtmsyncmanager.utils

import android.content.Context
import android.os.*
import android.util.Log
import com.orhanobut.logger.*
import java.io.File
import java.io.FileWriter
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*

class AUILogger(private val config: Config) {

    companion object {

        private val dataFormat = SimpleDateFormat("HH:mm:ss.SSS", Locale.US)
        private val logFileWriteThread by lazy { HandlerThread("AUILogger").apply { start() } }
        private val logAdapters = mutableListOf<LogAdapter>()
        private var logger : AUILogger? = null

        private fun addLogAdapterSafe(adapter: LogAdapter){
            if(!logAdapters.contains(adapter)){
                // not clear in case of other log adapter ineffective
                // Logger.clearLogAdapters()
                logAdapters.add(adapter)
                logAdapters.forEach { Logger.addLogAdapter(it) }
            }
        }

        private fun removeLogAdapterSafe(adapter: LogAdapter) {
            if (logAdapters.contains(adapter)) {
                // not clear in case of other log adapter ineffective
                // Logger.clearLogAdapters()
                logAdapters.remove(adapter)
                logAdapters.forEach { Logger.addLogAdapter(it) }
            }
        }

        fun initLogger(config: Config){
            logger = AUILogger(config)
        }

        fun logger() : AUILogger {
            return logger ?: throw RuntimeException("Before calling AUILogger.logger(), the AUILogger.initLogger(Config) method must be called firstly!")
        }

    }

    private val wrapTag = "${config.rootTag}-${Random().nextInt(10) + 100}"

    data class Config(
        val context: Context,
        val rootTag: String,
        val logFileSize: Int = 2 * 1024 * 1024, // 2M，unit Byte
        val logFileName: String = "agora_auikit_${rootTag}_Android_${SimpleDateFormat("yyyy-MM-DD", Locale.US).format(Date())}_log".lowercase(),
        val logFolder: String = context.getExternalFilesDir("")!!.absolutePath,
        val threadInfoEnable: Boolean = true,
        val threadMethodCount: Int = 2,
        val threadMethodOffset: Int = 2,
        val logCallback: AUILogCallback? = null
    )

    private val consoleLogAdapter by lazy {
        object : AndroidLogAdapter(
            PrettyFormatStrategy.newBuilder()
                .showThreadInfo(config.threadInfoEnable)
                .methodCount(config.threadMethodCount)
                .methodOffset(config.threadMethodOffset)
                .logStrategy(LogcatLogStrategy())
                .tag(wrapTag)
                .build()
        ) {
            override fun isLoggable(priority: Int, tag: String?): Boolean {
                return tag == wrapTag
            }
        }
    }

    private val diskLogAdapter by lazy {
        object : DiskLogAdapter(
            CsvFormatStrategy
                .newBuilder()
                .logStrategy(DiskLogStrategy(WriteHandler(config, logFileWriteThread.looper)))
                .tag(wrapTag)
                .build()
        ) {
            override fun isLoggable(priority: Int, tag: String?): Boolean {
                return tag == wrapTag
            }
        }
    }

    private val callbackLogAdapter by lazy {
        object : LogAdapter {
            var lastMessage = ""

            override fun isLoggable(priority: Int, tag: String?): Boolean {
                return tag == wrapTag
            }

            override fun log(priority: Int, tag: String?, message: String) {
                if (lastMessage == message) {
                    return
                }
                // In case of the same message, only log once
                lastMessage = message

                when (priority) {
                    Log.DEBUG -> config.logCallback?.onLogDebug(tag ?: "", message)
                    Log.INFO -> config.logCallback?.onLogInfo(tag ?: "", message)
                    Log.WARN -> config.logCallback?.onLogWarning(tag ?: "", message)
                    Log.ERROR -> config.logCallback?.onLogError(tag ?: "", message)
                }
            }
        }
    }


    init {
        addLogAdapterSafe(callbackLogAdapter)
    }

    fun enableConsoleLog(enable: Boolean) {
        if (enable) {
            addLogAdapterSafe(consoleLogAdapter)
        } else {
            removeLogAdapterSafe(consoleLogAdapter)
        }
    }

    fun enableDiskLog(enable: Boolean) {
        if (enable) {
            addLogAdapterSafe(diskLogAdapter)
        } else {
            removeLogAdapterSafe(diskLogAdapter)
        }
    }


    fun i(tag: String, message: String, vararg args: Any) {
        Logger.t(wrapTag).i(formatMessage("INFO", tag, message), args)
    }

    fun w(tag: String, message: String, vararg args: Any) {
        Logger.t(wrapTag).w(formatMessage("Warn", tag, message), args)
    }

    fun d(tag: String, message: String, vararg args: Any) {
        Logger.t(wrapTag).d(formatMessage("Debug", tag, message), args)
    }

    fun e(tag: String, message: String, vararg args: Any) {
        Logger.t(wrapTag).e(formatMessage("Error", tag, message), args)
    }

    fun e(tag: String, throwable: Throwable, message: String, vararg args: Any) {
        Logger.t(wrapTag).e(throwable, formatMessage("Error", tag, message), args)
    }

    private fun formatMessage(level: String, tag: String?, message: String): String {
        val sb = StringBuilder("[Agora][${level}][${wrapTag}]")
        tag?.let { sb.append("[${tag}]"); }
        sb.append(" : (${dataFormat.format(Date())}) : $message")
        return sb.toString()
    }


    private class WriteHandler(val config: Config, looper: Looper) : Handler(looper) {

        override fun handleMessage(msg: Message) {
            val content = msg.obj as String
            var fileWriter: FileWriter? = null
            val logFile = getLogFile(config.logFolder, config.logFileName)
            try {
                fileWriter = FileWriter(logFile, true)
                writeLog(fileWriter, content)
                fileWriter.flush()
                fileWriter.close()
            } catch (e: IOException) {
                if (fileWriter != null) {
                    try {
                        fileWriter.flush()
                        fileWriter.close()
                    } catch (e1: IOException) { /* fail silently */
                    }
                }
            }
        }

        @Throws(IOException::class)
        private fun writeLog(fileWriter: FileWriter, content: String) {
            var writeContent = content
            val agoraTag = writeContent.indexOf("[Agora]")
            if (agoraTag > 0) {
                writeContent = writeContent.substring(agoraTag)
            }
            fileWriter.append(writeContent)
        }

        private fun getLogFile(folderName: String, fileName: String): File {
            val folder = File(folderName)
            if (!folder.exists()) {
                folder.mkdirs()
            }
            var newFileCount = 0
            var newFile: File
            var existingFile: File? = null
            newFile = File(folder, getLogFileFullName(fileName, newFileCount))
            while (newFile.exists()) {
                existingFile = newFile
                newFileCount++
                newFile = File(folder, getLogFileFullName(fileName, newFileCount))
            }
            if (existingFile != null && existingFile.length() < config.logFileSize) {
                return existingFile
            } else {
                return newFile
            }
        }

        private fun getLogFileFullName(fileName: String, count: Int): String {
            if (count == 0) {
                return "${fileName}.txt"
            }
            return "${fileName}_${count}.txt"
        }
    }

    interface AUILogCallback {
        fun onLogDebug(tag: String, message: String)
        fun onLogInfo(tag: String, message: String)
        fun onLogWarning(tag: String, message: String)
        fun onLogError(tag: String, message: String)
    }
}


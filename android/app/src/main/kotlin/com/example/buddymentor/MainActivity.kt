package com.example.buddymentor

import android.app.DownloadManager
import android.content.Context
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.buddymentor/media_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    // ✅ Called after file is saved — scans + shows download notification
                    "saveFile" -> {
                        val path     = call.argument<String>("path")
                        val fileName = call.argument<String>("fileName")

                        if (path == null || fileName == null) {
                            result.error("INVALID_ARGS", "path and fileName required", null)
                            return@setMethodCallHandler
                        }

                        try {
                            // 1. Scan so file appears in file manager instantly
                            MediaScannerConnection.scanFile(
                                applicationContext,
                                arrayOf(path),
                                null
                            ) { _, _ -> }

                            // 2. ✅ Use DownloadManager to show the system download notification
                            //    "Downloading..." → "Downloaded successfully."
                            val dm = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
                            val request = DownloadManager.Request(
                                Uri.parse("file://$path") // local file — instant, no re-download
                            )
                                .setTitle(fileName)
                                .setDescription("Downloaded successfully.")
                                .setNotificationVisibility(
                                    DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED
                                )
                                .setDestinationUri(Uri.parse("file://$path"))
                                .setMimeType(getMimeType(fileName))

                            dm.enqueue(request)
                            result.success(null)
                        } catch (e: Exception) {
                            // Non-fatal fallback — file is saved, just no notification
                            debugLog("saveFile fallback: ${e.message}")
                            result.success(null)
                        }
                    }

                    // Legacy scan only (kept for backward compat)
                    "scanFile" -> {
                        val path = call.argument<String>("path")
                        if (path != null) {
                            MediaScannerConnection.scanFile(
                                applicationContext,
                                arrayOf(path),
                                null
                            ) { _, _ -> }
                            result.success(null)
                        } else {
                            result.error("INVALID_PATH", "Path is null", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun getMimeType(fileName: String): String {
        return when {
            fileName.endsWith(".pdf",  ignoreCase = true) -> "application/pdf"
            fileName.endsWith(".jpg",  ignoreCase = true) -> "image/jpeg"
            fileName.endsWith(".jpeg", ignoreCase = true) -> "image/jpeg"
            fileName.endsWith(".png",  ignoreCase = true) -> "image/png"
            fileName.endsWith(".docx", ignoreCase = true) ->
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            fileName.endsWith(".doc",  ignoreCase = true) -> "application/msword"
            else -> "application/octet-stream"
        }
    }

    private fun debugLog(msg: String) {
        android.util.Log.d("BuddyMentor", msg)
    }
}
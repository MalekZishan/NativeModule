package com.awesomeproject

import android.net.Uri
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem

class VideoPlayerModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    private var player: ExoPlayer? = null

    override fun getName(): String {
        return "VideoPlayerModule"
    }

    @ReactMethod
    fun initializePlayer() {
        if (player == null) {
            player = ExoPlayer.Builder(reactApplicationContext).build()
        }
    }

    @ReactMethod
    fun playVideo(videoUrl: String, promise: Promise) {
        try {
            val videoUri = Uri.parse(videoUrl)
            val mediaItem = MediaItem.fromUri(videoUri)
            player?.apply {
                setMediaItem(mediaItem)
                prepare()
                play()
            }
            promise.resolve("Video is playing")
        } catch (e: Exception) {
            promise.reject("Error playing video", e)
        }
    }

    @ReactMethod
    fun pauseVideo(promise: Promise) {
        player?.pause()
        promise.resolve("Video paused")
    }

    @ReactMethod
    fun seekTo(positionMs: Long, promise: Promise) {
        player?.seekTo(positionMs)
        promise.resolve("Seeked to position")
    }

    override fun onCatalystInstanceDestroy() {
        player?.release()
        player = null
    }
}

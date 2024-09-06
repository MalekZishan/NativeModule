package com.videoplayer

import android.net.Uri
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.PlayerView

class VideoPlayerManager : SimpleViewManager<PlayerView>() {
    private var player: ExoPlayer? = null

    override fun getName(): String {
        return "RCTVideoPlayer"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): PlayerView {
        // Initialize ExoPlayer
        player = ExoPlayer.Builder(reactContext).build()
        val playerView = PlayerView(reactContext)
        playerView.player = player
        return playerView
    }

    // Method to set the video URL from React Native
    @ReactProp(name = "videoURL")
    fun setVideoURL(view: PlayerView, url: String) {
        val uri = Uri.parse(url)
        val mediaItem = MediaItem.fromUri(uri)
        player?.setMediaItem(mediaItem)
        player?.prepare() // Prepare the player
    }

    // Method to play the video
    fun play() {
        player?.play()
    }

    // Method to pause the video
    fun pause() {
        player?.pause()
    }

    // Method to stop the video and release resources
    fun stop() {
        player?.stop()
        player?.release()
        player = null
    }

    override fun onDropViewInstance(view: PlayerView) {
        super.onDropViewInstance(view)
        player?.release() // Release resources when the view is dropped
    }
}

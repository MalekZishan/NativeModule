package com.awesomeproject

import android.content.Context
import android.net.Uri
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector
import com.google.android.exoplayer2.trackselection.TrackSelectionParameters
import com.google.android.exoplayer2.ui.PlayerView

class PlayerViewManager : SimpleViewManager<PlayerView>() {

    private var player: ExoPlayer? = null
    private var trackSelector: DefaultTrackSelector? = null

    override fun getName(): String {
        return "RCTPlayerView"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): PlayerView {
        // Create the PlayerView instance
        val playerView = PlayerView(reactContext)

        // Initialize the track selector with default parameters to limit resolution
        trackSelector = DefaultTrackSelector(reactContext).apply {
            // Set the max video resolution (e.g., 720p)
            setParameters(
                buildUponParameters()
                .setMaxVideoSize(320, 240) 
            )
        }

        // Initialize ExoPlayer with the track selector and attach it to PlayerView
        player = ExoPlayer.Builder(reactContext)
            .setTrackSelector(trackSelector!!)
            .build()

        playerView.useController = false
        playerView.player = player

        return playerView
    }

    @ReactProp(name = "videoUrl")
    fun setVideoUrl(view: PlayerView, videoUrl: String?) {
        if (videoUrl != null) {
            val videoUri = Uri.parse(videoUrl)
            val mediaItem = MediaItem.fromUri(videoUri)
            player?.apply {
                setMediaItem(mediaItem)
                prepare()
            }
        }
    }

    override fun onDropViewInstance(view: PlayerView) {
        super.onDropViewInstance(view)
        player?.release()
        player = null
    }
}

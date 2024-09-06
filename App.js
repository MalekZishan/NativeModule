import React, { useRef, useState } from "react";
import {
   requireNativeComponent,
   UIManager,
   findNodeHandle,
   FlatList,
   View,
   Dimensions,
   StyleSheet,
   Platform,
} from "react-native";

// Register the native component
const VideoPlayerViewIos = requireNativeComponent("VideoPlayerView");

const VideoPlayerViewAndroid = requireNativeComponent("RCTVideoPlayer");

const { height: screenHeight } = Dimensions.get("window");

// Array of 4 high-quality video URLs
const videos = [
   {
      id: 1,
      url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
   },
   {
      id: 2,
      url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
   },
   {
      id: 3,
      url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
   },
   {
      id: 4,
      url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
   },
];

const App = () => {
   const videoRefs = useRef([]); // Store references to all video components

   // Play the video at the current index
   const playVideo = (index) => {
      const playerRef = videoRefs.current[index];
      if (playerRef) {
         UIManager.dispatchViewManagerCommand(
            findNodeHandle(playerRef),
            UIManager.getViewManagerConfig("VideoPlayerView").Commands.play,
            []
         );
      }
   };

   // Pause the video at the current index
   const pauseVideo = (index) => {
      const playerRef = videoRefs.current[index];
      if (playerRef) {
         UIManager.dispatchViewManagerCommand(
            findNodeHandle(playerRef),
            UIManager.getViewManagerConfig("VideoPlayerView").Commands.pause,
            []
         );
      }
   };

   // This function is called when the FlatList detects changes in viewable items
   const onViewableItemsChanged = ({ viewableItems }) => {
      // Pause all videos
      videoRefs.current.forEach((ref, index) => pauseVideo(index));

      // Play the first viewable video (if any)
      if (viewableItems.length > 0) {
         const visibleIndex = viewableItems[0].index;
         playVideo(visibleIndex);
      }
   };

   // Config for the FlatList viewability, to track which items are currently visible
   const viewabilityConfig = {
      itemVisiblePercentThreshold: 50, // Consider a video visible when 50% of it is on screen
   };

   // Render each video in the FlatList
   const renderItem = ({ item, index }) => (
      <View style={styles.videoContainer}>
         {Platform.OS == "ios" ? (
            <VideoPlayerViewIos
               ref={(ref) => (videoRefs.current[index] = ref)} // Store reference for each video
               style={styles.videoPlayer}
               videoURL={item.url} // Pass the dynamic video URL
            />
         ) : (
            <VideoPlayerViewAndroid
               ref={(ref) => (videoRefs.current[index] = ref)} // Store reference for each video
               style={styles.videoPlayer}
               videoURL={item.url} // Pass the dynamic video URL
            />
         )}
      </View>
   );

   return (
      <FlatList
         data={videos}
         renderItem={renderItem}
         keyExtractor={(item) => item.id.toString()}
         snapToAlignment="start"
         snapToInterval={screenHeight} // Snap to each video (like TikTok)
         decelerationRate="fast"
         showsVerticalScrollIndicator={false}
         pagingEnabled
         onViewableItemsChanged={onViewableItemsChanged} // Detect visible videos
         viewabilityConfig={viewabilityConfig} // Set the viewability config
      />
   );
};

const styles = StyleSheet.create({
   videoContainer: {
      height: screenHeight,
      justifyContent: "center",
      alignItems: "center",
   },
   videoPlayer: {
      width: "100%",
      height: "100%",
   },
});

export default App;

#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h> // Import RCTUIManager to handle view management
#import "Videoplayer-Swift.h"  // Bridging header to access Swift from Objective-C

@interface VideoPlayerManager : RCTViewManager
@end

@implementation VideoPlayerManager

// Expose the module to React Native
RCT_EXPORT_MODULE(VideoPlayerView)

// This method returns the custom view (VideoPlayerView) to React Native
- (UIView *)view {
    return [[VideoPlayerView alloc] init];
}

// Expose the 'videoURL' property to set the video URL from React Native
RCT_EXPORT_VIEW_PROPERTY(videoURL, NSString)

// Expose play, pause, and stop methods to React Native
RCT_EXPORT_METHOD(play:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        VideoPlayerView *view = (VideoPlayerView *)viewRegistry[reactTag];
        if (view) {
            [view play];
        } else {
            NSLog(@"Error: View not found for tag %@", reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(pause:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        VideoPlayerView *view = (VideoPlayerView *)viewRegistry[reactTag];
        if (view) {
            [view pause];
        } else {
            NSLog(@"Error: View not found for tag %@", reactTag);
        }
    }];
}

RCT_EXPORT_METHOD(stop:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        VideoPlayerView *view = (VideoPlayerView *)viewRegistry[reactTag];
        if (view) {
            [view stop];
        } else {
            NSLog(@"Error: View not found for tag %@", reactTag);
        }
    }];
}

@end

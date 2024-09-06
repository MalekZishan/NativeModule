#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(BackgroundLocationManager, NSObject)

RCT_EXTERN_METHOD(startLocationUpdates)
RCT_EXTERN_METHOD(stopLocationUpdates)

@end

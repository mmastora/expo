// Copyright 2015-present 650 Industries. All rights reserved.

#import <AVFoundation/AVFoundation.h>

#import <ABI36_0_0EXAV/ABI36_0_0EXVideoManager.h>
#import <ABI36_0_0EXAV/ABI36_0_0EXVideoView.h>
#import <ABI36_0_0UMCore/ABI36_0_0UMUIManager.h>

@interface ABI36_0_0EXVideoManager ()

@property (nonatomic, weak) ABI36_0_0UMModuleRegistry *moduleRegistry;

@end

@implementation ABI36_0_0EXVideoManager

ABI36_0_0UM_EXPORT_MODULE(ExpoVideoManager);

- (NSString *)viewName
{
  return @"ExpoVideoView";
}

- (void)setModuleRegistry:(ABI36_0_0UMModuleRegistry *)moduleRegistry
{
  _moduleRegistry = moduleRegistry;
}

- (UIView *)view
{
  return [[ABI36_0_0EXVideoView alloc] initWithModuleRegistry:_moduleRegistry];
}

- (NSDictionary *)constantsToExport
{
  return @{@"ScaleNone": AVLayerVideoGravityResizeAspect,
           @"ScaleToFill": AVLayerVideoGravityResize,
           @"ScaleAspectFit": AVLayerVideoGravityResizeAspect,
           @"ScaleAspectFill": AVLayerVideoGravityResizeAspectFill};
}

// Props set directly in <Video> component
ABI36_0_0UM_VIEW_PROPERTY(status, NSDictionary *, ABI36_0_0EXVideoView)
{
  [view setStatus:value];
}

ABI36_0_0UM_VIEW_PROPERTY(useNativeControls, BOOL, ABI36_0_0EXVideoView)
{
  [view setUseNativeControls:value];
}

// Native only props -- set by Video.js
ABI36_0_0UM_VIEW_PROPERTY(source, NSDictionary *, ABI36_0_0EXVideoView)
{
  [view setSource:value];
}
ABI36_0_0UM_VIEW_PROPERTY(resizeMode, NSString *, ABI36_0_0EXVideoView)
{
  [view setNativeResizeMode:value];
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[
           @"onStatusUpdate",
           @"onLoadStart",
           @"onLoad",
           @"onError",
           @"onReadyForDisplay",
           @"onFullscreenUpdate"
           ];
}

- (void)_runBlock:(void (^)(ABI36_0_0EXVideoView *view))block
withEXVideoViewForTag:(nonnull NSNumber *)viewTag
     withRejecter:(ABI36_0_0UMPromiseRejectBlock)reject
{
  id<ABI36_0_0UMUIManager> uiManager = [_moduleRegistry getModuleImplementingProtocol:@protocol(ABI36_0_0UMUIManager)];
  [uiManager executeUIBlock:^(id view) {
    if ([view isKindOfClass:[ABI36_0_0EXVideoView class]]) {
      block((ABI36_0_0EXVideoView *)view);
    } else {
      NSString *errorMessage = [NSString stringWithFormat:@"Invalid view returned from registry, expecting ABI36_0_0EXVideo, got: %@", view];
      reject(@"E_VIDEO_TAGINCORRECT", errorMessage, ABI36_0_0UMErrorWithMessage(errorMessage));
    }
  } forView:viewTag ofClass:[ABI36_0_0EXVideoView class]];
}

ABI36_0_0UM_EXPORT_METHOD_AS(setFullscreen,
                    setFullscreen:(NSNumber *)viewTag
                    toValue:(BOOL)value
                    resolver:(ABI36_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI36_0_0UMPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI36_0_0EXVideoView *view) {
    [view setFullscreen:value resolver:resolve rejecter:reject];
  } withEXVideoViewForTag:viewTag withRejecter:reject];
}

// Note that the imperative playback API for Video is conducted through the AV module.

@end

// Copyright 2016-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface ABI37_0_0EXBarCodeScannerUtils : NSObject

+ (NSDictionary *)validBarCodeTypes;
+ (AVCaptureVideoOrientation)videoOrientationForInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (AVCaptureDevice *)deviceWithMediaType:(AVMediaType)mediaType
                      preferringPosition:(AVCaptureDevicePosition)position;

@end

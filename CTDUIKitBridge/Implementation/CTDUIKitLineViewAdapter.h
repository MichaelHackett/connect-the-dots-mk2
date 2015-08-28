// CTDUIKitLineViewAdapter:
//     Adapts CTDUIKitLineView to the CTDDotConnectionRenderer protocol.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDTrialRenderer.h"

@class CTDUIKitLineView;



@interface CTDUIKitLineViewAdapter : NSObject <CTDDotConnectionRenderer>

- (instancetype)initWithLineView:(CTDUIKitLineView*)connectionView;

@end

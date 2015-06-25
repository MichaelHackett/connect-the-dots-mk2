// CTDUIKitLineViewAdaptor:
//     Adapts CTDUIKitLineView to the CTDDotConnectionRenderer protocol.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDDotConnectionRenderer.h"

@class CTDUIKitLineView;



@interface CTDUIKitLineViewAdaptor : NSObject <CTDDotConnectionRenderer>

- (instancetype)initWithLineView:(CTDUIKitLineView*)connectionView;

@end

// CTDUIKitConnectTheDotsViewAdapter:
//     Adapts a UIView to be a container for the dots-and-connections activity.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTrialRenderer.h"

@class CTDUIKitColorPalette;
@class CTDUIKitConnectTheDotsView;



@interface CTDUIKitConnectTheDotsViewAdapter : NSObject <CTDTrialRenderer>

- (instancetype)initWithConnectTheDotsView:(CTDUIKitConnectTheDotsView*)connectTheDotsView
                        touchReferenceView:(UIView*)touchReferenceView
                              colorPalette:(CTDUIKitColorPalette*)colorPalette;

@end

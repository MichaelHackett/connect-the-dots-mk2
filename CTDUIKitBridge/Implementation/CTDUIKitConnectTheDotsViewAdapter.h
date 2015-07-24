// CTDUIKitConnectTheDotsViewAdapter:
//     Adapts a UIView to be a container for the dots-and-connections activity.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInteraction/Ports/CTDTouchMappers.h"
#import "CTDPresentation/Ports/CTDTrialRenderer.h"

@class CTDUIKitColorPalette;
@class CTDUIKitConnectTheDotsView;



@interface CTDUIKitConnectTheDotsViewAdapter : NSObject <CTDTrialRenderer, CTDTouchToPointMapper>

- (instancetype)initWithConnectTheDotsView:(CTDUIKitConnectTheDotsView*)connectTheDotsView
                              colorPalette:(CTDUIKitColorPalette*)colorPalette;

@end

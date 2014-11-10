// CTDApplication:
//     The main application controller.
//
// Copyright 2014 Michael Hackett. All rights reserved.

@protocol CTDTouchInputSource, CTDTrialRenderer;


@interface CTDApplication : NSObject

- (void)runTrialWithRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellMap:(NSDictionary*)colorCellMap
            touchInputSource:(id<CTDTouchInputSource>)touchInputSource;

@end

// CTDUIKitColorCell:
//     A toolbar cell for selecting a color.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDUIKitToolbar.h"
#import "CTDPresentation/CTDTouchable.h"



@interface CTDUIKitColorCell : NSObject <CTDUIKitToolbarCell, CTDTouchable>

- (instancetype)initWithColor:(UIColor*)cellColor;
CTD_NO_DEFAULT_INIT

@end

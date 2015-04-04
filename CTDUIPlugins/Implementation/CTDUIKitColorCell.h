// CTDUIKitColorCell:
//     A toolbar cell for selecting a color.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTouchable.h"
#import "CTDUIKitToolbar.h"



@interface CTDUIKitColorCell : NSObject <CTDUIKitToolbarCell, CTDTouchable>

- (instancetype)initWithColor:(UIColor*)cellColor;
CTD_NO_DEFAULT_INIT

@end

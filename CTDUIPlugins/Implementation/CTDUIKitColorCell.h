// CTDUIKitColorCell:
//     A toolbar cell for selecting a color.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitToolbar.h"
#import "CTDInteraction/ExtensionPoints/CTDTouchable.h"



@interface CTDUIKitColorCell : NSObject <CTDUIKitToolbarCell, CTDTouchable>

- (instancetype)initWithColor:(UIColor*)cellColor;
CTD_NO_DEFAULT_INIT

@end

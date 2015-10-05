// CTDUIKitColorCell:
//     A toolbar cell for selecting a color.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDInteraction/Ports/CTDTouchable.h"
#import "CTDApplication/Ports/CTDColorCellRenderer.h"



@interface CTDUIKitColorCell : UIView <CTDColorCellRenderer, CTDTouchable>

@property (strong, nonatomic) UIColor* colorWhenSelected;
@property (strong, nonatomic) UIColor* colorWhenNotSelected;
@property (assign, nonatomic) NSUInteger cellId; // currently 1-based index

@end

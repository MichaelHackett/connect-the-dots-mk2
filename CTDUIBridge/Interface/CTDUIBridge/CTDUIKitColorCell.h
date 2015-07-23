// CTDUIKitColorCell:
//     A toolbar cell for selecting a color.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDInteraction/ExtensionPoints/CTDTouchable.h"
#import "CTDPresentation/Ports/CTDSelectionRenderer.h"



@interface CTDUIKitColorCell : UIView <CTDSelectionRenderer, CTDTouchable>

@property (copy, nonatomic) UIColor* colorWhenSelected;
@property (copy, nonatomic) UIColor* colorWhenNotSelected;

@end

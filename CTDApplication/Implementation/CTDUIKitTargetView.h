// CTDUIKitTargetView:
//     UIKit renderer for task targets. The targets are drawn as circles
//     filled with a solid color.
//
// Copyright 2013-4 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDTargetRenderer.h"
#import "CTDPresentation/CTDTouchable.h"


@interface CTDUIKitTargetView : UIView <CTDTargetRenderer, CTDTouchable>

@end

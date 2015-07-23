// CTDUIKitDotViewAdapter:
//     Adapts CTDUIKitDotView to the CTDDotRenderer protocol. In particular,
//     it performs the color-mapping from the Presentation-layer color palette
//     labels to the actual UIColors that the view uses.
//
//     Other methods are simply forwarded for the time being, but that may
//     change if there are other aspects that might make sense to take from
//     the view.
//
//  Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInteraction/Ports/CTDTouchable.h"
#import "CTDPresentation/Ports/CTDDotRenderer.h"

@class CTDUIKitColorPalette;
@class CTDUIKitDotView;



@interface CTDUIKitDotViewAdapter : NSObject <CTDDotRenderer, CTDTouchable>

- (instancetype)initWithDotView:(CTDUIKitDotView*)dotView
                   colorPalette:(CTDUIKitColorPalette*)colorPalette;

@end

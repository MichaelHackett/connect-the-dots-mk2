// CTDRecordingSelectionRenderer:
//     A test spy to stand in for a selection renderer. May be extended to
//     create spies for protocols that include CTDSelectionRenderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectionRenderer.h"


@interface CTDRecordingSelectionRenderer : NSObject <CTDSelectionRenderer>

@property (assign, readonly, nonatomic, getter=isSelected) BOOL selected;

@end

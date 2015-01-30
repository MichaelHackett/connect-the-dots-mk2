// CTDRecordingSelectionRenderer:
//     A test spy to stand in for a selection renderer. May be extended to
//     create spies for protocols that include CTDSelectionRenderer.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDSelectionRenderer.h"
#import "CTDTestHelpers/CTDTestSpy.h"


@interface CTDRecordingSelectionRenderer : CTDTestSpy <CTDSelectionRenderer>

@property (assign, readonly, nonatomic, getter=isSelected) BOOL selected;

@end

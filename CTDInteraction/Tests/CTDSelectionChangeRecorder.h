// CTDSelectionChangeRecorder:
//     A test spy to stand in for a CTDSelectable object. May be extended to
//     create spies for protocols that include CTDSelectable.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDPresentation/CTDSelectable.h"
#import "CTDTestHelpers/CTDTestSpy.h"



@interface CTDSelectionChangeRecorder : CTDTestSpy <CTDSelectable>

@property (assign, readonly, nonatomic, getter=isSelected) BOOL selected;

- (NSArray*)selectionMesssagesReceived;

@end

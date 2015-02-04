// CTDSelectionChangeRecorder:
//     A test spy to stand in for a CTDSelectable object. May be extended to
//     create spies for protocols that include CTDSelectable.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDSelectable.h"


@interface CTDSelectionChangeRecorder : NSObject <CTDSelectable>

@property (assign, readonly, nonatomic, getter=isSelected) BOOL selected;
@property (copy, readonly, nonatomic) NSArray* messagesReceived;

- (void)reset;

@end

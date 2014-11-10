// CTDRecordingTargetConnectionView:
//     A test spy to stand in for a target-connection renderer.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetConnectionView.h"

@class CTDPoint;



@interface CTDRecordingTargetConnectionView : NSObject <CTDTargetConnectionView>

@property (copy, readonly, nonatomic) CTDPoint* firstEndpointPosition;
@property (copy, readonly, nonatomic) CTDPoint* secondEndpointPosition;
@property (assign, readonly, nonatomic, getter=wasInvalidated) BOOL invalidated;

- (instancetype)initWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                       secondEndpointPosition:(CTDPoint*)secondEndpointPosition;
@end

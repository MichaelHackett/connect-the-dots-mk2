// CTDRecordingDotConnectionRenderer:
//     A test spy to stand in for a dot-connection renderer.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDPresentation/Ports/CTDDotConnectionRenderer.h"

@class CTDPoint;



@interface CTDRecordingDotConnectionRenderer : NSObject <CTDDotConnectionRenderer>

@property (copy, readonly, nonatomic) CTDPoint* firstEndpointPosition;
@property (copy, readonly, nonatomic) CTDPoint* secondEndpointPosition;
@property (assign, readonly, nonatomic, getter=wasInvalidated) BOOL invalidated;

- (instancetype)initWithFirstEndpointPosition:(CTDPoint*)firstEndpointPosition
                       secondEndpointPosition:(CTDPoint*)secondEndpointPosition;
@end


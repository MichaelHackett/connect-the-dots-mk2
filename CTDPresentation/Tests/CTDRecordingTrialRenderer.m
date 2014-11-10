// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDRecordingTrialRenderer.h"

#import "CTDFakeTargetRenderer.h"
#import "CTDRecordingTargetConnectionView.h"
#import "CTDTargetConnectionView.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchable.h"
#import "CTDUtility/CTDPoint.h"



@implementation CTDRecordingTrialRenderer
{
    NSMutableArray* _targetViewsCreated;
    NSMutableArray* _targetConnectionViewsCreated;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _targetViewsCreated = [[NSMutableArray alloc] init];
        _targetConnectionViewsCreated = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)targetViewsCreated
{
    return [_targetViewsCreated copy];
}

- (NSArray*)targetConnectionViewsCreated
{
    return [_targetConnectionViewsCreated copy];
}

- (id<CTDTargetRenderer, CTDTouchable>)newTargetViewCenteredAt:(CTDPoint*)centerPosition
{
    id newTargetView = [[CTDFakeTargetRenderer alloc]
                        initWithCenterPosition:centerPosition];
    [_targetViewsCreated addObject:newTargetView];
    return newTargetView;
}

- (id<CTDTargetConnectionView>)
      newTargetConnectionViewWithFirstEndpointPosition:
          (CTDPoint*)firstEndpointPosition
      secondEndpointPosition:(CTDPoint*)secondEndpointPosition
{
    id newTargetConnectionView = [[CTDRecordingTargetConnectionView alloc]
                                  initWithFirstEndpointPosition:firstEndpointPosition
                                  secondEndpointPosition:secondEndpointPosition];
    [_targetConnectionViewsCreated addObject:newTargetConnectionView];
    return newTargetConnectionView;
}

@end

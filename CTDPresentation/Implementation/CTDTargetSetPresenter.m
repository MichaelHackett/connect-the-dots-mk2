// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDTargetSetPresenter.h"

#import "CTDColorPalette.h"
#import "CTDListOrderTouchMapper.h"
#import "CTDTargetRenderer.h"
#import "CTDTouchMapper.h"
#import "CTDTrialRenderer.h"
#import "CTDModel/CTDTarget.h"
#import "CTDUtility/CTDPoint.h"



static NSDictionary const* targetPaletteColorMap;



// ExerciseRunner (eventually), but just TargetSetPresenter for now?

@implementation CTDTargetSetPresenter
{
    NSArray* _targetViews;
    CTDListOrderTouchMapper* _targetsTouchMapper;
}

+ (void)initialize
{
    targetPaletteColorMap = @{
        @(CTDTargetColor_Red): @(CTDPaletteColor_RedTarget),
        @(CTDTargetColor_Green): @(CTDPaletteColor_GreenTarget),
        @(CTDTargetColor_Blue): @(CTDPaletteColor_BlueTarget),
    };
}

- (instancetype)initWithTargetList:(NSArray*)targetList
                     trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        NSMutableArray* targetViews = [[NSMutableArray alloc] init];
        for (CTDTarget* target in targetList) {
            CTDPaletteColor targetColor =
                [targetPaletteColorMap[@(target.color)] unsignedIntegerValue];
            [targetViews addObject:
                [trialRenderer newTargetViewCenteredAt:target.position
                                      withInitialColor:targetColor]];
        }

        _targetViews = [targetViews copy];
        _targetsTouchMapper = [[CTDListOrderTouchMapper alloc] init];
        for (id<CTDTouchable> targetView in targetViews) {
            [_targetsTouchMapper mapTouchable:targetView
                                   toActuator:targetView]; // TODO: Change to some PM obj
        }
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (id<CTDTouchMapper>)targetsTouchMapper
{
    return _targetsTouchMapper;
}

@end

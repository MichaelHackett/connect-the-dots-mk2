// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDDotSetPresenter.h"

#import "CTDColorPalette.h"
#import "CTDDotRenderer.h"
#import "CTDTrialRenderer.h"
#import "CTDModel/CTDDot.h"
#import "CTDUIPlugins/CTDListOrderTouchMapper.h"
#import "CTDUIPlugins/CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



static NSDictionary const* dotPaletteColorMap;



// ExerciseRunner (eventually), but just DotSetPresenter for now?

@implementation CTDDotSetPresenter
{
    NSArray* _dotViews;
    CTDListOrderTouchMapper* _dotsTouchMapper;
}

+ (void)initialize
{
    dotPaletteColorMap = @{
        @(CTDDotColor_Red): @(CTDPaletteColor_RedDot),
        @(CTDDotColor_Green): @(CTDPaletteColor_GreenDot),
        @(CTDDotColor_Blue): @(CTDPaletteColor_BlueDot),
    };
}

- (instancetype)initWithDotList:(NSArray*)dotList
                  trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        NSMutableArray* dotViews = [[NSMutableArray alloc] init];
        for (CTDDot* dot in dotList) {
            CTDPaletteColor dotColor =
                [dotPaletteColorMap[@(dot.color)] unsignedIntegerValue];
            [dotViews addObject:
                [trialRenderer newDotViewCenteredAt:dot.position
                                   withInitialColor:dotColor]];
        }

        _dotViews = [dotViews copy];
        _dotsTouchMapper = [[CTDListOrderTouchMapper alloc] init];
        for (id<CTDTouchable> dotView in dotViews) {
            [_dotsTouchMapper mapTouchable:dotView
                                toActuator:dotView]; // TODO: Change to some PM obj
        }
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD

- (id<CTDTouchMapper>)dotsTouchMapper
{
    return _dotsTouchMapper;
}

@end

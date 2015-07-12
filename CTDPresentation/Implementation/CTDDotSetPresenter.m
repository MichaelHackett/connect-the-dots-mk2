// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDDotSetPresenter.h"

#import "CTDColorPalette.h"
#import "CTDDotRenderer.h"
#import "CTDTrialRenderer.h"
#import "CTDModel/CTDDot.h"
#import "CTDInteraction/CTDListOrderTouchMapper.h"
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
        @(CTDDotColor_Red): CTDPaletteColor_DotType1,
        @(CTDDotColor_Green): CTDPaletteColor_DotType2,
        @(CTDDotColor_Blue): CTDPaletteColor_DotType3,
    };
}

- (instancetype)initWithDotList:(NSArray*)dotList
                  trialRenderer:(id<CTDTrialRenderer>)trialRenderer
{
    self = [super init];
    if (self) {
        NSMutableArray* dotViews = [[NSMutableArray alloc] init];
        for (CTDDot* dot in dotList) {
            CTDPaletteColorLabel dotColor = dotPaletteColorMap[@(dot.color)];
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

- (id<CTDTouchToElementMapper>)dotsTouchMapper
{
    return _dotsTouchMapper;
}

@end

// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDDotSetPresenter.h"

#import "CTDColorPalette.h"
#import "Ports/CTDDotRenderer.h"
#import "Ports/CTDTrialRenderer.h"
#import "CTDModel/CTDDot.h"
#import "CTDInteraction/CTDListOrderTouchMapper.h"
#import "CTDUtility/CTDPoint.h"



static NSDictionary const* dotPaletteColorMap;



// ExerciseRunner (eventually), but just DotSetPresenter for now?

@implementation CTDDotSetPresenter
{
    NSArray* _dotRenderings;
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
        NSMutableArray* dotRenderings = [[NSMutableArray alloc] init];
        for (CTDDot* dot in dotList) {
            CTDPaletteColorLabel dotColor = dotPaletteColorMap[@(dot.color)];
            [dotRenderings addObject:
                [trialRenderer newDotRenderingCenteredAt:dot.position
                                        withInitialColor:dotColor]];
        }

        _dotRenderings = [dotRenderings copy];
        _dotsTouchMapper = [[CTDListOrderTouchMapper alloc] init];
        for (id<CTDTouchable> dotRendering in dotRenderings) {
            [_dotsTouchMapper mapTouchable:dotRendering
                                toActuator:dotRendering]; // TODO: Change to some PM obj
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

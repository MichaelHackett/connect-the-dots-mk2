// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialRendererSpy.h"

#import "CTDUtility/CTDPoint.h"



@interface CTDFakeDotRendering ()

// Configuration:
@property (copy, nonatomic) void (^cancellationBlock)(void);

@end


@interface CTDFakeConnectionRendering ()

// Configuration:
@property (copy, nonatomic) void (^cancellationBlock)(void);

@end





@implementation CTDTrialRendererSpy
{
    NSMutableArray* _dotRenderings;
    NSMutableArray* _connectionRenderings;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dotRenderings = [[NSMutableArray alloc] init];
        _connectionRenderings = [[NSMutableArray alloc] init];

        // Default values for point conversions:
        _dotSpaceMargin = 0;
        _dotSpaceWidth = 1000;
        _dotSpaceHeight = 1000;
    }
    return self;
}

- (CTDPoint*)renderingCoordinatesForDotSpaceCoordinates:(CTDPoint*)dotSpaceCoordinates
{
    return [CTDPoint x:self.dotSpaceMargin + dotSpaceCoordinates.x * self.dotSpaceWidth
                     y:self.dotSpaceMargin + dotSpaceCoordinates.y * self.dotSpaceHeight];
}

- (id<CTDDotRenderer>)newRendererForDotWithId:(__unused id)dotId
{
    CTDFakeDotRendering* dotRendering = [[CTDFakeDotRendering alloc] init];
    [_dotRenderings addObject:dotRendering];
    return dotRendering;
}

- (id<CTDDotConnectionRenderer>)newRendererForDotConnection
{
    CTDFakeConnectionRendering* connectionRendering = [[CTDFakeConnectionRendering alloc] init];

    ctd_weakify(self, weakSelf);
    ctd_weakify(connectionRendering, weakConnectionRendering);
    connectionRendering.cancellationBlock = ^{
        ctd_strongify(weakSelf, strongSelf);
        ctd_strongify(weakConnectionRendering, strongConnectionRendering);
        [strongSelf->_connectionRenderings removeObject:strongConnectionRendering];
    };

    [_connectionRenderings addObject:connectionRendering];
    return connectionRendering;
}

//- (void)cancelDotConnectionRenderer:(id<CTDDotConnectionRenderer>)connectionRenderer
//{
//    [_connectionRenderings removeObject:connectionRenderer];
//}

- (NSArray*)dotRenderings
{
    return [_dotRenderings filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"isVisible == YES"]];
}

- (NSArray*)connectionRenderings
{
    return [_connectionRenderings filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"isVisible == YES"]];
}

@end





@implementation CTDFakeDotRendering

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cancellationBlock = nil;
        _dotCenterPosition = [CTDPoint origin];
        _dotColor = nil;
        _isVisible = NO;
        _hasSelectionIndicator = NO;
    }
    return self;
}

- (void)discardRendering
{
    if (self.cancellationBlock) {
        self.cancellationBlock();
    }
}

- (void)setDotCenterPosition:(CTDPoint*)centerPosition
{
    _dotCenterPosition = [centerPosition copy];
}

- (void)setDotColor:(CTDPaletteColorLabel)newDotColor
{
    _dotColor = [newDotColor copy];
}

- (void)setVisible:(BOOL)visible { _isVisible = visible; }
- (void)hideSelectionIndicator { _hasSelectionIndicator = NO; }
- (void)showSelectionIndicator { _hasSelectionIndicator = YES; }

- (CTDPoint*)dotConnectionPoint {
    // Return an arbitrarily different value for the connection point (based
    // on the given position), so tests can distinguish that connection code
    // is using this value and not the one right from the trial step data.
    return [CTDPoint x:(999 - self.dotCenterPosition.x)
                     y:(999 - self.dotCenterPosition.y)];
}

@end



@implementation CTDFakeConnectionRendering

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cancellationBlock = nil;
        _firstEndpointPosition = nil;
        _secondEndpointPosition = nil;
        _isVisible = NO;
    }
    return self;
}

- (void)discardRendering
{
    self.cancellationBlock();
}

- (void)setVisible:(BOOL)visible { _isVisible = visible; }

@end

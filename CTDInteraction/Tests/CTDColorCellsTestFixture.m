// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDColorCellsTestFixture.h"

#import "Ports/CTDTouchMappers.h"
#import "CTDUtility/CTDPoint.h"

#define pt CTDMakePoint




@interface CTDColorCellsTestFixture_TouchMapper : NSObject <CTDTouchToElementMapper>
@end
@implementation CTDColorCellsTestFixture_TouchMapper
{
    __weak CTDColorCellsTestFixture* _fixture;
}

- (instancetype)initWithTestFixture:(CTDColorCellsTestFixture*)fixture
{
    self = [super init];
    if (self)
    {
        _fixture = fixture;
    }
    return self;
}

- (id)idOfElementAtTouchLocation:(CTDPoint*)touchLocation
{
    CTDColorCellsTestFixture* fixture = _fixture;

    if ([fixture.pointsInsideCell1 containsObject:touchLocation])
    {
        return @1;
    }
    else if ([fixture.pointsInsideCell2 containsObject:touchLocation])
    {
        return @2;
    }
    else if ([fixture.pointsInsideCell3 containsObject:touchLocation])
    {
        return @3;
    }
    return nil;
}

@end





@implementation CTDColorCellsTestFixture

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pointsInsideCell1 = @[pt(300,40), pt(310,35), pt(278,77)];
        _pointsInsideCell2 = @[pt(675,123), pt(704,95), pt(723,150)];
        _pointsInsideCell3 = @[pt(40,96), pt(45,99), pt(47,95)];
        _pointsOutsideElements = @[pt(191,150), pt(528,213), pt(22,70)];
        _colorCellTouchMapper = [[CTDColorCellsTestFixture_TouchMapper alloc]
                                 initWithTestFixture:self];
    }
    return self;
}

@end

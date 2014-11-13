// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDColorCellsTestFixture.h"

#import "CTDTouchMapper.h"
#import "CTDUtility/CTDPoint.h"




@interface CTDColorCellsTestFixture_TouchMapper : NSObject <CTDTouchMapper>
@end
@implementation CTDColorCellsTestFixture_TouchMapper
{
    CTDColorCellsTestFixture* _fixture;
}

- (instancetype)initWithTestFixture:(CTDColorCellsTestFixture*)fixture
{
    self = [super init];
    if (self) {
        _fixture = fixture;
    }
    return self;
}

- (id)elementAtTouchLocation:(CTDPoint*)touchLocation
{
    if ([_fixture.pointsInsideCell1 containsObject:touchLocation]) {
        return _fixture.colorCell1;
    }
    else if ([_fixture.pointsInsideCell2 containsObject:touchLocation]) {
        return _fixture.colorCell2;
    }
    else if ([_fixture.pointsInsideCell3 containsObject:touchLocation]) {
        return _fixture.colorCell3;
    }
    return nil;
}

@end





@implementation CTDColorCellsTestFixture

- (instancetype)init
{
    self = [super init];
    if (self) {
        _colorCell1 = [[CTDRecordingColorCellRenderer alloc] init];
        _colorCell2 = [[CTDRecordingColorCellRenderer alloc] init];
        _colorCell3 = [[CTDRecordingColorCellRenderer alloc] init];
        _pointsInsideCell1 = @[point(300,40), point(310,35), point(278,77)];
        _pointsInsideCell2 = @[point(675,123), point(704,95), point(723,150)];
        _pointsInsideCell3 = @[point(40,96), point(45,99), point(47,95)];
        _pointsOutsideElements = @[point(191,150), point(528,213), point(22,70)];
        _colorCellTouchMapper = [[CTDColorCellsTestFixture_TouchMapper alloc]
                                 initWithTestFixture:self];
    }
    return self;
}

@end

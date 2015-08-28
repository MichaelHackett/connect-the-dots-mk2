// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDListOrderTouchMapper.h"

#import "CTDFakeTouchable.h"
#import "Ports/CTDTouchable.h"
#import "CTDUtility/CTDPoint.h"

#define point CTDMakePoint

static CTDPoint* somePoint() { return point(100,150); }





@interface CTDListOrderTouchMapperBaseTestCase : XCTestCase

@property (strong, nonatomic) CTDListOrderTouchMapper* subject;

@end

@implementation CTDListOrderTouchMapperBaseTestCase

- (void)setUp {
    [super setUp];
    self.subject = [[CTDListOrderTouchMapper alloc] init];
}

@end




@interface CTDListOrderTouchMapperWhenFreshlyCreated
    : CTDListOrderTouchMapperBaseTestCase
@end
@implementation CTDListOrderTouchMapperWhenFreshlyCreated

- (void)testThatItReturnsNilWhenQueried {
    assertThat([self.subject idOfElementAtTouchLocation:somePoint()],
               is(nilValue()));
}

@end




@interface CTDListOrderTouchMapperWhenSingleElementHit
    : CTDListOrderTouchMapperBaseTestCase
@end
@implementation CTDListOrderTouchMapperWhenSingleElementHit

- (void)setUp {
    [super setUp];
    [self.subject mapTouchable:TOUCHED toId:@"HIT"];
}

- (void)testThatItReturnsTheActuatorForTheSingleElements {
    assertThat([self.subject idOfElementAtTouchLocation:somePoint()], is(@"HIT"));
}

@end




@interface CTDListOrderTouchMapperWhenSingleElementMissed
    : CTDListOrderTouchMapperBaseTestCase
@end
@implementation CTDListOrderTouchMapperWhenSingleElementMissed

- (void)setUp {
    [super setUp];
    [self.subject mapTouchable:NOT_TOUCHED toId:@"HIT"];
}

- (void)testThatItReturnsNilWhenQueried {
    assertThat([self.subject idOfElementAtTouchLocation:somePoint()], is(nilValue()));
}

@end




@interface CTDListOrderTouchMapperWhenMultipleElementsHit
    : CTDListOrderTouchMapperBaseTestCase
@end
@implementation CTDListOrderTouchMapperWhenMultipleElementsHit

- (void)setUp {
    [super setUp];
    [self.subject mapTouchable:NOT_TOUCHED toId:@"#1"];
    [self.subject mapTouchable:TOUCHED toId:@"#2"];
    [self.subject mapTouchable:TOUCHED toId:@"#3"];
}

- (void)testThatItReturnsEarliestAddedActuatorThatSignalsAHit {
    assertThat([self.subject idOfElementAtTouchLocation:somePoint()], is(@"#2"));
}

@end

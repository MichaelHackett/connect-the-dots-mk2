// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInMemoryTrialResults.h"

#import "CTDUtility/CTDPoint.h"



// Test data

static double STEP_DURATIONS[] = { 5.5, 7.2, 11.0, 8.14 };
static CTDPoint* somePosition() { return [CTDPoint x:100 y:40]; }
static CTDPoint* someOtherPosition() { return [CTDPoint x:400 y:350]; }




@interface CTDInMemoryTrialResultsTestCase : XCTestCase

@property (strong, nonatomic) CTDInMemoryTrialResults* subject;

@end

@implementation CTDInMemoryTrialResultsTestCase

- (void)setUp
{
    [super setUp];
    self.subject = [[CTDInMemoryTrialResults alloc] init];
}

@end




@interface CTDEmptyInMemoryTrialResults : CTDInMemoryTrialResultsTestCase
@end

@implementation CTDEmptyInMemoryTrialResults

- (void)testThatTrialDurationIsZero
{
    assertThatDouble([self.subject trialDuration], is(equalToDouble(0)));
}

@end




@interface CTDInMemoryTrialResultsAfterOneTrialStep : CTDInMemoryTrialResultsTestCase
@end

@implementation CTDInMemoryTrialResultsAfterOneTrialStep

- (void)setUp
{
    [super setUp];
    [self.subject setDuration:STEP_DURATIONS[0]
                  forStepNumber:1
                  startingDotPosition:somePosition()
                  endingDotPosition:someOtherPosition()];
}

- (void)testThatTrialDurationEqualsDurationOfSingleStep
{
    assertThatDouble([self.subject trialDuration], is(closeTo(STEP_DURATIONS[0], 0.01)));
}

@end




@interface CTDInMemoryTrialResultsAfterCompletingTrial : CTDInMemoryTrialResultsTestCase
@end

@implementation CTDInMemoryTrialResultsAfterCompletingTrial

- (void)setUp
{
    [super setUp];
    for (NSUInteger i = 0; i < (sizeof(STEP_DURATIONS) / sizeof(double)); i += 1)
    {
        [self.subject setDuration:STEP_DURATIONS[i]
                      forStepNumber:i+1
                      startingDotPosition:someOtherPosition()
                      endingDotPosition:somePosition()];
    }
}

- (void)testThatTrialDurationEqualsSumOfAllStepDurations
{
    double stepDurationSum = 0.0;
    for (NSUInteger i = 0; i < (sizeof(STEP_DURATIONS) / sizeof(double)); i += 1)
    {
        stepDurationSum += STEP_DURATIONS[i];
    }

    assertThatDouble([self.subject trialDuration], is(closeTo(stepDurationSum, 0.01)));
}

@end

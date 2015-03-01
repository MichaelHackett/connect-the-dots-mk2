// CTDOccurrenceCountMatcher:
//     A special type of sub-matcher intended for use with message matchers.
//
// Note: With only a little effort, these could become full Hamcrest matchers,
// but it's not clear that that would be useful. For now, having a distinct
// type seems safer, reducing the chance of using an inappropriate matcher in
// the place of a count-related submatcher.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import <OCHamcrest/HCDescription.h>


@protocol CTDOccurrenceCountMatcher <NSObject>
- (BOOL)matches:(NSUInteger)actualCount;
- (void)describeTo:(id<HCDescription>)description;
@end


// Constructor methods for various (private) concrete types that implement
// the above interface:
FOUNDATION_EXPORT id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_exactly(NSUInteger expectedCount);
FOUNDATION_EXPORT id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_exactlyOnce(void);
FOUNDATION_EXPORT id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_atLeast(NSUInteger expectedCount);
FOUNDATION_EXPORT id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_atLeastOnce(void);
FOUNDATION_EXPORT id<CTDOccurrenceCountMatcher> CTDOccurrenceCountMatcher_never(void);


// Convenience macros for more concise use of the above functions.
#define exactly CTDOccurrenceCountMatcher_exactly
#define exactlyOnce CTDOccurrenceCountMatcher_exactlyOnce
#define atLeastCount CTDOccurrenceCountMatcher_atLeast
// these conflict with OCMockito's macros; need to rename them or avoid using
// MOCKITO_SHORTHAND (or just undef those macros)
#define atLeastOnce CTDOccurrenceCountMatcher_atLeastOnce
#define never CTDOccurrenceCountMatcher_never

// TODO: functions for "at most" and perhaps others.

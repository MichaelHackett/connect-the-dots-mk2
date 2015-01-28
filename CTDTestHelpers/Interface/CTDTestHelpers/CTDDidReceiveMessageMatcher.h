// CTDDidReceiveMessageMatcher:
//     Hamcrest matcher for verifying messages received by a test spy.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import <OCHamcrest/HCBaseMatcher.h>


@protocol CTDMessageCountMatcher <NSObject>
- (BOOL)matches:(NSUInteger)actualCount;
- (void)describeTo:(id<HCDescription>)description;
@end



FOUNDATION_EXPORT id didReceive(SEL selector, id<CTDMessageCountMatcher> countMatcher);

FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_exactly(NSUInteger expectedCount);
FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_exactlyOnce(void);
FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_never(void);

#define exactly CTDMessageCountMatcher_exactly
#define exactlyOnce CTDMessageCountMatcher_exactlyOnce
// conflicts with OCMockito's never macro; rename or don't use with MOCKITO_SHORTHAND (or just undef those macros)
//#define never CTDMessageCountMatcher_never

// TODO: functions for "at least", "at most" and perhaps others.

// CTDDidReceiveMessageMatcher:
//     Hamcrest matcher for verifying messages received by a test spy.
//
// Note: The macros that define the standard (more compact) interface can be
// undefined and renamed if a conflict arises with some other library.
// Alternatively, one could add "guards" to the definition blocks so that they
// are only defined if some other definition is set first. (See OCHamcrest and
// OCMockito for examples.)
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import <OCHamcrest/HCBaseMatcher.h>


@protocol CTDMessageCountMatcher <NSObject>
- (BOOL)matches:(NSUInteger)actualCount;
- (void)describeTo:(id<HCDescription>)description;
@end



FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_exactly(NSUInteger expectedCount);
FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_exactlyOnce(void);
FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_atLeast(NSUInteger expectedCount);
FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_atLeastOnce(void);
FOUNDATION_EXPORT id<CTDMessageCountMatcher> CTDMessageCountMatcher_never(void);

#define exactly CTDMessageCountMatcher_exactly
#define exactlyOnce CTDMessageCountMatcher_exactlyOnce
#define atLeastCount CTDMessageCountMatcher_atLeast
#define atLeastOnce CTDMessageCountMatcher_atLeastOnce
// conflicts with OCMockito's never macro; rename or don't use with MOCKITO_SHORTHAND (or just undef those macros)
//#define never CTDMessageCountMatcher_never

// TODO: functions for "at most" and perhaps others.


FOUNDATION_EXPORT id CTD_receivedMessage(SEL selector, id<CTDMessageCountMatcher> countMatcher);

#define CTD_receivedMessageVarArg(SELECTOR, MATCHER, ...) CTD_receivedMessage(@selector(SELECTOR), MATCHER)
#define receivedMessage(...) CTD_receivedMessageVarArg(__VA_ARGS__, CTDMessageCountMatcher_atLeastOnce())
#define didNotReceiveMessage(SELECTOR) \
     CTD_receivedMessage(@selector(SELECTOR), CTDMessageCountMatcher_never())

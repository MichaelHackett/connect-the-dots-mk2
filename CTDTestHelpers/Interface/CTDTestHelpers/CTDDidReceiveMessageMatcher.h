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

#import "CTDOccurrenceCountMatcher.h"


FOUNDATION_EXPORT id CTD_receivedMessage(SEL selector, id<CTDOccurrenceCountMatcher> countMatcher);

#define CTD_receivedMessageVarArg(SELECTOR, MATCHER, ...) CTD_receivedMessage(@selector(SELECTOR), MATCHER)
#define receivedMessage(...) CTD_receivedMessageVarArg(__VA_ARGS__, CTDOccurrenceCountMatcher_atLeastOnce())
#define didNotReceiveMessage(SELECTOR) \
     CTD_receivedMessage(@selector(SELECTOR), CTDOccurrenceCountMatcher_never())

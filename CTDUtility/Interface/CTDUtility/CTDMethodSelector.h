// CTDMethodSelector:
//     An object representation of an Objective-C method selector (normally a
//     primitive type, SEL). This is convenient for use with collections and
//     display. (Sure it's possible to use string representations of method
//     names, but these will not be automatically updated during refactorings
//     the way @selector() arguments will be.)
//
// Copyright 2014-5 Michael Hackett. All rights reserved.


@interface CTDMethodSelector : NSObject <NSCopying>

@property (assign, readonly, nonatomic) SEL rawSelector;


- (instancetype)initWithRawSelector:(SEL)rawSelector;
CTD_NO_DEFAULT_INIT

- (BOOL)isEqualToRawSelector:(SEL)rawSelector;

// Note: -description returns the selector as a string

@end


// Convenience macro for creating instances of CTDMethodSelector:
#define CTDMakeMethodSelector(SELECTOR) \
    [[CTDMethodSelector alloc] initWithRawSelector:@selector(SELECTOR)]

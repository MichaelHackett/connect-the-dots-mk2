// CTDAnimationUtils:
//     Quartz animation utility functions.
//
// Copyright 2014 Michael Hackett. All rights reserved.


typedef void (^CTDAnimationBlock)(void);


// Shortcut for making changes to a layer with implicit animations disabled.
void withoutImplicitAnimationDo(CTDAnimationBlock block);

// Control the duration of implicit animations.
void animateWithDuration(double seconds, CTDAnimationBlock block);

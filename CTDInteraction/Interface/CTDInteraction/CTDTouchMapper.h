// CTDTouchMapper:
//     Maps touch locations to interaction objects; performs a hit-test scan of
//     the touchable elements under its purview. Different implementations may
//     implement priority ordering of overlapping touch-sensitive areas in
//     different ways.
//
// Copyright 2014 Michael Hackett. All rights reserved.

#import "./ExtensionPoints/CTDTouchMappers.h"

// Temporary remapping of new protocol name to old.
@protocol CTDTouchMapper <CTDTouchToElementMapper> @end

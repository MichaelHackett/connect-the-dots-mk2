// CTDTestDataHelpers:
//     Convenience macros for use in defining data and expectations for unit
//     tests.
//
// Usage: The macro names are longish here to avoid potential conflicts with
// regular variable and method names. It is suggested that unit test source
// modules that use any of these macros should define shortcut macros that are
// safe for within that module.
//
// Copyright 2014 Michael Hackett. All rights reserved.


// CTDPoint constants
#define CTDMakePoint(XCOORD,YCOORD) [[CTDPoint alloc] initWithX:XCOORD y:YCOORD]

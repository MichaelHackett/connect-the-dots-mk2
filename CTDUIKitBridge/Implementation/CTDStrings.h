// CTDStrings:
//     Alternative macros for accessing string resources (without needless
//     genstring support).
//
// Copyright 2015 Michael Hackett. All rights reserved.

#define CTDString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"<MISSING STRING>" table:nil]

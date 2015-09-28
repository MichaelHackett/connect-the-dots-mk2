// CTDStrings:
//     Alternative macros for accessing string resources (without needless
//     genstring support).
//
// Copyright 2015 Michael Hackett. All rights reserved.

#define CTDString(KEY) CTDStringWithDefault(KEY, @"<MISSING STRING>")
#define CTDStringWithDefault(KEY, DEFAULT) [[NSBundle mainBundle] localizedStringForKey:(KEY) value:DEFAULT table:nil]

// CTDStrongWeak.h
//
// Copyright 2015 Michael Hackett. All rights reserved.


// Macros for converting between strong and weak references.
#define ctd_weakify(STRONG, WEAK) __typeof(STRONG) __weak WEAK = (STRONG)
#define ctd_strongify(WEAK, STRONG) __typeof(WEAK) __strong STRONG = (WEAK)

// Stand-ins for CTDTouchables in tests:
//
// CTDAlwaysTouchable: containsTouchLocation always returns YES
// CTDNeverTouchable: containsTouchLocation always returns NO
//
// Use the macros to create instances more compactly.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "ExtensionPoints/CTDTouchable.h"



#define TOUCHED [[CTDAlwaysTouchable alloc] init]
#define NOT_TOUCHED [[CTDNeverTouchable alloc] init]


@interface CTDAlwaysTouchable : NSObject <CTDTouchable>
@end

@interface CTDNeverTouchable : NSObject <CTDTouchable>
@end

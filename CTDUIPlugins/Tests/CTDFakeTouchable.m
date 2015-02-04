// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDFakeTouchable.h"



@implementation CTDAlwaysTouchable

- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation
{
    return YES;
}

@end



@implementation CTDNeverTouchable

- (BOOL)containsTouchLocation:(__unused CTDPoint*)touchLocation
{
    return NO;
}

@end

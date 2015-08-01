// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitBridge.h"

#import "CTDUIKitWhatzit.h"



@implementation CTDUIKitBridge

+ (id<CTDDisplayController>)displayControllerForApplication:(UIApplication*)application
{
    return [[CTDUIKitWhatzit alloc] initWithApplication:application];
}

@end

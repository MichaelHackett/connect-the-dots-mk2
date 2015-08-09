// CTDApplication:
//
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDDisplayController;



@interface CTDApplication : NSObject

// Designated initializer
- (instancetype)initWithDisplayController:(id<CTDDisplayController>)displayController;

CTD_NO_DEFAULT_INIT


- (void)start;

@end

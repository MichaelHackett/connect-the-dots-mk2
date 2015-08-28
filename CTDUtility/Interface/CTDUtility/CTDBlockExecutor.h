// CTDBlockExecutor:
//     Use as a wrapper on a C block where a target/action pair is required.
//
// Copyright 2015 Michael Hackett. All rights reserved.


typedef void (^CTDBlockExecutorVoidBlock)(void);



@interface CTDBlockExecutor : NSObject

- (instancetype)initWithBlock:(CTDBlockExecutorVoidBlock)block;
CTD_NO_DEFAULT_INIT

- (void)execute;

@end

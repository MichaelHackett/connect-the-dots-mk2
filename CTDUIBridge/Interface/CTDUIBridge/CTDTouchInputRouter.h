// CTDTouchInputRouter:
//     A component that processes touch input and directs it to native and
//     custom touch "responders" (as installed through this interface).
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@protocol CTDTouchResponder;


@protocol CTDTouchInputRouter <NSObject>

- (void)addTouchResponder:(id<CTDTouchResponder>)touchResponder;
- (void)removeTouchResponder:(id<CTDTouchResponder>)touchResponder;

@end

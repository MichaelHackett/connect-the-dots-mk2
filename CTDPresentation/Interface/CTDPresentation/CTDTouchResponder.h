// CTDTouchResponder:
//
// Copyright 2014 Michael Hackett. All rights reserved.

@class CTDPoint;


@protocol CTDTouchTracker <NSObject>

@optional
- (void)touchDidMoveTo:(CTDPoint*)newPosition;
- (void)touchDidEnd;
- (void)touchWasCancelled;

@end


@protocol CTDTouchResponder <NSObject>

// Returns nil if responder not interested in tracking this touch.
// Else, caller must retain the tracker and send it updates.
- (id<CTDTouchTracker>)trackerForTouchStartingAt:(CTDPoint*)initialPosition;

@end



/**
 * To be implemented by the platform UI layer; distributes notifies responders
 * about new touches, and distributes updates to trackers over the lifetime of
 * each touch.
 */
@protocol CTDTouchInputSource <NSObject>

- (void)addTouchResponder:(id<CTDTouchResponder>)touchResponder;
- (void)removeTouchResponder:(id<CTDTouchResponder>)touchResponder;

@end

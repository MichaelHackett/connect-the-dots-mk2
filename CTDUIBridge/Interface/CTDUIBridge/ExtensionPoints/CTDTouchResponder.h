// CTDTouchResponder:
//     Extends the default touch routing to handle custom interactions.
//
// Installed touch responders are notified when a new touch is detected on the
// associated screen area and can respond by returning a "tracker" that will
// be sent updates continuously as long as the touch is active. The tracker
// will be retained by the touch source while the touch remains active.
// (Revisit this if it results in difficult retain loops.)
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

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

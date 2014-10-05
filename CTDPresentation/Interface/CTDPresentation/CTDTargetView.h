// CTDTargetView:
//     Visual representation of a target.
//
// This might not be implemented by a UIView directly (or whatever platform-
// specific equivalent); it might be something that creates and configures the
// platform view class. This may be particularly useful where the platform
// view class cannot be selected or fully configured until its container (where
// it will be rendered) is known.
//
// Copyright (c) 2014 Michael Hackett. All rights reserved.

@class CTDPoint;


@protocol CTDTargetView <NSObject>

- (void)showSelectionIndicator;
- (void)hideSelectionIndicator;

// Point is in local coordinates of target container view (aka, target view renderer).
- (BOOL)containsPoint:(CTDPoint*)point;

// This is part of the child interface only because it avoids the situation
// where, if the container was asked to remove the target view, it would only
// work with implementations that the container itself created, and it would
// have to verify that that was true. Here, the child will still have to ask
// the container for assistance, but it will be able to use native calls to
// do so.
//- (void)discardView; // don't even need this at the moment

@end

// TODO: Split above interface into a parent View interface and perhaps a
// "Selectable" interface, if it makes sense (or just keep the CTDTargetView type).



//@protocol CTDTargetViewFactory <NSObject>
//
//- (id<CTDTargetView>)newTargetView;
//
//@end


@protocol CTDTargetViewRenderer <NSObject>

- (id<CTDTargetView>)newTargetViewCenteredAt:(CTDPoint*)centerPosition;
//- (void)addTargetView:(id<CTDTargetView>)targetView
//           centeredAt:(CTDPoint*)centerPosition;
//- (void)removeTargetView:(id<CTDTargetView>)targetView;

@end

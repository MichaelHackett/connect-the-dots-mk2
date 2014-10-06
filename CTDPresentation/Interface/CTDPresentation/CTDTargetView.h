// CTDTargetView:
//     The visual representation of a target.
//
// Copyright 2014 Michael Hackett. All rights reserved.

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

// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitStandardViewController.h"

@class CTDUIKitColorPalette;
@class CTDUIKitConnectTheDotsView;
@protocol CTDTouchToPointMapper;
@protocol CTDTrialRenderer;



@interface CTDUIKitConnectSceneViewController
    : CTDUIKitStandardViewController

@property (copy, nonatomic) CTDUIKitColorPalette* colorPalette;

// IB Outlets
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorSelectionCells;
@property (weak, nonatomic) IBOutlet CTDUIKitConnectTheDotsView* connectTheDotsView;

// Property-like accessors
- (id<CTDTrialRenderer>)trialRenderer;
- (id<CTDTouchToPointMapper>)trialTouchMapper;

@end

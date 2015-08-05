// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitStandardViewController.h"
#import "CTDApplication/Ports/CTDConnectScene.h"

@class CTDUIKitColorPalette;
@class CTDUIKitConnectTheDotsView;



@interface CTDUIKitConnectSceneViewController
    : CTDUIKitStandardViewController <CTDConnectScene>

@property (copy, nonatomic) CTDUIKitColorPalette* colorPalette;
@property (weak, nonatomic) id<CTDTrialStepEditor> trialStepEditor;

// IB Outlets
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorSelectionCells;
@property (weak, nonatomic) IBOutlet CTDUIKitConnectTheDotsView* connectTheDotsView;

@end

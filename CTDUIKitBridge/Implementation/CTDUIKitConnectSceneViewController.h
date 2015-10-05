// CTDUIKitConnectSceneViewController:
//     Controller for the main connect-the-dots scene.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitStandardViewController.h"
#import "CTDApplication/Ports/CTDConnectScene.h"

@class CTDUIKitColorPalette;
@class CTDUIKitConnectTheDotsView;
@protocol CTDTrialEditor;



@interface CTDUIKitConnectSceneViewController
    : CTDUIKitStandardViewController <CTDConnectScene>

@property (copy, nonatomic) CTDUIKitColorPalette* colorPalette;
@property (assign, nonatomic) BOOL colorBarOnRight;
@property (assign, nonatomic) BOOL quasimodalButtons;
@property (weak, nonatomic) id<CTDTrialEditor> trialEditor;

// IB Outlets
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray* colorSelectionCells;
@property (weak, nonatomic) IBOutlet CTDUIKitConnectTheDotsView* connectTheDotsView;
@property (weak, nonatomic) IBOutlet UIView* colorSelectionBarView;
@property (weak, nonatomic) IBOutlet UIView* trialCompletionMessageView;
@property (weak, nonatomic) IBOutlet UILabel* trialTimeLabel;

@end

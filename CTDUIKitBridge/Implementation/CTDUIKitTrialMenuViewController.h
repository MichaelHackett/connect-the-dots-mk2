// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDTrialMenuSceneInputSource.h"




/**
 * Controller for the pre-trial overlay which provides the user with
 * information about the upcoming trial, allows them to initiate the trial
 * or lets the presenter exit the trial block early.
 */
@interface CTDUIKitTrialMenuViewController : UIViewController <CTDTrialMenuSceneInputSource>

/// Message to display. (Set this rather than manipulating the label directly.)
@property (copy, nonatomic) NSString* message;

@property (weak, nonatomic) IBOutlet UILabel* messageLabel;
@property (weak, nonatomic) IBOutlet UIButton* beginButton;

- (IBAction)beginTapped;
- (IBAction)exitTapped;

@end

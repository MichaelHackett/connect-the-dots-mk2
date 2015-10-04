// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/CTDDialogResponseHandler.h"




@interface CTDUIKitTrialBlockCompletionViewController : UIViewController

@property (assign, nonatomic) NSUInteger trialCount;
@property (copy, nonatomic) NSString* timeString;
@property (copy, nonatomic) CTDAcknowledgementResponseHandler acknowledgementHandler;

@property (weak, nonatomic) IBOutlet UILabel* messageLabel;
@property (weak, nonatomic) IBOutlet UIButton* okButton;

- (IBAction)okTapped;

@end

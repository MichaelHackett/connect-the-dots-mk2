// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitTrialBlockCompletionViewController.h"

#import "CTDStrings.h"




@implementation CTDUIKitTrialBlockCompletionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _timeString = nil;
        _acknowledgementHandler = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ctd_strongify(self.messageLabel, messageLabel);
    messageLabel.text = [NSString stringWithFormat:CTDString(@"TrialBlockCompletion"),
                                                   (unsigned long)self.trialCount,
                                                   self.timeString];

    // Interface Builder does not allow the setting of cap insets, except on
    // UIImageView elements, so we set the button images here.

    UIImage* buttonImage = [[UIImage imageNamed:@"BlueButton"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage* buttonHighlightedImage = [[UIImage imageNamed:@"BlueButtonHighlighted"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

    ctd_strongify(self.okButton, okButton);
    [okButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [okButton setBackgroundImage:buttonHighlightedImage forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark IBActions


- (void)okTapped
{
    if (self.acknowledgementHandler)
    {
        self.acknowledgementHandler();
    }
}

@end

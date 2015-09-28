// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitTrialMenuViewController.h"

#import "CTDApplication/CTDTrialMenuSceneInputRouter.h"



@interface CTDUIKitTrialMenuViewController ()

@end



@implementation CTDUIKitTrialMenuViewController
{
    __weak id<CTDTrialMenuSceneInputRouter> _inputRouter;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _inputRouter = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ctd_strongify(self.messageLabel, messageLabel);
    messageLabel.text = self.message;

    // Interface Builder does not allow the setting of cap insets, except on
    // UIImageView elements, so we set the button images here.

    UIImage* greenButtonImage = [[UIImage imageNamed:@"GreenButton"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage* greenButtonHighlightedImage = [[UIImage imageNamed:@"GreenButtonHighlighted"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];

    ctd_strongify(self.beginButton, beginButton);
    [beginButton setBackgroundImage:greenButtonImage forState:UIControlStateNormal];
    [beginButton setBackgroundImage:greenButtonHighlightedImage forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMessage:(NSString*)message
{
    _message = [message copy];
    ctd_strongify(self.messageLabel, messageLabel);
    messageLabel.text = message;
}



#pragma mark IBActions


- (void)beginTapped
{
    ctd_strongify(_inputRouter, inputRouter);
    [inputRouter beginButtonPressed];
}

- (void)exitTapped
{
    ctd_strongify(_inputRouter, inputRouter);
    [inputRouter exitButtonPressed];
}



#pragma mark CTDTrialMenuSceneInputSource protocol


- (void)setTrialMenuSceneInputRouter:(id<CTDTrialMenuSceneInputRouter>)sceneInputRouter
{
    _inputRouter = sceneInputRouter;
}

@end

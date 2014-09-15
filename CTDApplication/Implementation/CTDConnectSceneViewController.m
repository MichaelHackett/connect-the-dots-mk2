// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDConnectSceneViewController.h"
#import "CTDUIKitTargetView.h"
#import "CTDUIKitToolbar.h"


@interface CTDConnectSceneViewController ()

@end

@implementation CTDConnectSceneViewController
{
    CTDUIKitTargetView* _targetView;
}

//- (id)initWithNibName:(NSString*)nibNameOrNil
//               bundle:(NSBundle*)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CTDUIKitToolbar* toolbar = [[CTDUIKitToolbar alloc]
                                initWithFrame:CGRectMake(200, 50, 400, 60)];
    UIView* greenToolbarCell = [[UIView alloc]
                                initWithFrame:CGRectMake(0, 0, 100, 0)];
    greenToolbarCell.backgroundColor = [UIColor greenColor];
    UIView* redToolbarCell = [[UIView alloc]
                              initWithFrame:CGRectMake(0, 0, 100, 0)];
    redToolbarCell.backgroundColor = [UIColor redColor];
    [toolbar addSubview:greenToolbarCell];
    [toolbar addSubview:redToolbarCell];

    [self.view addSubview:toolbar];
    _targetView = [[CTDUIKitTargetView alloc]
                   initWithFrame:CGRectMake(400, 250, 75, 75)];
    [self.view addSubview:_targetView];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

// TEMP for target indicator testing
- (IBAction)showIndicator
{
    [_targetView showActivationIndicator];
}

- (IBAction)hideIndicator
{
    [_targetView hideActivationIndicator];
}

@end

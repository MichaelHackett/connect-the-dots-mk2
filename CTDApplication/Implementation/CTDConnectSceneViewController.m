// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDConnectSceneViewController.h"
#import "CTDUIKitTargetView.h"


@interface CTDConnectSceneViewController ()

@end

@implementation CTDConnectSceneViewController

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
    [self.view addSubview:[[CTDUIKitTargetView alloc]
                           initWithFrame:CGRectMake(400, 250, 75, 75)]];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end

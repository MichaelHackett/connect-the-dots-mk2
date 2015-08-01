// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDUIKitConnectTheDotsViewAdapter.h"
#import "CTDPresentation/Ports/CTDTrialRenderer.h"




@implementation CTDUIKitConnectSceneViewController
{
    CTDUIKitConnectTheDotsViewAdapter* _ctdViewAdapter;
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
    CTDUIKitConnectTheDotsView* ctdView = self.connectTheDotsView;
    NSAssert(ctdView, @"Missing outlet connection to connect-the-dots view");
    _ctdViewAdapter = [[CTDUIKitConnectTheDotsViewAdapter alloc]
                       initWithConnectTheDotsView:ctdView
                                     colorPalette:self.colorPalette];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



#pragma mark CTDConnectScene


- (id<CTDTrialRenderer>)trialRenderer
{
    return _ctdViewAdapter;
}

- (id<CTDTouchToPointMapper>)trialTouchMapper
{
    return _ctdViewAdapter;
}

@end

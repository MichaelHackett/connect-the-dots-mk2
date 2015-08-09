// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDUIKitConnectTheDotsViewAdapter.h"

#import "CTDApplication/Ports/CTDTrialRenderer.h"
#import "CTDInteraction/CTDListOrderTouchMapper.h"
#import "CTDInteraction/CTDTrialSceneTouchRouter.h"



@implementation CTDUIKitConnectSceneViewController
{
    id<CTDMutableTouchToElementMapper> _touchToDotMapper;
    CTDUIKitConnectTheDotsViewAdapter* _ctdViewAdapter;
    CTDTrialSceneTouchRouter* _touchRouter;
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

    _touchToDotMapper = [[CTDListOrderTouchMapper alloc] init];
    _ctdViewAdapter = [[CTDUIKitConnectTheDotsViewAdapter alloc]
                       initWithConnectTheDotsView:ctdView
                                     colorPalette:self.colorPalette
                                 touchToDotMapper:_touchToDotMapper];

    _touchRouter = [[CTDTrialSceneTouchRouter alloc] init];
    _touchRouter.trialStepEditor = self.trialStepEditor;
    _touchRouter.dotsTouchMapper = _touchToDotMapper;
    self.touchResponder = _touchRouter;
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



#pragma mark CTDConnectScene


- (void)setTrialStepEditor:(id<CTDTrialStepEditor>)trialStepEditor
{
    // KVO support
    NSString* propertyKey = NSStringFromSelector(@selector(trialStepEditor));
    [self willChangeValueForKey:propertyKey];
    _trialStepEditor = trialStepEditor;
    [self didChangeValueForKey:propertyKey];

    // Update external entities that share a reference to the editor.
    _touchRouter.trialStepEditor = trialStepEditor;
}

- (id<CTDTrialRenderer>)trialRenderer
{
    return _ctdViewAdapter;
}

- (id<CTDTouchToPointMapper>)trialTouchMapper
{
    return _ctdViewAdapter;
}

@end

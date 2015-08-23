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
    _touchRouter.trialEditor = self.trialEditor;
    _touchRouter.dotsTouchMapper = _touchToDotMapper;
    _touchRouter.freeEndMapper = _ctdViewAdapter;

    self.touchResponder = _touchRouter;
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



#pragma mark CTDConnectScene


- (void)setTrialEditor:(id<CTDTrialEditor>)trialEditor
{
    // KVO support
    NSString* propertyKey = NSStringFromSelector(@selector(trialEditor));
    [self willChangeValueForKey:propertyKey];
    _trialEditor = trialEditor;
    [self didChangeValueForKey:propertyKey];

    // Update external entities that share a reference to the editor.
    _touchRouter.trialEditor = trialEditor;
}

- (id<CTDTrialRenderer>)trialRenderer
{
    return _ctdViewAdapter;
}

- (id<CTDTouchToPointMapper>)trialTouchMapper
{
    return _ctdViewAdapter;
}

- (void)displayTrialCompletionMessage
{
    ctd_strongify(self.trialCompletionMessageLabel, completionMessageLabel);
    completionMessageLabel.hidden = NO;

    // disable touch input while message visible
    self.view.userInteractionEnabled = NO;
}

- (void)hideTrialCompletionMessage
{
    ctd_strongify(self.trialCompletionMessageLabel, completionMessageLabel);
    completionMessageLabel.hidden = YES;

    // reenable touch input
    self.view.userInteractionEnabled = YES;
}

@end

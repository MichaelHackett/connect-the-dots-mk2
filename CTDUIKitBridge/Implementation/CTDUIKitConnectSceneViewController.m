// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "CTDUIKitConnectSceneViewController.h"

#import "CTDStrings.h"
#import "CTDUIKitAlertViewAdapter.h"
#import "CTDUIKitConnectTheDotsView.h"
#import "CTDUIKitConnectTheDotsViewAdapter.h"
#import "CTDUIKitColorCell.h"
#import "CTDUIKitTrialBlockCompletionViewController.h"
#import "CTDUIKitTrialMenuViewController.h"

#import "CTDApplication/Ports/CTDTrialRenderer.h"
#import "CTDApplication/CTDTrialMenuSceneInputRouter.h"
#import "CTDInteraction/CTDListOrderTouchMapper.h"
#import "CTDInteraction/CTDSelectOnTapInteraction.h"
#import "CTDInteraction/CTDSelectOnTouchInteraction.h"
#import "CTDInteraction/CTDTouchTrackerFactory.h"
#import "CTDInteraction/CTDTrialSceneTouchRouter.h"
#import "CTDInteraction/Ports/CTDTrialEditor.h"




static NSDictionary* colorCellsRendererMap(NSArray* colorSelectionCells)
{
    NSMutableDictionary* cellMap =
        [NSMutableDictionary dictionaryWithCapacity:[colorSelectionCells count]];
    for (CTDUIKitColorCell* colorCell in colorSelectionCells)
    {
        [cellMap setObject:colorCell forKey:@(colorCell.cellId)];
    }
    return cellMap;
}

static id<CTDTouchToElementMapper> colorCellsTouchMapper(NSArray* colorSelectionCells)
{
    CTDListOrderTouchMapper* colorCellsTouchMapper = [[CTDListOrderTouchMapper alloc] init];
    for (CTDUIKitColorCell* colorCell in colorSelectionCells)
    {
        [colorCellsTouchMapper mapTouchable:colorCell toId:@(colorCell.cellId)];
    }
    return colorCellsTouchMapper;
}





@implementation CTDUIKitConnectSceneViewController
{
    NSDictionary* _colorCellRendererMap;
    id<CTDTouchToElementMapper> _touchToColorCellMapper;
    id<CTDMutableTouchToElementMapper> _touchToDotMapper;
    CTDUIKitConnectTheDotsViewAdapter* _ctdViewAdapter;
    CTDTrialSceneTouchRouter* _touchRouter;
    id<CTDTouchResponder> _colorCellsTouchResponder;
    CTDUIKitAlertViewAdapter* _exitConfirmationAlertAdapter;
}

- (id)initWithNibName:(NSString*)nibNameOrNil
               bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _colorBarOnRight = NO;
        // the rest are all nil refs to start
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CTDUIKitConnectTheDotsView* ctdView = self.connectTheDotsView;
    NSAssert(ctdView, @"Missing outlet connection to connect-the-dots view");
    UIView* colorBarView = self.colorSelectionBarView;
    NSAssert(colorBarView, @"Missing outlet connection to color selection bar view");

    // Swap positions of color bar and connect-the-dots view if color bar is on right.
    if (self.colorBarOnRight)
    {
        CGRect containerRect = colorBarView.superview.bounds;
        CGRect colorBarFrame = colorBarView.frame;
        // inset from right edge by the same margin it originally had from the left edge
        CGFloat colorBarRightEdge = CGRectGetMaxX(containerRect)
                                  - CGRectGetMinX(colorBarFrame); // margin from container
        colorBarFrame.origin.x = colorBarRightEdge - CGRectGetWidth(colorBarFrame);
        colorBarView.frame = colorBarFrame;

        CGRect ctdViewFrame = ctdView.frame;
        // inset from left edge by the same margin it originally had from the right edge
        ctdViewFrame.origin.x = CGRectGetMaxX(containerRect) - CGRectGetMaxX(ctdViewFrame);
        ctdView.frame = ctdViewFrame;
    }

    _colorCellRendererMap = colorCellsRendererMap(self.colorSelectionCells);
    _touchToColorCellMapper = colorCellsTouchMapper(self.colorSelectionCells);
    _touchToDotMapper = [[CTDListOrderTouchMapper alloc] init];
    _ctdViewAdapter = [[CTDUIKitConnectTheDotsViewAdapter alloc]
                       initWithConnectTheDotsView:ctdView
                                     colorPalette:self.colorPalette
                                 touchToDotMapper:_touchToDotMapper];
    _exitConfirmationAlertAdapter = nil;

    Class buttonTrackerClass = self.quasimodalButtons
                             ? [CTDSelectOnTouchInteraction class]
                             : [CTDSelectOnTapInteraction class];
    ctd_weakify(self, weakSelf);
    _colorCellsTouchResponder = [[CTDTouchTrackerFactory alloc]
                                 initWithTouchTrackerFactoryBlock:
        ^id<CTDTouchTracker>(CTDPoint* initialPosition)
        {
            ctd_strongify(weakSelf, strongSelf);
            ctd_strongify(strongSelf.trialEditor, trialEditor);
             return [[buttonTrackerClass alloc]
                     initWithSelectionEditor:[trialEditor editorForColorSelection]
                                 touchMapper:strongSelf->_touchToColorCellMapper
                        initialTouchPosition:initialPosition];
         }];

    _touchRouter = [[CTDTrialSceneTouchRouter alloc] init];
    _touchRouter.trialEditor = self.trialEditor;
    _touchRouter.dotsTouchMapper = _touchToDotMapper;
    _touchRouter.freeEndMapper = _ctdViewAdapter;
    _touchRouter.colorCellsTouchResponder = _colorCellsTouchResponder;

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

//- (id<CTDTouchToPointMapper>)trialTouchMapper
//{
//    return _ctdViewAdapter;
//}

- (NSDictionary*)colorCellRendererMap
{
    return _colorCellRendererMap;
}

- (void)displayPreTrialMenuForTrialNumber:(NSInteger)trialNumber
                              inputRouter:(id<CTDTrialMenuSceneInputRouter>)inputRouter
{
    NSString* defaultMessage =
        [NSString stringWithFormat:CTDString(@"Trial-N"), (long)trialNumber];
    NSString* overrideMessageKey =
        [NSString stringWithFormat:@"Trial-%ld", (long)trialNumber];
    NSString* pretrialMessage =
        CTDStringWithDefault(overrideMessageKey, defaultMessage);

    CTDUIKitTrialMenuViewController* trialMenuVC =
        [[CTDUIKitTrialMenuViewController alloc]
         initWithNibName:@"CTDUIKitTrialMenuScene"
         bundle:nil];
    trialMenuVC.message = pretrialMessage;
    trialMenuVC.modalPresentationStyle = UIModalPresentationFormSheet;
    trialMenuVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [trialMenuVC setTrialMenuSceneInputRouter:inputRouter];
    [self presentViewController:trialMenuVC animated:YES completion:nil];
}

- (void)hidePreTrialMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];  // TODO: Wait for completion to start trial
}

- (void)confirmExitWithResponseHandler:(CTDConfirmationResponseHandler)responseHandler
{
    _exitConfirmationAlertAdapter = [[CTDUIKitAlertViewAdapter alloc] init];
    ctd_weakify(self, weakSelf);
    _exitConfirmationAlertAdapter.responseHandler = ^(BOOL confirmed)
    {
        if (responseHandler) { responseHandler( confirmed); }
        ctd_strongify(weakSelf, strongSelf);
        strongSelf->_exitConfirmationAlertAdapter = nil;
    };

    [[[UIAlertView alloc] initWithTitle:CTDString(@"TrialBlockExitAlertTitle")
                          message:CTDString(@"TrialBlockExitAlertMessage")
                          delegate:_exitConfirmationAlertAdapter
                          cancelButtonTitle:CTDString(@"TrialBlockExitAlertCancelLabel")
                          otherButtonTitles:CTDString(@"TrialBlockExitAlertConfirmationLabel"),
                                             nil]
     show];
}

- (void)displayTrialCompletionMessageWithTimeString:(NSString*)trialTimeString
                                     bestTimeString:(NSString*)bestTimeString
{
    ctd_strongify(self.trialCompletionMessageView, completionMessageView);
    ctd_strongify(self.trialTimeLabel, trialTimeLabel);
    ctd_strongify(self.bestTimeLabel, bestTimeLabel);
    trialTimeLabel.text =
        [NSString stringWithFormat:CTDString(@"TrialTime"), trialTimeString];

    if (bestTimeString)
    {
        bestTimeLabel.text =
            [NSString stringWithFormat:CTDString(@"BestTrialTime"), bestTimeString];
    }
    else
    {
        // If "Best time" is not to be shown, reduce height of message box so
        // there isn't so much extra whitespace.
        bestTimeLabel.hidden = YES;
        CGFloat vDelta = CGRectGetMaxY(bestTimeLabel.frame)
                       - CGRectGetMaxY(trialTimeLabel.frame);
        CGRect messageFrame = completionMessageView.frame;
        messageFrame.size.height -= vDelta;
        messageFrame.origin.y += vDelta / 2.0;
        completionMessageView.frame = messageFrame;
    }

    completionMessageView.hidden = NO;

    // disable touch input while message visible
    self.view.userInteractionEnabled = NO;
}

- (void)hideTrialCompletionMessage
{
    ctd_strongify(self.trialCompletionMessageView, completionMessageView);
    completionMessageView.hidden = YES;

    // reenable touch input
    self.view.userInteractionEnabled = YES;
}

- (void)displayTrialBlockCompletionMessageWithTrialCount:(NSUInteger)trialCount
                                         totalTimeString:(NSString*)timeString
        acknowledgementHandler:(CTDAcknowledgementResponseHandler)acknowledgementHandler;
{
    CTDUIKitTrialBlockCompletionViewController* completionVC =
        [[CTDUIKitTrialBlockCompletionViewController alloc]
         initWithNibName:@"CTDUIKitTrialBlockCompletionScene"
         bundle:nil];
    completionVC.trialCount = trialCount;
    completionVC.timeString = timeString;
    completionVC.acknowledgementHandler = acknowledgementHandler;
    completionVC.modalPresentationStyle = UIModalPresentationFormSheet;
    completionVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:completionVC animated:YES completion:nil];
}

@end

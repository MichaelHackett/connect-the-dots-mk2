// Copyright 2014 Michael Hackett. All rights reserved.

#import "CTDConnectSceneViewController.h"

#import "CTDUIKitTargetView.h"
#import "CTDUIKitToolbar.h"
#import "CTDUtility/CTDPoint.h"



static CGFloat const kTargetDiameter = 75;


static CGRect frameForTargetCenteredAt(CGPoint center)
{
    CGFloat radius = kTargetDiameter / (CGFloat)2.0;
    CGFloat left = center.x - radius;
    CGFloat top = center.y - radius;
    return CGRectMake(left, top, kTargetDiameter, kTargetDiameter);
}




@interface CTDConnectSceneViewController ()

@end

@implementation CTDConnectSceneViewController
{
    NSMutableArray* _targetViews;
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
    _targetViews = [[NSMutableArray alloc] init];

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
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}



#pragma mark - CTDTargetViewRenderer protocol


- (id<CTDTargetView>)newTargetViewCenteredAt:(CTDPoint*)centerPosition
{
    CGPoint cgCenterPosition = CGPointMake(centerPosition.x, centerPosition.y);
    CTDUIKitTargetView* newTargetView =
        [[CTDUIKitTargetView alloc]
         initWithFrame:frameForTargetCenteredAt(cgCenterPosition)];
    [self.view addSubview:newTargetView];
    [_targetViews addObject:newTargetView];
    return newTargetView;
}




#pragma mark - TEMP for target indicator testing


- (IBAction)showIndicator
{
    if ([_targetViews count] >= 1) {
        [_targetViews[0] showSelectionIndicator];
    }
}

- (IBAction)hideIndicator
{
    if ([_targetViews count] >= 1) {
        [_targetViews[0] hideSelectionIndicator];
    }
}

@end

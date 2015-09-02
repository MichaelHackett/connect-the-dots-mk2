// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitConfigSceneViewController.h"



@interface CTDUIKitConfigSceneViewController ()
@end


@implementation CTDUIKitConfigSceneViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ctd_strongify(self.participantIdField, participantIdField);
    ctd_strongify(self.preferredHandPicker, preferredHandPicker);
    ctd_strongify(self.interfaceStylePicker, interfaceStylePicker);
    ctd_strongify(self.sequenceIdField, sequenceIdField);

    participantIdField.text = @"1";
    preferredHandPicker.selectedSegmentIndex = UISegmentedControlNoSegment;
    interfaceStylePicker.selectedSegmentIndex = UISegmentedControlNoSegment;
    sequenceIdField.text = @"1";
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end

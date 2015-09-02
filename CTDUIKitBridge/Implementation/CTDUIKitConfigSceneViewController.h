// CTDUIKitConfigSceneViewController:
//     Controller for the trial configuration scene.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDConfigurationScene.h"



@interface CTDUIKitConfigSceneViewController
    : UIViewController <CTDConfigurationScene>

// IB Outlets
@property (weak, nonatomic) IBOutlet UITextField *participantIdField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *preferredHandPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *interfaceStylePicker;
@property (weak, nonatomic) IBOutlet UITextField *sequenceIdField;

@end

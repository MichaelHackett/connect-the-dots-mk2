// CTDUIKitTaskConfigSceneViewController:
//     Controller for the task configuration scene.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDTaskConfigurationSceneRenderer.h"



@interface CTDUIKitTaskConfigSceneViewController
    : UIViewController <CTDTaskConfigurationSceneRenderer>

// IB Outlets
@property (weak, nonatomic) IBOutlet UITextField *participantIdField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *preferredHandPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *interfaceStylePicker;
@property (weak, nonatomic) IBOutlet UITextField *sequenceIdField;

@end

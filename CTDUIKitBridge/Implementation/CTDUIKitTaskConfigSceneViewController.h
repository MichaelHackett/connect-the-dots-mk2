// CTDUIKitTaskConfigSceneViewController:
//     Controller for the task configuration scene.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDTaskConfigurationSceneRenderer.h"
#import "CTDApplication/Ports/CTDTaskConfigurationSceneInputSource.h"



@interface CTDUIKitTaskConfigSceneViewController
    : UIViewController <CTDTaskConfigurationSceneRenderer,
                        CTDTaskConfigurationSceneInputSource>

// IB Outlets
@property (weak, nonatomic) IBOutlet UIStepper* participantIdStepper;
@property (weak, nonatomic) IBOutlet UITextField* participantIdField;
@property (weak, nonatomic) IBOutlet UISegmentedControl* preferredHandPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl* interfaceStylePicker;
@property (weak, nonatomic) IBOutlet UIStepper* sequenceIdStepper;
@property (weak, nonatomic) IBOutlet UITextField* sequenceIdField;

// IB Actions
- (IBAction)participantIdChangedByStepper;
- (IBAction)preferredHandSelectionChanged;
- (IBAction)interfaceStyleSelectionChanged;
- (IBAction)beginButtonPressed;

@end

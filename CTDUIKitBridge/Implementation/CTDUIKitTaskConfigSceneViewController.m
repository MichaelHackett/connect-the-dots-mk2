// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitTaskConfigSceneViewController.h"




@interface CTDUIKitTaskConfigSceneViewController ()
@end


@implementation CTDUIKitTaskConfigSceneViewController

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



#pragma mark CTDTaskConfigurationSceneRenderer protocol

- (void)setParticipantIdValue:(NSNumber*)participantId
{
    ctd_strongify(self.participantIdStepper, participantIdStepper);
    participantIdStepper.value = [participantId doubleValue];
}

- (void)setParticipantIdString:(NSString*)participantIdString
{
    ctd_strongify(self.participantIdField, participantIdField);
    participantIdField.text = participantIdString;
}

- (void)setPreferredHandIndex:(NSNumber*)preferredHandIndex
{
    NSInteger segmentIndex = preferredHandIndex
                           ? [preferredHandIndex integerValue]
                           : UISegmentedControlNoSegment;
    ctd_strongify(self.preferredHandPicker, preferredHandPicker);
    [preferredHandPicker setSelectedSegmentIndex:segmentIndex];
}

- (void)setInterfaceStyleIndex:(NSNumber*)interfaceStyleIndex
{
    NSInteger segmentIndex = interfaceStyleIndex
                           ? [interfaceStyleIndex integerValue]
                           : UISegmentedControlNoSegment;
    ctd_strongify(self.interfaceStylePicker, interfaceStylePicker);
    [interfaceStylePicker setSelectedSegmentIndex:segmentIndex];
}

- (void)setSequenceNumberValue:(NSNumber*)sequenceNumber
{
    ctd_strongify(self.sequenceIdStepper, sequenceIdStepper);
    sequenceIdStepper.value = [sequenceNumber doubleValue];
}

- (void)setSequenceNumberString:(NSString*)sequenceNumberString
{
    ctd_strongify(self.sequenceIdField, sequenceIdField);
    sequenceIdField.text = sequenceNumberString;
}

@end

// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitTaskConfigSceneViewController.h"

#import "CTDApplication/CTDTaskConfigurationSceneInputRouter.h"



@interface CTDUIKitTaskConfigSceneViewController ()
@end


@implementation CTDUIKitTaskConfigSceneViewController
{
    __weak id<CTDTaskConfigurationSceneInputRouter> _inputRouter;
}

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self)
    {
        _inputRouter = nil;
    }
    return self;
}

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



#pragma mark IBActions


- (IBAction)participantIdChangedByStepper
{
    ctd_strongify(_inputRouter, inputRouter);
    ctd_strongify(self.participantIdStepper, stepper);
    [inputRouter participantIdChangedTo:(NSUInteger)round(stepper.value)];
}

- (IBAction)preferredHandSelectionChanged
{
    ctd_strongify(self.preferredHandPicker, picker);
    NSInteger selectedIndex = picker.selectedSegmentIndex;
    NSNumber* newHandIndex = selectedIndex == UISegmentedControlNoSegment
                           ? nil  // no selection
                           : [NSNumber numberWithUnsignedInteger:(NSUInteger)selectedIndex];

    ctd_strongify(_inputRouter, inputRouter);
    [inputRouter preferredHandChangedTo:newHandIndex];
}

- (IBAction)beginButtonPressed
{
    ctd_strongify(_inputRouter, inputRouter);
    [inputRouter formSubmissionButtonPressed];
}



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



#pragma mark CTDTaskConfigurationSceneInputSource protocol


- (void)setTaskConfigurationSceneInputRouter:
      (id<CTDTaskConfigurationSceneInputRouter>)sceneInputRouter
{
    _inputRouter = sceneInputRouter;
}

@end

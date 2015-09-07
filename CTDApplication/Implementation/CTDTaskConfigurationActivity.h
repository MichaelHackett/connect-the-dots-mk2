// CTDTaskConfigurationActivity:
//     Session configuration screen.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTaskConfiguration;



//
// Activity Model (supplied  to activity)
//

@protocol CTDTaskConfigurationForm <NSObject>

- (void)setFormParticipantId:(NSUInteger)participantId;
- (void)setFormPreferredHand:(NSNumber*)preferredHand;  // nil or CTDHand (wrapped)
- (void)setFormInterfaceStyle:(NSNumber*)interfaceStyle; // nil or CTDInterfaceStyle (wrapped)
- (void)setFormSequenceNumber:(NSUInteger)sequenceNumber;

@end



// Editor interfaces

@protocol CTDTaskConfigurationFormEditor <NSObject>
// Reset or initialize values in form to those from the model configuration.
- (void)resetForm;
@end




@interface CTDTaskConfigurationActivity : NSObject <CTDTaskConfigurationFormEditor>

@property (weak, nonatomic) id<CTDTaskConfiguration> taskConfiguration;
@property (weak, nonatomic) id<CTDTaskConfigurationForm> taskConfigurationForm;

@end

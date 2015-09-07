// CTDTaskConfigurationActivity:
//     Session configuration screen.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDNotificationReceiver;
@protocol CTDTaskConfiguration;



// Notifications
FOUNDATION_EXPORT NSString * const CTDTaskConfigurationCompletedNotification;



//
// Activity Model (supplied  to activity)
//

@protocol CTDTaskConfigurationForm <NSObject>

- (void)setFormParticipantId:(NSUInteger)participantId;
- (void)setFormPreferredHand:(NSNumber*)preferredHand;  // nil or CTDHand (wrapped)
- (void)setFormInterfaceStyle:(NSNumber*)interfaceStyle; // nil or CTDInterfaceStyle (wrapped)
//- (void)setFormSequenceNumber:(NSUInteger)sequenceNumber;

@end



// Editor interfaces

@protocol CTDTaskConfigurationFormEditor <NSObject>

// Reset or initialize values in form to those from the model configuration.
- (void)resetForm;
// Validate form values and update the model configuration (if validation passes).
- (void)acceptConfiguration;

- (void)changeParticipantIdTo:(NSUInteger)newParticipantId;
- (void)changePreferredHandTo:(NSNumber*)newPreferredHand;
- (void)changeInterfaceStyleTo:(NSNumber*)newInterfaceStyle;

@end




@interface CTDTaskConfigurationActivity : NSObject <CTDTaskConfigurationFormEditor>

@property (weak, nonatomic) id<CTDTaskConfiguration> taskConfiguration;
@property (weak, nonatomic) id<CTDTaskConfigurationForm> taskConfigurationForm;
@property (weak, nonatomic) id<CTDNotificationReceiver> notificationReceiver;

@end

// Copyright 2015 Michael Hackett. All rights reserved.


@protocol CTDApplicationState <NSObject>

- (NSNumber*)participantId;
- (NSNumber*)preferredHand;
- (NSNumber*)interfaceStyle;
- (NSArray*)sequenceOrder; // of NSNumber -- the order in which to present the sequences
- (NSNumber*)trialIndex;
- (NSArray*)trialDurations; // of NSNumber (containing NSTimeInterval values)

@end


@protocol CTDMutableApplicationState <NSObject>

- (void)setParticipantId:(NSNumber*)participantId;
- (void)setPreferredHand:(NSNumber*)preferredHand;
- (void)setInterfaceStyle:(NSNumber*)interfaceStyle;
- (void)setSequenceOrder:(NSArray*)sequenceOrder; // of NSNumber -- the order in which to present the sequences
- (void)setTrialIndex:(NSNumber*)trialIndex;
- (void)setTrialDurations:(NSArray*)trialDurations;

@end



@protocol CTDAppStateRecorder <NSObject>

- (id<CTDApplicationState>)savedApplicationState;
- (void)updateSavedApplicationStateWithBuilder:(void (^)(id<CTDMutableApplicationState> state))builder;

@end

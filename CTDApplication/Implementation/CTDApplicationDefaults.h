// CTDApplicationDefaults:
//     Default values used by various types, available for use by tests (to
//     verify that values are set as expected, without repeating the values in
//     the tests).
//
// Copyright 2015 Michael Hackett. All rights reserved.


@interface CTDApplicationDefaults : NSObject

+ (NSUInteger)taskConfigurationFormDefaultParticipantId;
+ (NSNumber*)taskConfigurationFormDefaultPreferredHand;
+ (NSNumber*)taskConfigurationFormDefaultInterfaceStyle;
+ (NSUInteger)taskConfigurationFormDefaultSequenceNumber;

@end

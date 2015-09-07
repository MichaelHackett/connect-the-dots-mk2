// CTDNotificationRecorder.h
//     A CTDNotificationReceiver that simply records the messages it receives.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUtility/CTDNotificationReceiver.h"


//
// The properties of a captured notification
//
@interface CTDRecordedNotification : NSObject

@property (copy, nonatomic) NSString* notificationId;
@property (strong, nonatomic) id sender;
@property (copy, nonatomic) NSDictionary* info;

@end



@interface CTDNotificationRecorder : NSObject <CTDNotificationReceiver>

@property (copy, readonly, nonatomic) NSArray* receivedNotifications;

@end

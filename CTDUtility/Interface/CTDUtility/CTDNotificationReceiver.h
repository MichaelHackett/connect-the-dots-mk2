// CTDNotificationReceiver:
//     A receiver of general notifications.
//
//     Can be implemented directly by any recipients or by a "Notice Board"
//     object that broadcasts messages to several recipients.
//
// TODO: Make adapter for NSNotificationCenter as a broadcaster.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDNotificationReceiver <NSObject>

- (void)receiveNotification:(NSString*)notificationId
                 fromSender:(id)sender
                   withInfo:(NSDictionary*)info;

@end

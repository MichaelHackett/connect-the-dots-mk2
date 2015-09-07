// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDNotificationRecorder.h"



// Just a bag of properties (really, a struct).
@implementation CTDRecordedNotification
@end




@implementation CTDNotificationRecorder
{
    NSMutableArray* _receivedNotifications;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _receivedNotifications = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reset
{
    [_receivedNotifications removeAllObjects];
}

- (NSArray*)receivedNotifications
{
    return [_receivedNotifications copy];
}

- (void)receiveNotification:(NSString*)notificationId
                 fromSender:(id)sender
                   withInfo:(NSDictionary*)info
{
    CTDRecordedNotification* notification = [[CTDRecordedNotification alloc] init];
    notification.notificationId = notificationId;
    notification.sender = sender;
    notification.info = info;

    [_receivedNotifications addObject:notification];
}

@end

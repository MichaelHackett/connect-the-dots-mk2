// CTDConnectionActivity:
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTrialEditor.h"
@protocol CTDTrialScript;
@protocol CTDTrialRenderer;
@protocol CTDNotificationReceiver;



// Notifications
FOUNDATION_EXPORT NSString * const CTDTrialCompletedNotification;



@interface CTDConnectionActivity : NSObject <CTDTrialEditor>

- (instancetype)initWithTrialScript:(id<CTDTrialScript>)trialScript
                trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                colorCellRenderers:(NSDictionary*)colorCellRenderers
                trialCompletionNotificationReceiver:(id<CTDNotificationReceiver>)notificationReceiver;

CTD_NO_DEFAULT_INIT

@end

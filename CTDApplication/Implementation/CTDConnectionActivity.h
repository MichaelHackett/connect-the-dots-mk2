// CTDConnectionActivity:
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInteraction/Ports/CTDTrialEditor.h"
#import "CTDModel/CTDDotColor.h"
@protocol CTDTimeSource;
@protocol CTDTrialResults;
@protocol CTDTrialScript;
@protocol CTDTrialRenderer;
@protocol CTDNotificationReceiver;



// Notifications
FOUNDATION_EXPORT NSString * const CTDTrialCompletedNotification;



// Access to Activity model

@protocol CTDDotConnection <NSObject>

- (void)setFreeEndPosition:(CTDPoint*)freeEndPosition;
- (void)establishConnection;
- (void)invalidate;

@end


@protocol CTDTrial <NSObject>

- (void)selectColor:(CTDDotColor)color;

// More to come --- this is just to allow the next stage of tests to be written.
@end




@interface CTDConnectionActivity : NSObject <CTDTrial, CTDTrialEditor>

- (instancetype)initWithTrialScript:(id<CTDTrialScript>)trialScript
                 trialResultsHolder:(id<CTDTrialResults>)trialResultsHolder
                      trialRenderer:(id<CTDTrialRenderer>)trialRenderer
                 colorCellRenderers:(NSDictionary*)colorCellRenderers
                         timeSource:(id<CTDTimeSource>)timeSource
trialCompletionNotificationReceiver:(id<CTDNotificationReceiver>)notificationReceiver;

CTD_NO_DEFAULT_INIT

@end

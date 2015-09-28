// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/CTDDialogResponseHandler.h"



/**
 * Acts as a reverse-adapter for UIAlertViews to send notifications back to
 * the application when the user has made a selection in the alert. Can be
 * subclassed to customize the alert view through additional
 * UIAlertViewDelegate methods.
 */
@interface CTDUIKitAlertViewAdapter : NSObject <UIAlertViewDelegate>

/// The block to invoke when the alert is dismissed by pressing one of its buttons.
@property (copy, nonatomic) CTDConfirmationResponseHandler responseHandler;

@end

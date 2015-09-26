// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDUIKitAlertViewAdapter.h"


@implementation CTDUIKitAlertViewAdapter

- (void)alertView:(UIAlertView*)alertView
        clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.responseHandler)
    {
        // Action is "confirmed" if a button other than "Cancel" is pressed.
        self.responseHandler(buttonIndex != alertView.cancelButtonIndex);
    }
}

@end

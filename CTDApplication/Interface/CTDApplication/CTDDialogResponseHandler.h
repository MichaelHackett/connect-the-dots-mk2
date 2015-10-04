// Copyright 2015 Michael Hackett. All rights reserved.


/// A block to process the response from an "OK/Cancel" question being presented to the user.
typedef void (^CTDConfirmationResponseHandler)(BOOL confirmed);

/// A block to be invoked after the user has acknowledged some presented message (e.g., by tapping "OK").
typedef void (^CTDAcknowledgementResponseHandler)(void);


// TODO: Add handlers for other types of questions/dialogs.

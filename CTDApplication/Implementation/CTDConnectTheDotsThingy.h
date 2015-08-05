// CTDConnectTheDotsThingy:
//     The thing that loads the data, starts the activity and implements the
//     editor commands from Interactors. Don't know what to call it. ("Scene"
//     is taken for the protocol between the Application and the UI Bridge,
//     but that might be applicable here. Could use "View" or "SceneRenderer"
//     for the other.)
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDInteraction/Ports/CTDTrialStepEditor.h"

@protocol CTDConnectScene;



@interface CTDConnectTheDotsThingy : NSObject <CTDTrialStepEditor>

+ (instancetype)prepareTrialScene:(id<CTDConnectScene>)connectScene;

- (void)start;

@end

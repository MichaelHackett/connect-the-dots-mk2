// CTDTaskConfigurationScene:
//     Presentation model implementation for the task configuration activity.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDTaskConfigurationActivity.h"
#import "CTDTaskConfigurationSceneInputRouter.h"
@protocol CTDTaskConfigurationSceneRenderer;



@interface CTDTaskConfigurationScene : NSObject <CTDTaskConfigurationForm,
                                                 CTDTaskConfigurationSceneInputRouter>

@property (weak, nonatomic) id<CTDTaskConfigurationSceneRenderer> sceneRenderer;
@property (weak, nonatomic) id<CTDTaskConfigurationFormEditor> configurationFormEditor;

@end

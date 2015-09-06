// CTDTaskConfigurationActivity:
//     Session configuration screen.
//
// Copyright 2015 Michael Hackett. All rights reserved.

@protocol CTDTaskConfiguration;



//
// Activity Model (supplied  to activity)
//

@protocol CTDTaskConfigurationForm <NSObject>
@end



// Editor interfaces

@protocol CTDTaskConfigurationFormEditor <NSObject>
@end




@interface CTDTaskConfigurationActivity : NSObject <CTDTaskConfigurationFormEditor>

@property (weak, nonatomic) id<CTDTaskConfiguration> taskConfiguration;
@property (weak, nonatomic) id<CTDTaskConfigurationForm> taskConfigurationForm;

@end

// UIKit:
//     Gateway for UIKit framework.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#include <UIKit/UIKit.h>


@interface UIKit : NSObject

+ (UIWindow*)fullScreenWindowWithRootViewController:(UIViewController*)rootViewController
                                    backgroundColor:(UIColor*)color;

@end

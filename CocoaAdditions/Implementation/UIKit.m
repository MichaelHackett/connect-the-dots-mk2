// Copyright 2015 Michael Hackett. All rights reserved.

#import "UIKit.h"

@implementation UIKit

+ (UIWindow*)fullScreenWindowWithRootViewController:(UIViewController*)rootViewController
                                    backgroundColor:(UIColor*)backgroundColor
{
    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = rootViewController;
    window.backgroundColor = backgroundColor;
    return window;
}

@end

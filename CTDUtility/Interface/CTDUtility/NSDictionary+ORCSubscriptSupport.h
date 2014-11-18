// NSArray+ORCSubscriptSupport:
//     Compatibility declarations to allow NSDictionary shorthand subscripting
//     with SDKs prior to iOS 6 and OSX 10.8.
//
// The compiler in Xcode 4.4+ (and perhaps earlier) needs to see these
// declarations in order to emit the appropriate method calls, but apparently
// Clang actually includes implementations of these methods in a library that
// that is automatically linked in with ARC-enabled code (libarclite), so we
// only need to provide the declaration, not the implementation!
//
// See:
//     http://lists.apple.com/archives/cocoa-dev/2012/Aug/msg00636.html
//     http://lists.apple.com/archives/cocoa-dev/2012/Aug/msg00640.html
// or:
//     http://www.cocoabuilder.com/archive/cocoa/321091-how-to-make-obj-collection-subscripting-work-on-ios-5.html
//
// Copyright 2014 Michael Hackett. All rights reserved.

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < 60000)

#import <Foundation/NSDictionary.h>

@interface  NSDictionary (ORCSubscriptSupport)
- (id)objectForKeyedSubscript:(id)key NS_AVAILABLE(10_6, 5_0);
@end

@interface  NSMutableDictionary (ORCSubscriptSupport)
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key NS_AVAILABLE(10_6, 5_0);
@end

#endif

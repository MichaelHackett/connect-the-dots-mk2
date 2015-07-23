// CTDFakeTouchMapper:
//     A stand-in for a CTDTouchToElementMapper that simply looks up the given
//     point in the supplied dictionary and returns whatever the point maps to
//     (nil if the point is not in the dictionary).
//
// Copyright (c) 2014 Michael Hackett. All rights reserved.

#import "Ports/CTDTouchMappers.h"



@interface CTDFakeTouchMapper : NSObject <CTDTouchToElementMapper>

- (instancetype)initWithPointMap:(NSDictionary*)pointToElementMap;
CTD_NO_DEFAULT_INIT

@end

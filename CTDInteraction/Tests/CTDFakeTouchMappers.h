// CTDFakeTouchMappers:
//     Stand-ins for the various touch-to-activity-model mappers, such as
//     CTDTouchToPointMapper and CTDTouchToElementMapper.
//
// CTDFakeTouchToElementMapper:
//     A mapper that simply looks up the given point in the supplied dictionary
//     and returns whatever the point maps to (nil if the point is not in th
//     dictionary).
//
// CTDFakeTouchToPointMapper:
//     Same as the element mapper, but the supplied dictionary should map
//     CTDPoints to CTDPoints.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "Ports/CTDTouchMappers.h"



@interface CTDFakeTouchToElementMapper : NSObject <CTDTouchToElementMapper>

- (instancetype)initWithPointMap:(NSDictionary*)pointToElementMap;
CTD_NO_DEFAULT_INIT

@end



@interface CTDFakeTouchToPointMapper : NSObject <CTDTouchToPointMapper>

- (instancetype)initWithPointMap:(NSDictionary*)pointToPointMap;
CTD_NO_DEFAULT_INIT

@end

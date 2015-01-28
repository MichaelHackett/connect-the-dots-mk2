// CTDIntegerQuantity:
//     An integer quantity, consisting of a magnitude (number) and unit of
//     measure.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@interface CTDIntegerQuantity : NSObject

@property (assign, readonly, nonatomic) NSInteger magnitude;

- (instancetype)initWithMagnitude:(NSInteger)magnitude
                             unit:(NSString*)unit;
- (instancetype)initWithMagnitude:(NSInteger)magnitude
                     unitSingular:(NSString*)unitSingular
                       unitPlural:(NSString*)unitPlural;
CTD_NO_DEFAULT_INIT

@end

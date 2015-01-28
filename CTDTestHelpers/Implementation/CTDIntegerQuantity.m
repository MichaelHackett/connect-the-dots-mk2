// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDIntegerQuantity.h"



@implementation CTDIntegerQuantity
{
    NSString* _unitSingular;
    NSString* _unitPlural;
}

- (instancetype)initWithMagnitude:(NSInteger)magnitude
                     unitSingular:(NSString*)unitSingular
                       unitPlural:(NSString*)unitPlural
{
    self = [super init];
    if (self) {
        _magnitude = magnitude;
        _unitSingular = [unitSingular copy];
        _unitPlural = [unitPlural copy];
    }
    return self;
}

- (instancetype)initWithMagnitude:(NSInteger)magnitude
                             unit:(NSString*)unit
{
    return [self initWithMagnitude:magnitude
                      unitSingular:unit
                        unitPlural:[NSString stringWithFormat:@"%@s", unit]];
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD

- (NSString*)description
{
    return [NSString stringWithFormat:@"%u %@",
            self.magnitude,
            self.magnitude == 1 ? _unitSingular : _unitPlural];
}

@end

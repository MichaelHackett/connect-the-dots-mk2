// Copyright 2014-5 Michael Hackett. All rights reserved.

#import "NSArray+CTDAdditions.h"


@implementation NSArray (CTDAdditions)

+ (id)ctd_arrayWithSize:(NSUInteger)count
             usingBlock:(id (^)(NSUInteger index))factory
{
  if (!factory) {
    return [NSArray array];
  }
  NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:count];
  for (NSUInteger i = 0; i < count; i++) {
    [tempArray addObject:factory(i)];
  }
  return [tempArray copy];
}

+ (NSArray*)ctd_arrayOfIntegersFrom:(NSInteger)startingNumber
                                 to:(NSInteger)endingNumber
{
    // Shift numbers from signed to unsigned integer range, to avoid potential
    // overflow when finding the difference between them.
    NSUInteger startingOffset = (NSUInteger)(startingNumber - NSIntegerMin);
    NSUInteger endingOffset = (NSUInteger)(endingNumber - NSIntegerMin);

    NSMutableArray* array = nil;
    if (startingNumber <= endingNumber)
    {
        // Ascending list
        NSUInteger elementCount = endingOffset - startingOffset + 1;
        array = [NSMutableArray arrayWithCapacity:elementCount];
        for (NSInteger i = startingNumber; i <= endingNumber; i += 1)
        {
            [array addObject:@(i)];
        }
    }
    else
    {
        // Descending list
        NSUInteger elementCount = startingOffset - endingOffset + 1;
        array = [NSMutableArray arrayWithCapacity:elementCount];
        for (NSInteger i = startingNumber; i >= endingNumber; i -= 1)
        {
            [array addObject:@(i)];
        }
    }

    return [array copy];
}

- (void)ctd_forEach:(void (^)(id element))action
{
  [self enumerateObjectsUsingBlock:^(id element, __unused NSUInteger index, __unused BOOL* stop) {
    action(element);
  }];
}

// TODO: Needs unit tests
- (NSArray*)ctd_map:(id (^)(id))elementMapper
{
  NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:[self count]];
  [self ctd_forEach:^(id element) {
    [newArray addObject:elementMapper(element)];
  }];
  return [newArray copy];
}

- (NSArray*)ctd_select:(BOOL (^)(id element))elementFilter
{
  NSMutableArray* newArray = [NSMutableArray array];
  [self ctd_forEach:^(id element) {
    if (elementFilter(element)) {
      [newArray addObject:element];
    }
  }];
  return [newArray copy];
}

// TODO: Needs tests
- (NSArray*)ctd_except:(id)elementToRemove
{
  return [self ctd_select:^BOOL(id element) {
    return (element != elementToRemove);
  }];
}

@end

// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDDefaultRandomalizer.h"


@implementation CTDDefaultRandomalizer

- (NSArray*)randomizeList:(NSArray*)originalList
                     seed:(unsigned long)seed
{
    NSMutableArray* outputList = [originalList mutableCopy];
    NSUInteger listLength = [outputList count];
    if (listLength >= 2)
    {
        // Generate new order by starting from first position and picking one of the
        // elements from that position to the end of the array, and swapping those
        // two elements. Then advance and repeat until reaching the end of the array
        // (stopping after the second-to-last element, as the last place would always
        // have only itself to choose from).
        srandom(seed);
        for (NSUInteger i = 0; i < listLength - 1; i += 1) // stop after second-to-last element
        {
            NSUInteger nextIndex = (NSUInteger)(random() % (long)(listLength - i)) + i;
            [outputList exchangeObjectAtIndex:i withObjectAtIndex:nextIndex];
        }
    }
    NSLog(@"%@", [outputList componentsJoinedByString:@", "]);

    return outputList;
}

@end

// Additions to NSArray class.
//
// Copyright 2014-5 Michael Hackett. All rights reserved.

@interface NSArray (CTDAdditions)

/**
 * Calls the block `count` times, passing a 0-based index (incremented with
 * each subsequent call), and adds the objects returned by the block to the
 * array, in the order returned.
 */
+ (id)ctd_arrayWithSize:(NSUInteger)count
             usingBlock:(id (^)(NSUInteger index))factory;

/**
 * Create an array containing a sequence of integers (wrapped in NSNumbers),
 * _including_ both the starting and ending values. If the starting number is
 * less than the ending number, the list will be ascending order; if the
 * starting number is greater, the list will be in descending order.
 *
 * @param startingNumber
 *     The first number of the sequence.
 * @param endingNumber 
 *     The final number of the sequence.
 */
+ (NSArray*)ctd_arrayOfIntegersFrom:(NSInteger)startingNumber
                                 to:(NSInteger)endingNumber;

/// Perform an action with each item in the array.
- (void)ctd_forEach:(void (^)(id element))action;

/// Produces a new array containing the results of processing the elements of
/// the receiver with the block, in order.
- (NSArray*)ctd_map:(id (^)(id element))elementMapper;

/// Produces a new array containing only the elements for which the filter
/// returns YES, retaining relative element ordering.
- (NSArray*)ctd_select:(BOOL (^)(id element))elementFilter;

/// Returns a copy of the array, save for the specified element (if present).
- (NSArray*)ctd_except:(id)elementToRemove;

@end

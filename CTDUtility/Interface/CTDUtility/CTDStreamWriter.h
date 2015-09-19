// CTDStreamWriter:
//     Buffered, non-blocking interface to an NSOutputStream. This greatly
//     simplifies the work needed to write to any type of stream in a
//     non-blocking way.
//
// Copyright 2015 Michael Hackett. All rights reserved.


@interface CTDStreamWriter : NSObject

+ (instancetype)writeToURL:(NSURL*)destinationUrl;

// Designated initializer
- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream
                  scheduledOnRunLoop:(NSRunLoop*)runLoop
                         runLoopMode:(NSString*)runLoopMode;

// Default to main run loop and default run loop mode.
- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream;

CTD_NO_DEFAULT_INIT


- (void)appendString:(NSString*)string;
- (void)appendData:(NSData*)data;
- (void)closeStream;

@end

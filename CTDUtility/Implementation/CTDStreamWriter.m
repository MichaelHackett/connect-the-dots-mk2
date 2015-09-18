// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDStreamWriter.h"



// Initial output buffer size; can grow as needed.
const NSUInteger kOutputBufferInitialSize = 1024; // in bytes



@interface CTDStreamWriterBuffer : NSObject

- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream;
CTD_NO_DEFAULT_INIT

- (BOOL)isEmpty;
- (void)appendData:(NSData*)data;
- (void)writeBufferDataToStream;

@end




// Maintains strong references to CTDStreamWriters that have been closed but
// which still have some buffered data to be flushed. Objects are removed from
// the list when their buffers have been emptied.
static NSMutableArray* writersInFinalFlush = nil;



@interface CTDStreamWriter () <NSStreamDelegate>
@end



@implementation CTDStreamWriter
{
    NSOutputStream* _outputStream;
    __weak NSRunLoop* _runLoop;
    NSString* _runLoopMode;
    CTDStreamWriterBuffer* _outputBuffer;
    BOOL _outputStreamHasSpace;
    BOOL _streamClosed;
}

+ (void)initialize
{
    if (self != [CTDStreamWriter class]) { return; }
    writersInFinalFlush = [[NSMutableArray alloc] init];
}

- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream
                  scheduledOnRunLoop:(NSRunLoop*)runLoop
                         runLoopMode:(NSString*)runLoopMode
{
    self = [super init];
    if (self)
    {
//        NSStreamStatus streamStatus = [outputStream streamStatus];
//        NSAssert(streamStatus <= NSStreamStatusOpen || streamStatus == NSStreamStatusWriting,
//                 @"Output stream in invalid state (%lu); should either not be open or be open for writing",
//                 (unsigned long)streamStatus);
        NSAssert([outputStream streamStatus] == NSStreamStatusNotOpen,
                 @"Output stream must not yet be opened");

        _outputStream = outputStream;
        _runLoop = runLoop;
        _runLoopMode = [runLoopMode copy];
        _outputBuffer = [[CTDStreamWriterBuffer alloc] initWithOutputStream:outputStream];
        _outputStreamHasSpace = NO;
        _streamClosed = NO;

        outputStream.delegate = self;
        [outputStream scheduleInRunLoop:runLoop forMode:runLoopMode];
        [outputStream open];
    }
    return self;

}

- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream
{
    return [self initWithOutputStream:outputStream
                   scheduledOnRunLoop:[NSRunLoop mainRunLoop]
                          runLoopMode:NSDefaultRunLoopMode];
}

- (id)init CTD_BLOCK_PARENT_METHOD


- (void)appendString:(NSString*)string
{
    [self appendData:[string dataUsingEncoding:NSASCIIStringEncoding]];
}

- (void)appendData:(NSData*)data
{
    NSAssert(!_streamClosed, @"Attempt to append data to stream after it has been closed");
//    if (_streamClosed) { return; }

    [_outputBuffer appendData:data];
    if (_outputStreamHasSpace)
    {
        _outputStreamHasSpace = NO;
        [_outputBuffer writeBufferDataToStream];
    }
}

- (void)closeStream
{
    if (_streamClosed) { return; }
    _streamClosed = YES;

    if (![_outputBuffer isEmpty])
    {
        // Keep a strong ref to the writer until all buffered data has been written.
        // (See stream:handleEvent: for the code that handles delayed closing.)
        [writersInFinalFlush addObject:self];
    }
    else
    {
        [_outputStream close];
        [_outputStream removeFromRunLoop:_runLoop forMode:_runLoopMode];
        _outputStream.delegate = nil;
    }
}



// NSStreamDelegate implementation

- (void)stream:(NSStream*)stream
   handleEvent:(NSStreamEvent)eventCode
{
    NSAssert(stream == _outputStream,
             @"Received NSStreamDelegate notification for unexpected stream");

    if (eventCode == NSStreamEventHasSpaceAvailable)
    {
        if (![_outputBuffer isEmpty])
        {
            [_outputBuffer writeBufferDataToStream];
        }
        else
        {
            if ([writersInFinalFlush containsObject:self])
            {
                [_outputStream close];
                [_outputStream removeFromRunLoop:_runLoop forMode:_runLoopMode];
                _outputStream.delegate = nil;
                // This may remove the last strong ref to self, so do it last.
                [writersInFinalFlush removeObject:self];
            }
            else
            {
                _outputStreamHasSpace = YES;
            }
        }
    }
}

@end

// TODO: Whenever there is data waiting to be written, we should periodically
// try to push it out, even if the 'outputStreamHasSpace' flag is NO, to avoid
// having the output stream get jammed while the framework thinks it has sent
// the notification that there is space, but our flag is out of sync.





@implementation CTDStreamWriterBuffer
{
    NSOutputStream* _outputStream;
    NSMutableData* _outputBuffer;
}

- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream
{
    self = [super init];
    if (self)
    {
        _outputStream = outputStream;
        _outputBuffer = [[NSMutableData alloc] initWithCapacity:kOutputBufferInitialSize];
    }
    return self;
}

- (id)init CTD_BLOCK_PARENT_METHOD;

- (BOOL)isEmpty
{
    return [_outputBuffer length] == 0;
}

- (void)appendData:(NSData*)data
{
    [_outputBuffer appendData:data];
}

/**
 * Push as much data from the output buffer onto the output stream as it will
 * allow, removing the sent data from the buffer. (There may still be unwritten
 * data left in the buffer after this method returns, if the stream would only
 * accept a portion without blocking. That data will be the next sent when this
 * method is called again.
 */
- (void)writeBufferDataToStream
{
    NSMutableData* data = _outputBuffer;
    if (data.length == 0) { return; }

    NSInteger bytesWritten = [_outputStream write:[data bytes]
                                        maxLength:data.length];
    if (bytesWritten <= 0) { return; }

    // remove sent data from start of buffer
    [data replaceBytesInRange:NSMakeRange(0, (NSUInteger)bytesWritten)
                    withBytes:NULL
                       length:0];
}

@end

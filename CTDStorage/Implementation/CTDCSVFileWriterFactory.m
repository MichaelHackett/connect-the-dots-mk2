// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDCSVFileWriterFactory.h"

#import "CTDStreamWriter.h"
#import "CTDCSVStreamTrialResults.h"
#import "CTDModel/CTDTrial.h"



@implementation CTDCSVFileWriterFactory

+ (NSURL*)documentsDirectoryOrError:(NSError**)error
{
    NSURL* documentsURL = [[NSFileManager defaultManager]
                           URLForDirectory:NSDocumentDirectory
                           inDomain:NSUserDomainMask
                           appropriateForURL:nil
                           create:YES
                           error:error];
    return documentsURL;
}

- (id<CTDTrialBlockResults>)
      trialBlockResultsForParticipantId:(NSUInteger)participantId
                          preferredHand:(CTDHand)preferredHand
                         interfaceStyle:(CTDInterfaceStyle)interfaceStyle
                                  error:(NSError**)error
{
    NSURL* documentsURL = [[self class] documentsDirectoryOrError:error];
    if (!documentsURL) { return nil; }

    NSString* filename = [NSString stringWithFormat:@"P%02lu%c.csv",
                          (unsigned long)participantId,
                          interfaceStyle == CTDModalInterfaceStyle ? 'M' : 'Q'];

    NSURL* blockResultsURL = [documentsURL URLByAppendingPathComponent:filename];

    // TODO: Verify that no file exists at this path

    CTDStreamWriter* blockResultsStreamWriter =
        [CTDStreamWriter writerForURL:blockResultsURL];

    return [[CTDCSVStreamTrialBlockResults alloc]
            initWithParticipantId:participantId
                    preferredHand:preferredHand
                   interfaceStyle:interfaceStyle
               outputStreamWriter:blockResultsStreamWriter];

}

//- (id<CTDTrialResults>)trialResultsForTrialNumber:(NSUInteger)trialNumber
//{
//
//}

@end

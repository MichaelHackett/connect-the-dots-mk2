// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDAppStateFileArchiver.h"


// Archive filename (relative to base directory)
static NSString * const appStateArchiveFilename = @"appstate.plist";

// Archive element keys
static NSString * const participantIdKey = @"participantId";
static NSString * const preferredHandKey = @"preferredHand";
static NSString * const interfaceStyleKey = @"interfaceStyle";
static NSString * const sequenceOrderKey = @"sequenceOrder";
static NSString * const trialIndexKey = @"trialIndex";




@interface CTDAppStateFileArchiver_Proxy : NSObject <CTDApplicationState, CTDMutableApplicationState>

@property (copy, nonatomic) NSNumber* participantId;
@property (copy, nonatomic) NSNumber* preferredHand;
@property (copy, nonatomic) NSNumber* interfaceStyle;
@property (copy, nonatomic) NSArray* sequenceOrder;
@property (copy, nonatomic) NSNumber* trialIndex;

@end

@implementation CTDAppStateFileArchiver_Proxy
@end




@implementation CTDAppStateFileArchiver

+ (NSURL*)appStateDirectoryOrError:(NSError**)error
{
    return [[NSFileManager defaultManager]
            URLForDirectory:NSApplicationSupportDirectory
            inDomain:NSUserDomainMask
            appropriateForURL:nil
            create:YES
            error:error];
}

+ (NSString*)appStateSavePathOrError:(NSError**)error
{
    NSURL* appStateDir = [self appStateDirectoryOrError:error];
    if (!appStateDir) { return nil; }
    return [[appStateDir URLByAppendingPathComponent:appStateArchiveFilename] path];
}

/// Handles errors by logging them and returning nil.
+ (NSString*)appStateSavePath
{
    NSError* error = nil;
    NSString* appStateArchivePath = [[self class] appStateSavePathOrError:&error];
    if (!appStateArchivePath)
    {
        NSLog(@"Unable to get app-state save path; error = %@",
              [error localizedDescription]);
    }
    return appStateArchivePath;
}

- (void)updateSavedApplicationStateWithBuilder:(void (^)(id<CTDMutableApplicationState>))builder
{
    CTDAppStateFileArchiver_Proxy* appState =
        [[CTDAppStateFileArchiver_Proxy alloc] init];
    builder(appState);

    NSString* appStateArchivePath = [[self class] appStateSavePath];
    if (!appStateArchivePath) { return; }

    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:appState.participantId forKey:participantIdKey];
    [archiver encodeObject:appState.preferredHand forKey:preferredHandKey];
    [archiver encodeObject:appState.interfaceStyle forKey:interfaceStyleKey];
    [archiver encodeObject:appState.sequenceOrder forKey:sequenceOrderKey];
    [archiver encodeObject:appState.trialIndex forKey:trialIndexKey];
    [archiver finishEncoding];

    NSError* error = nil;
    BOOL successful = [data writeToFile:appStateArchivePath
                                options:NSDataWritingAtomic
                                  error:&error];
    if (!successful)
    {
        NSLog(@"Unable to save application state; error = %@", [error localizedDescription]);
    }
}

- (id<CTDApplicationState>)savedApplicationState
{
    NSString* appStateArchivePath = [[self class] appStateSavePath];
    if (!appStateArchivePath) { return nil; }

    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfFile:appStateArchivePath
                                          options:0
                                            error:&error];
    if (!data)
    {
        // Ignore file-not-found errors; report others.
        if (!(error.domain == NSCocoaErrorDomain &&
              (error.code == NSFileNoSuchFileError ||
               error.code == NSFileReadNoSuchFileError)))
        {
            NSLog(@"Unable to load application state; error = %@",
                  [error localizedDescription]);
        }
        return nil;
    }

    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]
                                     initForReadingWithData:data];
    CTDAppStateFileArchiver_Proxy* appState =
        [[CTDAppStateFileArchiver_Proxy alloc] init];
    appState.participantId = [unarchiver decodeObjectForKey:participantIdKey];
    appState.preferredHand = [unarchiver decodeObjectForKey:preferredHandKey];
    appState.interfaceStyle = [unarchiver decodeObjectForKey:interfaceStyleKey];
    appState.sequenceOrder = [unarchiver decodeObjectForKey:sequenceOrderKey];
    appState.trialIndex = [unarchiver decodeObjectForKey:trialIndexKey];
    [unarchiver finishDecoding];

    return appState;
}

@end

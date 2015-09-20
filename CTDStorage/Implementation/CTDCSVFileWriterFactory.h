// CTDCSVFileWriterFactory.h
//     Factory for CTDTrialResults and CTDTrialBlockResults implementations
//     that store the result data in CSV format in local files (under the
//     app's Documents directory, currently).
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDApplication/Ports/CTDTrialResultsFactory.h"


@interface CTDCSVFileWriterFactory : NSObject <CTDTrialResultsFactory>

@end

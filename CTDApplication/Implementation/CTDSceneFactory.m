// Copyright 2015 Michael Hackett. All rights reserved.

#import "CTDSceneFactory.h"

#import "CTDUIKitDrawingConfig.h"
#import "CTDUIPlugins/CTDUIKitConnectSceneViewController.h"


static NSString* const kCTDUIKitConnectSceneViewControllerNibName =
          @"CTDUIKitConnectSceneViewController";

// Merge drawing config into this class (rather than separate class)?
// If config gets loaded from a file eventually, then makes sense to keep it separate.



@implementation CTDSceneFactory
{
    CTDUIKitDrawingConfig* _drawingConfig;
}


#pragma mark Initialization


- (instancetype)initWithDrawingConfig:(CTDUIKitDrawingConfig*)drawingConfig
{
    self = [super init];
    if (self) {
        _drawingConfig = drawingConfig;
    }
    return self;
}

- (instancetype)init CTD_BLOCK_PARENT_METHOD



#pragma mark Factory methods


- (CTDUIKitConnectSceneViewController*)connectScene
{
    CTDUIKitConnectSceneViewController* vc =
        [[CTDUIKitConnectSceneViewController alloc]
         initWithNibName:kCTDUIKitConnectSceneViewControllerNibName
                  bundle:nil];
    vc.connectionLineWidth = _drawingConfig.connectionLineWidth;
    vc.connectionLineColor = _drawingConfig.connectionLineColor;
    vc.colorPalette = _drawingConfig.colorPalette;

    return vc;
}

@end

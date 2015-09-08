// CTDTrialRendererSpy:
//     Test spy implementation of CTDTrialRenderer; uses its own fake
//     implementations of CTDDotRenderer and CTDDotConnectionRenderer.
//
// Copyright 2015 Michael Hackett. All rights reserved.

#import "Ports/CTDTrialRenderer.h"
#import "CTDUtility/CTDPoint.h"



@interface CTDTrialRendererSpy : NSObject <CTDTrialRenderer>

// Configuration for dot position mapping
@property (assign, nonatomic) CTDPointCoordinate dotSpaceMargin;
@property (assign, nonatomic) CTDPointCoordinate dotSpaceWidth;
@property (assign, nonatomic) CTDPointCoordinate dotSpaceHeight;

// Both of these return only the currently visible renderings. This is so that
// tests don't need to care whether the implementation creates renderings only
// when needed for display, or pre-creates them hidden and just shows and hides
// them as needed.
@property (strong, nonatomic, readonly) NSArray* dotRenderings; // of CTDFakeDotRenderings
@property (strong, nonatomic, readonly) NSArray* connectionRenderings; // of CTDFakeConnectionRendering

@end



@interface CTDFakeDotRendering : NSObject <CTDDotRenderer>

// Captured rendering state:
@property (copy, readonly, nonatomic) CTDPoint* dotCenterPosition;
@property (copy, readonly, nonatomic) CTDPaletteColorLabel dotColor;
@property (assign, readonly, nonatomic) BOOL isVisible;
@property (assign, readonly, nonatomic) BOOL hasSelectionIndicator;

@end



@interface CTDFakeConnectionRendering : NSObject <CTDDotConnectionRenderer>

// Captured rendering state:
@property (copy, nonatomic) CTDPoint* firstEndpointPosition;
@property (copy, nonatomic) CTDPoint* secondEndpointPosition;
@property (assign, readonly, nonatomic) BOOL isVisible;

@end

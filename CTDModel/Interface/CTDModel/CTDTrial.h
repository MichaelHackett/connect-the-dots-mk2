// CTDTrial:
//     Describes an individual trial within the experimental task.
//
// Copyright 2015 Michael Hackett. All rights reserved.


typedef enum
{
    CTDLeftHand,
    CTDRightHand
}
CTDHand;

typedef enum
{
    CTDModalInterfaceStyle,
    CTDQuasimodalInterfaceStyle
}
CTDInterfaceStyle;



// Not sure if there needs to be a Domain-Model type for a trial; maybe just
// the properties above (used in both the trial results and Activity Model).
// Or maybe, in the Domain Model, a "trial" is the results of the _completed_
// trial, while the Activity Model acts as an Editor for that object.

//@protocol CTDTrial <NSObject>
//@end

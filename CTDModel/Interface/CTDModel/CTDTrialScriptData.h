// CTDTrialScriptData:
//     Raw data used to build run-time trial-script structures.
//
// Copyright 2015 Michael Hackett. All rights reserved.


typedef struct {
    unsigned int dotColor;
    double x1, y1, x2, y2;
} CTDTrialStepData;

typedef struct {
    unsigned int stepCount;  // need this here to appease compiler, even if same for all sequences
    CTDTrialStepData steps[];
} CTDTrialSequenceData;

typedef struct {
    unsigned int sequenceCount;
    CTDTrialSequenceData sequences[];
} CTDTrialScriptData;



extern CTDTrialScriptData trialScriptData;

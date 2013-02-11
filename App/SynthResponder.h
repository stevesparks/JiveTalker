//
//  SynthResponder.h
//  JiveTalker
//
//  Created by Steve Sparks on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TalkItem.h"

@interface SynthResponder : NSResponder {
	NSSpeechSynthesizer *synth;
	BOOL performing;
	NSDictionary *talkItems;
}
@property (nonatomic) BOOL performing;
@property (nonatomic, retain) NSDictionary *talkItems;
@property (nonatomic, retain) NSSpeechSynthesizer *synth;


@end


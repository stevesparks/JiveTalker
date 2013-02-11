//
//  SynthResponder.m
//  JiveTalker
//
//  Created by Steve Sparks on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SynthResponder.h"


@implementation SynthResponder
@synthesize synth;
@synthesize performing;
@synthesize talkItems;


- (BOOL)acceptsFirstResponder {
	NSLog(@"Accepting");
	return YES;
}

- (BOOL)becomeFirstResponder {
	NSLog(@"Becoming");
	return YES;
}

- (BOOL)resignFirstResponder {
	NSLog(@"Resigning");
	return YES;
}

// performance player

- (void) keyDown: (NSEvent *)event {
	if ( [event isARepeat] ) return;
	if(!performing) return;
	
	TalkItem *t = [talkItems objectForKey:[[event characters] uppercaseString]];
	if(t != nil) {
//		if([synth isSpeaking]) [synth stopSpeaking];
		[t speak:synth];
		NSLog(@"Speak %x", synth);
	}
}

- (void) keyUp: (NSEvent *)event {
	if(!performing) return;
	
	TalkItem *t = [talkItems objectForKey:[[event characters] uppercaseString]];
	if(t != nil) {
		if (! [t sustain]) {
			[synth setVolume:0.0];
			NSLog(@"Stop %x", synth);
			[synth stopSpeaking];
		}
	}
}



@end

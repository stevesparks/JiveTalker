//
//  TalkItem.m
//  TalkBalk
//
//  Created by Steve Sparks on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TalkItem.h"

@implementation TalkItem
@synthesize pitchBase;
@synthesize modulation;
@synthesize rate;
@synthesize volume;
@synthesize text;
@synthesize voice;
@synthesize sustain;

- (id) init {
	[super init];

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	text = @"";
	pitchBase = [NSNumber numberWithInt:0];
	rate = [[NSNumber numberWithInt:150] retain];
	volume = [[NSNumber numberWithInt:1] retain];
	modulation = [NSNumber numberWithInt:0];
	sustain = YES;
	
	voice = @"com.apple.speech.synthesis.voice.Zarvox";
	[pool release];
	
	return self;
}

- (id) initLike: (TalkItem *)orig {
	[self init];
	
	if(orig != nil) {
		
		pitchBase = [[orig pitchBase] copy];
		modulation = [[orig modulation] copy];
		rate = [[orig rate] copy];
		volume = [[orig volume] copy];
		text = [[orig text] copy];
		voice = [[orig voice] copy];
		sustain = [orig sustain];
		
	}
	return self;
}


- (void) speak: (NSSpeechSynthesizer *)synth {

    [synth setVoice:voice];

	[synth setObject:[NSNumber numberWithInt:([pitchBase intValue] + 60)] 
		 forProperty:NSSpeechPitchBaseProperty 
			   error:nil];
	
	[synth setObject:modulation
		 forProperty:NSSpeechPitchModProperty 
			   error:nil];
	[synth setObject:rate
		 forProperty:NSSpeechRateProperty 
			   error:nil];
	[synth setObject:volume
		 forProperty:NSSpeechVolumeProperty 
			   error:nil];
	
	[synth startSpeakingString:text];
}

- (void) encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:pitchBase forKey:@"pitchBase"];
	[coder encodeObject:modulation forKey:@"modulation"];
	[coder encodeObject:rate forKey:@"rate"];
	[coder encodeObject:volume forKey:@"volume"];
	[coder encodeObject:text forKey:@"text"];
	[coder encodeObject:voice forKey:@"voice"];
	[coder encodeBool:sustain forKey:@"sustain"];	
}

- (id) initWithCoder:(NSCoder *)coder {
	[super init];
	
	self.pitchBase = [coder decodeObjectForKey:@"pitchBase"];
	self.modulation = [coder decodeObjectForKey:@"modulation"];
	self.rate = [coder decodeObjectForKey:@"rate"];
	self.volume = [coder decodeObjectForKey:@"volume"];
	self.text = [coder decodeObjectForKey:@"text"];
	self.voice = [coder decodeObjectForKey:@"voice"];
	self.sustain = [coder decodeBoolForKey:@"sustain"];
	
	return self;
}


@end

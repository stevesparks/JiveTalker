//
//  TalkItem.h
//  TalkBalk
//
//  Created by Steve Sparks on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TalkItem : NSObject <NSCoding> {
	NSNumber *pitchBase;
	NSNumber *modulation;
	NSNumber *rate;
	NSNumber *volume;
	NSString *text;
	NSString *voice;
	BOOL sustain;
}
@property (nonatomic, retain) NSNumber *pitchBase;
@property (nonatomic, retain) NSNumber *modulation;
@property (nonatomic, retain) NSNumber *rate;
@property (nonatomic, retain) NSNumber *volume;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *voice;
@property (nonatomic) BOOL sustain;

- (void) speak: (NSSpeechSynthesizer *)synth ;
- (id) initLike: (TalkItem *)orig;

@end

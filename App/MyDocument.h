//
//  MyDocument.h
//  JiveTalker
//
//  Created by Steve Sparks on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "SynthResponder.h"
#import "ColorButton.h"

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface TalkerDocument : NSDocument
#else
@interface TalkerDocument : NSDocument <NSApplicationDelegate, NSSpeechSynthesizerDelegate> 
#endif
{
	NSWindow *window;
	
	SynthResponder *myResponder;
	
	
	NSSpeechSynthesizer *synth;
	NSNumberFormatter *fmt;
	NSArray *phonemes;	
	NSMutableArray *voices;
	NSText *textEditor;
	ColorButton *lastButton;
	NSColor *black;
	NSColor *red;
	NSColor *grey;
	
	IBOutlet NSTextField *fileInfoField;
	TalkItem *nullItem;
	TalkItem *currentItem;
	NSMutableDictionary *talkItems;
	NSMutableDictionary *buttons;
	
	IBOutlet NSWindow *myWindow;
	IBOutlet NSArrayController *arrayController;
	IBOutlet NSTextField *phraseField;
	IBOutlet NSTextField *pitchBaseField;
	IBOutlet NSTextField *modulationField;
	IBOutlet NSTextField *rateField;
	IBOutlet NSTextField *volumeField;
	IBOutlet NSButton *sustainCheckbox;
	IBOutlet NSPopUpButton *voiceList;
	IBOutlet NSBox *editBox;
	IBOutlet NSButton *disclosureButton;
	IBOutlet NSTextField *currentlyEditing;
	IBOutlet NSTextField *editLabel;
	
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain) TalkItem *nullItem;
@property (nonatomic, retain) TalkItem *currentItem;
@property (nonatomic, retain) NSMutableDictionary *talkItems;


@property (nonatomic, retain) NSSpeechSynthesizer *synth;

@property (nonatomic, retain) IBOutlet NSWindow *myWindow;
@property (nonatomic, retain) IBOutlet NSTextField *phraseField;
@property (nonatomic, retain) IBOutlet NSPopUpButton *voiceList;
@property (nonatomic, retain) IBOutlet NSTextField *pitchBaseField;
@property (nonatomic, retain) IBOutlet NSTextField *modulationField;
@property (nonatomic, retain) IBOutlet NSTextField *rateField;
@property (nonatomic, retain) IBOutlet NSTextField *fileInfoField;
@property (nonatomic, retain) IBOutlet NSTextField *volumeField;
@property (nonatomic, retain) IBOutlet NSButton *disclosureButton;
@property (nonatomic, retain) IBOutlet NSButton *sustainCheckbox;
@property (nonatomic, retain) IBOutlet NSTextField *currentlyEditing;
@property (nonatomic, retain) IBOutlet NSTextField *editLabel;
@property (nonatomic, retain) IBOutlet NSArrayController *arrayController;
@property (nonatomic, retain) IBOutlet NSBox *editBox;

@property (nonatomic, retain) NSNumberFormatter *fmt;
@property (nonatomic, retain) NSArray *phonemes;
@property (nonatomic, retain) NSMutableArray *voices;
@property (nonatomic, retain) NSMutableDictionary *buttons;
@property (nonatomic, retain) NSColor *black;
@property (nonatomic, retain) NSColor *red;
@property (nonatomic, retain) NSColor *grey;

- (IBAction)speak:(id)sender;
- (IBAction)stopSpeaking:(id)sender;
- (IBAction)selectButton:(id)sender;
- (IBAction)disclosureButtonTriggered:(id)sender;
- (void) displayCurrentItem;
- (BOOL) commit ;
- (int) findIndexOfVoice:(NSString *)vName;
@end

//
//  MyDocument.m
//  JiveTalker
//
//  Created by Steve Sparks on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"

@implementation TalkerDocument

@synthesize window;
@synthesize myWindow;
@synthesize synth;
@synthesize phraseField; 
@synthesize voiceList;
@synthesize pitchBaseField;
@synthesize modulationField;
@synthesize rateField;
@synthesize volumeField;
@synthesize editLabel;
@synthesize editBox;
@synthesize disclosureButton;
@synthesize sustainCheckbox;
@synthesize currentlyEditing;
@synthesize arrayController;
@synthesize fmt;
@synthesize phonemes;
@synthesize voices;
@synthesize buttons;
@synthesize fileInfoField;
@synthesize nullItem;
@synthesize currentItem;
@synthesize talkItems;

@synthesize black;
@synthesize red;
@synthesize grey;

- (id)init
{
    self = [super init];
    if (self) {
		black = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		red = [NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:1.0];
		grey = [NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:1.0];

        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		synth = [[NSSpeechSynthesizer alloc] init]; //start with default voice
		//	[synth setDelegate:self];
		phonemes = [synth objectForProperty:NSSpeechPhonemeSymbolsProperty error:nil];
		
		//// Populate the list of available voices
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSArray *voiceSrc = [NSSpeechSynthesizer availableVoices];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		int ctr = 0;
		for(NSString *str in voiceSrc) {
			NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:str];
			
			[arr addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
							[dict objectForKey:NSVoiceName], @"name", 
							str, @"value", 
							[NSNumber numberWithInt:ctr], @"order", nil]];
			ctr++;
		}
		
		voices = [arr copy];
		[arr release];

		// UI formatter
		fmt = [[NSNumberFormatter alloc] init];	
		[fmt setNumberStyle:NSNumberFormatterDecimalStyle];
		
		myResponder = [[SynthResponder alloc] init];
		myResponder.synth = synth;
		myResponder.performing = NO;
		[pool drain];
		
    }
    return self;
}

- (void) dealloc {
	[window release];
	[myWindow release];
	[myResponder release];
	[synth release];
	[phraseField release];
	[voiceList release];
	[pitchBaseField release];
	[modulationField release];
	[rateField release];
	[volumeField release];
	[editLabel release];
	[editBox release];
	[disclosureButton release];
	[sustainCheckbox release];
	[currentlyEditing release];
	[arrayController release];
	[fmt release];
	[phonemes release];
	[voices release];
	[buttons release];
	[fileInfoField release];
	[nullItem release];
	[currentItem release];
	[talkItems release];
	[black release];
	[red release];
	[grey release];
	[super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	[aController setShouldCloseDocument:YES];
	// find the editor 
	textEditor = [myWindow fieldEditor:YES forObject:phraseField];
	
	// find the letter buttons
	buttons = [[NSMutableDictionary alloc] init];
	
	NSLog(@"View Hunting");
	NSArray *vws = [[[editBox subviews] objectAtIndex:0] subviews];
	
	for ( NSView *sv in vws ) {
		//		NSLog(@"Found view %@", [sv description]);
		if ( [sv isKindOfClass:[ColorButton class]] ) {
			ColorButton *bt = (ColorButton *)sv;
			if ( [[bt title] length] == 1 ){
		//		NSLog(@"Found button %@", [bt title]);
				[buttons setObject:bt forKey:[bt title]];
				[bt setTextColor:grey];
				[bt setBezelStyle:NSSmallSquareBezelStyle];

			}
		}
	}
	
	
	//	// Create the startup talk item.

//	
//	currentItem = nullItem;

	// wait til we're done in case we're loading a doc
	if(talkItems == nil) {
		[fileInfoField setStringValue:@"- new file -"] ;
		talkItems = [[NSMutableDictionary alloc] init];
		myResponder.talkItems = talkItems;
		
		nullItem = [[TalkItem alloc] init];
		nullItem.text = @"JyveTalker";
		nullItem.pitchBase = [NSNumber numberWithInt:-12];
		nullItem.rate = [NSNumber numberWithInt:120];
		nullItem.volume = [NSNumber numberWithFloat:1.0];
		nullItem.voice = @"com.apple.speech.synthesis.voice.Zarvox";
		
		[nullItem speak:synth];
		
	} else {
		NSURL *fu = [self fileURL];
		NSArray *parts = [[fu path] componentsSeparatedByString:@"/"];
		NSString *filename = [parts objectAtIndex:[parts count]-1];		
		[fileInfoField setStringValue:filename] ;

		[disclosureButton setState:NSOffState];
		[self disclosureButtonTriggered:disclosureButton];
		
		for ( NSString *kk in [talkItems allKeys] ) {
			//			TalkItem *ti = [r objectForKey:kk];
			ColorButton *cb = [buttons objectForKey:kk];
//			NSLog(@"Old: %d", [cb bezelStyle]);
			[cb setBezelStyle:NSTexturedSquareBezelStyle];
			[cb setTextColor:black];
		}
	}
	[arrayController setContent:voices];
	[voiceList selectItemAtIndex:[voices count]-1]; // last one, commonly 'zarvox'	
	
	
	
	
	// Let's scan the buttons and build an array of them
}

- (BOOL) windowShouldClose:(id)sender {
	NSLog(@"Should??");
	return YES;
}

- (IBAction)stopSpeaking:(id)sender
{
	[synth stopSpeaking];
}

- (IBAction)speak:(id)sender
{
    NSString *text = [phraseField stringValue];
    NSString *voiceID =[[NSSpeechSynthesizer availableVoices] objectAtIndex:[voiceList indexOfSelectedItem]];
    [synth setVoice:voiceID];
	
	int p = [[pitchBaseField stringValue] intValue];
	p = p + 60;
	
	NSNumber *num = [NSNumber numberWithInt:p];
	
	[synth setObject:num 
		 forProperty:NSSpeechPitchBaseProperty 
			   error:nil];
	
	[synth setObject:[fmt numberFromString:[modulationField stringValue]]
		 forProperty:NSSpeechPitchModProperty 
			   error:nil];
	[synth setObject:[fmt numberFromString:[rateField stringValue]]
		 forProperty:NSSpeechRateProperty 
			   error:nil];
	[synth setObject:[fmt numberFromString:[volumeField stringValue]] 
		 forProperty:NSSpeechVolumeProperty 
			   error:nil];	
	[synth startSpeakingString:text];
}

- (BOOL) commit {
	if (currentItem == nil || lastButton == nil) 
		return YES;

	currentItem.text = [phraseField stringValue];
	currentItem.modulation = [fmt numberFromString:[modulationField stringValue]];
	
	NSString *pbS = [pitchBaseField stringValue];
	NSNumber *pb = [fmt numberFromString:pbS];
	currentItem.pitchBase = pb;
	currentItem.rate = [fmt numberFromString:[rateField stringValue]];
	currentItem.volume = [fmt numberFromString:[volumeField stringValue]];
	currentItem.sustain = [sustainCheckbox state] == NSOnState;
	
	NSDictionary *thisVoice = [voices objectAtIndex:[voiceList indexOfSelectedItem]];
	currentItem.voice = [thisVoice objectForKey:@"value"];
	
	if(lastButton != nil)
		[talkItems setObject:currentItem forKey:[lastButton title]];
	
	// Manage undo
	[self updateChangeCount:NSChangeDone];
	
	return YES;
}

/**** DEBUG: Adding Undo

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
	NSLog(@"Control %x = %@", control, [control description]);
	NSLog(@"Text %x = %@", fieldEditor, [fieldEditor description]);
	
	
	if(currentItem == nil) return YES; // it just doesnt matter

	NSString *nuu = [fieldEditor string];
	NSString *prev = nil;

	if(control == phraseField) {
		prev = currentItem.text;
		NSLog(@"new phrase [%@]", nuu);
		// validate
		// compare
		if(![[fieldEditor string] isEqualToString:prev]) {
			currentItem.text = nuu;
			[[[self undoManager] prepareWithInvocationTarget:currentItem] setText:prev];
			NSLog(@"undo added");
		} 
		// create undo step
		// set new value in object
	} else if(control == modulationField) {
		NSLog(@"new modulation [%@]", [fieldEditor string]);
		// validate
		// compare
		// create undo step
		// set new value in object
	} else if(control == pitchBaseField) {
		NSLog(@"new pitch base [%@]", [fieldEditor string]);
		// validate
		// compare
		// create undo step
		// set new value in object
	} else if(control == rateField) {
		NSLog(@"new rate [%@]", [fieldEditor string]);
		// validate
		// compare
		// create undo step
		// set new value in object
	} else if(control == volumeField) {
		NSLog(@"new volume [%@]", [fieldEditor string]);
		// validate
		// compare
		// create undo step
		// set new value in object
	}
	return YES;
}
*/
 
 
- (void) displayCurrentItem {

	if(currentItem == nil) {
		return;
	}

	if(currentItem.text)
		[phraseField setStringValue:[currentItem text]];
	else 
		[phraseField setStringValue:@""];

	[modulationField setStringValue:[[currentItem modulation] stringValue]];
	[pitchBaseField setStringValue:[[currentItem pitchBase] stringValue]];
	[rateField setStringValue:[[currentItem rate] stringValue]];
	[volumeField setStringValue:[[currentItem volume] stringValue]];
	
	// TODO voice
	int vv = [self findIndexOfVoice:[currentItem voice]];
	[voiceList selectItemAtIndex:vv];
	
	//    NSString *voiceID =[[NSSpeechSynthesizer availableVoices] objectAtIndex:[voiceList indexOfSelectedItem]];
	
	[sustainCheckbox setState:(currentItem.sustain?NSOnState:NSOffState)];

	[myWindow display];
}


- (IBAction)selectButton:(id)sender {
	if(lastButton != nil) 
		[lastButton setTextColor:black];
	[self commit];

	[sender setTextColor:red];
	[sender setBezelStyle:NSTexturedSquareBezelStyle];
	[currentlyEditing setStringValue:[sender title]];
	
	TalkItem *t = [talkItems objectForKey:[sender title]];
	if(t == nil) {
		t = [[[TalkItem alloc] initLike:currentItem] autorelease];
		[talkItems setObject:t forKey:[sender title]];
	}
	
	currentItem = t;
	[self displayCurrentItem];
	lastButton = sender;
}


- (IBAction)disclosureButtonTriggered:(id)sender {
	// Save previous values!
	[self commit];
	
	NSWindow *swindow = [sender window];
    NSRect frame = [swindow frame];
    // The extra +14 accounts for the space between the box and its neighboring views
    CGFloat sizeChange = [editBox frame].size.height + 14;
    switch ([sender state]) {
        case NSOnState:
            // Show the extra box.
            [editBox setHidden:NO];
            // Make the window bigger.
            frame.size.height += sizeChange;
            // Move the origin.
            frame.origin.y -= sizeChange;
			[editLabel setStringValue:@"EDIT MODE"];
			myResponder.performing = NO;
            break;
        case NSOffState:
            // Hide the extra box.
            [editBox setHidden:YES];
            // Make the window smaller.
            frame.size.height -= sizeChange;
            // Move the origin.
            frame.origin.y += sizeChange;
			
			[editLabel setStringValue:@"PERFORMANCE MODE"];
			[myWindow makeFirstResponder:myResponder];
			
			myResponder.performing = YES;
			
            break;
        default:
            break;
    }
    [swindow setFrame:frame display:YES animate:YES];	
}

- (void) setFileURL:(NSURL *)absoluteURL {
	[super setFileURL:absoluteURL];
	NSURL *fu = [self fileURL];
	NSArray *parts = [[fu path] componentsSeparatedByString:@"/"];
	NSString *filename = [parts objectAtIndex:[parts count]-1];		
	[fileInfoField setStringValue:filename] ;
	
//	[fileInfoField setStringValue:[absoluteURL lastPathComponent]] ;
}

- (int) findIndexOfVoice:(NSString *)vName {
	int ctr = 0;
	
	NSArray *systemVoices = [NSSpeechSynthesizer availableVoices];
	
	for(NSString *v in systemVoices) {
		if( [v isEqual:vName])
			return ctr;
		ctr++;
	}
	return 0;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	[self commit];
	return [NSKeyedArchiver archivedDataWithRootObject:talkItems];

}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	NSMutableDictionary * r = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	if (r != nil) {
		[self setTalkItems:r];
		[myResponder setTalkItems:r];
	} else {
		return NO;
	}

	return YES;
}

- (void) changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue {
	[obj setValue:newValue forKeyPath:keyPath]; 
}

- (void) observeValueForKeyPath:(NSString *)keyPath 
					   ofObject:(id)object 
						 change:(NSDictionary *)change 
						context:(void *)context {
	NSUndoManager *undo = [self undoManager];
	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	
	if (oldValue == [NSNull null]) oldValue = nil;
	
	[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
	[undo setActionName:@"Edit"];
}

@end

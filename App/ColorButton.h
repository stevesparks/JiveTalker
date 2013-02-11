//
//  NSButton+TextColor.h
//  TalkBalk
//
//  Created by Steve Sparks on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorButton : NSButton {

}

- (NSColor *)textColor;
- (void)setTextColor:(NSColor *)textColor;

@end
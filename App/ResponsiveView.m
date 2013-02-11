//
//  ResponsiveView.m
//  LiveTalker
//
//  Created by Steve Sparks on 1/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResponsiveView.h"


@implementation ResponsiveView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

//- (void)drawRect:(NSRect)dirtyRect {
//    // Drawing code here.
//}



- (BOOL)acceptsFirstResponder {
	return YES;
}


@end

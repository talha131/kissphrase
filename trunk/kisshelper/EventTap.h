//
//  EventTap.h
//  EventTap
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface EventTap : NSObject {
	CFMachPortRef _ref;
	NSMutableString * _buffer;
}

// Enable the event tap.
- (void)enable;

// Disable the event tap.
- (void)disable;

// Called whenever a key event is received.
- (void)keyEventReceived:(NSEvent*)event;

// Called whenever an entire word has been received.
- (void)wordReceived:(NSString *)word;

- (void)clearBuffer;

@end

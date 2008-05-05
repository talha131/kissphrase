//
//  EventTap.m
//  EventTap
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import "EventTap.h"

// How many characters to keep track of in the buffer.
static int const MAX_BUFFER_LENGTH = 50;

@interface EventTap (Private)

// The event tap receives the key up events.
- (void)createEventTap;

// Remove when we don't need it anymore (and before exiting).
- (void)destroyEventTap;

// This function is called when an event occurrs which we're tapping.
CGEventRef MyEventTapCallBack (CGEventTapProxy proxy,
							   CGEventType type,
							   CGEventRef event,
							   void *refcon);

@end


@implementation EventTap

- (id) init {
	self = [super init];
	if (self != nil) {	
		_ref = NULL;
		_buffer = [[NSMutableString stringWithCapacity:MAX_BUFFER_LENGTH + 1] retain];		
	}
	return self;
}

- (void) dealloc {
	[self disable];
	[_buffer release];
	
	[super dealloc];
}

- (void)enable {
	[self createEventTap];
}

- (void)disable {
	[self destroyEventTap];
}

- (void)keyEventReceived:(NSEvent*)event {
	// This method should be as efficient as possible since it will be called every time the 
	// user types a key on their keyboard!  It's not quite as efficient as I'd like at this point,
	// but it doesn't appear to slow things down...
	
	NSString * chars = [event characters];
	
	// Don't know how to handle this case, so just abort.
	if ([chars length] != 1) return;
	
	#if DEBUG
	NSLog(@"%@ (%u)", chars, [event keyCode]);
	NSLog(@"buffer is %@", _buffer);
	#endif	
	
	if ([chars characterAtIndex:0] == 127) {
		// Delete pressed, so remove last character from buffer.		
		if ([_buffer length] >= 1)
			[_buffer deleteCharactersInRange:NSMakeRange([_buffer length] - 1, 1)];
		return;
	}
	
	if ([chars isEqualToString:@" "] || [chars isEqualToString:@"\n"] || [chars isEqualToString:@"\r"] || [chars isEqualToString:@"\t"]) {
		// Remove all whitespace and new line characters from front and end.
		NSString * word = [[[_buffer copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] autorelease];		

		[self clearBuffer];		
		[self wordReceived:word];

		return;
	}
	
	[_buffer appendString:chars];
	
	// If buffer is too long, pop off the oldest character.
	if ([_buffer length] > MAX_BUFFER_LENGTH) [_buffer deleteCharactersInRange:NSMakeRange(0, 1)];
}

- (void)wordReceived:(NSString *)word {
}

- (void)clearBuffer {
	#if DEBUG
	NSLog(@"clearing buffer %@", _buffer);
	#endif 
	
	[_buffer deleteCharactersInRange:NSMakeRange(0, [_buffer length])];
}

@end

@implementation EventTap (Private)

- (void)createEventTap {

	// What events should we listen for?
	CGEventMask mask = CGEventMaskBit(kCGEventKeyUp);
	
	_ref = CGEventTapCreate(kCGAnnotatedSessionEventTap,
							kCGTailAppendEventTap,
							kCGEventTapOptionListenOnly,
							mask,
							MyEventTapCallBack, 
							self);
	
	CFRunLoopSourceRef sourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, _ref, 0);
	
	NSRunLoop * loop = [NSRunLoop mainRunLoop];
	CFRunLoopAddSource([loop getCFRunLoop], sourceRef, kCFRunLoopCommonModes);

}

// Callback for the event tap which is called every time the user types a key.
CGEventRef MyEventTapCallBack (CGEventTapProxy proxy,
							   CGEventType type,
							   CGEventRef event,
							   void *refcon) {
	
	// Convert to an NSEvent.
	[(EventTap*)refcon keyEventReceived:[NSEvent eventWithCGEvent:event]];

	return event;
}


- (void)destroyEventTap {
	if (_ref) {	
		#if DEBUG
		NSLog(@"Destroying event tap.");
		#endif 
		
		CFRunLoopSourceRef sourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, _ref, 0);
		
		NSRunLoop * loop = [NSRunLoop mainRunLoop];
		CFRunLoopRemoveSource([loop getCFRunLoop], sourceRef, kCFRunLoopCommonModes);

		CFRelease(_ref);
		_ref = NULL;
	}
}



@end

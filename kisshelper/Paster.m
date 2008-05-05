//
//  Paster.m
//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "Paster.h"

// Class extention (private).
@interface Paster ()

- (void)selectAndPaste:(NSString*)value;

@end

@implementation Paster

@synthesize substitutionDictionary = _substitutions;

- (id) init {
	self = [super init];
	if (self != nil) {				
		self.substitutionDictionary = [NSMutableDictionary dictionaryWithObject:@"This is a test snippit." forKey:@"test"];
				
		NSDictionary * errors = nil;
		_pasteScript = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\"\ntry\nkeystroke (ASCII character 28) using {option down, shift down}\nkeystroke \"v\" using {command down}\nend try\nend tell"];
		[_pasteScript compileAndReturnError:&errors];
		
		[self addObserver:self
			   forKeyPath:@"substitutions"
				  options:(NSKeyValueObservingOptionNew)
				  context:NULL];		
		
	}
	return self;
}

- (void) dealloc {
	[self removeObserver:self forKeyPath:@"substitutions"];
	
	[_pasteScript release];	
	[_substitutions release];
	[_oldTypes release];
	[_oldData release];
	
	[super dealloc];
}


- (void)selectAndPaste:(NSString*)value {
	
	NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
	
	// Save old data from the paste board.
	[_oldTypes release];
	_oldTypes = [[pasteBoard types] retain];
	[_oldData release];
	_oldData = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	for (id type in _oldTypes) {
		[_oldData setObject:[pasteBoard dataForType:type] forKey:type];
	}
	
	// Insert our new string.
	[pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
	[pasteBoard setString:value forType:NSStringPboardType];
	
	//	NSLog(@"%@", [pasteBoard types]);
	
	// Select the key word the user typed and paste the replacement string.
	NSDictionary * executeErrors = nil;
	NSAppleEventDescriptor * descriptor = [_pasteScript executeAndReturnError:&executeErrors];
	if ([executeErrors count] > 0) {
		NSLog([executeErrors description]);
	}
	
	// The applescript takes a bit of time to actually paste the data, so if we restore
	// the paste board data too quickly, the script ends up pasting the original data rather
	// than our replacement data.
	
	// Ideally, we'd have some method of figuring out when the paste has completed rather than
	// setting an arbitrary delay here.
	[self performSelector:@selector(restorePasteBoardData) withObject:nil afterDelay:0.55];
	
	/*
	 // This way doesn't seem to work correctly.
	 
	 CGEventRef commandDown	=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)55, true);
	 CGEventRef commandUp	=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)55, false);
	 
	 CGEventRef shiftDown	=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)56, true);
	 CGEventRef shiftUp		=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)56, false);
	 
	 CGEventRef optionDown	=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)58, true);
	 CGEventRef optionUp		=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)58, false);
	 
	 CGEventRef vDown		=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)47, true);
	 CGEventRef vUp			=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)47, false);
	 
	 CGEventRef leftDown		=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)123, true);
	 CGEventRef leftUp		=	CGEventCreateKeyboardEvent(NULL, (CGKeyCode)123, false);
	 
	 CGEventPost(kCGHIDEventTap, shiftDown);
	 CGEventPost(kCGHIDEventTap, optionDown);
	 CGEventPost(kCGHIDEventTap, leftDown);
	 
	 CGEventPost(kCGHIDEventTap, leftUp);	
	 CGEventPost(kCGHIDEventTap, optionUp);
	 CGEventPost(kCGHIDEventTap, shiftUp);
	 
	 CGEventPost(kCGAnnotatedSessionEventTap, commandDown);
	 CGEventPost(kCGAnnotatedSessionEventTap, vDown);
	 CGEventPost(kCGAnnotatedSessionEventTap, vUp);
	 CGEventPost(kCGAnnotatedSessionEventTap, commandUp);
	 
	 CFRelease(commandDown);
	 CFRelease(commandUp);
	 CFRelease(shiftDown);
	 CFRelease(shiftUp);
	 CFRelease(optionDown);
	 CFRelease(optionUp);
	 CFRelease(vDown);
	 CFRelease(vUp);
	 CFRelease(leftDown);
	 CFRelease(leftUp);
	 */	
}

- (void)restorePasteBoardData {
	// Replace the original paste board data.
	NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
	
	[pasteBoard declareTypes:_oldTypes owner:self];
	
	for (id type in _oldTypes) {
		[pasteBoard setData:[_oldData objectForKey:type] forType:type];
	}

	[self clearBuffer];
}



- (void)wordReceived:(NSString *)word {
	[super wordReceived:word];
	
	NSString * value = nil;
	
	if (value = [_substitutions valueForKey:word]) {
		[self selectAndPaste:value];
	}
		
}

@end

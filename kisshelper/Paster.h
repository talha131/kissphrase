//
//  Paster.h
//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import "EventTap.h"

@interface Paster : EventTap {
	
	// Paste board.
	NSArray * _oldTypes;								// Old paste board types.
	NSMutableDictionary * _oldData;						// Old paste board data.
	
	NSAppleScript * _pasteScript;						// This compiled applescript handles the pasting.
	NSMutableDictionary * _substitutions;				// Dictionary of substitutions to apply.
}

@property (nonatomic, retain) NSMutableDictionary * substitutionDictionary;

- (void)wordReceived:(NSString *)word;

@end

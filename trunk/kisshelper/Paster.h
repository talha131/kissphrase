//
//  Paster.h
//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


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

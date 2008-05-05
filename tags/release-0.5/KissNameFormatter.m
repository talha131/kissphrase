//
//  KissNameFormatter.m
//
//  Created by Ryan on 3/4/08.
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

#import "KissNameFormatter.h"


// Don't let the keyword be longer than 25 chars.
static int const MAX_KEY_LENGTH = 25;


@implementation KissNameFormatter

- (id)init {
	if (self = [super init]) {
				
	}	
    return self;	
}


- (NSString *)stringForObjectValue:(id)anObject {
	return anObject;
}


// Removes illegal characters.
- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
	
	NSMutableString * s = [NSMutableString stringWithString:string];
	
	// Remove all of these characters
	NSArray * charsToRemove = [NSArray arrayWithObjects:@" ", nil];
	
	for (id obj in charsToRemove) {
		[s replaceOccurrencesOfString:obj
						   withString:@""
							  options:NSCaseInsensitiveSearch
								range:NSMakeRange(0, [s length])];		
	}
	
	// Must be two characters long.
	if ([s length] == 0) [s appendString:@"key"];
	if ([s length] == 1) [s appendString:@"_"];
	
	if ([s length] > MAX_KEY_LENGTH) [s deleteCharactersInRange:NSMakeRange(MAX_KEY_LENGTH, [s length] - MAX_KEY_LENGTH)];
	
	*anObject = s;
//	*error = NSLocalizedString(@"Couldn't convert to string", @"Error converting");
	
    return YES;
}


- (void)dealloc {
	[super dealloc];
}


@end

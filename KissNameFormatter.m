//
//  KissNameFormatter.m
//
//  Created by Ryan on 3/4/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

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

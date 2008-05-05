//
//  Controller.m
//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import "Controller.h"
#import "Paster.h"
#import "KissphraseCommon.h"

@implementation Controller

@synthesize shouldQuit = _shouldQuit;

- (id) init {
	self = [super init];
	if (self != nil) {		

		_shouldQuit = NO;
		
		// Listen for notification from preference pane telling us to quit.
		NSDistributedNotificationCenter * noteCenter = [NSDistributedNotificationCenter defaultCenter];
		
		[noteCenter addObserver:self
					   selector:@selector(quitHelper:)
						   name:kCMSKissHelperDieNotification
						 object:nil];

		[noteCenter addObserver:self
					   selector:@selector(reloadSubstitutions:)
						   name:kCMSKissHelperReloadSubstitutionsNotification
						 object:nil];

		[noteCenter addObserver:self
					   selector:@selector(amIAlive:)
						   name:kCMSKissHelperAreYouAliveNotification
						 object:nil];

		
		// Create the paster which handles event tapping and pasting.
		_paster = [[Paster alloc] init];

		[self reloadSubstitutions:nil];
		
		// Enable automatically.
		[_paster enable];
		
	}
	return self;
}

- (void) dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_paster disable];
	[_paster release];
	[super dealloc];
}


- (void)amIAlive:(NSNotification*)note {
	// Reply that the process is alive.
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kCMSKissHelperIAmAliveNotification
																   object:nil];	
}

- (void)reloadSubstitutions:(NSNotification*)note {
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[KissphraseCommon readSubstitutions]];
	_paster.substitutionDictionary = dict;
}

- (void)quitHelper:(NSNotification*)note {	
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	// Remove the event tap.
	[_paster disable];
	
	_shouldQuit = YES;
}


@end

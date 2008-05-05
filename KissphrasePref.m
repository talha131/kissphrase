//
//  KissphrasePref.m
//  Kissphrase
//
//  Created by Ryan on 3/4/08.
//  Copyright (c) 2008 Chimoosoft. All rights reserved.
//

#import "KissphrasePref.h"
#import "CMSCommon.h"
#import "CMSFileUtils.h"
#import "KissphraseCommon.h"

@implementation KissphrasePref

@synthesize substitutionDictionary = _substitutions;

- (id)initWithBundle:(NSBundle *)bundle  { 
	if ( ( self = [super initWithBundle:bundle] ) != nil ) { 

		// Only works on Leopard.
		if (![CMSCommon systemIsLeopardOrLater]) return nil;
		
		_assistiveDevicesSupportEnabled = YES;
		
		_initialValueString = [[NSString stringWithString:@"Enter a phrase for Kissphrase to auto-complete whenever you type the keyword selected on the left."] retain];

		// Listen for notification from helper telling whether or not it's alive.
		NSDistributedNotificationCenter * noteCenter = [NSDistributedNotificationCenter defaultCenter];
		
		[noteCenter addObserver:self
					   selector:@selector(helperIsAlive:)
						   name:kCMSKissHelperIAmAliveNotification
						 object:nil];
		
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kCMSKissHelperAreYouAliveNotification
																	   object:nil];

		
		// Read the substitutions dictionary from a file.
		[self willChangeValueForKey:@"substitutions"];
		[_substitutions release];
		_substitutions = [[NSMutableDictionary dictionaryWithDictionary:[KissphraseCommon readSubstitutions]] retain];

		if ([_substitutions count] <= 0) {
			[_substitutions setValue:@"This is a test phrase which will be automatically inserted when you type the keyword at the left." forKey:@"test"];
		}
		[self didChangeValueForKey:@"substitutions"];
		
		[self addObserver:self
			   forKeyPath:@"substitutions"
				  options:(NSKeyValueObservingOptionNew)
				  context:NULL];
				
	} 
	return self; 
} 


- (void) willSelect {
	// Called when the pref pane is about to be displayed.

	// Check whether the "enable access for assitive devices" checkbox checked in Universal Access?
	NSString * scriptSource = @"tell application \"System Events\"\nset UI_enabled to UI elements enabled\nend tell";	
	NSAppleScript * script = [[NSAppleScript alloc] initWithSource:scriptSource];
	
	[self willChangeValueForKey:@"assistiveDevicesSupportEnabled"];
	NSDictionary * executeErrors = nil;
	NSAppleEventDescriptor * descriptor = [script executeAndReturnError:&executeErrors];
	if ([executeErrors count] > 0) {		
		_assistiveDevicesSupportEnabled = NO;
	} else {
		_assistiveDevicesSupportEnabled = [descriptor booleanValue];
	}
	[self didChangeValueForKey:@"assistiveDevicesSupportEnabled"];
	
	[script release];
}

- (void)willUnselect {
	[KissphraseCommon setAutoLaunches:isActive];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self removeObserver:self forKeyPath:@"substitutions"];

	[_substitutions release];
	[_initialValueString release];
	
	[super dealloc];
}


- (void)helperIsAlive:(NSNotification*)note {
	
	[self willChangeValueForKey:@"isActive"];
	isActive = YES;
	[self didChangeValueForKey:@"isActive"];
	
}

- (IBAction)donate:(id)sender {
	[CMSCommon openDonationPage];
}

- (IBAction)openUniversalAccess:(id)sender {
	[CMSCommon runScriptFromString:@"tell application \"System Preferences\"\nactivate\nset current pane to pane \"com.apple.preference.universalaccess\"\nend tell"];
}

- (IBAction)openKissHelp:(id)sender {
	[NSApp showHelp:sender];
}

- (IBAction)openKissHome:(id)sender {
	[CMSCommon openURLFromString:@"http://www.chimoosoft.com/products/kissphrase/"];
}

- (NSURL*)productURL {
	return [NSURL URLWithString:@"http://www.chimoosoft.com/products/kissphrase/"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"substitutions"]) {

		// Save the dictionary.
		[KissphraseCommon saveSubstitutions:_substitutions];

		// Make sure the helper reloads them.
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kCMSKissHelperReloadSubstitutionsNotification
																	   object:nil];

    }
	
}

- (IBAction)enableDisable:(id)sender {
	if (isActive) {
		// Launch kisshelper
		[self quitKissHelper];
		[self launchKissHelper];
		
	} else {
		// Send distributed notification to kisshelper and ask it to quit.		
		[self quitKissHelper];
	}
}


- (void)quitKissHelper {
	
	// Make sure launchd doesn't automatically re-launch it.
	
	NSString * path = [@"~/Library/LaunchAgents/kissphraselauncher.plist" stringByExpandingTildeInPath];
	
	NSTask * task = [NSTask launchedTaskWithLaunchPath:@"/bin/launchctl"
											 arguments:[NSArray arrayWithObjects:@"unload", path, nil]];

	
	
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:kCMSKissHelperDieNotification
																   object:nil];
	[self willChangeValueForKey:@"isActive"];
	isActive = NO;
	[self didChangeValueForKey:@"isActive"];
}


- (void)launchKissHelper {
	
	NSString * path = [KissphraseCommon pathToHelper];
	if (nil == path) return;
	
	NSURL * url = [NSURL fileURLWithPath: path];
	
	NSTask * task = [NSTask launchedTaskWithLaunchPath:[url path]
											 arguments:[NSArray array]];

	[self willChangeValueForKey:@"isActive"];
	isActive = YES;
	[self didChangeValueForKey:@"isActive"];
	
}


@end

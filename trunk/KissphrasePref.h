//
//  KissphrasePref.h
//  Kissphrase
//
//  Created by Ryan on 3/4/08.
//  Copyright (c) 2008 Chimoosoft. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@class KissphraseCommon;

@interface KissphrasePref : NSPreferencePane  {
	NSMutableDictionary * _substitutions;			// Dictionary of substitutions between abbreviations and phrases.
	
	BOOL isActive;
	BOOL _assistiveDevicesSupportEnabled;			// Is the "enable access for assitive devices" checkbox checked in Universal Access?
	
	NSString * _initialValueString;					// What should be displayed for the value when the user creates a new key?
}

@property(nonatomic, retain) NSMutableDictionary * substitutionDictionary;


- (void)willUnselect;

// Enable or disable the event tap based on user defaults value.
- (IBAction)enableDisable:(id)sender;

- (IBAction)donate:(id)sender;

// Applescript which opens the Universal Access system preference pane.
- (IBAction)openUniversalAccess:(id)sender;

- (IBAction)openKissHelp:(id)sender;

- (IBAction)openKissHome:(id)sender;

- (void)launchKissHelper;
- (void)quitKissHelper;

// Delegate methods for CMSVersioning.
- (NSURL*)productURL;

@end

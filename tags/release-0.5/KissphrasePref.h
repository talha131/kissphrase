//
//  KissphrasePref.h
//  Kissphrase
//
//  Created by Ryan on 3/4/08.
//  Copyright (c) 2008 Chimoosoft. All rights reserved.
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

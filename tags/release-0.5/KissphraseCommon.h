//
//  KissphraseCommon.h
//  Kissphrase
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


#import <Cocoa/Cocoa.h>

static NSString * const kCMSKissHelperDieNotification					=	@"CMSKissHelperPleaseDie";
static NSString * const kCMSKissHelperReloadSubstitutionsNotification	=	@"CMSKissHelperPleaseReloadSubstitutions";
static NSString * const kCMSKissHelperAreYouAliveNotification			=	@"CMSKissHelperAreYouAlive";
static NSString * const kCMSKissHelperIAmAliveNotification				=	@"CMSKissHelperIAmAlive";



@interface KissphraseCommon : NSObject {
}

// Creates or deletes a launchd plist file as necessary in the ~/Library/LaunchAgents/ folder. 
+ (void)setAutoLaunches:(BOOL)b;

// Returns the path to the helper program.
+ (NSString*)pathToHelper;

// Read the substitutions file and return.
+ (NSDictionary*)readSubstitutions;

// Save the substitutions to a file.
+ (void)saveSubstitutions:(NSDictionary*)dict;

@end

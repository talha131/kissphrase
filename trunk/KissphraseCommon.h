//
//  KissphraseCommon.h
//  Kissphrase
//
//  Created by Ryan on 3/4/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

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

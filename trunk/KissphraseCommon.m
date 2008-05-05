//
//  KissphraseCommon.m
//  Kissphrase
//
//  Created by Ryan on 3/4/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import "KissphraseCommon.h"
#import "CMSFileUtils.h"

@implementation KissphraseCommon

+ (NSString*)pathToHelper {
	NSString * path = [@"~/Library/PreferencePanes/Kissphrase.prefPane/Contents/MacOS/kisshelper" stringByExpandingTildeInPath];
	if (![CMSFileUtils pathExists:path]) {
		path = @"/Library/PreferencePanes/Kissphrase.prefPane/Contents/MacOS/kisshelper";
	}
	if (![CMSFileUtils pathExists:path]) {
		path = @"/Network/Library/PreferencePanes/Kissphrase.prefPane/Contents/MacOS/kisshelper";
	}
	
	if (![CMSFileUtils pathExists:path]) {
		NSLog(@"Couldn't find kisshelper at path %@.", path);
		return nil;
	}
	
	return path;
}




+ (void)setAutoLaunches:(BOOL)b {
	
	NSString * path = [@"~/Library/LaunchAgents/kissphraselauncher.plist" stringByExpandingTildeInPath];
	if (!b) {
		// Remove the launchd file.
		NSError * error = nil;
		if ([CMSFileUtils pathExists:path])
			[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
		
	} else if (![CMSFileUtils pathExists:path]) {
		
		// Create and add the launchd file since it doesn't already exist.
		NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
		[dict setObject:@"com.chimoosoft.kisshelper" forKey:@"Label"];
		
		// This tells launchd to relaunch the program only if it exited improperly (i.e. crashed).
		NSDictionary * keepAlive = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"SuccessfulExit"];
		[dict setObject:keepAlive forKey:@"KeepAlive"];
				
		[dict setObject:@"Aqua" forKey:@"LimitLoadToSessionType"];
		// Run it when the user logs in.
		[dict setObject:[NSNumber numberWithBool:YES] forKey:@"RunAtLoad"];
		
		NSArray * args = [NSArray arrayWithObject:[KissphraseCommon pathToHelper]];
		[dict setObject:args forKey:@"ProgramArguments"];
		
		if (![dict writeToFile:path atomically:NO])
			NSLog(@"error writing launchd file");		
	}
	
}


+ (NSDictionary*)readSubstitutions {
	NSString * path = [[CMSFileUtils applicationSupportPathForName:@"Kissphrase"] stringByAppendingPathComponent:@"substitutions.plist"];
	
	BOOL exists = [CMSFileUtils pathExists:path];
	if (!exists) return nil;
	
	NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	if (nil == dict) NSLog(@"Error reading substitutions.");
	
	[dict autorelease];
	return dict;
}


+ (void)saveSubstitutions:(NSDictionary*)dict {	
	NSString * path = [CMSFileUtils applicationSupportPathForName:@"Kissphrase"];

	BOOL b = [dict writeToFile:[path stringByAppendingPathComponent:@"substitutions.plist"] 
					atomically:NO];		
	if (!b) NSLog(@"error writing file");
}


@end

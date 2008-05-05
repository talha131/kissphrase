//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.

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


#import <Foundation/Foundation.h>
#import "Controller.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	#if DEBUG
	NSLog(@"Kisshelper launching.");
	#endif
	
	Controller * controller = [[Controller alloc] init];
	
	NSRunLoop * loop = [NSRunLoop currentRunLoop];
	NSPort * port = [NSPort port];
	[loop addPort:port forMode:NSDefaultRunLoopMode];
		
	double resolution = 1.0;
	BOOL endRunLoop = NO; 
	BOOL isRunning;
	int count = 0;
	do { 
		NSAutoreleasePool * innerPool = [[NSAutoreleasePool alloc] init];
		NSDate* next = [NSDate dateWithTimeIntervalSinceNow:resolution]; 
		isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode 
											 beforeDate:next];
		
		endRunLoop = [controller shouldQuit];		
		
		#if DEBUG
		// If debugging, quit after 100 iterations.
		count++;		
		NSLog(@"count = %i", count);
		if (count > 100) endRunLoop = YES;
		#endif		
		
		[innerPool drain];
		
	} while (isRunning && !endRunLoop); 
	
	[controller release];	
    
	#if DEBUG
    NSLog(@"Goodbye!");
	#endif
	
    [pool drain];
    return 0;
}

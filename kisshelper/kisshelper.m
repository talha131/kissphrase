
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

//
//  Controller.h
//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Paster;

@interface Controller : NSObject {
	Paster * _paster;
	BOOL _shouldQuit;
}

@property (nonatomic, assign, readonly) BOOL shouldQuit;

- (void)amIAlive:(NSNotification*)note;
- (void)reloadSubstitutions:(NSNotification*)note;
- (void)quitHelper:(NSNotification*)note;

@end

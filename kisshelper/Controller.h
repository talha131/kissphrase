//
//  Controller.h
//  Kissphrase
//
//  Created by Ryan on 3/1/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//
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

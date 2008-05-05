//
//  KissNameFormatter.h
//
//  Created by Ryan on 3/4/08.
//  Copyright 2008 Chimoosoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KissNameFormatter : NSFormatter {

}

- (id)init;

- (NSString *)stringForObjectValue:(id)anObject;
- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error;

@end

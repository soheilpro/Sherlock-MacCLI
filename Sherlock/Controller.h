//
//  Sherlock.h
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Controller : NSObject

@property (nonatomic, strong, readonly) NSArray* commandClasses;
@property (nonatomic) BOOL shouldExit;

- (int)runWithArguments:(NSArray*)arguments;
- (void)reportError:(NSString*)error;

@end

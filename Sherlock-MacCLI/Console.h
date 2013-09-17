//
//  Console.h
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Console : NSObject

+ (void)write:(NSString*)format,...;
+ (NSString*)read;
+ (NSString*)readPassword;

@end

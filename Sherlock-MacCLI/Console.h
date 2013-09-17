//
//  Console.h
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_CYAN @"\e[0;36m"
#define COLOR_GREEN @"\e[0;32m"
#define COLOR_GREY @"\e[0;37m"
#define COLOR_RESET @"\e[m"
#define COLOR_YELLOW @"\e[0;33m"

@interface Console : NSObject

+ (void)write:(NSString*)format,...;
+ (NSString*)read;
+ (NSString*)readPassword;

@end

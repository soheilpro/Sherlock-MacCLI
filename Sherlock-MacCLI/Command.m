//
//  Command.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Command.h"

@implementation Command

- (void)execute
{
}

+ (NSString*)name
{
    return nil;
}

+ (NSString*)syntax
{
    return @"";
}

+ (NSArray*)arguments
{
    return @[];
}

+ (NSString*)description
{
    return nil;
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
}

@end

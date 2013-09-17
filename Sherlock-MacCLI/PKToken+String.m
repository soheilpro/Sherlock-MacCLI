//
//  PKToken+String.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "PKToken+String.h"

@implementation PKToken (String)

- (NSString*)unquotedStringValue
{
    if (self.isQuotedString)
        return [stringValue substringWithRange:NSMakeRange(1, stringValue.length - 2)];

    return stringValue;
}

@end

//
//  main.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Controller.h"
#import <Foundation/Foundation.h>

int main(int argc, const char* argv[])
{
    @autoreleasepool
    {
        NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:argc];

        for (int i = 0; i < argc; i++)
            [arguments addObject:[NSString stringWithUTF8String:argv[i]]];

        Controller* sherlock = [[Controller alloc] init];
        [sherlock runWithArguments:arguments];
    }

    return 0;
}

//
//  ListCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "Folder+Utilities.h"
#import "ListCommand.h"

@implementation ListCommand

- (void)execute
{
    BOOL optionLongForm = NO;
    BOOL optionShowSecrets = NO;

    PKToken* optionToken = [self.tokenizer nextToken];

    if (optionToken != [PKToken EOFToken])
    {
        if ([optionToken.stringValue isEqualToString:@"-l"])
            optionLongForm = YES;

        if ([optionToken.stringValue isEqualToString:@"-p"] || [optionToken.stringValue isEqualToString:@"-lp"])
        {
            optionLongForm = YES;
            optionShowSecrets = YES;
        }
    }

    Folder* folder = self.context.folder;
    NSInteger maxIndexLength = [[NSString stringWithFormat:@"%ld", MAX(folder.folders.count, folder.items.count)] length];

    [folder.folders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        Folder* folder = (Folder*)obj;

        [Console write:@"%*i " COLOR_CYAN "[%@]" COLOR_RESET "\n", maxIndexLength, idx + 1, folder.name];
    }];

    [folder.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        Item* item = (Item*)obj;
        NSString* value = optionLongForm ? item.value : @"";

        if (item.isSecret && !optionShowSecrets)
            value = [@"" stringByPaddingToLength:value.length withString:@"*" startingAtIndex:0];

        if (value.length > 0)
            value = [NSString stringWithFormat:@" %@", value];

        [Console write:@"%*i %@" COLOR_GREEN "%@" COLOR_RESET "\n", maxIndexLength, idx + 1, item.name, value];
    }];
}

+ (NSString*)name
{
    return @"ls";
}

+ (NSString*)syntax
{
    return @"[-l] [-p]";
}

+ (NSArray*)arguments
{
    return @[
        @"-l: Display in long form.",
        @"-p: Reveal secrets. Implies -l.",
    ];
}

+ (NSString*)description
{
    return @"List folders and items.";
}

+ (void)initTokenizer:(PKTokenizer*)tokenizer
{
    [tokenizer.symbolState add:@"-l"];
    [tokenizer.symbolState add:@"-p"];
    [tokenizer.symbolState add:@"-lp"];
}

@end

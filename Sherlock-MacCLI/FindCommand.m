//
//  FindCommand.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/18/15.
//  Copyright (c) 2015 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "FindCommand.h"

@implementation FindCommand

- (void)execute
{
    PKToken* nameToken = [self.tokenizer nextToken];

    Folder* folder = self.context.folder;
    NSInteger maxIndexLength = [[NSString stringWithFormat:@"%ld", MAX(folder.folders.count, folder.items.count)] length];

    [folder.folders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        Folder* folder = (Folder*)obj;

        if ([folder.name rangeOfString:nameToken.stringValue options:NSCaseInsensitiveSearch].location == NSNotFound)
            return;

        [Console write:@"%*i " COLOR_CYAN "[%@]" COLOR_RESET "\n", maxIndexLength, idx + 1, folder.name];
    }];

    [folder.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        Item* item = (Item*)obj;
        NSString* value = @"";

        if ([item.name rangeOfString:nameToken.stringValue options:NSCaseInsensitiveSearch].location == NSNotFound)
            return;

        [Console write:@"%*i %@" COLOR_GREEN "%@" COLOR_RESET "\n", maxIndexLength, idx + 1, item.name, value];
    }];
}

+ (NSArray*)names
{
    return @[@"find"];
}

+ (NSString*)syntax
{
    return @"name";
}

+ (NSArray*)arguments
{
    return @[
        @"name: Item or folder's name.",
    ];
}

+ (NSString*)description
{
    return @"Searches for folders and items.";
}

@end

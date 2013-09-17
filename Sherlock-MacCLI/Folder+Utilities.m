//
//  Folder+Utilities.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/17/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "Folder+Utilities.h"
#import "PKToken+Value.h"

@implementation Folder (Utilities)

- (NSString*)path
{
    Folder* folder = self;
    NSMutableString* path = [NSMutableString string];

    while (folder != nil)
    {
        if (folder.name != nil)
            [path insertString:[NSString stringWithFormat:@"/%@", folder.name] atIndex:0];

        folder = folder.parent;
    }

    if (path.length == 0)
        [path appendString:@"/"];

    return path;
}

- (Folder*)folderForToken:(PKToken*)token
{
    if (token.isSymbol && [token.stringValue isEqualToString:@".."])
    {
        if (self.parent == nil)
            return nil;

        return self.parent;
    }

    if (token.isNumber)
    {
        NSInteger index = (NSInteger)token.floatValue;

        if (index < 1 || index > self.folders.count)
            return nil;

        return [self.folders objectAtIndex:index - 1];
    }

    if (token.isWord || token.isQuotedString)
    {
        NSString* name = token.unquotedStringValue;
        NSArray* folders = [self foldersWithName:name options:NSCaseInsensitiveSearch];

        if (folders.count == 0)
            return nil;

        if (folders.count > 1)
            return nil;

        return [folders objectAtIndex:0];
    }

    return nil;
}

- (Item*)itemForToken:(PKToken*)token
{
    if (token.isNumber)
    {
        NSInteger index = (NSInteger)token.floatValue;

        if (index < 1 || index > self.items.count)
            return nil;

        return [self.items objectAtIndex:index - 1];
    }

    if (token.isWord || token.isQuotedString)
    {
        NSString* name = token.unquotedStringValue;
        NSArray* items = [self itemsWithName:name options:NSCaseInsensitiveSearch];

        if (items.count == 0)
            return nil;

        if (items.count > 1)
            return nil;

        return [items objectAtIndex:0];
    }

    return nil;
}

- (NSArray*)foldersWithName:(NSString*)name options:(NSStringCompareOptions)options
{
    NSMutableArray* result = [NSMutableArray array];

    for (Folder* folder in self.folders)
        if ([folder.name rangeOfString:name options:options].location != NSNotFound)
            [result addObject:folder];

    return result;
}

- (NSArray*)itemsWithName:(NSString*)name options:(NSStringCompareOptions)options
{
    NSMutableArray* result = [NSMutableArray array];

    for (Item* item in self.items)
        if ([item.name rangeOfString:name options:options].location != NSNotFound)
            [result addObject:item];
    
    return result;
}

@end

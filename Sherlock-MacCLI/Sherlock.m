//
//  Sherlock.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import "Database.h"
#import "PKToken+String.h"
#import "Sherlock.h"
#import <AppKit/AppKit.h>
#import <ParseKit/ParseKit.h>

@interface Sherlock ()

@property (nonatomic, strong) Folder* currentFolder;

@end

@implementation Sherlock

- (int)runWithArguments:(NSArray*)arguments
{
    if (arguments.count != 2)
    {
        [Console write:@"Usage: sherlock database\n"];
        
        return 1;
    }

    NSString* path = [arguments objectAtIndex:1];
    Database* database = [self openDatabaseAtPath:path];

    self.currentFolder = database.root;

    [self printFolder:self.currentFolder];
    [self processCommands];

    return 0;
}

- (Database*)openDatabaseAtPath:(NSString*)path;
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    Database* database = [[Database alloc] init];
    NSString* password = nil;

    while (YES)
    {
        if ([database openWithData:data andPassword:password])
            return database;

        [Console write:@"Password?\n"];

        password = [Console readPassword];
    }
}

- (void)processCommands
{
    while (YES)
    {
        [Console write:@"\n%@> ", [self pathForFolder:self.currentFolder]];

        NSString* input = [Console read];
        
        PKTokenizer* tokenizer = [PKTokenizer tokenizerWithString:input];
        [tokenizer.symbolState add:@".."];

        NSString* command = [tokenizer nextToken].stringValue;

        if ([command isEqualToString:@"help"])
        {
            [Console write:@"usage: ls\n"];
            [Console write:@"       cd folder_index | folder_name | ..\n"];
            [Console write:@"       show [item_index | item_name]\n"];
            [Console write:@"       copy item_index | item_name\n"];
            [Console write:@"       exit\n"];
        }
        else if ([command isEqualToString:@"exit"])
        {
            break;
        }
        else if ([command isEqualToString:@"ls"])
        {
            [self printFolder:self.currentFolder];
        }
        else if ([command isEqualToString:@"cd"])
        {
            PKToken* nextToken = [tokenizer nextToken];

            if (nextToken.isSymbol && [nextToken.stringValue isEqualToString:@".."])
            {
                if (self.currentFolder.parent == nil)
                {
                    [Console write:@"Error: Already at root\n"];
                    continue;
                }

                self.currentFolder = self.currentFolder.parent;

                [self printFolder:self.currentFolder];
            }
            else if (nextToken.isNumber)
            {
                NSInteger index = (NSInteger)nextToken.floatValue;

                if (index < 1 || index > self.currentFolder.folders.count)
                {
                    [Console write:@"Error: Invalid folder index\n"];
                    continue;
                }

                self.currentFolder = [self.currentFolder.folders objectAtIndex:index - 1];

                [self printFolder:self.currentFolder];
            }
            else if (nextToken.isWord || nextToken.isQuotedString)
            {
                NSString* name = nextToken.unquotedStringValue;
                NSArray* folders = [self findFoldersWithName:name options:NSCaseInsensitiveSearch];

                if (folders.count == 0)
                {
                    [Console write:@"Error: Invalid folder name\n"];
                    continue;
                }
                else if (folders.count > 1)
                {
                    [Console write:@"Error: Multiple matches found\n"];
                    continue;
                }

                self.currentFolder = [folders objectAtIndex:0];

                [self printFolder:self.currentFolder];
            }
            else
            {
                [Console write:@"Error: Invalid parameter\n"];
            }
        }
        else if ([command isEqualToString:@"show"])
        {
            PKToken* nextToken = [tokenizer nextToken];

            if (nextToken == [PKToken EOFToken])
            {
                NSInteger maxItemNameLength = 0;

                for (Item* item in self.currentFolder.items)
                    if (item.name.length > maxItemNameLength)
                        maxItemNameLength = item.name.length;

                for (Item* item in self.currentFolder.items)
                    [Console write:@"%*s: %@\n", maxItemNameLength, [item.name UTF8String], item.value];
            }
            else if (nextToken.isNumber)
            {
                NSInteger index = (NSInteger)nextToken.floatValue;

                if (index < 1 || index > self.currentFolder.items.count)
                {
                    [Console write:@"Error: Invalid item index\n"];
                    continue;
                }

                Item* item = [self.currentFolder.items objectAtIndex:index - 1];

                [Console write:@"%@: %@\n", item.name, item.value];
            }
            else if (nextToken.isWord || nextToken.isQuotedString)
            {
                NSString* name = nextToken.unquotedStringValue;
                NSArray* items = [self findItemsWithName:name options:NSCaseInsensitiveSearch];

                if (items.count == 0)
                {
                    [Console write:@"Error: Invalid item name\n"];
                    continue;
                }
                else if (items.count > 1)
                {
                    [Console write:@"Error: Multiple matches found\n"];
                    continue;
                }

                Item* item = [items objectAtIndex:0];
                
                [Console write:@"%@: %@\n", item.name, item.value];
            }
            else
            {
                [Console write:@"Error: Invalid parameter\n"];
            }
        }
        else if ([command isEqualToString:@"copy"])
        {
            PKToken* nextToken = [tokenizer nextToken];

            if (nextToken.isNumber)
            {
                NSInteger index = (NSInteger)nextToken.floatValue;

                if (index < 1 || index > self.currentFolder.items.count)
                {
                    [Console write:@"Error: Invalid item index\n"];
                    continue;
                }

                Item* item = [self.currentFolder.items objectAtIndex:index - 1];

                NSPasteboard* pasteboard =  [NSPasteboard generalPasteboard];
                [pasteboard clearContents];
                [pasteboard writeObjects:@[item.value]];
            }
            else if (nextToken.isWord || nextToken.isQuotedString)
            {
                NSString* name = nextToken.unquotedStringValue;
                NSArray* items = [self findItemsWithName:name options:NSCaseInsensitiveSearch];

                if (items.count == 0)
                {
                    [Console write:@"Error: Invalid item name\n"];
                    continue;
                }
                else if (items.count > 1)
                {
                    [Console write:@"Error: Multiple matches found\n"];
                    continue;
                }

                Item* item = [items objectAtIndex:0];
                
                NSPasteboard* pasteboard =  [NSPasteboard generalPasteboard];
                [pasteboard clearContents];
                [pasteboard writeObjects:@[item.value]];
            }
            else
            {
                [Console write:@"Error: Invalid parameter\n"];
            }
        }
        else
        {
            [Console write:@"Error: Unknown command\n"];
        }
    }
}

- (void)printFolder:(Folder*)folder
{
    NSInteger maxIndexLength = [[NSString stringWithFormat:@"%ld", MAX(folder.folders.count, folder.items.count)] length];

    [folder.folders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        Folder* folder = (Folder*)obj;

        [Console write:@"%*i [%@]\n", maxIndexLength, idx + 1, folder.name];
    }];
    
    [folder.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop)
    {
        Item* item = (Item*)obj;

        [Console write:@"%*i %@%@\n", maxIndexLength, idx + 1, item.name, item.isSecret ? @" (*)" : @""];
    }];
}

- (NSString*)pathForFolder:(Folder*)folder
{
    NSMutableString* path = [NSMutableString string];

    while (folder != nil)
    {
        if (folder.name != nil)
            [path insertString:[NSString stringWithFormat:@"/%@", folder.name] atIndex:0];

        folder = folder.parent;
    }

    return path;
}

- (NSArray*)findFoldersWithName:(NSString*)name options:(NSStringCompareOptions)options
{
    NSMutableArray* result = [NSMutableArray array];

    for (Folder* folder in self.currentFolder.folders)
        if ([folder.name rangeOfString:name options:options].location != NSNotFound)
            [result addObject:folder];

    return result;
}

- (NSArray*)findItemsWithName:(NSString*)name options:(NSStringCompareOptions)options
{
    NSMutableArray* result = [NSMutableArray array];

    for (Item* item in self.currentFolder.items)
        if ([item.name rangeOfString:name options:options].location != NSNotFound)
            [result addObject:item];

    return result;
}

@end

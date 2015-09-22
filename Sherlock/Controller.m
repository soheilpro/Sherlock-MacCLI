//
//  Sherlock.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "AddFolderCommand.h"
#import "AddItemCommand.h"
#import "ChangeDatabasePasswordCommand.h"
#import "ChangeFolderCommand.h"
#import "Console.h"
#import "Context.h"
#import "Controller.h"
#import "CopyItemValueToPasteboardCommand.h"
#import "Database.h"
#import "DeleteFolderCommand.h"
#import "DeleteItemCommand.h"
#import "ExitCommand.h"
#import "FindCommand.h"
#import "Folder+Utilities.h"
#import "HelpCommand.h"
#import "ListCommand.h"
#import "PKToken+Value.h"
#import "OpenCommand.h"
#import "RenameFolderCommand.h"
#import "RenameItemCommand.h"
#import "SaveDatabaseCommand.h"
#import "ShowItemCommand.h"
#import "UpdateItemCommand.h"
#import <ParseKit/ParseKit.h>

@interface Controller ()

@property (nonatomic, strong) Context* context;

@end

@implementation Controller

- (id)init
{
    self = [super init];

    if (self)
    {
        _commandClasses = @[
            [AddFolderCommand class],
            [AddItemCommand class],
            [ChangeDatabasePasswordCommand class],
            [ChangeFolderCommand class],
            [CopyItemValueToPasteboardCommand class],
            [DeleteFolderCommand class],
            [DeleteItemCommand class],
            [ExitCommand class],
            [FindCommand class],
            [HelpCommand class],
            [ListCommand class],
            [OpenCommand class],
            [RenameFolderCommand class],
            [RenameItemCommand class],
            [SaveDatabaseCommand class],
            [ShowItemCommand class],
            [UpdateItemCommand class],
        ];
    }

    return self;
}

- (int)runWithArguments:(NSArray*)arguments
{
    if (arguments.count < 2)
    {
        [Console write:@"Usage: sherlock database\n"];
        
        return 1;
    }

    self.context = [[Context alloc] init];
    self.context.databasePath = [arguments objectAtIndex:1];
    self.context.database = [self openDatabaseAtPath:self.context.databasePath];
    self.context.folder = self.context.database.root;

    if (arguments.count > 2)
        [self runScript:[arguments objectAtIndex:2]];

    if (self.shouldExit)
        return 0;

    [self runInteractive];

    return 0;
}

- (void)reportError:(NSString*)error
{
    [Console write:@"Error: %@\n", error];
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

- (void)runInteractive
{
    while (YES)
    {
        NSString* prompt = [NSString stringWithFormat:@"\n%@> ", [self.context.folder path]];
        NSString* input = [Console read:prompt completor:^NSArray* (NSString* buffer, NSString* prefix)
        {
            // Is it the first word?
            if ([[buffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] rangeOfString:@" "].length == 0)
            {
                NSMutableArray* matches = [NSMutableArray array];

                for (Class commandClass in self.commandClasses)
                    for (NSString* commandName in [commandClass names])
                        [matches addObject:commandName];

                return matches;
            }
            else
            {
                NSMutableArray* matches = [NSMutableArray array];

                for (Folder* folder in self.context.folder.folders)
                    [matches addObject:folder.name];

                for (Item* item in self.context.folder.items)
                    [matches addObject:item.name];

                return matches;
            }
        }];

        [self processStatement:input];

        if (self.shouldExit)
            break;
    }
}

- (void)runScript:(NSString*)script
{
    NSArray* statements = [script componentsSeparatedByString:@";"];

    for (NSString* statement in statements)
    {
        [self processStatement:statement];

        if (self.shouldExit)
            break;
    }
}

- (void)processStatement:(NSString*)input
{
    PKTokenizer* tokenizer = [PKTokenizer tokenizerWithString:input];

    for (Class commandClass in self.commandClasses)
        [commandClass initTokenizer:tokenizer];

    NSString* commandName = [tokenizer nextToken].stringValue;
    Command* command = [self commandByName:commandName];

    if (command == nil)
    {
        [self reportError:@"Invalid command"];
        return;
    }

    command.context = self.context;
    command.controller = self;
    command.tokenizer = tokenizer;

    [command execute];
}

- (Command*)commandByName:(NSString*)name
{
    for (Class commandClass in self.commandClasses)
        for (NSString* commandName in [commandClass names])
            if ([name isEqualToString:commandName])
                return [[commandClass alloc] init];

    return nil;
}

@end

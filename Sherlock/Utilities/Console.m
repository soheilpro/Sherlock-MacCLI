//
//  Console.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import <termios.h>
#import <readline/history.h>
#import <readline/readline.h>

@implementation Console

static struct termios old_termios;
static completorBlock completor_cb;

char* completion_match_generator(const char* text, int state)
{
    static NSMutableArray* matchingItems;

    if (state == 0)
    {
        matchingItems = [NSMutableArray array];

        NSString* buffer = [NSString stringWithUTF8String:rl_line_buffer];
        NSString* prefix = [NSString stringWithUTF8String:text];
        NSArray* items = completor_cb(buffer, prefix);

        for (NSString* item in items)
            if ([[item lowercaseString] hasPrefix:[prefix lowercaseString]])
                [matchingItems addObject:item];
    }

    if (state == matchingItems.count)
        return (char*)NULL;

    const char* str = [matchingItems[state] UTF8String];
    char* result = malloc(strlen(str));
    strcpy(result, str);

    return result;
}

+ (void)write:(NSString*)format,...
{
    va_list args;
    va_start(args, format);
    NSString* text = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    printf("%s", [text UTF8String]);
}

+ (NSString*)read:(NSString*)prompt
{
    return [self read:prompt completor:nil];
}

+ (NSString*)read:(NSString*)prompt completor:(completorBlock)completor;
{
    Function* old_rl_completion_entry_function;

    if (completor != nil)
    {
        old_rl_completion_entry_function = rl_completion_entry_function;
        rl_completion_entry_function = (Function*)completion_match_generator;
        completor_cb = completor;
    }

    char* line = readline([prompt UTF8String]);
    add_history(line);

    if (completor != nil)
    {
        rl_completion_entry_function = old_rl_completion_entry_function;
    }

    return [NSString stringWithUTF8String:line];
}

+ (NSString*)readPassword
{
    char text[50] = {0};

    [self setTerminalEcho:NO];

    scanf("%s", text);

    [self setTerminalSettingsToDefault];
    
    return [NSString stringWithUTF8String:text];
}

+ (void)setTerminalEcho:(BOOL)echo
{
    struct termios new_termios;

    tcgetattr(0, &old_termios);
    new_termios = old_termios;
    new_termios.c_lflag &= ~ICANON; // disable buffered i/o
    new_termios.c_lflag &= echo ? ECHO : ~ECHO; // set echo mode
    tcsetattr(0, TCSANOW, &new_termios);
}

+ (void)setTerminalSettingsToDefault
{
    tcsetattr(0, TCSANOW, &old_termios);
}

@end

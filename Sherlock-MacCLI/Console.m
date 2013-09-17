//
//  Console.m
//  Sherlock-MacCLI
//
//  Created by Soheil Rashidi on 9/16/13.
//  Copyright (c) 2013 Soheil Rashidi. All rights reserved.
//

#import "Console.h"
#import <termios.h>

@implementation Console

static struct termios oldTermios;

+ (void)write:(NSString*)format,...
{
    va_list args;
    va_start(args, format);
    NSString* text = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    printf("%s", [text UTF8String]);
}

+ (NSString*)read
{
    char text[50] = {0};

    scanf(" %99[^\n]", text);

    return [NSString stringWithUTF8String:text];
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
    struct termios newTermios;

    tcgetattr(0, &oldTermios);
    newTermios = oldTermios;
    newTermios.c_lflag &= ~ICANON; // disable buffered i/o
    newTermios.c_lflag &= echo ? ECHO : ~ECHO; // set echo mode
    tcsetattr(0, TCSANOW, &newTermios);
}

+ (void)setTerminalSettingsToDefault
{
    tcsetattr(0, TCSANOW, &oldTermios);
}

@end

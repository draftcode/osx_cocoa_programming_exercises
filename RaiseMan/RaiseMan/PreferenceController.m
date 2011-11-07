//
//  PreferenceController.m
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/23.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "PreferenceController.h"

NSString * const BNRTableBgColorKey = @"Table Background Color";
NSString * const BNREmptyDocKey = @"Empty Document Flag";

NSString * const BNRColorChangedNotification = @"BNRColorChanged";

@implementation PreferenceController

- (id)init
{
    if (![super initWithWindowNibName:@"Preferences"])
        return nil;
    return self;
}

- (void)windowDidLoad
{
    [colorWell setColor:[self tableBgColor]];
    [checkbox setState:[self emptyDoc]];
}

- (IBAction)changeBackgroundColor:(id)sender
{
    NSColor *color = [colorWell color];
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData
                                              forKey:BNRTableBgColorKey];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
    
    [nc postNotificationName:BNRColorChangedNotification
                      object:self
                    userInfo:d];
}

- (IBAction)changeNewEmptyDoc:(id)sender
{
    NSInteger state = [checkbox state];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:BNREmptyDocKey];
    NSLog(@"Checkbox changed %ld", state);
}

- (IBAction)resetUserDefaults:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:BNREmptyDocKey];
    [defaults removeObjectForKey:BNRTableBgColorKey];
    [self windowDidLoad];
}

- (NSColor *)tableBgColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:BNRTableBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (BOOL)emptyDoc
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:BNREmptyDocKey];
}

@end

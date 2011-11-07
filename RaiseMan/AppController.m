//
//  AppController.m
//  RaiseMan
//
//  Created by Masaya Suzuki on 11/10/23.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void)initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:
                           [NSColor yellowColor]];
    
    [defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:BNREmptyDocKey];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)showPreferencePanel:(id)sender
{
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    
    [preferenceController showWindow:self];
}

- (IBAction)showAboutPanel:(id)sender
{
    if (!aboutPanelController) {
        aboutPanelController = [[NSWindowController alloc]
                                initWithWindowNibName:@"About"];
    }
    
    [aboutPanelController showWindow:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:BNREmptyDocKey];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
    NSBeep();
    NSLog(@"Application was activated");
}

@end

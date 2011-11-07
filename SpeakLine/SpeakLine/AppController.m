//
//  AppController.m
//  SpeakLine
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "AppController.h"

@implementation AppController

- (void)awakeFromNib
{
    NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
    NSInteger defaultRow = [voiceList indexOfObject:defaultVoice];
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:defaultRow]
           byExtendingSelection:NO];
    [tableView scrollRowToVisible:defaultRow];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [speechSynth setDelegate:self];
        voiceList = [[NSSpeechSynthesizer availableVoices] retain];
    }
    
    return self;
}

- (IBAction)sayIt:(id)sender
{
    NSString *string = [textField stringValue];
    
    if ([string length] == 0) {
        NSLog(@"string from %@ is of zero-length", textField);
        return;
    }
    [speechSynth startSpeakingString:string];
    NSLog(@"Have started to say %@", string);
    
    [stopButton setEnabled:YES];
    [startButton setEnabled:NO];
    [tableView setEnabled:NO];
}

- (IBAction)stopIt:(id)sender
{
    NSLog(@"stopping");
    [speechSynth stopSpeaking];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender
        didFinishSpeaking:(BOOL)finishedSpeaking
{
    NSLog(@"finishedSpeaking = %d", finishedSpeaking);
    [stopButton setEnabled:NO];
    [startButton setEnabled:YES];
    [tableView setEnabled:YES];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv
{
    return [voiceList count];
}

- (id)tableView:(NSTableView *)tv
        objectValueForTableColumn:(NSTableColumn *)tableColumn
                              row:(NSInteger)row
{
    NSString *v = [voiceList objectAtIndex:row];
    return v;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = [tableView selectedRow];
    if (row == -1) {
        return;
    }
    NSString *selectedVoice = [voiceList objectAtIndex:row];
    [speechSynth setVoice:selectedVoice];
    NSLog(@"new voice = %@", selectedVoice);
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *methodName = NSStringFromSelector(aSelector);
    NSLog(@"respondsToSelector:%@", methodName);
    return [super respondsToSelector:aSelector];
}
@end

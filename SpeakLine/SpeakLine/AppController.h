//
//  AppController.h
//  SpeakLine
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject <NSSpeechSynthesizerDelegate>
{
    IBOutlet NSTextField *textField;
    NSSpeechSynthesizer *speechSynth;
    IBOutlet NSButton *startButton;
    IBOutlet NSButton *stopButton;
    IBOutlet NSTableView *tableView;
    NSArray *voiceList;
}

- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;
@end

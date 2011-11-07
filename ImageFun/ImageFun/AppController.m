//
//  AppController.m
//  ImageFun
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "AppController.h"
#import "StretchView.h"

@implementation AppController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel
             returnCode:(NSInteger)returnCode
            contextInfo:(void *)x
{
    if (returnCode == NSOKButton) {
        NSString *path = [openPanel filename];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
        [stretchView setImage:image];
        [image release];
    }
}

- (IBAction)showOpenPanel:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel beginSheetForDirectory:nil
                             file:nil
                            types:[NSImage imageFileTypes]
                   modalForWindow:[stretchView window]
                    modalDelegate:self
                   didEndSelector:
     @selector(openPanelDidEnd:returnCode:contextInfo:)
                      contextInfo:NULL];
}

@end

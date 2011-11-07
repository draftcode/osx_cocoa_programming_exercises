//
//  AppController.m
//  ResizeWindow
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "AppController.h"

@implementation AppController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSSize)windowWillResize:(NSWindow *)sender
                    toSize:(NSSize)frameSize
{
    frameSize.height = frameSize.width * 2;
    return frameSize;
}

@end

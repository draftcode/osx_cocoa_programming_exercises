//
//  AppController.m
//  CharCounting
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

- (IBAction)counting:(id)sender {
    NSString *string = [textField stringValue];
    int len = [string length];

    NSString *message;
    if (len == 0) {
        message = @"There are no characters.";
    } else if (len == 1) {
        message = [NSString stringWithFormat:@"'%@' has only one character.", string];
    } else {
        message = [NSString stringWithFormat:@"'%@' has %d characters.", string, len];
    }
    
    [label setStringValue:message];
}
@end

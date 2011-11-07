//
//  AppController.m
//  KeyValueCoding
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "AppController.h"

@implementation AppController

@synthesize fido;

- (id)init
{
    self = [super init];
    if (self) {
        [self setValue:[NSNumber numberWithInt:5] forKey:@"fido"];
    }
    
    return self;
}

- (IBAction)increment:(id)sender
{
    self.fido++;
}
@end

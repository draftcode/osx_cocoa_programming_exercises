//
//  Foo.m
//  RandomApp
//
//  Created by Masaya Suzuki on 11/10/20.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "Foo.h"

@implementation Foo

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (IBAction)generate:(id)sender
{
    int generated = (int)(random() % 100) + 1;
    NSLog(@"generated = %d", generated);
    
    [textField setIntValue:(int)generated];
}

- (IBAction)seed:(id)sender
{
    srandom(time(NULL));
    [textField setStringValue:@"Generator seeded"];
}

- (void)awakeFromNib
{
    NSCalendarDate *now = [NSCalendarDate calendarDate];
    [textField setObjectValue:now];
}
@end

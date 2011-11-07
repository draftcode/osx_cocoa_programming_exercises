//
//  main.m
//  lottery
//
//  Created by Masaya Suzuki on 11/10/20.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LotteryEntry.h"

int main (int argc, const char * argv[])
{

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    NSCalendarDate *now = [[NSCalendarDate alloc] init];
    
    srandom(time(NULL));    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        NSCalendarDate *iWeeksFromNow;
        iWeeksFromNow = [now dateByAddingYears:0
                                        months:0
                                          days:(i*7)
                                         hours:0
                                       minutes:0
                                       seconds:0];
        
        LotteryEntry *newEntry = [[LotteryEntry alloc] initWithEntryDate:iWeeksFromNow];
        [array addObject:newEntry];
        [newEntry release];
    }
    [now release];
    now = nil;

    for (LotteryEntry *entryToPrint in array) {
        NSLog(@"%@", entryToPrint);
    }
    [array release];
    array = nil;
    
    [pool drain];
    return 0;
}


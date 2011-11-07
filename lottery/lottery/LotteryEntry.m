//
//  LotteryEntry.m
//  lottery
//
//  Created by Masaya Suzuki on 11/10/20.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "LotteryEntry.h"

@implementation LotteryEntry
- (id)init
{
    return [self initWithEntryDate:[NSCalendarDate calendarDate]];
}

- (void)dealloc
{
    NSLog(@"deallocating %@", self);
    [entryDate release];
    [super dealloc];
}

- (id)initWithEntryDate:(NSCalendarDate *)theDate
{
    if (![super init])
        return nil;
    
    NSAssert(theDate != nil, @"Argument must be non-nil");
    entryDate = [theDate retain];
    firstNumber = random() % 100 + 1;
    secondNumber = random() % 100 + 1;
    return self;
}

- (void)setEntryDate:(NSCalendarDate *)date
{
    [date retain];
    [entryDate release];
    entryDate = date;
}

- (NSCalendarDate *)entryDate
{
    return entryDate;
}

- (int)firstNumber
{
    return firstNumber;
}

- (int)secondNumber
{
    return secondNumber;
}

- (NSString *)description
{
    NSString *result;
    result = [[NSString alloc] initWithFormat:@"%@ = %d and %d",
              [entryDate descriptionWithCalendarFormat:@"%Y-%m-%d"],
              firstNumber, secondNumber];
    [result autorelease];
    return result;
}
@end

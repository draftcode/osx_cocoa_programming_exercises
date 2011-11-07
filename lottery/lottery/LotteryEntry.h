//
//  LotteryEntry.h
//  lottery
//
//  Created by Masaya Suzuki on 11/10/20.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryEntry : NSObject
{
    NSCalendarDate *entryDate;
    int firstNumber;
    int secondNumber;
}
- (id)initWithEntryDate:(NSCalendarDate *)theDate;
- (void)setEntryDate:(NSCalendarDate *)date;
- (NSCalendarDate *)entryDate;
- (int)firstNumber;
- (int)secondNumber;
@end

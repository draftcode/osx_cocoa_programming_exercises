//
//  FirstLetter.m
//  TypingTutor
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "FirstLetter.h"

@implementation NSString (FirstLetter)

- (NSString *)BNR_firstLetter
{
    if ([self length] < 2) {
        return self;
    }
    NSRange r;
    r.location = 0;
    r.length = 1;
    return [self substringWithRange:r];
}

@end

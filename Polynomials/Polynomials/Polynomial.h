//
//  Polynomial.h
//  Polynomials
//
//  Created by Masaya Suzuki on 11/10/29.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Polynomial : NSObject
{
    __strong CGFloat *terms;
    int termCount;
    __strong CGColorRef color;
}
- (float)valueAt:(float)x;
- (void)drawInRect:(CGRect)b
         inContext:(CGContextRef)ctx;
- (CGColorRef)color;
@end

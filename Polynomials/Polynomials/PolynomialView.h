//
//  PolynomialView.h
//  Polynomials
//
//  Created by Masaya Suzuki on 11/10/29.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PolynomialView : NSView
{
    NSMutableArray *polynomials;
    BOOL blasted;
}
- (IBAction)createNewPolynomial:(id)sender;
- (IBAction)deleteRandomPolynomial:(id)sender;
- (IBAction)blastem:(id)sender;
- (NSPoint)randomOffViewPosition;
@end

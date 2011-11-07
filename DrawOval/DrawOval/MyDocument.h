//
//  MyDocument.h
//  DrawOval
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class OvalDrawView;

@interface MyDocument : NSDocument
{
    NSMutableArray *ovals;
    IBOutlet OvalDrawView *view;
}
- (void)removeObjectFromOvalsAtIndex:(NSUInteger)index;
- (void)insertObject:(NSValue *)object inOvalsAtIndex:(NSUInteger)index;
@property (readwrite, retain) NSMutableArray *ovals;
@end

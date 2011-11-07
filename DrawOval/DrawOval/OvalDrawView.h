//
//  OvalDrawView.h
//  DrawOval
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OvalDrawView : NSView
{
    id valueObservable;
    NSString *valueKeyPath;
    NSPoint downPoint;
    NSPoint currentPoint;
}
@end

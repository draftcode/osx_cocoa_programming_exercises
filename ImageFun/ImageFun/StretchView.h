//
//  StretchView.h
//  ImageFun
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StretchView : NSView
{
    NSBezierPath *path;
    NSImage *image;
    float opacity;
    NSPoint downPoint;
    NSPoint currentPoint;
    NSTimer *timer;
}
@property (readwrite) float opacity;
- (void)setImage:(NSImage *)newImage;
- (NSPoint)randomPoint;
@end

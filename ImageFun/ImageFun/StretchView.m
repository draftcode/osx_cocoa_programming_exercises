//
//  StretchView.m
//  ImageFun
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "StretchView.h"

@implementation StretchView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        srandom(time(NULL));
        
        path = [[NSBezierPath alloc] init];
        [path setLineWidth:3.0];
        NSPoint p = [self randomPoint];
        [path moveToPoint:p];
        for (int i = 0; i < 15; i++) {
            p = [self randomPoint];
            NSPoint controlPoint1 = [self randomPoint];
            NSPoint controlPoint2 = [self randomPoint];
            [path curveToPoint:p
                 controlPoint1:controlPoint1
                 controlPoint2:controlPoint2];
        }
        [path closePath];
        opacity = 1.0;
    }
    
    return self;
}

- (void)dealloc
{
    [path release];
    [image release];
    [super dealloc];
}

- (NSPoint)randomPoint
{
    NSPoint result;
    NSRect r = [self bounds];
    result.x = r.origin.x + random() % (int)r.size.width;
    result.y = r.origin.y + random() % (int)r.size.height;
    return result;
}


- (NSRect)currentRect
{
    float minX = MIN(downPoint.x, currentPoint.x);
    float maxX = MAX(downPoint.x, currentPoint.x);
    float minY = MIN(downPoint.y, currentPoint.y);
    float maxY = MAX(downPoint.y, currentPoint.y);
    
    return NSMakeRect(minX, minY, maxX-minX, maxY-minY);
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    [[NSColor greenColor] set];
    [NSBezierPath fillRect:bounds];
    
    [[NSColor whiteColor] set];
    [path fill];
    
    if (image) {
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = [image size];
        NSRect drawingRect = [self currentRect];
        [image drawInRect:drawingRect
                 fromRect:imageRect
                operation:NSCompositeSourceOver
                 fraction:opacity];
    }
}


#pragma mark Events

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    downPoint = [self convertPoint:p fromView:nil];
    currentPoint = downPoint;
    [self setNeedsDisplay:YES];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(check:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)check:(NSTimer *)aTimer
{
    NSPoint p = [[NSApp currentEvent] locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self setNeedsDisplay:YES];
    [self autoscroll:[NSApp currentEvent]];
}


- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self setNeedsDisplay:YES];
    
    [timer invalidate];
    [timer release];
    timer = nil;
}

#pragma mark Accessors

- (void)setImage:(NSImage *)newImage
{
    [newImage retain];
    
    [image release];
    image = newImage;
    NSSize imageSize = [newImage size];
    downPoint = NSZeroPoint;
    currentPoint.x = downPoint.x + imageSize.width;
    currentPoint.y = downPoint.y + imageSize.height;
    [self setNeedsDisplay:YES];
}

- (float)opacity
{
    return opacity;
}

- (void)setOpacity:(float)x
{
    opacity = x;
    [self setNeedsDisplay:YES];
}

@end

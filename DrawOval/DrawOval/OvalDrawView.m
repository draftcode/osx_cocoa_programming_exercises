//
//  OvalDrawView.m
//  DrawOval
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "OvalDrawView.h"

@implementation OvalDrawView

+ (void)initialize
{
    [self exposeBinding:@"value"];
}

# pragma mark Utilities

- (NSRect)currentRect
{
    float minX = MIN(downPoint.x, currentPoint.x);
    float maxX = MAX(downPoint.x, currentPoint.x);
    float minY = MIN(downPoint.y, currentPoint.y);
    float maxY = MAX(downPoint.y, currentPoint.y);
    
    return NSMakeRect(minX, minY, maxX-minX, maxY-minY);
}

# pragma mark NSView implementation

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        valueObservable = valueKeyPath = nil;
        downPoint = currentPoint = NSZeroPoint;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (valueObservable != nil) {
        [[NSColor blueColor] set];
    
        NSArray *arr =
            [valueObservable mutableArrayValueForKeyPath:valueKeyPath];
        for (NSValue *v in arr) {
            NSBezierPath *path =[NSBezierPath
                                 bezierPathWithOvalInRect:[v rectValue]];
            [path stroke];
        }
    }
    
    NSBezierPath *path = [NSBezierPath
                          bezierPathWithOvalInRect:[self currentRect]];
    [path stroke];
}

- (void)addCurrentRectAsOval
{
    if (valueObservable != nil) {
        NSValue *v = [NSValue valueWithRect:[self currentRect]];
        NSMutableArray *arr =
            [valueObservable mutableArrayValueForKeyPath:valueKeyPath];
        [arr addObject:v];
    }    
}

# pragma mark Mouse Events

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    downPoint = [self convertPoint:p fromView:nil];
    currentPoint = downPoint;
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint p = [theEvent locationInWindow];
    currentPoint = [self convertPoint:p fromView:nil];

    [self addCurrentRectAsOval];
    
    downPoint = currentPoint = NSZeroPoint;
    [self setNeedsDisplay:YES];
}

# pragma mark Binding

- (void)bind:(NSString *)binding
    toObject:(id)observable
 withKeyPath:(NSString *)keyPath
     options:(NSDictionary *)options
{
    if ([binding isEqualToString:@"value"]) {
        [observable addObserver:self
                     forKeyPath:keyPath
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
        valueObservable = observable;
        valueKeyPath = keyPath;
        [keyPath retain];
    }
}

- (void)unbind:(NSString *)binding
{
    if (valueKeyPath != nil && [binding isEqualToString:@"value"]) {
        [valueObservable removeObserver:self forKeyPath:valueKeyPath];
        [valueKeyPath release];
        valueKeyPath = nil;
        valueObservable = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (valueKeyPath != nil &&
        [valueKeyPath isEqualToString:keyPath] &&
        valueObservable == object)
    {
        [self setNeedsDisplay:YES];
    }
}

@end

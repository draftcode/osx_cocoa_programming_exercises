//
//  ColorFormatter.m
//  TypingTutor
//
//  Created by Masaya Suzuki on 11/10/27.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "ColorFormatter.h"

@interface ColorFormatter ()
- (NSString *)firstColorKeyForPartialString:(NSString *)string;
@end

@implementation ColorFormatter

- (id)init
{
    self = [super init];
    if (self) {
        colorList = [[NSColorList colorListNamed:@"Apple"] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [colorList release];
    [super dealloc];
}

- (NSString *)firstColorKeyForPartialString:(NSString *)string
{
    if ([string length] == 0) {
        return nil;
    }
    
    for (NSString *key in [colorList allKeys]) {
        NSRange whereFound = [key rangeOfString:string
                                        options:NSCaseInsensitiveSearch];
        if ((whereFound.location == 0) && (whereFound.length > 0)) {
            return key;
        }
    }
    
    return nil;
}

- (NSString *)stringForObjectValue:(id)obj
{
    if (![obj isKindOfClass:[NSColor class]]) {
        return nil;
    }
    
    NSColor *color = [obj colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat red, green, blue;
    [color getRed:&red
            green:&green
             blue:&blue
            alpha:NULL];
    
    float minDistance = 3.0;
    NSString *closestKey = nil;
    
    for (NSString *key in [colorList allKeys]) {
        NSColor *c = [colorList colorWithKey:key];
        CGFloat r, g, b;
        [c getRed:&r green:&g blue:&b alpha:NULL];
        
        float dist;
        dist = pow(red-r,2) + pow(green-g,2) + pow(blue-b,2);
        
        if (dist < minDistance) {
            minDistance = dist;
            closestKey = key;
        }
    }
    
    return closestKey;
}

- (BOOL) getObjectValue:(id *)obj
              forString:(NSString *)string
       errorDescription:(NSString **)error
{
    NSString *matchingKey = [self firstColorKeyForPartialString:string];
    
    if (matchingKey) {
        *obj = [colorList colorWithKey:matchingKey];
        return YES;
    } else {
        if (error != NULL) {
            *error = [NSString stringWithFormat:
                      @"'%@' is not a color", string];
        }
        return NO;
    }
}

//- (BOOL) isPartialStringValid:(NSString *)partialString newEditingString:(NSString **)newString errorDescription:(NSString **)error
//{
//    if ([partialString length] == 0) {
//        return YES;
//    }
//    
//    NSString *match = [self firstColorKeyForPartialString:partialString];
//    if (match) {
//        return YES;
//    } else {
//        if (error) {
//            *error = @"No such Color";
//        }
//        return NO;
//    }
//}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString **)error
{
    if ([*partialStringPtr length] == 0) {
        return YES;
    }
    
    NSString *match = [self firstColorKeyForPartialString:*partialStringPtr];
    if (!match) {
        return NO;
    }
    
    if (origSelRange.location == proposedSelRangePtr->location) {
        return YES;
    }
    
    if ([match length] != [*partialStringPtr length]) {
        proposedSelRangePtr->location = [*partialStringPtr length];
        proposedSelRangePtr->length = [match length] - proposedSelRangePtr->location;
        *partialStringPtr = match;
        return NO;
    }
    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs
{
    NSMutableDictionary *md = [attrs mutableCopy];
    NSString *match = [self stringForObjectValue:obj];
    if (match) {
        [md setObject:obj forKey:NSForegroundColorAttributeName];
    } else {
        match = @"";
    }
    
    NSAttributedString *atString;
    atString = [[NSAttributedString alloc] initWithString:match
                                               attributes:md];
    
    [md release];
    [atString autorelease];
    return atString;
}
@end

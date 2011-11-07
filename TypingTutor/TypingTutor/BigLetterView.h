//
//  BigLetterView.h
//  TypingTutor
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BigLetterView : NSView
{
    NSColor *bgColor;
    NSString *string;
    NSMutableDictionary *attributes;
    NSEvent *mouseDownEvent;
    
    BOOL bold;
    BOOL italic;
    BOOL highlighted;
}
- (void)prepareAttributes;
- (void)drawStringCenteredIn:(NSRect)r;
- (IBAction)savePDF:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;

@property (retain, readwrite) NSColor *bgColor;
@property (copy, readwrite) NSString *string;
@property (readwrite) BOOL bold;
@property (readwrite) BOOL italic;
@end

//
//  BigLetterView.m
//  TypingTutor
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "BigLetterView.h"
#import "FirstLetter.h"

@implementation BigLetterView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initializing view");
        attributes = [[NSMutableDictionary alloc] init];
        bgColor = [[NSColor yellowColor] retain];
        string = @" ";
        [self registerForDraggedTypes:
         [NSArray arrayWithObject:NSStringPboardType]];
        bold = NO;
        italic = NO;

        [self prepareAttributes];
    }
    
    return self;
}

- (void)dealloc
{
    [bgColor release];
    [string release];
    [attributes release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    if (highlighted) {
        NSGradient *gr;
        gr = [[NSGradient alloc] initWithStartingColor:[NSColor whiteColor]
                                           endingColor:bgColor];
        [gr drawInRect:bounds relativeCenterPosition:NSZeroPoint];
        [gr release];
    } else {
        [bgColor set];
        [NSBezierPath fillRect:bounds];
    }
    [self drawStringCenteredIn:bounds];
    
    if ([[self window] firstResponder] == self &&
        [NSGraphicsContext currentContextDrawingToScreen])
    {
        [NSGraphicsContext saveGraphicsState];
        NSSetFocusRingStyle(NSFocusRingOnly);
        [NSBezierPath fillRect:bounds];
        [NSGraphicsContext restoreGraphicsState];
    }
}

- (BOOL)isOpaque
{
    return YES;
}

- (void)prepareAttributes
{
    [attributes setObject:[NSFont fontWithName:@"Helvetica"
                                          size:75]
                   forKey:NSFontAttributeName];
    
    [attributes setObject:[NSColor redColor]
                   forKey:NSForegroundColorAttributeName];
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    if (bold) {
        NSFont *boldFont =
            [fontManager
                convertFont:[attributes objectForKey:NSFontAttributeName]
                toHaveTrait:NSBoldFontMask];
        [attributes setObject:boldFont forKey:NSFontAttributeName];
    }

    if (italic) {
        NSFont *italicFont =
            [fontManager
             convertFont:[attributes objectForKey:NSFontAttributeName]
             toHaveTrait:NSItalicFontMask];
        [attributes setObject:italicFont forKey:NSFontAttributeName];
    }
}

- (void)drawStringCenteredIn:(NSRect)r
{
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:NSMakeSize(5.0, 5.0)];
    [shadow setShadowColor:[NSColor grayColor]];
    [shadow setShadowBlurRadius:3.0];
    [shadow set];
    
    NSSize strSize = [string sizeWithAttributes:attributes];
    NSPoint strOrigin;
    strOrigin.x = r.origin.x + (r.size.width - strSize.width)/2;
    strOrigin.y = r.origin.y + (r.size.height - strSize.height)/2;
    [string drawAtPoint:strOrigin withAttributes:attributes];
}

#pragma mark First Responder

- (BOOL)acceptsFirstResponder
{
    NSLog(@"Accepting");
    return YES;
}

- (BOOL)resignFirstResponder
{
    NSLog(@"Resigning");
    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    return YES;
}

- (BOOL)becomeFirstResponder
{
    NSLog(@"Becoming");
    [self setNeedsDisplay:YES];
    return YES;
}

#pragma mark Keyboard Events

- (void)keyDown:(NSEvent *)theEvent
{
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
}

- (void)insertText:(id)insertString
{
    [self setString:insertString];
}

- (void)insertTab:(id)sender
{
    [[self window] selectKeyViewFollowingView:self];
}

- (void)insertBacktab:(id)sender
{
    [[self window] selectKeyViewPrecedingView:self];
}

- (void)deleteBackward:(id)sender
{
    [self setString:@" "];
}

#pragma mark Accessor

- (void)setBgColor:(NSColor *)c
{
    [c retain];
    [c release];
    bgColor = c;
    [self setNeedsDisplay:YES];
}

- (NSColor *)bgColor
{
    return bgColor;
}

- (void)setString:(NSString *)c
{
    c = [c copy];
    [string release];
    string = c;
    NSLog(@"The string is now %@", string);
    [self setNeedsDisplay:YES];
}

- (NSString *)string
{
    return string;
}

- (void)setBold:(BOOL)c
{
    bold = c;
    [self prepareAttributes];
    [self setNeedsDisplay:YES];
}

- (BOOL)bold
{
    return bold;
}

- (void)setItalic:(BOOL)c
{
    italic = c;
    [self prepareAttributes];
    [self setNeedsDisplay:YES];
}

- (BOOL)italic
{
    return italic;
}

#pragma mark Actions

- (void)didEnd:(NSSavePanel *)sheet
    returnCode:(NSInteger)code
   contextInfo:(void *)contextInfo
{
    if (code != NSOKButton)
        return;
    
    NSRect r = [self bounds];
    NSData *data = [self dataWithPDFInsideRect:r];
    NSString *path = [sheet filename];
    NSError *error;
    BOOL successful = [data writeToFile:path
                                options:0
                                  error:&error];
    
    if (!successful) {
        NSAlert *a = [NSAlert alertWithError:error];
        [a runModal];
    }
}

- (IBAction)savePDF:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setRequiredFileType:@"pdf"];
    [panel beginSheetForDirectory:nil
                             file:nil
                   modalForWindow:[self window]
                    modalDelegate:self
                   didEndSelector:
     @selector(didEnd:returnCode:contextInfo:)
                      contextInfo:NULL];
}

#pragma mark Copy and Paste

- (void)writeToPasteboard:(NSPasteboard *)pb
{
    [pb declareTypes:[NSArray arrayWithObjects:
                        NSStringPboardType, NSPDFPboardType, nil]
               owner:self];
    
    [pb setString:string forType:NSStringPboardType];
    [pb setData:[self dataWithPDFInsideRect:[self bounds]]
        forType:NSPDFPboardType];
}

- (BOOL)readFromPasteboard:(NSPasteboard *)pb
{
    NSArray *types = [pb types];
    if ([types containsObject:NSStringPboardType]) {
        NSString *value = [pb stringForType:NSStringPboardType];
        
        [self setString:[value BNR_firstLetter]];
        return YES;
    }
    return NO;
}

- (IBAction)cut:(id)sender
{
    [self copy:sender];
    [self setString:@""];
}

- (IBAction)copy:(id)sender
{
    NSPasteboard *pb = [NSPasteboard  generalPasteboard];
    [self writeToPasteboard:pb];
}

- (IBAction)paste:(id)sender
{
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    if (![self readFromPasteboard:pb]) {
        NSBeep();
    }
}

#pragma mark Drag and Drop

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
{
    return NSDragOperationCopy | NSDragOperationDelete;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [theEvent retain];
    [mouseDownEvent release];
    mouseDownEvent = theEvent;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint down = [mouseDownEvent locationInWindow];
    NSPoint drag = [theEvent locationInWindow];
    float distance = hypot(down.x - drag.x, down.y - drag.y);
    if (distance < 3) {
        return;
    }
    
    if ([string length] == 0) {
        return;
    }
    
    NSSize s = [string sizeWithAttributes:attributes];
    
    NSImage *anImage = [[NSImage alloc] initWithSize:s];
    NSRect imageBounds;
    imageBounds.origin = NSZeroPoint;
    imageBounds.size = s;
    
    [anImage lockFocus];
    [self drawStringCenteredIn:imageBounds];
    [anImage unlockFocus];
    
    NSPoint p = [self convertPoint:down fromView:nil];
    
    p.x = p.x - s.width/2;
    p.y = p.y - s.height/2;
    
    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSDragPboard];
    
    [self writeToPasteboard:pb];
    
    [self dragImage:anImage
                 at:p
             offset:NSMakeSize(0, 0)
              event:mouseDownEvent
         pasteboard:pb
             source:self
          slideBack:YES];
    
    [anImage release];
}

- (void)draggedImage:(NSImage *)image endedAt:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    if (operation == NSDragOperationDelete) {
        [self setString:@""];
    }
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered:");
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    
    highlighted = YES;
    [self setNeedsDisplay:YES];
    return NSDragOperationCopy;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSLog(@"draggingExited:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pb = [sender draggingPasteboard];
    if (![self readFromPasteboard:pb]) {
        NSLog(@"Error: Could not read from dragging pasteboard");
        return NO;
    }
    return YES;
}

- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"concludeDragOperation:");
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    NSDragOperation op = [sender draggingSourceOperationMask];
    NSLog(@"operation mask = %ld", op);
    if ([sender draggingSource] == self) {
        return NSDragOperationNone;
    }
    return NSDragOperationCopy;
}

@end

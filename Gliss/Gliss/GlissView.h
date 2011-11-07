//
//  GlissView.h
//  Gliss
//
//  Created by Masaya Suzuki on 11/10/29.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GlissView : NSOpenGLView
{
    IBOutlet NSMatrix *sliderMatrix;
    float lightX, theta, radius;
    int displayList;
}
- (IBAction)changeParameter:(id)sender;
@end

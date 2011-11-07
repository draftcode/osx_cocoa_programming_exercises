//
//  AppController.h
//  ImageFun
//
//  Created by Masaya Suzuki on 11/10/24.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StretchView;

@interface AppController : NSObject
{
    IBOutlet StretchView *stretchView;
}
- (IBAction)showOpenPanel:(id)sender;
@end

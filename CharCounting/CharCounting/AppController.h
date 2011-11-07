//
//  AppController.h
//  CharCounting
//
//  Created by Masaya Suzuki on 11/10/21.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject
{
    IBOutlet NSTextField *textField;
    IBOutlet NSTextField *label;
}
- (IBAction)counting:(id)sender;
@end

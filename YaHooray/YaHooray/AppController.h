//
//  AppController.h
//  YaHooray
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface AppController : NSObject <NSTableViewDataSource>
{
    IBOutlet NSProgressIndicator *progress;
    IBOutlet NSTextField *searchField;
    IBOutlet NSTableView *tableView;
    
    NSXMLDocument *doc;
    NSArray *itemNodes;
    
    IBOutlet NSWindow *sheet;
    IBOutlet WebView *webView;
    IBOutlet NSProgressIndicator *webIndicator;
}
- (IBAction)fetchData:(id)sender;
- (IBAction)closeWebSheet:(id)sender;
@end

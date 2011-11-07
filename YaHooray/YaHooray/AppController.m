//
//  AppController.m
//  YaHooray
//
//  Created by Masaya Suzuki on 11/10/28.
//  Copyright 2011年 Tokyo Institute of Technology. All rights reserved.
//

#import "AppController.h"
#define YAHOO_APP_ID @"DCrlirGxg65k9iHchSOqAuMWNOGHpHdAmb4_V3KH5j3_cBeut4Nkt9tjfV7nTkGcLw--"

@implementation AppController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [tableView setDoubleAction:@selector(openItem:)];
    [tableView setTarget:self];
}


- (NSString *)stringForPath:(NSString *)xp ofNode:(NSXMLNode *)n
{
    NSError *error;
    NSArray *nodes = [n nodesForXPath:xp error:&error];
    if (!nodes) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return nil;
    }
    if ([nodes count] == 0) {
        return nil;
    } else {
        return [[nodes objectAtIndex:0] stringValue];
    }
}

- (void)openItem:(id)sender
{
    NSInteger row = [tableView clickedRow];
    if (row == -1) {
        return;
    }
    
    NSXMLNode *clickedItem = [itemNodes objectAtIndex:row];
    NSString *urlString = [self stringForPath:@"Url"
                                       ofNode:clickedItem];
    
    // NSURL *url = [NSURL URLWithString:urlString];
    // [[NSWorkspace sharedWorkspace] openURL:url];
    
    [webView setMainFrameURL:urlString];
    [NSApp beginSheet:sheet
       modalForWindow:[progress window]
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
}

- (IBAction)fetchData:(id)sender
{
    [progress startAnimation:nil];
    
    NSString *input = [searchField stringValue];
    NSString *searchString =
        [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"searchString = %@", searchString);
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://search.yahooapis.jp/WebSearchService/V2/webSearch?"
                           @"appid=%@&"
                           @"query=%@&"
                           @"results=50",
                           YAHOO_APP_ID,
                           searchString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    if (!urlData) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return;
    }
    
    [doc release];
    doc = [[NSXMLDocument alloc] initWithData:urlData
                                      options:0
                                        error:&error];
    NSLog(@"doc = %@", doc);
    if (!doc) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return;
    }
    
    [itemNodes release];
    itemNodes = [[doc nodesForXPath:@"ResultSet/Result"
                              error:&error] retain];
    if (!itemNodes) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return;
    }
    
    [tableView reloadData];
    [progress stopAnimation:nil];
}

#pragma mark TableView data source methods

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return [itemNodes count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSXMLNode *node = [itemNodes objectAtIndex:row];
    NSString *xPath = [tableColumn identifier];
    return [self stringForPath:xPath ofNode:node];
}

#pragma mark WebView sheet

- (IBAction)closeWebSheet:(id)sender
{
    [NSApp endSheet:sheet];
    [sheet orderOut:sender];
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    [webIndicator startAnimation:nil];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [webIndicator stopAnimation:nil];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
    [webIndicator stopAnimation:nil];
}

@end

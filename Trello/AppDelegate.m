//
//  AppDelegate.m
//  Trello
//
//  Created by Hector Vergara on 7/19/12.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize webview;
WebInspector *_inspector;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)awakeFromNib {
    //enable WebKit Inspector
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //userscript loader
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *jsPath = [resourcesPath stringByAppendingString:@"/userscripts/loader.js"];
    
    NSString *urlAddress = @"https://www.trello.com/login";
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //need proper user-agent for Trello's JS to enable drag-n-drop attach's
    [webview setCustomUserAgent:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_9_3; en-us) AppleWebKit/537.76.4 (KHTML, like Gecko) Version/7.0.4 Safari/537.76.4"];
    //[webview setApplicationNameForUserAgent:@"Safari"];
    
    [[webview mainFrame] loadRequest:requestObj];
}

- (IBAction)reloadPage:(id)sender {
    [webview reload:sender];
}

-(BOOL)route_link:(NSURL *)url
{
    return ([[url host] hasSuffix:@"trello.com"] || [[url host] hasSuffix:@"accounts.google.com"]);
}

-(void)background_link:(NSURL *)url
{
    NSLog(@"opening in external browser: %@", url);
    //[[NSWorkspace sharedWorkspace] openURL:url];
    NSArray* urls = [NSArray arrayWithObject:url];
    [[NSWorkspace sharedWorkspace] openURLs:urls withAppBundleIdentifier:nil options:NSWorkspaceLaunchWithoutActivation additionalEventParamDescriptor:nil launchIdentifiers:nil];
}

- (void)webView:(WebView *)sender
decidePolicyForNavigationAction:(NSDictionary *)actionInformation
        request:(NSURLRequest *)request
          frame:(id)frame
decisionListener:(id <WebPolicyDecisionListener>)listener
{
    NSURL *url = [request URL];
    if ([self route_link:url]) {
        NSLog(@"opening in webview: %@", url);
        [listener use];
    } else {
        [listener ignore];
        [self background_link:url];
    }
}

- (void)webView:(WebView *)sender
decidePolicyForNewWindowAction:(NSDictionary *)actionInformation
request:(NSURLRequest *)request
newFrameName:(NSString *)frameName
decisionListener:(id <WebPolicyDecisionListener>)listener
{
    [self background_link:[request URL]];
}

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];

    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:NO];

    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [[openDlg URLs]valueForKey:@"relativePath"];
        [resultListener chooseFilenames:files];
    }
}

- (IBAction)showInspector:(id)x {
    _inspector = [WebInspector.alloc initWithWebView:webview];
    [_inspector      detach:webview];
    [_inspector showConsole:webview];
}

@end

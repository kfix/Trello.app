//
//  AppDelegate.h
//  Trello
//
//  Created by Hector Vergara on 7/19/12.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    WebView *webview;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain, nonatomic) IBOutlet WebView *webview;
- (IBAction)reloadPage:(id)sender;
- (IBAction)showInspector:(id)sender;

-(BOOL)route_link:(NSURL *)url;
-(void)background_link:(NSURL *)url;

@end

@interface WebInspector : NSObject  { WebView *_webView; }
- (id)initWithWebView:(WebView *)webView;
- (void)detach:     (id)sender;
- (void)show:       (id)sender;
- (void)showConsole:(id)sender;
@end

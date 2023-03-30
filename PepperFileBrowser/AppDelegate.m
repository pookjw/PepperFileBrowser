//
//  AppDelegate.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/29/23.
//

#import "AppDelegate.h"
#import "FilesViewController.h"
#import <objc/message.h>

@interface AppDelegate ()
@property (retain) id _Nullable window;
@end

@implementation AppDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    id window = [NSClassFromString(@"UIWindow") new];
    
    id filesViewController = FilesViewController_initWithURL([FilesViewController() alloc], [NSURL fileURLWithPath:@"/" isDirectory:YES]);
    id navigationController = ((id (*)(id, SEL, id, BOOL))objc_msgSend)([NSClassFromString(@"PUICNavigationController") alloc], NSSelectorFromString(@"initWithRootViewController:requireStatusBar:"), filesViewController, YES);
    
    [filesViewController release];
    
    ((void (*)(id, SEL, id))objc_msgSend)(window, NSSelectorFromString(@"setRootViewController:"), navigationController);
    
    [navigationController release];
    
    ((void (*)(id, SEL))objc_msgSend)(window, NSSelectorFromString(@"makeKeyAndVisible"));
    
    self.window = window;
    [window release];
    
    return YES;
}

- (void)didReceiveNonClockKitEvent {
    
}

- (id)extendLaunchTest {
    return nil;
}

- (void)applicationWillSuspend:(id)arg0 {
    
}

@end

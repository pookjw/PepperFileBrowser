//
//  AppDelegate.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/29/23.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (retain) id _Nullable window;
@end

@implementation AppDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(id)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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

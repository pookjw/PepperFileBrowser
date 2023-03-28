//
//  main.m
//  PepperFileBrowser Watch App
//
//  Created by Jinwoo Kim on 3/29/23.
//

#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    void *uiKit = dlopen("/System/Library/Frameworks/UIKit.framework/UIKit", RTLD_NOW);
    assert(uiKit);
    
    int (*UIApplicationMain)(int, char * _Nullable *, NSString * _Nullable, NSString * _Nullable) = dlsym(uiKit, "UIApplicationMain");
    
    void *watchKit = dlopen("/System/Library/Frameworks/WatchKit.framework/WatchKit", RTLD_NOW);
    assert(watchKit);
    
    return UIApplicationMain(argc, argv, @"SPApplication", NSStringFromClass(AppDelegate.class));
}

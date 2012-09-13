//
//  AppDelegate.m
//  FileSuffixesTest
//
//  Created by Nick Lockwood on 08/06/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "StandardPaths.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //load the correct nib on iPhone 5 as Apple offers no built-in support
    NSString *nibName = [@"ViewController" stringByAppendingTallscreenSuffix];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:nibName bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

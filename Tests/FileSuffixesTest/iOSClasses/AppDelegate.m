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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

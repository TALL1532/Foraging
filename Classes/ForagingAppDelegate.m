//
//  ForagingAppDelegate.m
//  Foraging
//
//  Created by Andrew Battles on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ForagingAppDelegate.h"

@implementation ForagingAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    vc = [[ExpInterfaceVC alloc] initWithNibName:@"ExpInterfaceVC" bundle:nil];
	
	
	nav = [[UINavigationController alloc] 
		   initWithRootViewController:vc];
	nav.navigationController.title = @"Experimenter Interface";
	[[self window] addSubview:[nav view]];   
	
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[LoggingSingleton logIt:@"----- Foraging program closed"];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	NSLog(@"MEMORY WARN APPDELEGATE");
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end

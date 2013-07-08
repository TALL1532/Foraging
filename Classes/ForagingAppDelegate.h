//
//  ForagingAppDelegate.h
//  Foraging
//
//  Created by Andrew Battles on 6/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ExpInterfaceVC.h"

@interface ForagingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *nav;
	ExpInterfaceVC *vc;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


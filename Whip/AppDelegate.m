//
//  AppDelegate.m
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenViewController.h"
#import <Parse/Parse.h>
#import "TimerUIApplication.h"

@interface AppDelegate ()

@end

@import iAd;

@implementation AppDelegate

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	[UIViewController prepareInterstitialAds];
	
	// Initialize Parse.
	[Parse setApplicationId:@"h7AF6v1BMu9K94qase78fqEfk0F4NwsVsBqIkZoc"
		      clientKey:@"EDS0ouDdeu1KVMMWGIZwjCc4qTgTMqvOrmkl6pGn"];
 
	// [Optional] Track statistics around application opens.
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	
	//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];

	return YES;
}


-(void)applicationDidTimeout:(NSNotification *) notif
{
	NSLog (@"time exceeded!!");
	
	//This is where storyboarding vs xib files comes in. Whichever view controller you want to revert back to, on your storyboard, make sure it is given the identifier that matches the following code. In my case, "mainView". My storyboard file is called MainStoryboard.storyboard, so make sure your file name matches the storyboardWithName property.
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	//Home controller
	HomeScreenViewController *hsvc = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
//	self.window.rootViewController = hsvc;
	
	[(UINavigationController *)self.window.rootViewController pushViewController:hsvc animated:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//	//Home controller
//	HomeScreenViewController *hsvc = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreenViewController"];
//	self.window.rootViewController = hsvc;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

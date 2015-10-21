//
//  TimerUIApplication.h
//  Whip
//
//  Created by Allen White on 10/20/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 0.5

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"


@interface TimerUIApplication : UIApplication
{
	NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;


@end

//
//  HomeScreenViewController.h
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeScreenViewController : UIViewController

- (IBAction)playButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@end

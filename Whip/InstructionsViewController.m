//
//  InstructionsViewController.m
//  Whip
//
//  Created by Allen White on 10/8/15.
//  Copyright © 2015 Worldwide International. All rights reserved.
//

#import "InstructionsViewController.h"
#import "GamePlayViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	 if ([segue.identifier isEqualToString:@"playTapped"]) {
//		GamePlayViewController *gpvc = segue.destinationViewController;
	}
 }


@end

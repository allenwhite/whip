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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)readyButtonTapped:(id)sender {
	GamePlayViewController *gpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePlayViewController"];
	[self presentViewController:gpvc animated:YES completion:nil];
}
@end

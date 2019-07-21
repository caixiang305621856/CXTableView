//
//  CXViewController.m
//  CXTableView
//
//  Created by caixiang305621856 on 07/20/2019.
//  Copyright (c) 2019 caixiang305621856. All rights reserved.
//

#import "CXViewController.h"
#import "CXDemoViewController.h"
#import "CXDemo1ViewController.h"

@interface CXViewController ()

@end

@implementation CXViewController

- (IBAction)pushClick:(id)sender {
    CXDemoViewController *demoViewController = [[CXDemoViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:demoViewController animated:YES];
}

- (IBAction)pushClick2:(id)sender {
    CXDemo1ViewController *demoViewController = [[CXDemo1ViewController alloc] init];
    [self.navigationController pushViewController:demoViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

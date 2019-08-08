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
#import "CXResponder.h"

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
    
    CXResponder *responder1 = [[CXResponder alloc] init];
    responder1.responderName = @"responder1";
    CXResponder *responder2 = [[CXResponder alloc] init];
    responder2.responderName = @"responder2";
    CXResponder *responder3 = [[CXResponder alloc] init];
    responder3.responderName = @"responder3";
    CXResponder *responder4 = [[CXResponder alloc] init];
    responder4.responderName = @"responder4";
    responder1.nextResponder = responder2;
    responder2.nextResponder = responder3;
    responder3.nextResponder = responder4;
    responder4.handled = YES;

    responder1.handled = NO;
    [responder1 handle:^(CXResponder * _Nonnull responder, BOOL handled) {
        if(handled) {
            NSLog(@"%@",responder.responderName);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

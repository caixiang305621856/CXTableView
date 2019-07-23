//
//  CXEmptyView.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/23.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXEmptyView.h"

@interface CXEmptyView()

@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@end

@implementation CXEmptyView
- (void)awakeFromNib {
    [super awakeFromNib];
    self.loadBtn.layer.borderWidth = 1.0f;
    self.loadBtn.layer.cornerRadius = 5.0f;
    self.loadBtn.layer.borderColor = [UIColor blueColor].CGColor;
}

- (IBAction)load:(id)sender {
    !self.reloadData?:self.reloadData();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

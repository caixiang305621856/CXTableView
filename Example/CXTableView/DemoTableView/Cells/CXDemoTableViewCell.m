//
//  CXDemoTableViewCell.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemoTableViewCell.h"
#import "CXDemoAdapter.h"

@interface CXDemoTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation CXDemoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setItem:(CXDemoAdapter *)item {
    self.titleLabel.text = item.title;
    [self.addBtn setTitle:item.content forState:UIControlStateNormal];
}

+ (CGFloat)rowHeightForItem:(id)object {
    return 60;
}

- (void)addClick:(id)sender {
    !self.clickHandler?:self.clickHandler();
}


@end

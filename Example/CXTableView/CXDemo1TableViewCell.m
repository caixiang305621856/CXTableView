//
//  CXDemo1TableViewCell.m
//  CXTableView_Example
//
//  Created by caixiang on 2019/7/20.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXDemo1TableViewCell.h"
#import "CXDemoAdapter.h"

@interface CXDemo1TableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;

@end

@implementation CXDemo1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(CXDemoAdapter *)item {
    self.contentlabel.text = item.cellIdentifier;
}

+ (CGFloat)rowHeightForItem:(id)object {
    return 60;
}

@end

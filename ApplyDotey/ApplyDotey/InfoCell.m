//
//  InfoCell.m
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    [self.contentView addSubview:self.keyLabel];
    [self.contentView addSubview:self.textField];
    
}

- (UILabel *)keyLabel
{
    if (!_keyLabel) {
        self.keyLabel = ({
             UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20,2 , self.frame.size.width - 40, 20)];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.backgroundColor = [UIColor clearColor];
            lable.font = [UIFont systemFontOfSize:14];
            lable;
        });
    }
    return _keyLabel;
}
- (UITextField *)textField
{
    if (!_textField) {
        self.textField = ({
            UITextField *textFeild = [[UITextField alloc]initWithFrame:CGRectMake(20, 25, [UIScreen mainScreen].bounds.size.width - 40, 37)];
            textFeild.borderStyle = UITextBorderStyleRoundedRect;
            textFeild.delegate = self;
            textFeild;
        });
    }
    return _textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [self.textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditingWithCell: andTextFeild:)]) {
        [self.delegate textFieldDidEndEditingWithCell:self andTextFeild:textField];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

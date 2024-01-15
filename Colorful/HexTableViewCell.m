//
//  HexTableViewCell.m
//  Colorful
//
//  Created by lee on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "HexTableViewCell.h"

@interface HexTableViewCell()
{
    
}
@property (nonatomic ,strong)UILabel * laberRGB;
@property (nonatomic ,strong)UILabel * laberName;
@end

@implementation HexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.laberRGB = [[UILabel alloc]init];
        [self.contentView addSubview:self.laberRGB];
        WEAKSELF;
        [self.laberRGB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).offset(40);
            make.top.equalTo(weakSelf.mas_top);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.width.equalTo(@150);
        }];
        [self.laberRGB setTextAlignment:NSTextAlignmentLeft];
        [self.laberRGB setFont:[UIFont fontWithName:DefaultFontNameLight size:26]];
        [self.laberRGB setTextColor:[UIColor whiteColor]];
//        Avenir-Book  AvenirNext-Medium
        
        self.laberName = [[UILabel alloc]init];
        [self.contentView addSubview:self.laberName];
        [self.laberName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.laberRGB.mas_right).offset(30);
            make.top.equalTo(weakSelf.mas_top);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.right.equalTo(weakSelf.mas_right).offset(-15);
        }];
        [self.laberName setTextAlignment:NSTextAlignmentRight];
        [self.laberName setFont:[UIFont fontWithName:DefaultFontNameLight size:16]];
        [self.laberName setTextColor:[UIColor whiteColor]];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    if (_fillColor)
    {
        self.backgroundColor = _fillColor;
        
        if ([[PublicMethod sharedInstance]isDarkColor:_fillColor]) {
            [self.laberRGB setTextColor:HEX_RGB(0xffffff)];
            [self.laberName setTextColor:HEX_RGB(0xffffff)];
        }
        else {
            [self.laberRGB setTextColor:HEX_RGB(0x252525)];
            [self.laberName setTextColor:HEX_RGB(0x252525)];
        }
        
        NSString * hexStr = [_fillColor hexString];
        NSString * name = [[PublicMethod sharedInstance] getColorName:_fillColor];
        
        [self.laberRGB setText:hexStr];
        if (name) {
            [self.laberName setText:name];
        }
    }
}

@end

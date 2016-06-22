//
//  KCSetFirstTableViewCell.m
//  eNavi
//
//  Created by zuotoujing on 16/6/15.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSetFirstTableViewCell.h"

@interface KCSetFirstTableViewCell ()
@property (nonatomic, weak)UIButton *XTButton;
@property (nonatomic, weak)UIButton *LXButton;
@property (nonatomic, weak)UIButton *FYButton;
@property (nonatomic, weak)UIButton *DBButton;
@property (nonatomic, weak)UIButton *selectButton;

@end
@implementation KCSetFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setFirst";
    
    KCSetFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil)
    {
        cell = [[KCSetFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        UIButton *xtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.XTButton = xtButton;
        [self.contentView addSubview:xtButton];
        UIButton *lxbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.LXButton = lxbutton;
        [self.contentView addSubview:lxbutton];
        UIButton *fybutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.FYButton = fybutton;
        [self.contentView addSubview:fybutton];
        UIButton *dbbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.DBButton = dbbutton;
        [self.contentView addSubview:dbbutton];
        
    }
    return self;
}


-(void)setModel:(KCSetFirstSectionModel *)model
{
//    __weak __typeof(self) weakSelf = self;
//    [weakSelf.XTButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(weakSelf.contentView).offset(5);
//        make.height.mas_equalTo(weakSelf.contentView);
//    }];
//    [weakSelf.LXButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [weakSelf.FYButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [weakSelf.DBButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
    CGFloat y = 5.0;
    CGFloat W = (kMainScreenSizeWidth-30)/3;
    CGFloat H = 75/2;
    CGFloat padding = 10;
    //_XTButton.backgroundColor = [UIColor redColor];
    [self setsubBtn:_XTButton imageName:@"btn_set_chosen_n" selectImag:@"btn_set_chosen" name:@"系统推荐" frame:CGRectMake(5, y, W, H)];
    
    CGFloat lxx = CGRectGetMaxX(_XTButton.frame)+padding;
    //_LXButton.backgroundColor = [UIColor redColor];
    [self setsubBtn:_LXButton imageName:@"btn_set_chosen_n" selectImag:@"btn_set_chosen" name:@"路线最短" frame:CGRectMake(lxx, y, W, H)];
    
    CGFloat fyx = CGRectGetMaxX(_LXButton.frame)+padding;
    //_FYButton.backgroundColor = [UIColor redColor];
    [self setsubBtn:_FYButton imageName:@"btn_set_chosen_n" selectImag:@"btn_set_chosen" name:@"费用最少" frame:CGRectMake(fyx, y, W, H)];
    
    CGFloat dby = CGRectGetMaxY(_LXButton.frame)+5;
   // _DBButton.backgroundColor = [UIColor redColor];
    [self setsubBtn:_DBButton imageName:@"btn_set_uncheck" selectImag:@"btn_set_check" name:@"躲避拥堵" frame:CGRectMake(5, dby, W, H)];
    
}

- (void)setsubBtn:(UIButton *)button imageName:(NSString *)imgname selectImag:(NSString *)selectStr name:(NSString *)name frame:(CGRect)frame
{
    button.frame = frame;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = kLayerBorderColor;
    button.titleLabel.font = font(14.0);
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:kTextFontColor forState:UIControlStateNormal];
    [button setTitleColor:kColor(41, 191, 240, 1) forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:imgname] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectStr] forState:UIControlStateSelected];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    if(button==_DBButton)
    {
    [button addTarget:self action:@selector(DBBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
    [button addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)DBBtnclicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.selected == YES)
    {
    btn.layer.borderColor = kColor(41, 191, 240, 1).CGColor;
    }
    else
    {
        btn.layer.borderColor = kLayerBorderColor;
    }
}

- (void)btnclicked:(UIButton *)btn
{
    if (btn != _selectButton)
    {
        _selectButton.layer.borderColor = kLayerBorderColor;
        _selectButton.selected = NO;
        _selectButton = btn;
    }
    _selectButton.selected = YES;
    _selectButton.layer.borderColor = kColor(41, 191, 240, 1).CGColor;
   
#warning 这里写路线类型切换，方法：存储tag切换
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

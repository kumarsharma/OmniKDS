//
//  KSGridTableViewCell.m
//  omniPOS
//
//  Created by Kumar Sharma on 12/02/19.
//  Copyright © 2019 Home. All rights reserved.
//

#import "KSGridTableViewCell.h"

@implementation KSGridTableViewCell
@synthesize cells, columns;
@synthesize cellCount;
@synthesize showInFullView;
@synthesize viewWidth;

- (UILabel *)createLabelWithRect:(CGRect)rect text:(NSString *)text bgColor:(UIColor *)color font:(UIFont*)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = text;
    label.numberOfLines=3;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier numberOfCell:(NSInteger)cellCount
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.cellCount = cellCount;
    }
    return self;
}

- (void)setupSubviews
{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
//    self.contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    self.contentView.layer.borderWidth = 1.0;
    NSMutableArray *cells_ = [NSMutableArray arrayWithCapacity:self.cellCount];
    
    NSInteger kGap = 5;
    float cellSize = 646/self.cellCount;
    if(self.showInFullView)
        cellSize = viewWidth/self.cellCount;
    float xPos = 0;
    
    for(int i=0;i<self.cellCount;i++)
    {
        UILabel *cell = [self  createLabelWithRect:CGRectMake(xPos, 0, cellSize, self.bounds.size.height) text:@"" bgColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:22.0]];
//        cell.minimumScaleFactor = 10;
        cell.adjustsFontSizeToFitWidth = YES;
        cell.textAlignment = NSTextAlignmentCenter;
        [cells_ addObject:cell];
        [self addSubview:cell];
        xPos += cellSize+kGap;
        cell.layer.borderWidth=0.5;
        cell.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    }
    self.cells = cells_;
}
@end

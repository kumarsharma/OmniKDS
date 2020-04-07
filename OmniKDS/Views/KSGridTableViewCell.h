//
//  KSGridTableViewCell.h
//  omniPOS
//
//  Created by Kumar Sharma on 12/02/19.
//  Copyright © 2019 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KSGridTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, strong) NSArray *cells, *columns;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) BOOL showInFullView;
@property (nonatomic, assign) float viewWidth;
- (void)setupSubviews;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier numberOfCell:(NSInteger)cellCount;
@end


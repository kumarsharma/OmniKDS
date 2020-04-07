//
//  KSGridView.h
//  omniPOS
//
//  Created by Kumar Sharma on 12/02/19.
//  Copyright © 2019 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSGridView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) NSArray *gridSections;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL showInFullView;
@property (nonatomic, strong) NSString *headerText1, *headerText2;

- (id)initWithGridSections:(NSArray *)sections;
- (void)setupViews;
- (void)reloadGrid;
@end


//
//  KCSearchResultController.h
//  eNavi
//
//  Created by zuotoujing on 16/3/17.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <iNaviCore/MBPoi.h>
#import <iNaviCore/MBPoiQuery.h>
@class KCSearchResultController,historyModel;
//@protocol KCSearchResultControllerDelegate <NSObject>
//
//- (void)ViewController:(KCSearchResultController *)searchVC andModel:(historyModel *)model;
//@end

@interface KCSearchResultController : UIViewController
@property (nonatomic, strong)NSArray *resultList;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)Class vcClass;
@property (nonatomic, assign)MBPoint startPoint;
//@property (nonatomic, strong)MBPoiQuery *poiQ;
@property (nonatomic, copy) NSString *titleStr;
//@property (nonatomic ,weak) id <KCSearchResultControllerDelegate>delegate;

@end

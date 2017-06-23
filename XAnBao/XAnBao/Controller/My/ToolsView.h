//
//  ToolsView.h
//  NewESOP
//
//  Created by Apex on 16/4/26.
//  Copyright © 2016年 Apex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class ToolsView;

@protocol UIPopoverListViewDataSource <NSObject>
@required

- (UITableViewCell *)popoverListView:(ToolsView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popoverListView:(ToolsView *)popoverListView
       numberOfRowsInSection:(NSInteger)section;

@end

@protocol UIPopoverListViewDelegate <NSObject>
@optional

- (void)popoverListView:(ToolsView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListViewCancel:(ToolsView *)popoverListView;

- (CGFloat)popoverListView:(ToolsView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ToolsView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_listView;
    UILabel     *_titleView;
    UIControl   *_overlayView;
    
    id<UIPopoverListViewDataSource> datasource;
    id<UIPopoverListViewDelegate>   delegate;

}

@property (nonatomic, assign) id<UIPopoverListViewDataSource> datasource;
@property (nonatomic, assign) id<UIPopoverListViewDelegate>   delegate;

@property (nonatomic, retain) UITableView *listView;

- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;


@end

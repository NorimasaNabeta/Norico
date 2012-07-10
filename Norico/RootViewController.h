//
//  RootViewController.h
//  NoriCo
//
//  Created by 式正 鍋田 on 12/06/22.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "SectionHeaderView.h"

@class QuoteCell;
@interface RootViewController : UITableViewController <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,NSFetchedResultsControllerDelegate,SectionHeaderViewDelegate>

// @property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
// @property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

typedef enum BookViewStyle {
    BOOKVIEW_STYLE_AUTHOR,
    BOOKVIEW_STYLE_BOOK1,
    BOOKVIEW_STYLE_BOOK2,
    BOOKVIEW_STYLE_BOOK3,
    BOOKVIEW_STYLE_BOOK4,
    BOOKVIEW_STYLE_BOOK5,
    BOOKVIEW_STYLE_BOOK6,
    BOOKVIEW_STYLE_BOOK7,
    BOOKVIEW_STYLE_BOOK8,
} BookViewStyle;
@end

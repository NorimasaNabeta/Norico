//
//  Verse.h
//  Norico
//
//  Created by 式正 鍋田 on 12/07/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Verse : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * book;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * sub;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * vid;

@end

//
//  Verse+BookTitle.m
//  Norico
//
//  Created by 式正 鍋田 on 12/07/08.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "Verse+BookTitle.h"

@implementation Verse (BookTitle)

// Category for StanfordCS139p Lecture13, demo:PhotoMania
//
- (NSString*) titleVerseBookTitle
{
    // 'How to define a static table of strings in iPhone / XCode?'
    // http://stackoverflow.com/questions/6652192/how-to-define-a-static-table-of-strings-in-iphone-xcode
    // When you store a reference to an object in a static variable, you need to ensure that it doesn't get deallocated.
    // So you can either send it a retain message, or create with alloc instead of a convenience creation method.
    //
    static NSDictionary *dicBook=nil;
    if(dicBook==nil){
        dicBook=[[NSDictionary alloc] initWithObjectsAndKeys: 
          @"古今和歌集　春歌 上", @"00010001",@"古今和歌集　春歌 下",@"00010002",@"古今和歌集　夏歌",@"00010003",
          @"古今和歌集　秋歌 上", @"00010004",@"古今和歌集　秋歌 下",@"00010005",@"古今和歌集　冬歌",@"00010006",
          @"古今和歌集　賀歌",@"00010007",@"古今和歌集　離別歌",@"00010008",@"古今和歌集　羈旅歌", @"00010009",
          @"古今和歌集　物名",@"00010010",@"古今和歌集　恋歌 一",@"00010011", @"古今和歌集　恋歌 二",@"00010012",
          @"古今和歌集　恋歌 三",@"00010013", @"古今和歌集　恋歌 四",@"00010014",@"古今和歌集　恋歌 五",@"00010015",
          @"古今和歌集　哀傷歌",@"00010016",@"古今和歌集　雑歌 上",@"00010017", @"古今和歌集　雑歌 下",@"00010018",
          @"古今和歌集　雑体",@"00010019",@"古今和歌集　大歌所御歌", @"00010020",
          @"新古今和歌集　春歌 上",@"00080001", @"新古今和歌集　春歌 下",@"00080002",@"新古今和歌集　夏歌",@"00080003",
          @"新古今和歌集　秋歌 上", @"00080004",@"新古今和歌集　秋歌 下",@"00080005",
          @"新古今和歌集　冬歌", @"00080006", @"新古今和歌集　賀歌",@"00080007",
          @"新古今和歌集　哀傷歌",@"00080008",@"新古今和歌集　離別歌",@"00080009",@"新古今和歌集　羇旅歌",@"00080010",
          @"新古今和歌集　恋歌　一",@"00080011", @"新古今和歌集　恋歌　二",@"00080012",
          @"新古今和歌集　恋歌　三", @"00080013",@"新古今和歌集　恋歌　四",@"00080014",@"新古今和歌集　恋歌　五",@"00080015",
          @"新古今和歌集　雑歌 上", @"00080016",@"新古今和歌集　雑歌 中",@"00080017",
          @"新古今和歌集　雑歌 下",@"00080018", @"新古今和歌集　神祇歌",@"00080019",
          @"新古今和歌集　釈教歌", @"00080020",nil];
    }
       
    // Display the authors' names as section headings.
    return [dicBook valueForKey:[self book]];
}
@end

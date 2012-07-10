
/*
     File: SectionHeaderView.m
 Abstract: A view to display a section header, and support opening and closing a section.
 
  Version: 2.0
 
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

// required QuartzCore.framework(a.k.a CoreAnimation)
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView
@synthesize titleLabel=_titleLabel;
@synthesize disclosureButton=_disclosureButton;
@synthesize delegate=_delegate;
@synthesize section=_section;

+ (Class)layerClass {
     return [CAGradientLayer class];
}

-(id)initWithFrame:(CGRect)frame
             title:(NSString*)title
           section:(NSInteger)sectionNumber
             style:(NSInteger)style
          delegate:(id <SectionHeaderViewDelegate>)delegate
{
    
    self = [super initWithFrame:frame];
    if (self != nil) {
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];

        _delegate = delegate;        
        self.userInteractionEnabled = YES;
        
        // Create and configure the title label.
        _section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        _titleLabel = label;
        
        
        // 開閉のキャレット表示は自立的に状態遷移する
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 5.0, 35.0, 35.0);
        [button setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _disclosureButton = button;

        // Set the colors for the gradient layer.
        static NSMutableArray *colors1 = nil;
        static NSMutableArray *colors2 = nil;
        static NSMutableArray *colors3 = nil;
        switch(style){
            case 1:
                if (colors1 == nil) {
                    colors1 = [[NSMutableArray alloc] initWithCapacity:3];
                    UIColor *color = nil;
                    color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
                    [colors1 addObject:(id)[color CGColor]];
                    color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
                    [colors1 addObject:(id)[color CGColor]];
                    color = [UIColor colorWithRed:0.41 green:0.41 blue:0.59 alpha:1.0];
                    [colors1 addObject:(id)[color CGColor]];
                }
                [(CAGradientLayer *)self.layer setColors:colors1];
                break;
            case 2:
                if (colors2 == nil) {
                    colors2 = [[NSMutableArray alloc] initWithCapacity:3];
                    UIColor *color = nil;
                    color = [UIColor colorWithRed:0.87 green:0.84 blue:0.82 alpha:1.0];
                    [colors2 addObject:(id)[color CGColor]];
                    color = [UIColor colorWithRed:0.59 green:0.41 blue:0.41 alpha:1.0];
                    [colors2 addObject:(id)[color CGColor]];
                    color = [UIColor colorWithRed:0.59 green:0.41 blue:0.41 alpha:1.0];
                    [colors2 addObject:(id)[color CGColor]];
                }
                [(CAGradientLayer *)self.layer setColors:colors2];
                break;
            default:
            case 0:
                if (colors3 == nil) {
                    colors3 = [[NSMutableArray alloc] initWithCapacity:3];
                    UIColor *color = nil;
                    color = [UIColor colorWithRed:0.87 green:0.84 blue:0.82 alpha:1.0];
                    color = [UIColor colorWithRed:0.84 green:0.87 blue:0.82 alpha:1.0];
                    [colors3 addObject:(id)[color CGColor]];
                    color = [UIColor colorWithRed:0.41 green:0.59 blue:0.41 alpha:1.0];
                    [colors3 addObject:(id)[color CGColor]];
                    color = [UIColor colorWithRed:0.41 green:0.59 blue:0.41 alpha:1.0];
                    [colors3 addObject:(id)[color CGColor]];
                    
                }
                [(CAGradientLayer *)self.layer setColors:colors3]; 
                break;
        }
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:
                                                     [NSNumber numberWithFloat:0.0], 
                                                     [NSNumber numberWithFloat:0.48], 
                                                     [NSNumber numberWithFloat:1.0], nil]];
    
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    NSLog(@"ToggleAction");
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}




@end

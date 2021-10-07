//
//  MainView.m
//  CalculatorImitate
//
//  Created by 张博添 on 2021/9/26.
//

#import "MainView.h"
#import <Masonry.h>
@implementation MainView

NSArray *allButtons;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    
    float selfWidth = self.frame.size.width;
    float selfHeight = self.frame.size.height;
    
    float buttonWidth = (selfWidth - 75) / 4;
    float buttonHeight = buttonWidth;
    
    _buttonAC = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonAC setBackgroundColor:[UIColor lightGrayColor]];
    [_buttonAC setTitle:@"AC" forState:UIControlStateNormal];
    [_buttonAC setTintColor:[UIColor blackColor]];
    _buttonAC.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.4];
    [self addSubview:_buttonAC];
    
    _buttonLeftBracket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonLeftBracket setBackgroundColor:[UIColor lightGrayColor]];
    [_buttonLeftBracket setTitle:@"(" forState:UIControlStateNormal];
    [_buttonLeftBracket setTintColor:[UIColor blackColor]];
    _buttonLeftBracket.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.4];
    [self addSubview:_buttonLeftBracket];
    
    _buttonRightBracket = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonRightBracket setBackgroundColor:[UIColor lightGrayColor]];
    [_buttonRightBracket setTitle:@")" forState:UIControlStateNormal];
    [_buttonRightBracket setTintColor:[UIColor blackColor]];
    _buttonRightBracket.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.4];
    [self addSubview:_buttonRightBracket];
    
    _buttonDivide = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonDivide setBackgroundColor:[UIColor orangeColor]];
    [_buttonDivide setTitle:@"÷" forState:UIControlStateNormal];
    [_buttonDivide setTintColor:[UIColor whiteColor]];
    _buttonDivide.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.65];
    [self addSubview:_buttonDivide];
    
    NSArray *buttonArrayOne = @[_buttonAC, _buttonLeftBracket, _buttonRightBracket, _buttonDivide];
    //withFixedSpacing: 每个view中间的间距
    //leadSpacing: 左最开始的间距
    //tailSpacing:; 右边最后的的间距
    [buttonArrayOne mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [buttonArrayOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(selfHeight - (buttonHeight * 5 + 110)));
        make.height.equalTo(@(buttonHeight));
    }];
    
    
    
    _buttonSeven = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonSeven setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonSeven setTitle:@"7" forState:UIControlStateNormal];
    [_buttonSeven setTintColor:[UIColor whiteColor]];
    _buttonSeven.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonSeven];
    
    _buttonEight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonEight setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonEight setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonEight setTitle:@"8" forState:UIControlStateNormal];
    [_buttonEight setTintColor:[UIColor whiteColor]];
    _buttonEight.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonEight];
    
    _buttonNine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonNine setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonNine setTitle:@"9" forState:UIControlStateNormal];
    [_buttonNine setTintColor:[UIColor whiteColor]];
    _buttonNine.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonNine];
    
    _buttonMultiply = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonMultiply setBackgroundColor:[UIColor orangeColor]];
    [_buttonMultiply setTitle:@"×" forState:UIControlStateNormal];
    [_buttonMultiply setTintColor:[UIColor whiteColor]];
    _buttonMultiply.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.65];
    [self addSubview:_buttonMultiply];
    
    NSArray *buttonArrayTwo = @[_buttonSeven, _buttonEight, _buttonNine, _buttonMultiply];
    
    [buttonArrayTwo mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [buttonArrayTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(selfHeight - (buttonHeight * 4 + 95)));
        make.height.equalTo(@(buttonHeight));
    }];
    
    
    
    _buttonFour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonFour setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonFour setTitle:@"4" forState:UIControlStateNormal];
    [_buttonFour setTintColor:[UIColor whiteColor]];
    _buttonFour.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview: _buttonFour];
    
    _buttonFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonFive setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonFive setTitle:@"5" forState:UIControlStateNormal];
    [_buttonFive setTintColor:[UIColor whiteColor]];
    _buttonFive.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonFive];
    
    _buttonSix = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonSix setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonSix setTitle:@"6" forState:UIControlStateNormal];
    [_buttonSix setTintColor:[UIColor whiteColor]];
    _buttonSix.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonSix];
    
    _buttonMinus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonMinus setBackgroundColor:[UIColor orangeColor]];
    [_buttonMinus setTitle:@"−" forState:UIControlStateNormal];
    [_buttonMinus setTintColor:[UIColor whiteColor]];
    _buttonMinus.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.65];
    [self addSubview:_buttonMinus];
    
    NSArray *buttonArrayThree = @[_buttonFour, _buttonFive, _buttonSix, _buttonMinus];
    
    [buttonArrayThree mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [buttonArrayThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(selfHeight - (buttonHeight * 3 + 80)));
        make.height.equalTo(@(buttonHeight));
    }];
    
    
    
    _buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonOne setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [_buttonOne setTintColor:[UIColor whiteColor]];
    _buttonOne.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonOne];
    
    _buttonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonTwo setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [_buttonTwo setTintColor:[UIColor whiteColor]];
    _buttonTwo.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonTwo];
    
    _buttonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonThree setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [_buttonThree setTintColor:[UIColor whiteColor]];
    _buttonThree.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonThree];
    
    _buttonPlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonPlus setBackgroundColor:[UIColor orangeColor]];
    [_buttonPlus setTitle:@"+" forState:UIControlStateNormal];
    [_buttonPlus setTintColor:[UIColor whiteColor]];
    _buttonPlus.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.65];
    [self addSubview:_buttonPlus];
    
    NSArray *buttonArrayFour = @[_buttonOne, _buttonTwo, _buttonThree, _buttonPlus];
    
    [buttonArrayFour mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:15 tailSpacing:15];
    [buttonArrayFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(selfHeight - (buttonHeight * 2 + 65)));
        make.height.equalTo(@(buttonHeight));
    }];
    
    _buttonZero = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonZero setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonZero setTitle:@"0" forState:UIControlStateNormal];
    [_buttonZero setTintColor:[UIColor whiteColor]];
    _buttonZero.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonZero];
    
    _buttonDot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonDot setBackgroundColor:[UIColor darkGrayColor]];
    [_buttonDot setTitle:@"." forState:UIControlStateNormal];
    [_buttonDot setTintColor:[UIColor whiteColor]];
    _buttonDot.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.5];
    [self addSubview:_buttonDot];
    
    _buttonEqualSign = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonEqualSign setBackgroundColor:[UIColor orangeColor]];
    [_buttonEqualSign setTitle:@"=" forState:UIControlStateNormal];
    [_buttonEqualSign setTintColor:[UIColor whiteColor]];
    _buttonEqualSign.titleLabel.font = [UIFont systemFontOfSize:buttonHeight*0.65];
    [self addSubview:_buttonEqualSign];
    
    NSArray *buttonArrayFive = @[_buttonZero, _buttonDot, _buttonEqualSign];
    
    [_buttonZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@(selfHeight - (buttonHeight + 50)));
        make.width.equalTo(@(buttonWidth * 2 + 15));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [_buttonZero.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonOne.titleLabel);
    }];
    
    [_buttonDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(45 + buttonWidth * 2));
        make.top.equalTo(@(selfHeight - (buttonHeight + 50)));
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [_buttonEqualSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
        make.left.equalTo(@(60 + buttonWidth * 3));
        make.top.equalTo(@(selfHeight - (buttonHeight + 50)));
        make.height.equalTo(@(buttonHeight));
    }];
    
    allButtons = @[buttonArrayOne, buttonArrayTwo, buttonArrayThree, buttonArrayFour, buttonArrayFive];
    
    _mainTextField = [[UITextField alloc] init];
    _mainTextField.textColor = [UIColor whiteColor];
    _mainTextField.textAlignment = NSTextAlignmentRight;
    _mainTextField.font = [UIFont systemFontOfSize:65];
    [self addSubview:_mainTextField];
    
    [_mainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.width.equalTo(@(selfWidth - 30));
        make.top.equalTo(@(selfHeight - (buttonHeight * 5 + 245)));
        make.height.equalTo(@(120));
    }];
    
    return self;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer{
    [super layoutSublayersOfLayer:layer];
    //添加layer
    for (NSArray *array in allButtons) {
        for (UIButton *button in array) {
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:button.frame.size.height/2];
            [button.layer setBorderWidth:0];
            [button.layer setBorderColor:[UIColor blackColor].CGColor];
        }
    }
}

@end

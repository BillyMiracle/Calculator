//
//  MainViewController.m
//  CalculatorImitate
//
//  Created by 张博添 on 2021/9/26.
//

#import "MainViewController.h"


@interface MainViewController ()

@property (nonatomic, strong) MainView *mainView;
@property (nonatomic, strong) NSMutableString *formula;

@property (nonatomic, assign) BOOL lastIsNumber;
@property (nonatomic, assign) BOOL lastIsOperator;
@property (nonatomic, assign) BOOL lastIsLeftBracket;
@property (nonatomic, assign) BOOL lastIsRighttBracket;
@property (nonatomic, assign) BOOL haveDot;
@property (nonatomic, assign) int numberOfRightBracketsNeeded;

@property (nonatomic, assign) BOOL inputtingFirstChar;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveResult:) name:@"getResult" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainView = [[MainView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mainView];
    
    _formula = [[NSMutableString alloc] init];
    
    _numberOfRightBracketsNeeded = 0;
    _lastIsNumber = NO;
    _lastIsOperator = NO;
    _haveDot = NO;
    _lastIsLeftBracket = NO;
    _lastIsRighttBracket = NO;
    
    _inputtingFirstChar = YES;
    
    [_mainView.buttonAC addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonLeftBracket addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonRightBracket addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonDivide addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonSeven addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonEight addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonNine addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonMultiply addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonFour addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonFive addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonSix addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonMinus addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonOne addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonTwo addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonThree addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonPlus addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonZero addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonDot addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView.buttonEqualSign addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainView.mainTextField becomeFirstResponder];
    _mainView.mainTextField.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)press:(UIButton*)button {
    NSString *ch = button.titleLabel.text;
    
    if ([ch isEqualToString:@"="]) {
        if (!_inputtingFirstChar) {
            while (_numberOfRightBracketsNeeded) {
                [self append:@")"];
                _numberOfRightBracketsNeeded--;
            }
            NSNotification *notification = [NSNotification notificationWithName:@"pressEqual" object:ch userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            _inputtingFirstChar = YES;
            _numberOfRightBracketsNeeded = 0;
            _lastIsNumber = NO;
            _lastIsOperator = NO;
            _haveDot = NO;
            _lastIsLeftBracket = NO;
            _lastIsRighttBracket = NO;
        }
        
    } else if ([ch isEqualToString:@"AC"]) {
        
        NSNotification *notification = [NSNotification notificationWithName:@"pressAC" object:ch userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        _formula = [[NSMutableString alloc] init];
        _mainView.mainTextField.text = @"";
        _inputtingFirstChar = YES;
        _numberOfRightBracketsNeeded = 0;
        _lastIsNumber = NO;
        _lastIsOperator = NO;
        _haveDot = NO;
        _lastIsLeftBracket = NO;
        _lastIsRighttBracket = NO;
        
    } else {
        
        if ([ch isEqualToString:@"+"] || [ch isEqualToString:@"−"] || [ch isEqualToString:@"×"] || [ch isEqualToString:@"÷"]) {
            if ([ch isEqualToString:@"+"] || [ch isEqualToString:@"×"] || [ch isEqualToString:@"÷"]) {
                if ((_lastIsNumber && !_lastIsLeftBracket) || _lastIsRighttBracket) {
                    [self append:ch];
                    _lastIsOperator = YES;
                    _lastIsNumber = NO;
                    _haveDot = NO;
                    _lastIsRighttBracket = NO;
                } else if (_lastIsOperator && ![_formula isEqualToString:@"−"] && !_lastIsLeftBracket) {
                    [_formula deleteCharactersInRange:NSMakeRange(_formula.length - 1, 1)];
                    NSNotification *notificationD = [NSNotification notificationWithName:@"delete" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notificationD];
                    [self append:ch];
                    _lastIsOperator = YES;
                    _lastIsNumber = NO;
                    _haveDot = NO;
                    _lastIsRighttBracket = NO;
                }
            } else {
                if (_lastIsOperator == YES) {
                    [_formula deleteCharactersInRange:NSMakeRange(_formula.length - 1, 1)];
                    NSNotification *notificationD = [NSNotification notificationWithName:@"delete" object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notificationD];
                }
                [self append:ch];
                _lastIsOperator = YES;
                _lastIsNumber = NO;
                _haveDot = NO;
                _lastIsRighttBracket = NO;
            }
            
        } else if ([ch isEqualToString:@"("] || [ch isEqualToString:@")"]) {
            
            if (_inputtingFirstChar) {
                _formula = [[NSMutableString alloc] init];
                NSNotification *notification = [NSNotification notificationWithName:@"pressAC" object:ch userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            if ([ch isEqualToString:@"("]) {
                if (_lastIsNumber) {
                    _numberOfRightBracketsNeeded++;
                    [self append:@"×"];
                    [self append:ch];
                    _lastIsLeftBracket = YES;
                    _lastIsOperator = NO;
                    _lastIsNumber = NO;
                    _haveDot = NO;
                    _lastIsRighttBracket = NO;
                } else {
                    _numberOfRightBracketsNeeded++;
                    [self append:ch];
                    _lastIsLeftBracket = YES;
                    _lastIsOperator = NO;
                    _lastIsNumber = NO;
                    _haveDot = NO;
                    _lastIsRighttBracket = NO;
                }
                
            } else if (_numberOfRightBracketsNeeded != 0 && !_lastIsLeftBracket && _lastIsNumber) {
                _numberOfRightBracketsNeeded--;
                [self append:ch];
                _lastIsOperator = NO;
                _lastIsNumber = NO;
                _haveDot = NO;
                _lastIsRighttBracket = YES;
            }
            
        } else {
            
            if (_inputtingFirstChar && ![ch isEqualToString:@"."]) {
                _formula = [[NSMutableString alloc] init];
                NSNotification *notification = [NSNotification notificationWithName:@"pressAC" object:ch userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            
            if ([ch isEqualToString:@"."]) {
                if (_lastIsNumber) {
                    if (!_haveDot) {
                        [self append:ch];
                        _haveDot = YES;
                        _lastIsNumber = NO;
                        _lastIsRighttBracket = NO;
                    }
                }
            } else {
                [self append:ch];
                _lastIsOperator = NO;
                _lastIsNumber = YES;
                _lastIsLeftBracket = NO;
                _lastIsRighttBracket = NO;
            }
        }
    }
}

- (void)receiveResult:(NSNotification *)notification {
    NSNumber *error = [notification.userInfo valueForKey:@"error"];
    NSNumber *value = [notification.userInfo valueForKey:@"value"];
    if ([error isEqual:@-1]) {
        _mainView.mainTextField.text = @"格式错误";
        _formula = [[NSMutableString alloc] init];
    } else {
        _mainView.mainTextField.text = [NSString stringWithFormat:@"%g", value.doubleValue];
        _formula = [_mainView.mainTextField.text mutableCopy];
    }
}

- (void)append:(NSString*)ch {
    [_formula appendString:ch];
    _mainView.mainTextField.text = [_formula copy];
    //_mainView.mainTextField.adjustsFontSizeToFitWidth = YES;
    //_mainView.mainTextField.minimumFontSize = 20;
    NSNotification *notification = [NSNotification notificationWithName:@"pressButton" object:ch userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    _inputtingFirstChar = NO;
}

@end

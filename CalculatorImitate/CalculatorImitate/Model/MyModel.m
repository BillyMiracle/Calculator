//
//  MyModel.m
//  CalculatorImitate
//
//  Created by 张博添 on 2021/9/26.
//

#import "MyModel.h"

#define CALCULATE_ERR -1  // 运算出错

#define CALCULATE_MAX_DIGITS 30    // 限制数字最大数量
#define CALCULATE_MAX_OPERATOR 30  // 限制运算符最大数量
#define CALCULATE_MAX_DIGIT 30     // 限制单个数字的最大位数

#define FORMULA_MAX_LENGTH 100

@implementation MyModel

static NSMutableString *formula = nil;

typedef struct Result {
    int error;
    double value;
} Result;

+ (void)load {
    NSLog(@"Load");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNormal:) name:@"pressButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEqual:) name:@"pressEqual" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAC:) name:@"pressAC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete:) name:@"delete" object:nil];
    formula = [[NSMutableString alloc] init];
}

+ (void)receiveNormal:(NSNotification *)notification {
    NSString *ch = notification.object;
    if ([ch isEqualToString:@"÷"]) {
        [formula appendString:@"/"];
    } else if ([ch isEqualToString:@"×"]) {
        [formula appendString:@"*"];
    } else if ([ch isEqualToString:@"−"]) {
        [formula appendString:@"-"];
    } else {
        [formula appendString:ch];
    }
}

+ (void)receiveEqual:(NSNotification *)notification {
    int length = (int)formula.length;
    char *Formula = (char*)formula.UTF8String;
    Result result = [self CalculateFor:Formula andLen:length];
    if (result.error == CALCULATE_ERR) {
        NSLog(@"格式错误");
    } else {
        NSLog(@"%g", result.value);
    }
    NSNotification *noti = [NSNotification notificationWithName:@"getResult" object:nil userInfo:@{@"error":@(result.error), @"value":@(result.value)}];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    formula = [[NSMutableString alloc] init];
    if (result.error != -1) {
        [formula appendFormat:@"%g", result.value];
    }
}

+ (void)receiveAC:(NSNotification *)notification {
    formula = [[NSMutableString alloc] init];
}

+ (void)delete:(NSNotification *)notification {
    [formula deleteCharactersInRange:NSMakeRange(formula.length - 1, 1)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"send" object:nil];
}

+ (Result)CalculateFor:(char*) formula andLen: (long) length {
    Result result = {0, 0.0f};
    int numberOfDots = 0;
    int index;
    int digitsNum = 0;
    float digits[CALCULATE_MAX_DIGITS];
    memset(digits, 0, sizeof(digits));
    int optNum = 0;
    char operator[CALCULATE_MAX_OPERATOR];
    memset(operator, 0, sizeof(operator));
    int digitNum = 0;
    char digit[CALCULATE_MAX_DIGIT];
    memset(digit, 0, sizeof(digit));
    char *p = formula;
    while (length--) {
        switch (*p) {
            case '+':
            case '-':
            case '*':
            case '/':
                numberOfDots = 0;
                if (0 == digitNum && '-' == *p) {
                    digit[digitNum++] = *p;
                } else {
                    if (-1 == digitNum) {
                        //刚计算过括号，符号前可以没有数字读入
                    } else if (0 == digitNum || CALCULATE_MAX_DIGITS == digitsNum - 1) {
                        result.error = CALCULATE_ERR;
                        return result;
                    } else {
                        digits[digitsNum++] = atof(digit);
                        memset(digit, '\0', sizeof(digit));
                    }
                    digitNum = 0;
                    operator[optNum++] = *p;
                }
                break;

            case '(': {
                char *pointer_son;
                int ExistEnd = 0;
                pointer_son = ++p;
                while(length--) {
                    if ('(' == *p) {
                        ExistEnd--;
                    } else if (')' == *p) {
                        ExistEnd++;
                    }
                    if (1 == ExistEnd) {
                        break;
                    }
                    p++;
                }
                Result result_son = [self CalculateFor:pointer_son andLen:p - pointer_son];
                if (CALCULATE_ERR == result_son.error) {
                    result.error = result_son.error;
                    return result;
                }
                digits[digitsNum++] = result_son.value;
                memset(digit, 0, sizeof(digit));
                digitNum = -1;
                break;
            }
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
            case '.':
                digit[digitNum++] = *p;
                if (numberOfDots == 0 && *p == '.') {
                    numberOfDots = 1;
                } else if (numberOfDots == 1 && *p == '.') {
                    result.error = CALCULATE_ERR;
                    return result;
                }
                break;

            default:
                result.error = CALCULATE_ERR;
                return result;

        }
        if (0 == length && 0 < digitNum) {
            digits[digitsNum++] = atof(digit);
            memset(digit, 0, sizeof(digit));
            digitNum = 0;
        }
        p ++;
    }
    if (digitsNum != optNum + 1) {
        result.error = CALCULATE_ERR;
        return result;
    }
    for (index = 0; index < optNum; index ++) {
        if ('*' == operator[index]) {
            digits[index + 1] = digits[index] * digits[index + 1];
            digits[index] = 0;
            operator[index] = '?';
        } else if ('/' == operator[index]) {
            if (digits[index + 1] == 0) {
                result.error = CALCULATE_ERR;
                return result;
            }
            digits[index + 1] = digits[index] / digits[index + 1];
            digits[index] = 0;
            operator[index] = '?';
        }
    }
    for (index = 0; index < optNum; index ++) {
        if ('?' == operator[index]) {
            if (0 == index) {
                operator[index] = '+';
            } else {
                operator[index] = operator[index - 1];
            }
        }
    }
    result.value = digits[0];
    for (index = 0; index < optNum; index ++) {
        if ('+' == operator[index]) {
            result.value += digits[index + 1];
        } else if ('-' == operator[index]) {
            result.value -= digits[index + 1];
        }
    }
    return result;
}

//+ (Result)CalculateFor:(char*) formula andLen: (long) length {
//    Result result = {0, 0.0f};
//    int numberOfDots = 0;
//    int index;
//    int digitsNum = 0;
//    float digits[CALCULATE_MAX_DIGITS];
//    memset(digits, 0, sizeof(digits));
//    int optNum = 0;
//    char operator[CALCULATE_MAX_OPERATOR];
//    memset(operator, 0, sizeof(operator));
//    BOOL smallFormula = NO;
//    NSMutableString *digit = [[NSMutableString alloc] init];
//    char *p = formula;
//    while (length--) {
//        switch (*p) {
//            case '+':
//            case '-':
//            case '*':
//            case '/':
//                numberOfDots = 0;
//                if (0 == digit.length && '-' == *p) {
//                    [digit appendFormat:@"%c", *p];
//                } else {
//                    if (smallFormula) {
//                        //刚计算过括号，符号前可以没有数字读入
//                    } else if (0 == digit.length || CALCULATE_MAX_DIGITS == digitsNum - 1) {
//                        result.error = CALCULATE_ERR;
//                        return result;
//                    } else {
//                        digits[digitsNum++] = digit.floatValue;
//                        digit = [[NSMutableString alloc] init];
//                    }
//                    smallFormula = NO;
//                    operator[optNum++] = *p;
//                }
//                break;
//
//            case '(': {
//                char *pointer_son;
//                int ExistEnd = 0;
//                pointer_son = ++p;
//                while(length--) {
//                    if ('(' == *p) {
//                        ExistEnd--;
//                    } else if (')' == *p) {
//                        ExistEnd++;
//                    }
//                    if (1 == ExistEnd) {
//                        break;
//                    }
//                    p++;
//                }
//                Result result_son = [self CalculateFor:pointer_son andLen:p - pointer_son];
//                if (CALCULATE_ERR == result_son.error) {
//                    result.error = result_son.error;
//                    return result;
//                }
//                digits[digitsNum++] = result_son.value;
//                digit = [[NSMutableString alloc] init];
//                smallFormula = YES;
//                break;
//            }
//            case '0':
//            case '1':
//            case '2':
//            case '3':
//            case '4':
//            case '5':
//            case '6':
//            case '7':
//            case '8':
//            case '9':
//            case '.':
//                [digit appendFormat:@"%c", *p];
//                if (numberOfDots == 0 && *p == '.') {
//                    numberOfDots = 1;
//                } else if (numberOfDots == 1 && *p == '.') {
//                    result.error = CALCULATE_ERR;
//                    return result;
//                }
//                break;
//
//            default:
//                result.error = CALCULATE_ERR;
//                return result;
//
//        }
//        if (0 == length && 0 < digit.length) {
//            digits[digitsNum++] = digit.floatValue;
//            digit = [[NSMutableString alloc] init];
//        }
//        p ++;
//    }
//    if (digitsNum != optNum + 1) {
//        result.error = CALCULATE_ERR;
//        return result;
//    }
//    for (index = 0; index < optNum; index ++) {
//        if ('*' == operator[index]) {
//            digits[index + 1] = digits[index] * digits[index + 1];
//            digits[index] = 0;
//            operator[index] = '?';
//        } else if ('/' == operator[index]) {
//            if (digits[index + 1] == 0) {
//                result.error = CALCULATE_ERR;
//                return result;
//            }
//            digits[index + 1] = digits[index] / digits[index + 1];
//            digits[index] = 0;
//            operator[index] = '?';
//        }
//    }
//    for (index = 0; index < optNum; index ++) {
//        if ('?' == operator[index]) {
//            if (0 == index) {
//                operator[index] = '+';
//            } else {
//                operator[index] = operator[index - 1];
//            }
//        }
//    }
//    result.value = digits[0];
//    for (index = 0; index < optNum; index ++) {
//        if ('+' == operator[index]) {
//            result.value += digits[index + 1];
//        } else if ('-' == operator[index]) {
//            result.value -= digits[index + 1];
//        }
//    }
//    return result;
//}

@end

#import "ViewController.h"
#import <math.h>

@interface ViewController ()
{
    BOOL isSideViewOpen;
}
@property (nonatomic) double firstOperand;
@property (nonatomic) double secondOperand;
@property (nonatomic) NSString *operation;
@property (nonatomic) BOOL isTypingNumber;
@property (nonatomic) NSInteger openParenthesisCount;
@property (nonatomic, strong) NSMutableArray<NSString *> *history1;

@end

@implementation ViewController
@synthesize sidebar, sideview;

- (void)viewDidLoad {
    [super viewDidLoad];
    sidebar.backgroundColor = [UIColor systemGroupedBackgroundColor];
    sideview.hidden = YES;
    isSideViewOpen = false;
    self.isTypingNumber = NO;
    self.openParenthesisCount = 0;
    self.history1 = [NSMutableArray array]; // Initialize history array

    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    NSInteger tag = sender.tag;

    if (tag >= 0 && tag <= 9) {
        NSString *digit = [NSString stringWithFormat:@"%ld", (long)tag];
        
        if (self.isTypingNumber) {
            self.displayLabel.text = [self.displayLabel.text stringByAppendingString:digit];
        } else {
            self.displayLabel.text = digit;
            self.isTypingNumber = YES;
        }
        
        [self formatDisplayWithCommas];
    } else if (tag == 21) {
        if (![self.displayLabel.text containsString:@"."]) {
            self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@"."];
            self.isTypingNumber = YES;
        }
    } else if (tag == 22) {
        double currentNumber = [self.displayLabel.text doubleValue];
        self.displayLabel.text = [NSString stringWithFormat:@"%g", currentNumber / 100];
        self.isTypingNumber = NO;
    } else if (tag == 23) {
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@"("];
        self.openParenthesisCount += 1;
        self.isTypingNumber = NO;
    } else if (tag == 24 && self.openParenthesisCount > 0) {
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@")"];
        self.openParenthesisCount -= 1;
        self.isTypingNumber = NO;
    } else if (tag >= 10 && tag <= 13) {
        self.isTypingNumber = NO;
        self.firstOperand = [self.displayLabel.text doubleValue];
        
        switch (tag) {
            case 10: self.operation = @"+"; break;
            case 11: self.operation = @"-"; break;
            case 12: self.operation = @"*"; break;
            case 13: self.operation = @"/"; break;
            default: break;
        }
    } else if (tag >= 14 && tag <= 18) {
        double currentNumber = [self.displayLabel.text doubleValue];
        double result = 0.0;
        
        switch (tag) {
            case 14: result = sin(currentNumber); break;
            case 15: result = cos(currentNumber); break;
            case 16: result = tan(currentNumber); break;
            case 17: result = currentNumber > 0 ? log10(currentNumber) : NAN; break;
            case 18: result = currentNumber >= 0 ? sqrt(currentNumber) : NAN; break;
            default: break;
        }
        
        self.displayLabel.text = isnan(result) ? @"Error" : [NSString stringWithFormat:@"%g", result];
        self.isTypingNumber = NO;
    }
}

- (IBAction)equalPressed:(UIButton *)sender {
    self.isTypingNumber = NO;
    self.secondOperand = [self.displayLabel.text doubleValue];
    
    double result = 0.0;
    
    if ([self.operation isEqualToString:@"+"]) {
        result = self.firstOperand + self.secondOperand;
    } else if ([self.operation isEqualToString:@"-"]) {
        result = self.firstOperand - self.secondOperand;
    } else if ([self.operation isEqualToString:@"*"]) {
        result = self.firstOperand * self.secondOperand;
    } else if ([self.operation isEqualToString:@"/"]) {
        result = self.secondOperand != 0 ? self.firstOperand / self.secondOperand : NAN;
    }
    
    NSString *resultString = isnan(result) ? @"Error" : [NSString stringWithFormat:@"%g", result];
    self.displayLabel.text = resultString;
    [self formatDisplayWithCommas];
    
    // Save calculation to history
    NSString *calculation = [NSString stringWithFormat:@"%g %@ %g = %@", self.firstOperand, self.operation, self.secondOperand, resultString];
    [self.history1 addObject:calculation];
    [self.historyTableView reloadData]; // Refresh table view to display new history
}

- (IBAction)clearPressed:(UIButton *)sender {
    self.displayLabel.text = @"0";
    self.firstOperand = 0;
    self.secondOperand = 0;
    self.operation = @"";
    self.isTypingNumber = NO;
    self.openParenthesisCount = 0;
}

- (void)formatDisplayWithCommas {
    NSString *currentText = self.displayLabel.text;
    NSArray<NSString *> *components = [currentText componentsSeparatedByString:@"."];
    NSString *integerPart = components[0];
    NSString *decimalPart = components.count > 1 ? components[1] : nil;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = @([integerPart longLongValue]);
    NSString *formattedIntegerPart = [formatter stringFromNumber:number];
    
    if (decimalPart) {
        self.displayLabel.text = [NSString stringWithFormat:@"%@.%@", formattedIntegerPart, decimalPart];
    } else {
        self.displayLabel.text = formattedIntegerPart;
    }
}

- (IBAction)historyAction:(id)sender {
    sideview.hidden = NO;
    sidebar.hidden = NO;
    [self.view bringSubviewToFront:sideview];
    if (!isSideViewOpen) {
        isSideViewOpen = true;
        [sideview setFrame:CGRectMake(0, 137, 0, 291)];
        [sidebar setFrame:CGRectMake(0, 137, 377, 291)];
        [UIView beginAnimations:@"TableAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [sideview setFrame:CGRectMake(0, 137, 377, 291)];
        [sidebar setFrame:CGRectMake(0, 8, 369, 283)];
        [UIView commitAnimations];
    } else {
        isSideViewOpen = false;
        sideview.hidden = YES;
        sidebar.hidden = YES;
        [sideview setFrame:CGRectMake(0, 137, 377, 291)];
        [sidebar setFrame:CGRectMake(0, 8, 369, 283)];
        [UIView beginAnimations:@"TableAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [sideview setFrame:CGRectMake(0, 137, 0, 291)];
        [sidebar setFrame:CGRectMake(0, 137, 377, 291)];
        [UIView commitAnimations];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.history1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryCell"];
    }
    cell.textLabel.text = self.history1[indexPath.row];
    return cell;
}

@end

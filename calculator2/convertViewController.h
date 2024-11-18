//
//  convertViewController.h
//  calculator2
//
//  Created by Celestial on 15/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface convertViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *baseAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *convertedAmountTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *baseCurrencyPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *targetCurrencyPicker;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;

- (IBAction)convertCurrency:(id)sender;








@end

NS_ASSUME_NONNULL_END

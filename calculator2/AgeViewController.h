//
//  AgeViewController.h
//  calculator2
//
//  Created by Celestial on 17/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *dobDatePicker;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *calculateAge;
- (IBAction)calculaterbut:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *monthlbl;
@property (weak, nonatomic) IBOutlet UILabel *dayLbl;
@property (weak, nonatomic) IBOutlet UILabel *hoursLbl;

@end

NS_ASSUME_NONNULL_END

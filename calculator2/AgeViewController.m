//
//  AgeViewController.m
//  calculator2
//
//  Created by Celestial on 17/11/24.
//

#import "AgeViewController.h"

@interface AgeViewController ()

@end

@implementation AgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dobDatePicker.maximumDate = [NSDate date];
        self.dobDatePicker.date = [NSDate date];
        self.dobDatePicker.datePickerMode = UIDatePickerModeDate;
}



- (IBAction)calculaterbut:(id)sender {
    NSDate *dob = self.dobDatePicker.date; // Get the selected date from the picker
        NSDate *currentDate = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        // Calculate years, months, and days
        NSDateComponents *ageComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                      fromDate:dob
                                                        toDate:currentDate
                                                       options:0];
        
        NSInteger years = [ageComponents year];
        NSInteger months = [ageComponents month];
        NSInteger days = [ageComponents day];
        
        // Calculate total months, days, and hours
        NSInteger totalMonths = years * 12 + months;
        NSInteger totalDays = [calendar components:NSCalendarUnitDay fromDate:dob toDate:currentDate options:0].day;
        NSInteger totalHours = totalDays * 24;
        
        // Update labels
        self.ageLabel.text = [NSString stringWithFormat:@"Your Age: %ld years, %ld months, %ld days",
                              (long)years, (long)months, (long)days];
    self.monthlbl.text = [NSString stringWithFormat:@"Total Months: %ld", (long)totalMonths];
    self.dayLbl.text = [NSString stringWithFormat:@"Total Days: %ld", (long)totalDays];
    self.hoursLbl.text = [NSString stringWithFormat:@"Total Hours: %ld", (long)totalHours];

   }

//   - (BOOL)isValidDate:(NSString *)dateString {
//       NSString *dateRegex = @"^\\d{2}-\\d{2}-\\d{4}$";
//       NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dateRegex];
//       return [dateTest evaluateWithObject:dateString];
//   }


@end

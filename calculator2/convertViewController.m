//
//  convertViewController.m
//  calculator2
//
//  Created by Celestial on 15/11/24.
//

#import "convertViewController.h"

@interface convertViewController ()
@property (strong, nonatomic) NSArray *currencyCodes;
@property (strong, nonatomic) NSDictionary *exchangeRates;

@end

@implementation convertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set the data source and delegate
       self.baseCurrencyPicker.dataSource = self;
       self.baseCurrencyPicker.delegate = self;
       self.targetCurrencyPicker.dataSource = self;
       self.targetCurrencyPicker.delegate = self;
       
       // Fetch rates
       [self fetchExchangeRatesWithCompletion:^(NSDictionary *rates, NSError *error) {
           if (error) {
               NSLog(@"Error: %@", error.localizedDescription);
           } else {
               self.exchangeRates = rates;
               self.currencyCodes = rates.allKeys;
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self.baseCurrencyPicker reloadAllComponents];
                   [self.targetCurrencyPicker reloadAllComponents];
               });
           }
       }];
}

- (void)fetchExchangeRatesWithCompletion:(void (^)(NSDictionary *rates, NSError *error))completion {
    NSString *urlString = @"https://v6.exchangerate-api.com/v6/dfd21f00b9181a5cfccfa171/latest/USD";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([json[@"result"] isEqualToString:@"success"]) {
            NSDictionary *rates = json[@"conversion_rates"];
            completion(rates, nil);
        } else {
            NSError *apiError = [NSError errorWithDomain:@"CurrencyAPI" code:100 userInfo:@{NSLocalizedDescriptionKey: @"Failed to fetch rates"}];
            completion(nil, apiError);
        }
    }];
    
    [task resume];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.currencyCodes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.currencyCodes[row];
}

- (IBAction)convertCurrency:(id)sender {
    double baseAmount = [self.baseAmountTextField.text doubleValue];
    NSInteger baseIndex = [self.baseCurrencyPicker selectedRowInComponent:0];
    NSInteger targetIndex = [self.targetCurrencyPicker selectedRowInComponent:0];
    
    NSString *baseCurrency = self.currencyCodes[baseIndex];
    NSString *targetCurrency = self.currencyCodes[targetIndex];
    
    double baseRate = [self.exchangeRates[baseCurrency] doubleValue];
    double targetRate = [self.exchangeRates[targetCurrency] doubleValue];
    
    double convertedAmount = (baseAmount / baseRate) * targetRate;
    self.convertedAmountTextField.text = [NSString stringWithFormat:@"%.2f", convertedAmount];
}


@end

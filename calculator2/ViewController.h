//
//  ViewController.h
//  calculator2
//
//  Created by Celestial on 12/11/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


- (IBAction)buttonPressed:(UIButton *)sender;
@property (nonatomic, assign) double currentInput;
- (IBAction)clearPressed:(UIButton *)sender;
- (IBAction)equalPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIButton *history;
@property (weak, nonatomic) IBOutlet UITableView *sidebar;
@property (weak, nonatomic) IBOutlet UIView *sideview;

- (IBAction)historyAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@end


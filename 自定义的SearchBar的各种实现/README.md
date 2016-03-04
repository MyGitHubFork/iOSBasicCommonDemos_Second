# JKSearchBar
JKSearchBar,Custom Easy to use SearchBar like UISearchBar with UIView and UITextField
##Demo
![](https://raw.githubusercontent.com/shaojiankui/JKSearchBar/master/demo.gif)

##Usage
###by code
	 JKSearchBar *searchBarCode = [[JKSearchBar alloc]initWithFrame:CGRectMake(0, 50, 320, 44)];
    searchBarCode.inputView = picker;
    searchBarCode.placeholder = @"this is a placeholder";
    searchBarCode.placeholderColor = [UIColor purpleColor];

    searchBarCode.backgroundColor = [UIColor yellowColor];
    //searchBarCode.inputAccessoryView =view;
    //searchBarCode.inputView = picker;
    [searchBarCode.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:searchBarCode];
###by XIB
drag a UIView and modify Custom Class to JKSearchBar in IB Panel

	@property (weak, nonatomic) IBOutlet JKSearchBar *searchBar;
  	self.searchBar.placeholder = @"please input a word";
    self.searchBar.textColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.searchBar.iconImage = [UIImage imageNamed:@"JKSearchBar_ICON"];
    //self.searchBar.textBorderStyle = UITextBorderStyleNone;
    //self.searchBar.keyboardType = UIKeyboardTypeDecimalPad;
    //elf.searchBar.placeholderColor = [UIColor redColor];

##License

JKSearchBar is available under the MIT license.
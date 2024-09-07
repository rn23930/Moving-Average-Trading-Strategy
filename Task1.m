% Displaying version of MATLAB used
matlabVersion = version;
disp(['MATLAB Version: ' matlabVersion]);

separatorLine = repmat('*', 1, 60);
disp(separatorLine);

% Reading the data file (Excel spreadsheet)
Data = readtable("JustEat6M.xlsx");

% Task (a): Implementation of Moving Average Trading Strategy
disp('Task (a) Implementation of Moving Average Trading Strategy')
disp(separatorLine);

% Extracting closing prices named as Close in data file
ClosingPrices = Data.Close;

% Initializing variables for Available Budget, Buying and Selling portfolio
% £1M available budget 
AvailableBudget = 1e6;

% Initially we have no assets in the portfolio
Portfolio = 0;
Deals = [];

% Variables defined for short and long Moving Average
ShortMovingAverage = 7;
LongMovingAverage = 14;

 % Calculating short and long Moving Averages
    ShortMA = movavg(ClosingPrices,'simple',ShortMovingAverage);
    LongMA = movavg(ClosingPrices,'simple',LongMovingAverage); 

% Implementation of Trading Strategy
for i = 15:length(ClosingPrices)
    
    % Buy signal (7 days Moving Average crosses 14 days Moving Average from below)
    if ShortMA(i) > LongMA(i) && ShortMA(i-1) <= LongMA(i-1)
        if AvailableBudget >= ClosingPrices
            buyQuantity = floor(AvailableBudget/ClosingPrices(i));
            BuyPrice = ClosingPrices(i); % Update BuyPrice here
            AvailableBudget = AvailableBudget-(buyQuantity*BuyPrice);
            Portfolio = Portfolio+buyQuantity;
            Deals = [Deals;"Buy" buyQuantity BuyPrice i];  
        end
    end
  % Sell signal (7 days Moving Average crosses 14 days Moving Average from above)
    if ShortMA(i) < LongMA(i) && ShortMA(i-1) >= LongMA(i-1)
        if Portfolio > 0
            sellQuantity = Portfolio;
            SellPrice = ClosingPrices(i);
            AvailableBudget = AvailableBudget + (sellQuantity * SellPrice);
            Portfolio = 0;
            Deals = [Deals; "Sell" sellQuantity SellPrice i];
        end
    end
end

% Task (b): Display output of Buy/Sell and Profit/Loss
disp('Task (b): Display output of Buy/Sell and Profit/Loss')
disp(separatorLine);

fprintf('Total profit/loss: £%.2f\n', AvailableBudget - 1e6);
disp('Deals:');
disp('Action  Quantity  Price Day');
disp(Deals);

% Saving results in a text file
outputFilename = 'TradingResults.txt';

% Creating a table for the results
resultsTable = table(Deals(:, 1), Deals(:, 2), Deals(:, 3),Deals(:,4), 'VariableNames', {'Action', 'Quantity', 'Price','Day'});

% Writing table to text file
writetable(resultsTable, outputFilename);

disp(['Results saved to ' outputFilename]);
% Version of MATLAB used
matlabVersion = version;
disp(['MATLAB Version: ' matlabVersion]);

separatorLine = repmat('*', 1, 92);
disp(separatorLine);

% Converting categorical variables into numerical data for MATLAB
% computations
StockPrice = categorical({'Up'; 'Up'; 'Up'; 'Stable'; 'Stable'; 'Down'; 'Down'; 'Down'});
Market = categorical({'Down'; 'Up'; 'Stable'; 'Up'; 'Stable'; 'Stable'; 'Down'; 'Stable'});
News = categorical({'Impartial'; 'Negative'; 'Positive'; 'Negative'; 'Negative'; 'Positive'; 'Positive'; 'Negative'});
Decision = categorical({'Buy'; 'Buy'; 'Buy'; 'Buy'; 'Buy'; 'Buy'; 'Sell'; 'Sell'});

% Creating a table from the dataset
data = table(StockPrice, Market, News, Decision, 'VariableNames', {'StockPrice', 'Market', 'News', 'Decision'});

% Task (b): Generating a Decision Tree and displaying it as text 
disp('Task (b) Generating a Decision Tree and displaying it as text')
disp(separatorLine);

% Fitting a Decision Tree using fitctree command
tree1 = fitctree(data, 'Decision');

% Displaying the tree using text mode
view(tree1, 'mode', 'text');

% Task (c): Computing maximum value for 'MinParentSize'and displaying
% Decision Tree as graph
disp('Task (c): Computing maximum value for "MinParentSize" and displaying Decision Tree as graph')
disp(separatorLine);

% Initializing variables
maxMinParentSize = 0;
tree2 = [];

for minParentSize = 1:10
    tree = fitctree(data, 'Decision', 'MinParentSize', minParentSize);
    loss = resubLoss(tree); % calculating Classification loss 
    
    % Checking if classification loss is zero and if it is zero
    % maxMinParentSize and maxTree are updated
    if loss == 0
        maxMinParentSize = minParentSize;
        tree2 = tree; 
    end
end

% Display the maximum MinParentSize value for which classification loss is
% zero
fprintf('Maximum MinParentSize value with zero classification loss: %d\n', maxMinParentSize);

% Plotting decision tree in graph mode
view(tree2, 'mode', 'graph');
function [ accMLP ] = Data2PerfMLP( featDataA, featDataB, fold, featType )

if featType == 1
    
    [train_x, train_y, test_x, test_y] = rawData2Train(fold, ...
                                        featDataA, featDataB);

	accMLP = test_example_NN(train_x, train_y, test_x, test_y);
    
elseif featType == 2
        
    [train_x, train_y, test_x, test_y] = featData2Train(fold, ...
                                        featDataA, featDataB);
    
    accMLP = test_example_NN(train_x, train_y, test_x, test_y);

end


    
end


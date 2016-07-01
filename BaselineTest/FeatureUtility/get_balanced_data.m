function [ dataClassA, dataClassB, dataClassC ] = get_balanced_data...
                    ( dataClassA, dataClassB, dataClassC )

classANum = size(dataClassA, 1);
classBNum = size(dataClassB, 1);
classCNum = size(dataClassC, 1);

balanceSize = min([classANum, classBNum, classCNum]);

dataClassA = dataClassA(randperm(classANum), :);
dataClassB = dataClassB(randperm(classBNum), :);
dataClassC = dataClassC(randperm(classCNum), :);

dataClassA = dataClassA(1:balanceSize, :);
dataClassB = dataClassB(1:balanceSize, :);
dataClassC = dataClassC(1:balanceSize, :);

end


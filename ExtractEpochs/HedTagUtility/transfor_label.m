function [ strLabel ] = transfor_label( label )

strLabel = cell(size(label, 2), 1);
for idx = 1:size(label, 2)
    strLabel{idx}=num2str(label(:, idx));
end

end
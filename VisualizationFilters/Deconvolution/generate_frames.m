function generate_frames(curr_weights, handles)

img_num = 0;

for id=1:size(curr_weights, 2)
    
    % Update current image number
    img_num = img_num + 1;
    
    % Update filename and generate current brainmap on the background
    filename = char(['image_', num2str(img_num), '.png']);
	handles.name = filename;
    generateBrainmap(((id-1)/64), curr_weights, id, handles);
           
    % Update the uiwait bar
    waitbar(id/size(curr_weights, 2));
    
end

end
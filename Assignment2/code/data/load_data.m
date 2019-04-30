function imgs = load_data(directory, number, start)	 % DOCSTRING_GENERATED
 % LOAD_DATA		 [add function description here]
 % INPUTS 
 %			directory = ..
 %			number = ..
 %			start = ..
 % OUTPUTS 
 %			imgs = ..



imgs = zeros(number, 480, 512);

for i= 1:number
    
    imgs(i, :,:) = load_one(i+start-1, directory);
end

end
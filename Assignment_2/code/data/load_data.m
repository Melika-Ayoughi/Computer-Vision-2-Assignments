function imgs = load_data(directory, number, start)	 % DOCSTRING_GENERATED
 % LOAD_DATA		 [loads entire directory of images]
 % INPUTS 
 %			directory
 %			number = amount of pictures to load
 %			start = start loading from picture-index
 % OUTPUTS 
 %			imgs



imgs = zeros(number, 480, 512);

for i= 1:number
    imgs(i, :,:) = load_one(i+start-1, directory);
end

end
function img = load_one(number, directory)	 % DOCSTRING_GENERATED
 % LOAD_ONE		 [add function description here]
 % INPUTS 
 %			number = ..
 %			directory = ..
 % OUTPUTS 
 %			img = ..



base = "frame000000";
index_string = string(number);
if (number < 10)
    index_string = "0"+index_string;
end

img = imread("./"+directory+"/"+base+index_string+".png");

end
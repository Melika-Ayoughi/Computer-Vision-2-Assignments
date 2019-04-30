function imgs = load_data(directory, number, start)

imgs = zeros(number, 480, 512);

for i= 1:number
    
    imgs(i, :,:) = load_one(i+start-1, directory);
end

end
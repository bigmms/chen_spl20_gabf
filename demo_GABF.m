clear, clc;

imgRoot = './img_noise/';
imnames=dir([imgRoot '*' 'png']);
Rad = 15;
StdS = 30;
StdR = 10;

for img = 1 : length(imnames)
    strin = sprintf('./img_noise/%04d.png', img);
    Isrc = double(imread(strin));
    
    Iout = func_GABF(Isrc, Rad, StdS, StdR);
    
    strin = sprintf('./img_output/%04d_GABF.png', img);
    imwrite(uint8(Iout), strin);
    fprintf('image %d has been done!\n', img);
end
I = imread('cameraman.tif');
noised = imnoise(I,'gaussian',0,0.005);
dynDenoised = dynamicAnisodiff(noised,19,1/4,8,2,0.5);

pos = [180, 0];
fSize = 13;
font = 'SFNS';
I = insertText(I,pos,'Orig','BoxOpacity',0,'TextColor','white','FontSize',fSize,'Font',font);
noised = insertText(noised,pos,'Noised','BoxOpacity',0,'TextColor','white','FontSize',fSize,'Font',font);
dynDenoised = insertText(dynDenoised,pos,'D-alpha-PM','BoxOpacity',0,'TextColor','white','FontSize',fSize,'Font',font);

out = [I,noised,dynDenoised];
imshow(out,[]);
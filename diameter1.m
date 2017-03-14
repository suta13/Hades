clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 14;
% Read in image
img=imread('telur.jpg');
subplot(3, 3, 1);
imshow(img);
title('Original Color Image', 'FontSize', fontSize);
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
drawnow;
grayImage = min( img, [], 3 );
subplot(3, 3, 2);
imshow(grayImage, []);
title('Gray Scale Image', 'FontSize', fontSize, 'Interpreter', 'None');
% Let's compute and display the histogram.
[pixelCount, grayLevels] = imhist(grayImage);
subplot(3, 3, 3); 
bar(grayLevels, pixelCount); % Plot it as a bar chart.
grid on;
title('Histogram of original image', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel('Gray Level', 'FontSize', fontSize);
ylabel('Pixel Count', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% Threshold and invert
% BW = ~im2bw( grayImage, .5 );
BW = grayImage < 170;
subplot(3, 3, 4);
imshow(BW);
title('Initial Binary Image', 'FontSize', fontSize);
% Get rid of border.
BW = imclearborder(BW);
% Get rid of small blobs
BW = bwareaopen(BW, 400);
subplot(3, 3, 5);
imshow(BW);
% Identify individual blobs by seeing which pixels are connected to each other.
% Each group of connected pixels will be given a label, a number, to identify it and distinguish it from the other blobs.
% Do connected components labeling with either bwlabel() or bwconncomp().
labeledImage = bwlabel(BW, 8);     % Label each blob so we can make measurements of it
% labeledImage is an integer-valued image where all pixels in the blobs have values of 1, or 2, or 3, or ... etc.
subplot(3, 3, 6);
imshow(labeledImage, []);  % Show the gray scale image.
title('Labeled Image, from bwlabel()', 'FontSize', fontSize);

% Let's assign each blob a different color to visually show the user the distinct blobs.
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle'); % pseudo random color labels
% coloredLabels is an RGB image.  We could have applied a colormap instead (but only with R2014b and later)
subplot(3, 3, 7);
imshow(coloredLabels);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
caption = sprintf('Pseudo colored labels, from label2rgb().\nBlobs are numbered from top to bottom, then from left to right.');
title(caption, 'FontSize', fontSize);

% Get all the blob properties.
blobMeasurements = regionprops(labeledImage, 'Area', 'Perimeter', 'EulerNumber');
numberOfBlobs = size(blobMeasurements, 1);
allPerimeters = [blobMeasurements.Perimeter];
allAreas = [blobMeasurements.Area];
allEuler = [blobMeasurements.EulerNumber]; % Num regions - num holes in region.
circularities = allPerimeters .^ 2 ./ (4*pi*allAreas);
% Find blobs with circularities less than 2 and with no holes insdie them.
circularBlobIndexes = find(circularities < 2);
% Extract circular blobs
circlesImage = ismember(labeledImage, circularBlobIndexes);
subplot(3, 3, 8);
imshow(circlesImage);
axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
caption = sprintf('Only the circular blobs.');
title(caption, 'FontSize', fontSize);

% Remeasure with the new, final binary image composed of only circles
labeledImage = bwlabel(circlesImage);
blobMeasurements = regionprops(labeledImage, 'EquivDiameter');
allDiameters = [blobMeasurements.EquivDiameter];
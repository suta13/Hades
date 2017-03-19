thinImg = imread('telurbw.jpg');
%Mark horizontal pixel
[row1, column1] = find(thinImg, 1, 'last');
hold on;
plot(column1, row1, 'yX', 'MarkerSize', 15);
%Mark vertical pixel
[row2, column2] = find(thinImg, 1, 'first');
hold on;
plot(row2, column2, 'yX', 'MarkerSize', 15);
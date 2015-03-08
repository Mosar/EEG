filenames = ['A03T'; 'A04T'; 'A05T'; 'A06T'];

num = 1;
filename = filenames(num,:);

[data, n] = read_data([filename, '.gdf']);

preprocessed_data = preprocess(data, n, 0, [filename, '.csv'], 0, 0);

range = 90000:100000;

c1 = 8;
c2 = 12;


figure();
x = 1:size(preprocessed_data(range,c1));
y = preprocessed_data(range,c1)'./preprocessed_data(range,c2)';
z = zeros(size(x));
col = preprocessed_data(range,26)';  % This is the color, vary with x in this case.
%col = zeros(size(preprocessed_data(range,26)'));

surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    
hold();
if 0
x = 1:size(preprocessed_data(range,c2));
y = preprocessed_data(range,c2)';
z = zeros(size(x));

col = preprocessed_data(range,26)';  % This is the color, vary with x in this case.

%col = zeros(size(preprocessed_data(range,26)'))+1;
surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    if 0 == 1
    figure
    plot(1:72, fv((fv(:,2) == 1),1), 'r')
    plot(1:72, fv((fv(:,2) == 2),1))
    plot(1:72, fv((fv(:,2) == 3),1), 'g')
    plot(1:72, fv((fv(:,2) == 4),1), 'black')
    hold
    end
end






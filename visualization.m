filenames = ['A03T'; 'A04T'; 'A05T'; 'A06T'];

num = 1;
filename = filenames(num,:);

[data, n] = read_data([filename, '.GDF']);

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

end
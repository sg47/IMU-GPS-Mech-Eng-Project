tic
FILE_LOCATION = strcat(pwd, '\test.data');
data = rand(5e5,1);  % i reduced 6 to 5; pre-processing (5M elements, ~40MB)

% Saving the data to the file
% fid = fopen(FILE_LOCATION,'w');
% fwrite(fid,data,'double');
% fclose(fid);

% Adding the current_folder % path to MyJavaThread.class
javaaddpath(pwd)
start(MyJavaThread(FILE_LOCATION,data));  % start running in parallel
data = fft(data);  % post-processing (Java I/O runs in parallel)
toc
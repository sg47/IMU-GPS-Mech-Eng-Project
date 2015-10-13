tic
data = rand(5e6,1);  % pre-processing (5M elements, ~40MB)
current_folder = pwd;
javaaddpath current_folder % path to MyJavaThread.class
start(MyJavaThread(pwd,data));  % start running in parallel
data = fft(data);  % post-processing (Java I/O runs in parallel)
toc
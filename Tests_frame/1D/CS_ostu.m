sum = zeros(1024,1);
fileId = fopen('E:\Matlab_workspace\Tests\1D\whitenoise300500.pcm','r');
whitenoise = fread(fileId,inf,'int16');
NNN=1000;
for kkk = 1:NNN
    y = abs(fft(whitenoise((kkk+1):(kkk+1024))));
    sum = sum + y;
end
y = sum/NNN;
f = ifft(y);
y = y(1:512);
[a b] = EWT_OtsuMethod(y);

plot(1:512,y)
hold on
plot(1:512,b)
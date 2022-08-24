t = 0:0.1:1000;
% x = (2 + sin(t/25)) .* sin(w0 * t.*log(t)/log(1.1));
x = cos(2*pi*t + sin(t/50)) + sin(2*pi*t*2);
[time, freq, X, window] = STFT(x, 200, 50);
figure, imagesc(time, freq, abs(X))
figure, imagesc(time, freq, abs(angle(X).*abs(X)))
%S = stft(x, 'Window', kaiser(10000,5),'OverlapLength',100);
%S = S(1:end/2, :);
%figure, imagesc(abs(S))
%figure, imagesc(angle(S).*abs(S))
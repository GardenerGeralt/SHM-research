t = 0:0.1:1000;
%x = (2 + sin(t/25)) .* sin(w0 * t.*log(t)/log(1.1));
%x = cos(2*pi*t + sin(t/50)) + sin(2*pi*t*2);
x = cos(t*2*pi)+ sin(t*4*pi);
[time, freq, X, window] = STFT(x, 200, 51);
figure, imagesc(time, freq, abs(X))
figure, imagesc(time, freq, abs(angle(X).*abs(X)))
% S = stft(x, 'Window', kaiser(200,5),'OverlapLength',51);
% S = S(1:end/2, :);
% figure, imagesc(abs(S))
% figure, imagesc(angle(S).*abs(S)) 
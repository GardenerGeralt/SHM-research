t = 0.125:0.125:128;
load kobe
kobe = reshape(kobe, 1, 3048);
%x = (2 + sin(t/25)) .* sin(w0 * t.*log(t)/log(1.1));
% x = cos(2*pi*t + sin(t/50)) + sin(2*pi*t*2);
x = cos(t*2*pi)+ 5*sin(t*400*pi);
X = WT(kobe(1:2048));
figure, imagesc(abs(flip(X, 1)))
% figure, imagesc(abs(angle(X).*abs(X)))
figure, cwt(kobe(1:2048), 'bump')
% S = S(1:end/2, :);
% figure, imagesc(abs(S))
% figure, imagesc(angle(S).*abs(S)) 
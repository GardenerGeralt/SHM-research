function [F] = TF_features(S)
%TF_FEATURES Summary of this function goes here
%   M. Mulimani and S. G. Koolagudi, "Acoustic Event Classification Using Spectrogram Features," TENCON 2018 - 2018 IEEE Region 10 Conference, 2018, pp. 1460-1464, doi: 10.1109/TENCON.2018.8650444.
    side = gcd(height(S), width(S));
    Q = to_blocks(S, [height(S) width(S)]);
    [nrows, ncols] = size(Q);
    F = cell(nrows, ncols);         % table('VariableNames', ["TF1" "TF2" "TF3" "TF4" "TF5" "TF6" "TF7" "TF8" "TF9" "TF10" "TF11"])
    for row = 1:nrows
        for col = 1:ncols
            Qkt = cell2mat(Q(row, col));

            TF1 = TF_flux(Qkt);
            TF2 = TF_rms(Qkt);
            [TF3, TF4, TF5, TF6, TF7] = TF_central_moments(Qkt);
            [TF8, TF9, TF10] = TF_SVD(Qkt);
            TF11 = TF_renyi_entropy(Qkt);
            F(row, col) = {cat(1, TF1, TF2, TF3(:), TF4, TF5(:), TF6, TF7, TF8, TF9, TF10, TF11)};
        end
    end

    function [Q] = to_blocks(S, block_shape)
        S_shape = size(S);
        rows = ones(1, S_shape(1) / block_shape(1)) * block_shape(1);
        cols = ones(1, S_shape(2) / block_shape(2)) * block_shape(2);
        Q = mat2cell(S, rows, cols);
    end

    function [mu_r] = mu(Qkt, tau)
        mu_r = mean(Qkt - mean(Qkt, 2), 2).^tau;
    end

    function [TF1] = TF_flux(Qkt)
        size_Q = size(Qkt);
        total = 0;
        for k = 1:size_Q(1)-1
            for t = 1:size_Q(2)-1
                total = total + abs(Qkt(k+1, t+1) - Qkt(k, t));
            end
        end
        TF1 = log10(sqrt(total));
    end

    function [TF2] = TF_rms(Qkt)
        TF2 = mean(rms(log10(Qkt))) / max(rms(Qkt));
    end

    function [TF3, TF4, TF5, TF6, TF7] = TF_central_moments(Qkt)
        muQ = @(tau) mu(Qkt, tau);
        TF3 = log10(sqrt(muQ(2)));
        TF4 = mean(muQ(3));
        TF5 = log10(muQ(4));

        Qkt_norm = (Qkt - min(Qkt)) / (max(Qkt) - min(Qkt));
        muQ_norm = @(tau) mu(Qkt_norm, tau);
        TF6 = mean(muQ_norm(2));
        TF7 = mean(muQ_norm(3));
    end

    function [TF8, TF9, TF10] = TF_SVD(Qkt)
        d1 = sum(Qkt, 2);
        d2 = sum(Qkt, 1);
        D1 = diag(d1);
        D2 = diag(d2);
        L = 0.5 * (D1 + D2 - Qkt - transpose(Qkt));
        L = L + transpose(L);
        [U, Sig, ~] = svd(L);
        Sig = diag(Sig);
        n_sing_vals = width(Sig) - 1;
        TF8 = sqrt(sum(Sig(1:end-1)) ./ n_sing_vals) ./ max(Sig);

        mu2 = mu(U.*Qkt, 2);
        TF9 = mean(log10(mu2)) / max(mu2);
    
        [UQ, ~, ~] = svd(Qkt);
        fv = UQ(:, 1);
        temp = sqrt(sum( fv/sum(fv) .* log10(fv/sum(fv)) ));
        TF10 = -log10(sqrt(abs(temp))) / 4;
    end

    function [TF11] = TF_renyi_entropy(Qkt)
        temp = -0.5 * log2(sum(Qkt/sum(Qkt)));
        TF11 = -abs(temp / numel(Qkt)^2) / 4;
    end
end


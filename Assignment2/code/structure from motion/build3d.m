function [] = build3d(PV, seq)
% structure from motion
% PV is point view matrix : 2M*N (M=#images N=#points)
% seq: number of images that we take as a sequence

% all non-zeros
step = 2 * seq;
for image= 1 : step : size(PV,1)-step+1
    PV_dense = PV(image:image+step-1, all(PV(image:image+step-1, :)));
    size(PV_dense)
    [s, m] = calculate_s_m(PV_dense, 1);
    figure(4);
    scatter3(s(1,:), s(2,:), s(3,:)) %maybe some prettier function
    figure(5);
    m = m';
    scatter3(m(1,:), m(2,:), m(3,:))
end

% Eliminate affine ambiguity

end


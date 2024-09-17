close all;
clear;
clc;

% trying out a different way to initilize the img 
img = ones([1024 1024]) * .9020;
img(257:768, 257:768) = .102;

benchmark_sigmas = 1:100;
results = zeros(length(benchmark_sigmas), 3);

% iterate over each sigma value and perform benchmark
for i = benchmark_sigmas
    fprintf('Benchmarking sigma %d/%d:\n', i, length(benchmark_sigmas));
   
    % spatial
    tic;
    spatial_gaussian(img, i);
    time1 = toc;
    % freq
    tic;
    frequency_gaussian(img, i);
    time2 = toc;
    
    % store results
    results(i, :) = [i, time1, time2];
end

% save results to a csv
csvwrite('benchmark_results.csv', results);

% Plotting results
figure;
plot(results(:, 1), results(:, 2), 'b-', 'LineWidth', 2);
hold on;
plot(results(:, 1), results(:, 3), 'r--', 'LineWidth', 2); 
xlabel('Sigma');
ylabel('Execution Time (seconds)');
title('Execution Time Comparison: Spatial vs. Frequency Gaussian Filtering');
legend('Spatial Domain', 'Frequency Domain');
grid on;

% بارگذاری داده‌ها
data = readtable('temporal_discrimination_task.csv');  
ts1 = data.ts1;
ts2 = data.ts2;

% رسم نمودار پراکندگی
figure;
scatter(ts1, ts2, 'filled', 'MarkerFaceAlpha', 0.6);
hold on;

% محاسبه و رسم خط رگرسیون
p = polyfit(ts1, ts2, 1); % به دست آوردن ضرایب خط رگرسیون خطی
yfit = polyval(p, ts1); % محاسبه مقادیر برازش شده
plot(ts1, yfit, '-r', 'LineWidth', 1.5); % رسم خط رگرسیون

% تنظیمات نمودار
title('Scatter Plot of ts1 vs. ts2 with Regression Line');
xlabel('Interval ts1 (ms)');
ylabel('Interval ts2 (ms)');
grid on;
legend('Data Points', 'Regression Line');
hold off;

%Accuracy
% Load data
data = readtable('temporal_discrimination_task.csv');

% Unique values of ts1
unique_ts1 = unique(data.ts1);

% Array to store accuracy rate for each ts1
accuracy_rate = zeros(size(unique_ts1));

% Loop over each unique ts1 to calculate accuracy
for i = 1:length(unique_ts1)
    ts1_value = unique_ts1(i);
    subset = data(data.ts1 == ts1_value, :);
    
    % Calculate accuracy rate
    correct_responses = sum(strcmp(subset.User_Response, subset.Correct_Response));
    total_responses = height(subset);
    accuracy_rate(i) = (correct_responses / total_responses) * 100; % Convert to percentage
end

% Plot Accuracy Rate vs ts1
figure;
plot(unique_ts1, accuracy_rate, '-o');
xlabel('Interval (ts1) (ms)');
ylabel('Accuracy Rate (%)');
title('Accuracy Rate as a Function of Interval Duration');
grid on;


% Load the data
data = readtable('temporal_discrimination_task.csv');

% Calculate Bias: Difference between ts2 and ts1
data.Bias = data.ts2 - data.ts1;

% Calculate Mean Bias for each unique ts1
unique_ts1 = unique(data.ts1);
mean_bias = zeros(size(unique_ts1));

for i = 1:length(unique_ts1)
    ts1_value = unique_ts1(i);
    % Extract subset of data for this ts1 value
    subset = data(data.ts1 == ts1_value, :);
    
    % Calculate mean bias
    mean_bias(i) = mean(subset.Bias);
end

% Plot Mean Bias vs ts1
figure;
plot(unique_ts1, mean_bias, '-o');
xlabel('Interval (ts1) (ms)');
ylabel('Mean Bias (ms)');
title('Mean Bias as a Function of Interval Duration');
grid on;



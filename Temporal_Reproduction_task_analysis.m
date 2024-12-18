% بارگذاری داده‌ها از فایل CSV
data = readtable('temporal_reproduction_task.csv');

% استخراج متغیرها از داده
ts = data.ts; % زمان نمونه
tr = data.tr; % زمان بازتولید شده توسط شرکت‌کننده
errors = data.Error; % خطای بازتولید (اختلاف بین زمان نمونه و زمان بازتولید شده)

% رسم نمودار پراکندگی: زمان نمونه در مقابل زمان بازتولید شده
figure;
scatter(ts, tr, 'filled'); % رسم نقاط پراکندگی
hold on;
plot([min(ts) max(ts)], [min(ts) max(ts)], 'k--'); % خط ایده‌آل y = x
xlabel('Sample Time (ts) [ms]');
ylabel('Reproduced Time (tr) [ms]');
title('Sample Time vs Reproduced Time');
legend('Data Points', 'y = x Line');
hold off;

% رگرسیون خطی: زمان نمونه در مقابل زمان بازتولید شده
p = polyfit(ts, tr, 1); % برازش خطی (یعنی y = p(1)*x + p(2))
tr_fit = polyval(p, ts);
figure;
scatter(ts, tr, 'filled'); % رسم نقاط پراکندگی
hold on;
plot(ts, tr_fit, 'r-', 'LineWidth', 1.5); % خط برازش شده
xlabel('Sample Time (ts) [ms]');
ylabel('Reproduced Time (tr) [ms]');
title('Linear Regression: Sample Time vs Reproduced Time');
legend('Data Points', 'Fitted Line');
hold off;

% رسم هیستوگرام خطاها
figure;
histogram(errors, 'BinWidth', 100); % تعیین عرض ستون‌ها در نمودار هیستوگرام
xlabel('Error [ms]');
ylabel('Frequency');
title('Histogram of Error');

% بارگذاری داده‌ها (اگر نیاز باشد)
data = readtable('temporal_reproduction_task.csv');

% یافتن زمان‌های نمونه یکتا
unique_ts = unique(data.ts);

% آماده‌سازی برای ذخیره‌سازی میانگین و انحراف استاندارد
mean_std = cell(length(unique_ts), 1);
min_max = cell(length(unique_ts), 1);

% محاسبه میانگین، انحراف استاندارد، کمینه و بیشینه برای هر زمان نمونه
for i = 1:length(unique_ts)
    % فیلتر کردن داده‌ها برای هر زمان نمونه خاص
    current_data = data.tr(data.ts == unique_ts(i));
    
    % محاسبه میانگین، انحراف استاندارد، کمینه و بیشینه
    mean_tr = mean(current_data);
    std_tr = std(current_data);
    min_tr = min(current_data);
    max_tr = max(current_data);
    
    % قالب‌بندی به صورت "میانگین ± انحراف استاندارد" و "کمینه–بیشینه"
    mean_std{i} = sprintf('%.2f ± %.2f', mean_tr, std_tr);
    min_max{i} = sprintf('%.2f–%.2f', min_tr, max_tr);
end

% ساخت جدول نتایج برای نمایش و ذخیره‌سازی
result_table = table(unique_ts, mean_std, min_max, 'VariableNames', {'Intervals', 'Mean_std', 'Min_max'});

% ذخیره نتایج به صورت فایل CSV
writetable(result_table, 'temporal_reproduction_analysis.csv');

% نمایش پیام تایید ذخیره‌سازی
disp('Results saved as temporal_reproduction_analysis.csv');


% محاسبه خطا و انحراف استاندارد برای هر زمان نمونه
unique_ts = unique(ts);
mean_error = arrayfun(@(x) mean(data.Error(data.ts == x)), unique_ts); % محاسبه میانگین خطا
std_error = arrayfun(@(x) std(data.Error(data.ts == x)), unique_ts); % محاسبه انحراف استاندارد خطا

% رسم نمودار خطا و انحراف استاندارد برای هر زمان نمونه
figure;
errorbar(unique_ts, mean_error, std_error, 'm-o', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Presented time (ts) [ms]');
ylabel('Mean Error ± Std [ms]');
title('Error and Standard Deviation for Each Presented Time');
grid on;


%NEW_PLOT____Distribution of tr______________________________________________________________________________________________________________________________________
% Load your data
data = readtable('temporal_reproduction_task csv.csv');
 
% Extract unique 'ts' values
unique_ts = unique(data.ts);

% Define custom colors (converted to 0-1 range)
colors = [
    236, 238, 129;
    141, 223, 203;
    130, 160, 216;
    237, 183, 237;
    237, 123, 123
] / 255; % Convert to 0-1 range
 
% Create a single figure
figure;
hold on;
 
for i = 1:length(unique_ts)
    % Filter 'tr' values for the current 'ts'
    ts_value = unique_ts(i);
    filtered_tr = data.tr(data.ts == ts_value);
    
    % Calculate mean and standard deviation of 'tr'
    mu = mean(filtered_tr);
    sigma = std(filtered_tr);
    
    % Plot only the normal distribution curve (without histogram)
    x = linspace(min(filtered_tr), max(filtered_tr), 100);
    y = (1 / (sigma * sqrt(2 * pi))) * exp(-0.5 * ((x - mu) / sigma).^2);
    plot(x, y, '-', 'LineWidth', 2, 'Color', colors(mod(i-1, size(colors, 1)) + 1, :), ...
        'DisplayName', ['ts = ', num2str(ts_value)]);
    
    % Shade the area under the normal curve
    fill([x fliplr(x)], [y zeros(size(y))], ...
        colors(mod(i-1, size(colors, 1)) + 1, :), ...
        'FaceAlpha', 0.2, 'EdgeColor', 'none');
end
 
% Add labels, title, legend, and grid
xlabel('Reproduced Time (tr)', 'FontSize', 12);
ylabel('Probability Density', 'FontSize', 12);
title('Distribution of TR Values Across All TS Groups', 'FontSize', 14);
legend('show', 'Location', 'northeast'); % Set legend position to northwest
grid on;
hold off;


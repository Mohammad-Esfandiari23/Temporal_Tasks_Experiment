% خواندن داده‌های CSV
data = readtable('temporal_discrimination_task.csv');

% محاسبه اختلاف بین ts2 و ts1
stimulus_diff = data.ts2 - data.ts1;

% تعریف پاسخ‌های بلندتر
long_response = strcmp(data.User_Response, 'right') & (data.ts2 > data.ts1);

% محاسبه نسبت پاسخ‌های بلندتر برای هر مقدار از stimulus_diff
[unique_diff, ~, idx] = unique(stimulus_diff);
proportion_long = accumarray(idx, long_response, [], @mean);

% فیلتر کردن داده‌های خارج از محدوده
valid_idx = abs(unique_diff) < 100; % فقط داده‌های با تفاوت کمتر از 100 در نظر گرفته می‌شوند
filtered_diff = unique_diff(valid_idx);
filtered_long = proportion_long(valid_idx);

% تعریف تابع چگالی تجمعی گاوسی برای برازش
gaussian_cdf = @(params, x) 0.5 * (1 + erf((x - params(1)) / (params(2) * sqrt(2))));

% برازش داده‌ها به تابع گاوسی با تخمین اولیه بهینه
params_init = [27, 10];  % تخمین اولیه برای μ (میانگین) و σ (انحراف معیار)
opts = optimset('MaxFunEvals',1000, 'MaxIter',1000, 'Display','off');
params_fit = lsqcurvefit(@(params, x) gaussian_cdf(params, x), params_init, filtered_diff, filtered_long, [], [], opts);

% محاسبه PSE (میانگین)
PSE = params_fit(1);

% رسم منحنی روان‌سنجی و منحنی برازش شده
figure;
scatter(filtered_diff, filtered_long, 'b', 'DisplayName','Filtered Data');
hold on;
x_fit = linspace(min(filtered_diff), max(filtered_diff), 100);
y_fit = gaussian_cdf(params_fit, x_fit);
plot(x_fit, y_fit, 'r-', 'LineWidth', 2, 'DisplayName','Fitted Gaussian Curve');
line([PSE PSE], [0 1], 'Color', 'g', 'LineStyle', '--', 'DisplayName', ['PSE = ' num2str(PSE, '%.2f')]);

% تنظیمات پلات
xlabel('Stimulus Difference (ts2 - ts1)');
ylabel('Proportion of "Long" Responses');
title('Psychometric Curve and PSE Estimation (Filtered)');
legend('Location','best');
grid on;
hold off;

% نمایش نتیجه
disp(['Calculated PSE: ' num2str(PSE)]);

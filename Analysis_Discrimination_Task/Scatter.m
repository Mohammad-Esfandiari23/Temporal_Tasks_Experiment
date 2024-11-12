% فرض می‌کنیم داده‌های شما در متغیرهایی به نام ts1 و ts2 ذخیره شده‌اند.

% بارگذاری داده‌ها
data = readtable('temporal_discrimination_task.csv'); % نام فایل خود را مشخص کنید
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

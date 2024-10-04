% تنظیمات اولیه صفحه
Screen('Preference', 'SkipSyncTests', 1);
[window, windowRect] = Screen('OpenWindow', 0, [128, 128, 128]); 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% مرکز صفحه
[xCenter, yCenter] = RectCenter(windowRect); 

% مشخصات صفحه نمایش (cm)
screenWidth_cm = 35.54; % عرض صفحه نمایش (باید بر اساس مانیتور شما تغییر کند)
viewingDistance_cm = 57; % فاصله بین سابجکت و صفحه نمایش (باید بر اساس تنظیمات آزمایش شما باشد)

% محاسبه تعداد پیکسل‌ها در هر سانتی‌متر
pixelsPerCm = screenXpixels / screenWidth_cm;

% زاویه‌های مختلف دایره‌ها و اهداف بر حسب درجه
fixationDiameter_deg = 0.2;   % قطر نقطه تمرکز
leftTargetDiameter_deg = 0.5; % قطر هدف سمت چپ
rightTargetDiameter_deg = 2;  % قطر هدف سمت راست
visualAngle_deg = 10;         % فاصله زاویه‌ای بین اهداف و نقطه تمرکز (10 درجه)

% محاسبه فاصله 10 درجه و قطر دایره‌ها بر حسب پیکسل‌ها
visualAngle_rad = deg2rad(visualAngle_deg); % تبدیل زاویه به رادیان
distanceFromFixation_cm = 2 * viewingDistance_cm * tan(visualAngle_rad / 2);
distanceFromFixation_pixels = distanceFromFixation_cm * pixelsPerCm;

% محاسبه قطر دایره‌ها بر حسب پیکسل‌ها
fixationDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(fixationDiameter_deg / 2)) * pixelsPerCm;
leftTargetDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(leftTargetDiameter_deg / 2)) * pixelsPerCm;
rightTargetDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(rightTargetDiameter_deg / 2)) * pixelsPerCm;

% موقعیت نقاط تمرکز و اهداف با توجه به محاسبات جدید
fixationPoint = [xCenter, yCenter];
leftTargetPos = fixationPoint + [-distanceFromFixation_pixels, 0];
rightTargetPos = fixationPoint + [distanceFromFixation_pixels, 0];

% تنظیمات رنگ‌ها
fixationColor = [255, 255, 255];
targetColor = [255, 255,255];

% تعریف رنگ‌ها برای محرک‌های چرخ‌مانند
yellowColor = [150, 150, 50];
purpleColor = [150, 50, 150];

% زوایای شروع و مقدار قوس برای هر بخش
angles = linspace(0, 360, 7);

% مدت زمان‌های آزمایش
ts_values = [400, 500, 700, 1100, 1900];
n_trials = 40;
feedback_time = 0.8;

% ایجاد فایل CSV برای ذخیره داده‌ها
fileID = fopen('temporal_reproduction_task.csv', 'w');
fprintf(fileID, 'Trial,ts,tr,Error\n');  % عنوان ستون‌ها

% شروع آزمایش
for trial = 1:n_trials
    % نمایش نقطه تمرکز و اهداف با استفاده از قطرهای جدید
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

    % نمایش تصویر روی صفحه
    Screen('Flip', window);

    % تأخیر تصادفی قبل از شروع محرک‌ها
    WaitSecs(0.5 + exprnd(0.25));

    % انتخاب یک فاصله زمانی تصادفی (ts)
    ts = ts_values(randi(length(ts_values)));

    
    % نمایش محرک اول (دایره چرخ‌مانند) با ۶ بخش بنفش و زرد
    for i = 1:6
        if mod(i, 2) == 1
            color = yellowColor; % بخش زرد
        else
            color = purpleColor; % بخش بنفش
        end
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
        Screen('FillArc', window, color, [xCenter-60, yCenter-60, xCenter+60, yCenter+60], angles(i), angles(i+1) - angles(i));
    end
    Screen('Flip', window);

    % نمایش محرک اول برای 26.6 میلی‌ثانیه
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

    WaitSecs(0.0266);
    Screen('Flip', window);

    % صبر به مدت ts (زمان فاصله بین دو محرک)
    WaitSecs(ts / 1000);


    % نمایش محرک دوم (مشابه اول)
    for i = 1:6
        if mod(i, 2) == 1
            color = yellowColor; % بخش زرد
        else
            color = purpleColor; % بخش بنفش
        end
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
        Screen('FillArc', window, color, [xCenter-60, yCenter-60, xCenter+60, yCenter+60], angles(i), angles(i+1) - angles(i));
    end
    Screen('Flip', window);
    Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
    Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
    WaitSecs(0.0266);
    Screen('Flip', window);

    % نمایش پیغام: "اکنون کلید جهت راست را نگه دارید و وقتی فکر می‌کنید مدت زمان مشابهی گذشته است، آن را رها کنید"
    DrawFormattedText(window, 'Now press and hold the right arrow, release when you think the same time has passed', 'center', 'center', [255, 255, 255]);
    Screen('Flip', window);

    % منتظر فشردن و نگه داشتن کلید
    KbWait([], 2);
    press_time = GetSecs;

    % منتظر رها کردن کلید
    while KbCheck
    end
    release_time = GetSecs;

    % محاسبه مدت زمان نگه داشتن کلید
    tr = (release_time - press_time) * 1000;

    % محاسبه خطا (تفاوت بین زمان پاسخ شما و زمان واقعی)
    error = tr - ts;

    % ذخیره داده‌ها در فایل CSV
    fprintf(fileID, '%d,%.2f,%.2f,%.2f\n', trial, ts, tr, error);

    % نمایش خطا به مدت 0.8 ثانیه
    DrawFormattedText(window, sprintf('Error: %.2f ms', error), 'center', 'center', [255, 255, 255]);
    Screen('Flip', window);
    WaitSecs(feedback_time);

    % شروع آزمایش بعدی بعد از 1.2 ثانیه
    WaitSecs(1.2);
end

% بستن فایل CSV و صفحه نمایش
fclose(fileID);
sca;



% بارگذاری داده‌ها از فایل CSV
data = readtable('temporal_reproduction_data.csv');

% استخراج داده‌ها
ts = data.ts;  % فاصله‌های زمانی واقعی
tr = data.tr;  % بازتولیدهای سابجکت
error = data.error;  % خطا

% رسم نمودار فاصله زمانی واقعی در برابر بازتولید شده
figure;
subplot(2, 1, 1); % تقسیم صفحه به دو قسمت
hold on;
plot(ts, 'b-o', 'DisplayName', 'Actual Time (ts)');
plot(tr, 'r-x', 'DisplayName', 'Reproduced Time (tr)');
xlabel('Trial Number');
ylabel('Time (ms)');
title('Actual vs Reproduced Time');
legend show;
grid on;

% با توجه به فواصل: اسکتر پلات
% رسم نمودار اکسترپلات
figure;
scatter(ts, tr, 'filled');
xlabel('Actual Time (ts)'); % برچسب محور X
ylabel('Reproduced Time (tr)'); % برچسب محور Y
title('Extrapolation Plot: Actual vs Reproduced Time'); % عنوان نمودار
grid on;

% اضافه کردن خط y=x برای مقایسه
hold on;
plot([min(ts), max(ts)], [min(ts), max(ts)], 'r--', 'LineWidth', 1.5); % خط y=x
legend('Reproduced Data', 'y = x', 'Location', 'best'); % افسانه
hold off;




% بارگذاری داده‌ها از فایل CSV
data = readtable('temporal_reproduction_data.csv');

% استخراج داده‌ها
ts = data.ts;  % فاصله‌های زمانی واقعی
tr = data.tr;  % بازتولیدهای سابجکت

% استخراج مقادیر منحصر به فرد ts
unique_ts = unique(ts);

% ایجاد آرایه‌های خالی برای ذخیره نتایج
mean_tr = zeros(length(unique_ts), 1);
std_tr = zeros(length(unique_ts), 1);
min_tr = zeros(length(unique_ts), 1);
max_tr = zeros(length(unique_ts), 1);

% محاسبه میانگین، انحراف معیار، مین و ماکس برای هر ts
for i = 1:length(unique_ts)
    % پیدا کردن ایندکس‌های مربوط به هر ts
    idx = ts == unique_ts(i);
    mean_tr(i) = mean(tr(idx));
    std_tr(i) = std(tr(idx));
    min_tr(i) = min(tr(idx));
    max_tr(i) = max(tr(idx));
end

% ایجاد جدول نتایج
results_table = table(unique_ts, mean_tr, std_tr, min_tr, max_tr, ...
    'VariableNames', {'ts', 'Mean_TR', 'Std_TR', 'Min_TR', 'Max_TR'});

% نمایش جدول نتایج
disp(results_table);


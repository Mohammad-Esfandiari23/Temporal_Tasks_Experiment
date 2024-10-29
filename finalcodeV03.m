% تنظیمات اولیه صفحه
Screen('Preference', 'SkipSyncTests', 1);
[window, windowRect] = Screen('OpenWindow', 0, [128, 128, 128]); 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% مرکز صفحه
[xCenter, yCenter] = RectCenter(windowRect); 

% مشخصات صفحه نمایش (cm)
screenWidth_cm = 35.54; 
viewingDistance_cm = 57; 

% محاسبه تعداد پیکسل‌ها در هر سانتی‌متر
pixelsPerCm = screenXpixels / screenWidth_cm;

% زاویه‌های مختلف دایره‌ها و اهداف بر حسب درجه
fixationDiameter_deg = 0.2;   
leftTargetDiameter_deg = 0.5; 
rightTargetDiameter_deg = 2;  
stimulusDiameter_deg = 2.5;   
visualAngle_deg = 10;        

% محاسبه فاصله 10 درجه و قطر دایره‌ها بر حسب پیکسل‌ها
visualAngle_rad = deg2rad(visualAngle_deg);
distanceFromFixation_cm = 2 * viewingDistance_cm * tan(visualAngle_rad / 2);
distanceFromFixation_pixels = distanceFromFixation_cm * pixelsPerCm;

% محاسبه قطر دایره‌ها بر حسب پیکسل‌ها
fixationDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(fixationDiameter_deg / 2)) * pixelsPerCm;
leftTargetDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(leftTargetDiameter_deg / 2)) * pixelsPerCm;
rightTargetDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(rightTargetDiameter_deg / 2)) * pixelsPerCm;
stimulusDiameter_pixels = 2 * viewingDistance_cm * tan(deg2rad(stimulusDiameter_deg / 2)) * pixelsPerCm;

% موقعیت نقاط تمرکز و اهداف با توجه به محاسبات جدید
fixationPoint = [xCenter, yCenter];
leftTargetPos = fixationPoint + [-distanceFromFixation_pixels, 0];
rightTargetPos = fixationPoint + [distanceFromFixation_pixels, 0];

% تنظیمات رنگ‌ها
fixationColor = [255, 255, 255];
targetColor = [255, 255, 255];
yellowColor = [150, 150, 50];
purpleColor = [150, 50, 150];

% زوایای شروع برای هر پره
angles = [10, 70, 130, 190, 250, 310];

% شعاع دایره سفید وسط
centerWhiteCircleRadius = fixationDiameter_pixels / 2;  
wheelOuterRadius = stimulusDiameter_pixels / 2 - 5;  
wheelInnerRadius = centerWhiteCircleRadius + 10; 

% عرض پره‌ها
segmentWidth = 15;

% مدت زمان‌های آزمایش
ts_values = [400, 500, 700, 1100, 1900];
n_trials = 40;
feedback_time = 0.8;

% ایجاد فایل CSV برای ذخیره داده‌ها
fileID = fopen('temporal_reproduction_task.csv', 'w');
fprintf(fileID, 'Session,Trial,ts,tr,Error\n');  % عنوان ستون‌ها

% شروع آزمایش برای سه سری
for session = 1:3
    for trial = 1:n_trials
        % نمایش نقطه تمرکز و اهداف با استفاده از قطرهای جدید
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

        % نمایش صفحه
        Screen('Flip', window);
        WaitSecs(0.5 + exprnd(0.25));  % تأخیر تصادفی

        % انتخاب یک فاصله زمانی تصادفی (ts)
        ts = ts_values(randi(length(ts_values)));

        % نمایش محرک اول (دایره چرخ‌مانند)
        for i = 1:6
            if i <= 3
                color = yellowColor; % سه پره اول زرد
            else
                color = purpleColor; % سه پره بعدی بنفش
            end

            % رسم پره‌ها
            Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
            Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
            Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
            Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
            Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
        end
        Screen('Flip', window);
        WaitSecs(0.0266);  % نمایش به مدت 26.6 میلی‌ثانیه

        % محو کردن محرک اول
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

        Screen('Flip', window);
        WaitSecs(ts / 1000);  % صبر به مدت ts

        % نمایش محرک دوم (مشابه اول)
        for i = 1:6
            if i <= 3
                color = yellowColor; % سه پره اول زرد
            else
                color = purpleColor; % سه پره بعدی بنفش
            end

            % رسم پره‌ها
            Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
            Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
            Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
            Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
            Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);
        end
        Screen('Flip', window);
        WaitSecs(0.0266);  % نمایش به مدت 26.6 میلی‌ثانیه

        % محو کردن محرک دوم
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

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
        fprintf(fileID, '%d,%d,%.2f,%.2f,%.2f\n', session, trial, ts, tr, error);

        % نمایش خطا به مدت 0.8 ثانیه
        DrawFormattedText(window, sprintf('Error: %.2f ms', error), 'center', 'center', [255, 255, 255]);
        Screen('Flip', window);
        WaitSecs(feedback_time);

        % شروع آزمایش بعدی بعد از 1.2 ثانیه
        WaitSecs(1.2);
    end
end

% بستن فایل CSV و صفحه نمایش
fclose(fileID);
sca;
%testing for git
% تنظیمات اولیه صفحه
Screen('Preference', 'SkipSyncTests', 1);
KbName('UnifyKeyNames');
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
ts2_multipliers = [0.06, 0.12, 0.24, 0.48];
n_trials = 40;
feedback_time = 0.8;

% ایجاد فایل CSV برای ذخیره داده‌ها
fileID = fopen('temporal_discrimination_task.csv', 'w');
fprintf(fileID, 'Session,Trial,ts1,ts2,Correct_Response,User_Response,Feedback\n');  % عنوان ستون‌ها

% شروع آزمایش برای 6 سری (فقط با پاسخ دستی)
for session = 1:6
    for trial = 1:n_trials
        % انتخاب یک فاصله زمانی تصادفی (ts1)
        ts1 = ts_values(randi(length(ts_values)));
        
        % تعیین ts2 بر اساس ضریب تصادفی
        ts2_multiplier = ts2_multipliers(randi(length(ts2_multipliers)));
        if rand < 0.5
            ts2 = ts1 * (1 + ts2_multiplier);
        else
            ts2 = ts1 * (1 - ts2_multiplier);
        end
        correct_response = 'right';
        if ts2 < ts1
            correct_response = 'left';
        end
        
        % نمایش نقطه تمرکز و اهداف با استفاده از قطرهای جدید
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [leftTargetPos(1) - leftTargetDiameter_pixels/2, leftTargetPos(2) - leftTargetDiameter_pixels/2, leftTargetPos(1) + leftTargetDiameter_pixels/2, leftTargetPos(2) + leftTargetDiameter_pixels/2]);
        Screen('FillOval', window, targetColor, [rightTargetPos(1) - rightTargetDiameter_pixels/2, rightTargetPos(2) - rightTargetDiameter_pixels/2, rightTargetPos(1) + rightTargetDiameter_pixels/2, rightTargetPos(2) + rightTargetDiameter_pixels/2]);

        % نمایش صفحه
        Screen('Flip', window);
        WaitSecs(0.5 + exprnd(0.25));  % تأخیر تصادفی

        % نمایش محرک اول (دایره چرخ‌مانند) به مدت ts1
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
        end
        Screen('Flip', window);
        WaitSecs(ts1 / 1000);  % نمایش به مدت ts1

        % محو کردن محرک اول و نمایش نقطه تمرکز
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('Flip', window);
        
        % نمایش محرک دوم (دایره چرخ‌مانند) به مدت ts2
        for i = 1:6
            if i <= 3
                color = purpleColor; % سه پره اول بنفش
            else
                color = yellowColor; % سه پره بعدی زرد
            end

            % رسم پره‌ها
            Screen('FillArc', window, color, [xCenter-wheelOuterRadius, yCenter-wheelOuterRadius, xCenter+wheelOuterRadius, yCenter+wheelOuterRadius], angles(i), segmentWidth);
            Screen('FillArc', window, [128, 128, 128], [xCenter-wheelInnerRadius, yCenter-wheelInnerRadius, xCenter+wheelInnerRadius, yCenter+wheelInnerRadius], angles(i), segmentWidth);
            Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        end
        Screen('Flip', window);
        WaitSecs(ts2 / 1000);  % نمایش به مدت ts2

        % محو کردن محرک دوم و نمایش نقطه تمرکز
        Screen('FillOval', window, fixationColor, [xCenter - fixationDiameter_pixels/2, yCenter - fixationDiameter_pixels/2, xCenter + fixationDiameter_pixels/2, yCenter + fixationDiameter_pixels/2]);
        Screen('Flip', window);
        
        % دریافت پاسخ شرکت‌کننده
        DrawFormattedText(window, 'Press left if ts2 < ts1, right if ts2 > ts1', 'center', 'center', [255, 255, 255]);
        Screen('Flip', window);
        [secs, keyCode] = KbWait;
        if keyCode(KbName('RightArrow'))
            user_response = 'right';
        elseif keyCode(KbName('LeftArrow'))
            user_response = 'left';
        else
            user_response = 'none';
        end

        % تعیین بازخورد
        if strcmp(user_response, correct_response)
            Screen('FillOval', window, [0, 255, 0], [xCenter - 20, yCenter - 20, xCenter + 20, yCenter + 20]);
            feedback = 'correct';
        else
            Screen('FillOval', window, [255, 0, 0], [xCenter - 20, yCenter - 20, xCenter + 20, yCenter + 20]);
            feedback = 'incorrect';
        end
        Screen('Flip', window);
        WaitSecs(feedback_time);

        % ذخیره داده‌ها در فایل CSV
        fprintf(fileID, '%d,%d,%.2f,%.2f,%s,%s,%s\n', session, trial, ts1, ts2, correct_response, user_response, feedback);

        % شروع آزمایش بعدی بعد از 1.2 ثانیه
        WaitSecs(1.2);
    end
end

% بستن فایل CSV و صفحه نمایش
fclose(fileID);
sca;
%testing the git

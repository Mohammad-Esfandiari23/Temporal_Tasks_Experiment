% MATLAB code for Visualizing Proportion of "Long" Responses for Each ts1 and ts2 Combination
% Assuming data is loaded in a table named 'data' with the following columns:
% 'Session', 'Trial', 'ts1', 'ts2', 'Correct_Response', 'User_Response', 'Feedback'

% Load the data from a CSV file
data = readtable('temporal_discrimination_task.csv'); % فرض کنید داده‌ها از این فایل بارگذاری شده‌اند

% Convert 'User_Response' to numerical values
% Left -> -1, Right -> +1
user_response_num = strcmp(data.User_Response, 'right') * 1 + strcmp(data.User_Response, 'left') * -1;

% Add the converted responses to the table
data.user_response_num = user_response_num;

% Unique values of ts1 and ts2
unique_ts1 = unique(data.ts1);
unique_ts2 = unique(data.ts2);

% Initializing arrays for storing proportions
proportion_long_responses = NaN(length(unique_ts1), length(unique_ts2));

% Loop through each combination of ts1 and ts2 to calculate proportions
for i = 1:length(unique_ts1)
    for j = 1:length(unique_ts2)
        ts1_value = unique_ts1(i);
        ts2_value = unique_ts2(j);
        % Filter the data for the specific ts1 and ts2 values
        indices = (data.ts1 == ts1_value) & (data.ts2 == ts2_value);
        total_responses = sum(indices);
        if total_responses > 0
            long_responses = sum(data.user_response_num(indices) == 1);
            proportion_long_responses(i, j) = long_responses / total_responses;
        end
    end
end

% Plotting the proportion of "long" responses for each ts1 and ts2
figure;
hold on;
colors = {'r', 'g', 'y', 'b', 'm'};
for i = 1:length(unique_ts1)
    ts1_value = unique_ts1(i);
    % Extract the proportions for the specific ts1 value
    proportions = proportion_long_responses(i, :);
    scatter(unique_ts2, proportions, 50, colors{i}, 'filled', 'DisplayName', sprintf('ts1 = %d', ts1_value));
end

xlabel('ts2 (ms)');
ylabel('Proportion of "Long" Responses');
title('Proportion of "Long" Responses for Each ts1');
legend;
grid on;
hold off;



% Define the columns to analyze
clc;
close all;
columns = [1, 5, 6, 8, 11, 12, 20, 24, 25];


load("D:\FYP\Datasets\dataset2\VP025-NIRS\cnt_nback.mat");
load("D:\FYP\Datasets\dataset2\VP025-NIRS\mrk_nback.mat");
time = mrk_nback.time(1,:);
for col = columns
     %Load
    
    data = cnt_nback.deoxy.x(:, col);
%     figure;
%     plot(data);
%     title('data')
%     
    % time in miliseconds
    
    
    
    % Calculate the number of data points in each session
    numDataPoints = diff([0, time]) / 100; % Sampling rate is 10 Hz and time is in miliseconds (divide by 1000 and multiply by 10)
    
    % Normalize the data
    normalizedData = (data - mean(data)) / std(data);

    % Divide the normalized data points into 27 sessions
    sessions = cell(1, 27);
    startIndex = 1;
    for i = 1:27
        endIndex = round(min(startIndex + numDataPoints(i) - 1, length(normalizedData)));
        sessions{i} = normalizedData(startIndex:endIndex+1);
        startIndex = endIndex + 1;
    end
    

    events = [9, 8, 7, 8, 7, 9, 7, 9, 8, 8, 7, 9, 7, 9, 8, 9, 8, 7, 7, 9, 8, 9, 8, 7, 8, 7, 9];
    session_ids_for_7 = [];
    session_ids_for_8 = [];
    session_ids_for_9 = [];
    
    for i = 1:length(events)
        if events(i) == 7
            session_ids_for_7 = [session_ids_for_7, i];
        elseif events(i) == 8
            session_ids_for_8 = [session_ids_for_8, i];
        else
            session_ids_for_9 = [session_ids_for_9, i];
        end
    end
    
     
    
    % % Extract data samples relevant to the identified sessions
    zero_back = [];
    two_back = [];
    three_back = [];
    for i = 1:length(session_ids_for_7)
        zero_back{i} = sessions{session_ids_for_7(i)};
       
    end
    for i = 1:length(session_ids_for_8)
        two_back{i} = sessions{session_ids_for_8(i)};
    end
    
    for i = 1:length(session_ids_for_9)
        three_back{i} = sessions{session_ids_for_9(i)};
    end
    
    
    
    
    % Calculate mean and standard deviation for each session in '0back'
    for i = 1:length(zero_back)
        maxi0(i) = max(zero_back{i});
       
    end
    
    % Calculate mean and standard deviation for each session in '2back'
    for i = 1:length(two_back)
        maxi2(i) = max(two_back{i});
       
    end
    
    % Calculate mean and standard deviation for each session in '3back'
    for i = 1:length(three_back)
        maxi3(i) = max(three_back{i});
        
    end
    
   
        % Calculate standard deviation for each session in 'zero_back'
%     std_each_session0 = cellfun(@std, zero_back);
%     std_zero_back = std(std_each_session0);
%    
%     std_each_session2 = cellfun(@std, two_back);
%     std_two_back = std(std_each_session2);
%     
%     std_each_session3 = cellfun(@std, three_back);
%     std_three_back = std(std_each_session3);
%    
% 
%     fprintf('0 back channel= %d',col);
    disp(max(maxi0));
%     fprintf('2 back channel= %d',col);
    disp(max(maxi2));
%     fprintf('3 back channel= %d',col);
    disp(max(maxi3));




    % coefficients0 = polyfit(1:numel(zero_back), cellfun(@mean, zero_back), 1);
    % slope_zero_back = coefficients0(1);
    % disp(num2str(slope_zero_back));
    % coefficients2 = polyfit(1:numel(two_back), cellfun(@mean, two_back), 1);
    % slope_two_back = coefficients2(1);
    % disp(num2str(slope_two_back));
    % coefficients3 = polyfit(1:numel(three_back), cellfun(@mean, three_back), 1);
    % slope_three_back = coefficients3(1);
    % disp(num2str(slope_three_back));
    % skewness_zero_back = skewness(cell2mat(zero_back(:)));
    % disp(num2str(skewness_zero_back));
    % skewness_two_back = skewness(cell2mat(two_back(:)));
    % disp(num2str(skewness_two_back));
    % skewness_three_back = skewness(cell2mat(three_back(:)));
    % disp(num2str(skewness_three_back));
        % disp(mean(meanX));
    % disp(mean(meanY));
    % disp(mean(meanZ));
    
    
    
end
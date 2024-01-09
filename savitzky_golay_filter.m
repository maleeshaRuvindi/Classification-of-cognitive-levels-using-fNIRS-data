close all;
clc;
len=680;
frameLength = 121;  % Frame length of the Savitzky-Golay filter
columns = [1, 5, 6, 8, 11, 12, 20, 24, 25];
order=3;

load("D:\FYP\Datasets\dataset2\VP023-NIRS\cnt_nback.mat");
load("D:\FYP\Datasets\dataset2\VP023-NIRS\mrk_nback.mat");
time = mrk_nback.time(1,:);
participant=23;
file_0 = strcat("avg_0back_", num2str(participant),".mat");

file_2=strcat("avg_2back_", num2str(participant),".mat");
file_3=strcat("avg_3back_", num2str(participant),".mat");
% zero=[];
% two=[];
% three=[];
j=1;
zero = zeros(len, 9);
two = zeros(len, 9);
three = zeros(len, 9);
%time_axis=[0:0.1:numDataPoints(3)/10];
numDataPoints = diff([0, time]) / 100;

for col=columns
% Extract raw data of a certain channel
    rawData =cnt_nback.deoxy.x(:, col);

    
%27 sessions 9 for each 0-back, 2-back, 3-back
    sessions = cell(1, 27);
    startIndex = 1;
    for i = 1:27
        endIndex = round(min(startIndex + numDataPoints(i) - 1, length(rawData)));
        sessions{i} = rawData(startIndex:endIndex+1);
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
    three_back=three_back(2:9);
    
    for i = 1:9
        zero_back{i}=zero_back{i}(1:len);
        %length(two_back{i})
        two_back{i}=two_back{i}(1:len);
       
    end
    for i= 1:8
        length(three_back{i})
        three_back{i}=three_back{i}(1:len);
    end
    avg_zero=[];
    avg_two=[];
    avg_three=[];
    for i=1:len
        avg_zero=[avg_zero,mean([zero_back{1}(i),zero_back{2}(i),zero_back{3}(i),zero_back{4}(i),zero_back{5}(i),zero_back{6}(i),zero_back{7}(i),zero_back{8}(i),zero_back{9}(i)])];
        avg_two=[avg_two,mean([two_back{1}(i),two_back{2}(i),two_back{3}(i),two_back{4}(i),two_back{5}(i),two_back{6}(i),two_back{7}(i),two_back{8}(i),two_back{9}(i)])];
        avg_three=[avg_three,mean([three_back{1}(i),three_back{2}(i),three_back{3}(i),three_back{4}(i),three_back{5}(i),three_back{6}(i),three_back{7}(i),three_back{8}(i)])];
        
    end
    smoothed_zero = sgolayfilt(avg_zero, order, frameLength);
    smoothed_two = sgolayfilt(avg_two, order, frameLength);
    smoothed_three = sgolayfilt(avg_three, order, frameLength);
    % Perform baseline correction
    baseline_corrected_zero = bsxfun(@minus, smoothed_zero, mean(smoothed_zero, 2));
    baseline_corrected_two = bsxfun(@minus, smoothed_two, mean(smoothed_two, 2));
    baseline_corrected_three = bsxfun(@minus, smoothed_three, mean(smoothed_three, 2));
%     
%     zero{j}=baseline_corrected_zero;
%     two{j}=baseline_corrected_two;
%     three{j}=baseline_corrected_three;
%     Zero = cell2mat(zero);
    %save('data.mat', 'data');
    zero(:,j)=baseline_corrected_zero;
    two(:,j)=baseline_corrected_two;
    three(:,j)=baseline_corrected_three;
    
    figure;
    plot(smoothed_zero);
    hold on;
%     plot(smoothed_two);
%     plot(smoothed_three);
    plot(baseline_corrected_zero)
    legend('sg_filtered','baseline corrected');
    hold off;
    j=j+1;

end
save(file_0, "zero");
save(file_2, "two");
save(file_3, "three");



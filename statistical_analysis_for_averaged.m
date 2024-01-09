% Define the columns to analyze
clc;
close all;
%columns = [1, 5, 6, 8, 11, 12, 20, 24, 25];

participant=1:26;
nback=[0,2,3];
for p=participant
    figure;
    for n=nback
        path=strcat('D:\FYP\Datasets\dataset2_preprocessed\subject',num2str(p),'\avg_',num2str(n),'back_',num2str(p),'.mat');
        fprintf('participant=%d, n=%d',p,n);
        data=load(path);
        if n==0
            data2 = data.zero;
        elseif n==2
            data2 = data.two; 
        else
            data2 = data.three;
        end
        
        plot(max(data2));
        hold on;
        
    end
    legend('0','2','3')
    hold off;
end

function plot_rewards( )
%PLOT_REWARDS 此处显示有关此函数的摘要
%   此处显示详细说明
    x = 3:20;
    x_n=0;
    y = 21:30;
    signal = 9;
    rewards=zeros(length(x),length(y));
    for short=x
        x_n  = x_n + 1;
        y_n = 0;
        for long=y
            y_n = y_n+1;
            rewards(x_n,y_n)=calc_reward(short, long, signal);
        end
    end
    

end


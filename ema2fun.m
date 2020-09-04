%% 2条均线进场

function [r,s] = ema2fun(P,N,M,cost)
%% 输入参数

if ~exist('cost','var') %检查cost是否变量。调用时如果没输入该参数，则赋初值
    cost = 0;
end

if nargin < 2
    % defualt values    默认值
    M = 26;    
    N = 12;
elseif nargin < 3                    %提示自己定义的错误，有意思
    error('LEADLAG:NoLagWindowDefined',...
        'When defining a leading window, the lag must be defined too')
end %if
%%
    s = zeros(size(P));                       %价格数组P
    [lead,lag] = movavg(P,N,M,'e');
    s(lead>lag) = 1;
    s(lag>lead) = -1;
    r  = [0; s(1:end-1).*diff(P)-abs(diff(s))*cost/2];  %r是1列数组
                                     %注意，头寸方向变化时产生交易成本
end
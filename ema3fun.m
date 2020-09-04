%% 3条均线进场
%规则1.duan大于长买入，短小于长卖出
    %2.当多头（空头）排列时加倍，穿越长期均线加仓1倍

function [r,s] = ema3fun(P,N,M,K,cost)
%% 输入参数

if ~exist('cost','var') %检查cost是否变量。调用时如果没输入该参数，则赋初值
    cost = 0;
end
    
if nargin < 4                    %提示自己定义的错误，有意思
    error('LEADLAG:NoLagWindowDefined',...
        'When defining a leading window, the lag must be defined too')
end %if
%%
    s = zeros(size(P));                       %价格数组P
    [lead,lag] = movavg(P,N,M,'e');
    long=movavg(P,K,K,'e');
    s(lead>lag)=1;
    s(lead>lag&lag>long) = 2;
    s(lag>lead)=-1;
    s(lag>lead&lag<long) = -2;
    
    r  = [0; s(1:end-1).*diff(P)-abs(diff(s))*cost/2];  %r是1列数组
                                     %注意，头寸方向变化时产生交易成本
end
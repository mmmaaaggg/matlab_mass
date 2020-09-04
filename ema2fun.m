%% 2�����߽���

function [r,s] = ema2fun(P,N,M,cost)
%% �������

if ~exist('cost','var') %���cost�Ƿ����������ʱ���û����ò������򸳳�ֵ
    cost = 0;
end

if nargin < 2
    % defualt values    Ĭ��ֵ
    M = 26;    
    N = 12;
elseif nargin < 3                    %��ʾ�Լ�����Ĵ�������˼
    error('LEADLAG:NoLagWindowDefined',...
        'When defining a leading window, the lag must be defined too')
end %if
%%
    s = zeros(size(P));                       %�۸�����P
    [lead,lag] = movavg(P,N,M,'e');
    s(lead>lag) = 1;
    s(lag>lead) = -1;
    r  = [0; s(1:end-1).*diff(P)-abs(diff(s))*cost/2];  %r��1������
                                     %ע�⣬ͷ�緽��仯ʱ�������׳ɱ�
end
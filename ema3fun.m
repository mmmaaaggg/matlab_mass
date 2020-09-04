%% 3�����߽���
%����1.duan���ڳ����룬��С�ڳ�����
    %2.����ͷ����ͷ������ʱ�ӱ�����Խ���ھ��߼Ӳ�1��

function [r,s] = ema3fun(P,N,M,K,cost)
%% �������

if ~exist('cost','var') %���cost�Ƿ����������ʱ���û����ò������򸳳�ֵ
    cost = 0;
end
    
if nargin < 4                    %��ʾ�Լ�����Ĵ�������˼
    error('LEADLAG:NoLagWindowDefined',...
        'When defining a leading window, the lag must be defined too')
end %if
%%
    s = zeros(size(P));                       %�۸�����P
    [lead,lag] = movavg(P,N,M,'e');
    long=movavg(P,K,K,'e');
    s(lead>lag)=1;
    s(lead>lag&lag>long) = 2;
    s(lag>lead)=-1;
    s(lag>lead&lag<long) = -2;
    
    r  = [0; s(1:end-1).*diff(P)-abs(diff(s))*cost/2];  %r��1������
                                     %ע�⣬ͷ�緽��仯ʱ�������׳ɱ�
end
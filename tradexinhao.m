function  vout=tradexinhao(jrxulie,xinhao,varargin)   %�������ʱ������ �ź����� ��ز���
%�����潻���ź� macd, kdj ������
vout = [];
% Number of observations
observ = size(jrxulie,1);% -1������ʱ��
% Switch between the various modes
switch lower(xinhao)
    %%% Momentum
%==========================================================================
    case 'macdtrade'      % Commodity Channel Index
        if isempty(varargin)
            
        end
        
         vout = chicangxinhao;
        
    case 'kdjtrade' 
        
        vout = chicangxinhao;

end
function  vout=tradexinhao(jrxulie,xinhao,varargin)   %输入金融时间序列 信号名称 相关参数
%技术面交易信号 macd, kdj 其他等
vout = [];
% Number of observations
observ = size(jrxulie,1);% -1？因含有时间
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
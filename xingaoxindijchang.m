%新高、新低进场系统
%进场创出10日新高、新低，出场突破3日高点低点
%%
%数据输入
%原始资金1000000
capital=1000000;

jibendwei=40;    %基本仓位,手数，以10吨为一手
shouxufeibili=0.001;%手续费标准

%输入数据
a='yyyy/mm/dd';
b='yyyy-mm-dd';
j=a;

k=10;%删除前面2年数据
[num1,text1]=xlsread('甲醇指数11');%期货
qihuoclose=num1(k:end,4);    %收盘价
qihuoopen=num(k:end,4);      %开盘价
date1=text1(k+1:end,1);
date1=datenum(date1,j);

%提取共同日期
duiyingriqi=date1-693960;%后面每日数据输出时用到
%%
%交易信号
changdu=length();
jinchangjiage=;
chuchangjiage=;
cangwei=;

for i=10:
%高于最大值进场，进场价格

%进场信号做多

%做多持仓或平仓

%进场信号做空

%做空持仓或平仓
end
%%
%交易统计




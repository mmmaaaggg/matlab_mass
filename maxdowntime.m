%%最长回撤时间计算（以数值形式输出，暂时未接受矩阵输入）
%计算每期资金的恢复时间，形成向量，取最大值
%find
function [time,maxind1,maxind2]=maxdowntime(s) %s是当期资金
n=length(s);
ind1=zeros(n,1);
ind2=zeros(n,1);
r=s;                        %如果s是指当期绝对收益，则r=cumsum(s)+最初资产
time=0;%赋初值
x=zeros(n,1);%每期资金的恢复时间，形成向量
for t=1:n-1
  b=r(t+1:end);
    if  r(t)<=max(b)
        a=find(b-r(t)>=0);
        x(t)=a(1)-1;
    else              %若资金一直未恢复原值,则
       x(t)=n-t;
    end   
end
[time,k]=max(x);
maxind1=k;
maxind2=k+time;
end
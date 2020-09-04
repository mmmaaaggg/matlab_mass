%%最大回撤绝对数量计算（以数值形式输出，暂时未接受矩阵输入）
%第t个值与t~n之间最小值之差
function [maxdd,maxind1,maxind2]=maxdown(s) %s是当期资金!!!!!!!!!!
n=length(s);
rate=zeros(n,1);
ind1=zeros(n,1);
ind2=zeros(n,1);
r=s;%如果s是指当期绝对收益，则r=cumsum(s)+最初资产
for t=1:n
    if r(t)==min(r(t:n))
        continue;
    end
    [xiao,xiaoind]=min(r(t:n));
    ind1(t)=t;
    ind2(t)=xiaoind;%这个指针相对t而言，故后面取t+xiaoind-1
    rate(t)=xiao-r(t);%绝对数量回撤最大值
end
[maxdd,k]=min(rate);
maxind1=k;
maxind2=ind2(k)+k-1;
end
%%最大回撤比率计算（以数值形式输出，暂时未接受矩阵输入）
%第t个值与t~n之间最小值之差，除以s（t）
function [maxddr,maxind1,maxind2]=maxdownrate(s) %s是当期资金
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
    rate(t)=(xiao-r(t))/r(t);%如果等式右边换成xiao-r(t),则是求绝对数量回撤最大值
end
[maxddr,k]=min(rate);             %值应该在0-100%之间
maxind1=k;
maxind2=ind2(k)+k-1;
end
    

%%���س����ʼ��㣨����ֵ��ʽ�������ʱδ���ܾ������룩
%��t��ֵ��t~n֮����Сֵ֮�����s��t��
function [maxddr,maxind1,maxind2]=maxdownrate(s) %s�ǵ����ʽ�
n=length(s);
rate=zeros(n,1);
ind1=zeros(n,1);
ind2=zeros(n,1);
r=s;%���s��ָ���ھ������棬��r=cumsum(s)+����ʲ�
for t=1:n
    if r(t)==min(r(t:n))
        continue;
    end
    [xiao,xiaoind]=min(r(t:n));
    ind1(t)=t;
    ind2(t)=xiaoind;%���ָ�����t���ԣ��ʺ���ȡt+xiaoind-1
    rate(t)=(xiao-r(t))/r(t);%�����ʽ�ұ߻���xiao-r(t),��������������س����ֵ
end
[maxddr,k]=min(rate);             %ֵӦ����0-100%֮��
maxind1=k;
maxind2=ind2(k)+k-1;
end
    

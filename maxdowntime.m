%%��س�ʱ����㣨����ֵ��ʽ�������ʱδ���ܾ������룩
%����ÿ���ʽ�Ļָ�ʱ�䣬�γ�������ȡ���ֵ
%find
function [time,maxind1,maxind2]=maxdowntime(s) %s�ǵ����ʽ�
n=length(s);
ind1=zeros(n,1);
ind2=zeros(n,1);
r=s;                        %���s��ָ���ھ������棬��r=cumsum(s)+����ʲ�
time=0;%����ֵ
x=zeros(n,1);%ÿ���ʽ�Ļָ�ʱ�䣬�γ�����
for t=1:n-1
  b=r(t+1:end);
    if  r(t)<=max(b)
        a=find(b-r(t)>=0);
        x(t)=a(1)-1;
    else              %���ʽ�һֱδ�ָ�ԭֵ,��
       x(t)=n-t;
    end   
end
[time,k]=max(x);
maxind1=k;
maxind2=k+time;
end
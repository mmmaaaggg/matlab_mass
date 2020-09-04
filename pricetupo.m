%%ͻ�ƽ���,�۸�20���¸߽������ر�ע�⣺����n*1��������ζԽӣ���
function [rr,r]=pricetupo(price,days,stop,distance)  

%priceָ�۸�������daysָ���ڣ�stopָֹ�����(�ٷֱȣ�,distanceָͻ�Ʒ��ȣ��ٷֱȣ�
%����r�����ź���������-1,0,1��ɣ�����ա��ޡ���
%����©��1�������ͷ�����󣬲�����ֹ�𣬸�λ����������20���µͣ����յ�ô����
%�ش𣺲����յ����൥�������У�
n=length(price);
r=zeros(n,1);          %���׽����ź�����
rr=zeros(n,1);         %�ֲ��ź�
%����ֵ
if ~exist('days','var')
    days=20;
end

if ~exist('stop','var')
    stop=0;
end

if ~exist('distance','var')
    distance=0;
end

d=days+1;
p=price;
s=stop;
t=d;
while t<=n
    if p(t)>max(p(t-d+1:t-1))*(1+distance)       %����ͻ�Ʒ���
        %�ش����©��1   ����&p(t)==0  ò��û��Ҫ
        %������2:�᲻��Ӱ��෭�գ�t��b��ѭ���е�����
        r(t)=1;               
        rr(t)=r(t);
        b=1;
        M=p(t);
        while p(b+t)>M*(1-stop)          %��ֹ�����������
              rr(b+t)=1;      
              if p(b+t)>M
                  M=p(b+t);
              end
              b=b+1;
              if b+t>n
                  return;                %������Ƿ���ʣ�
              end
        end
        t=t+b;     %��������ܽ������1�� ò��whileѭ���ͽ�����������
    elseif p(t)<min(p(t-d+1:t-1))*(1-distance)     %�յ�����
        r(t)=-1;
        rr(t)=r(t);
        b=1;
        M=p(t);
        while p(b+t)<M*(1+stop)              %��ֹ�����������
              rr(b+t)=-1;      
              if p(b+t)<M
                  M=p(b+t);
              end
              b=b+1;
              if b+t>n
                  return;  %������Ƿ���ʣ�
              end
        end
        t=t+b;
    else
        t=t+1;%�����࣬Ҳ������ʱ��ָ�����
    end
end
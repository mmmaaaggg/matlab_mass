%�¸ߡ��µͽ���ϵͳ
%��������10���¸ߡ��µͣ�����ͻ��3�ոߵ�͵�
%%
%��������
%ԭʼ�ʽ�1000000
capital=1000000;

jibendwei=40;    %������λ,��������10��Ϊһ��
shouxufeibili=0.001;%�����ѱ�׼

%��������
a='yyyy/mm/dd';
b='yyyy-mm-dd';
j=a;

k=10;%ɾ��ǰ��2������
[num1,text1]=xlsread('�״�ָ��11');%�ڻ�
qihuoclose=num1(k:end,4);    %���̼�
qihuoopen=num(k:end,4);      %���̼�
date1=text1(k+1:end,1);
date1=datenum(date1,j);

%��ȡ��ͬ����
duiyingriqi=date1-693960;%����ÿ���������ʱ�õ�
%%
%�����ź�
changdu=length();
jinchangjiage=;
chuchangjiage=;
cangwei=;

for i=10:
%�������ֵ�����������۸�

%�����ź�����

%����ֲֻ�ƽ��

%�����ź�����

%���ճֲֻ�ƽ��
end
%%
%����ͳ��




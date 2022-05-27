%% BETA FUNCION PLOT DIAGRAM %%
% Finds a and b values with mle and plots beta diagram of data
%% INPUT DATA FOR USER
t_start=[2020 ;2015 ;2020 ; 2015; 2016];% PUT each starting time in column
t_e = [3 ; 9 ; 2 ; 10; 14];% put each estimated duration in column
SOL = [4122 4124 4131 4132 4133]; % Put each SOL in a row 
%% time relations
%time functions
t_p = 1.25*t_e;%
t_n = 0.75*t_e;%
t_o = 0.8*t_n ; %to 0.8 allazei
%% main program
N=length(t_e);%number of inputs for for loop
%time matrix for MLE
t=[t_o t_n t_e t_p];
%normalization value
t_stop=2030;
t1= t_stop-t_start;
d=0.2;
l=4;
for j=1:N 
    norm(:,j) = t1(j);
    if t_p(j) > t1(j);
   norm(:,j) = t_p(j)*(1+d); 
    end
     for k=1:l
        norm1(j,k)= norm(:,j);
     end
    
end
%normalise
t_norm = t./norm1;
%space
time_beta_space = 0:.001:1;

c = zeros(N,2);%storage matrix for a and b values

for i = 1:N
    [values,]=betafit(t_norm(i,:));%fits values into b curve using mle
    c(i,:) = values ;
    
    pdfbeta = betapdf(time_beta_space,c(i,1),c(i,2));
   
    figure();
    txt1 = ['beta ',num2str(SOL(i)),' function '];%text of legend)
    plot(time_beta_space,pdfbeta/(max(pdfbeta)), ... 
        'LineWidth',2, ...
       'DisplayName',txt1)
    
    xt = t_norm(i,:);
    delta=.01;
    y1 = round(t_norm(i,:),3)*1e+3;
    yt = pdfbeta(y1)/(max(pdfbeta));
    
    %/(max(pdfbeta))
     
    
    str = {'t_o','t_n','t_e','t_p'};
    text(xt+delta,yt,str);
    
    xlabel('Time(Normalised)')
    ylabel('Probability density function, normalised')
    title('Beta Diagram')
    legend show 
    hold on
    txt2 = ['DATA of ',num2str(SOL(i)),' SOL'];
    plot(xt,yt,'r*','MarkerSize',6 ...
        ,'LineWidth' ,1 ...
       ,'DisplayName',txt2)
    
    
end
%%Clear Data %%
clear all;
clc;
 
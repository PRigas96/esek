%% SPIDER GRAPH %%
% oh hi mark
% Initialize data points for each solution, seperate with (;) in between
% and run the code
%% INPUT DATA FOR USER
dataPLAN = [1 1 1 1 1 0 ; 1 1 1 1 0 1; 1 1 1 1 1 1;1 1 1 1 0 0;1 1 1 1 1 0];
dataDO = [ 1 1 1 1 0 1; 1 1 1 1 1 0; 1 1 1 1 1 1 ;1 1 1 1 0 0;1 1 1 1 0 1];% example
SOL = [4122 4124 4131 4132 4133]; % Vazete ta SOL poy thelete na sas bgalei
%% main program.
data3 = [dataPLAN dataDO];
N = size(dataPLAN,1);
Legendary = [ 'Plan'  'Do'];
headers1 = { 'jurisdiction of M.E.E', 'Flow Chart', 'Organization Chart', 'jurisdiction of other Ministries', 'Oportunities of PLAN', 'Threats of PLAN'}; l1 = length(headers1);
headers2 = { 'Budget', 'Duration of Implementation', 'Directories involved','Resources','Threats of DO','Oportunities of DO'}; l2 = length(headers2);
headers = [ headers1 , headers2];
l= [l1 l2];



for kk = 1:2
    axesmin = zeros(1,l(kk));
    axesmax = ones(1,l(kk));
    axes = [axesmin ; axesmax];
    iters = [1 6; 7 12];
    P1 = [data3(1:N,iters(kk,1):iters(kk,2))];
    
    for ll = 1:N
        
        P = P1(ll,:);
        % Spider_plot function
        figure(); % take figure #N
        spider_plot(P,...
            'AxesInterval', 10,...
            'AxesPrecision', 0,...
            'AxesDisplay', 'none',...
            'AxesLimits', axes,...
            'FillOption', 'on',...
            'FillTransparency', 0.1,...
            'Color', [0, 69, 138]/255,...
            'LineWidth', 4,...
            'Marker', 'none',...
            'AxesLabels', headers(iters(kk,1):iters(kk,2)),...
            'AxesFontSize', 14,...
            'LabelFontSize', 10,...
            'AxesColor', [0.8, 0.8, 0.8],...
            'AxesLabelsEdge', 'none');
        % Title and legend properties
        title('Radar Chart',...
            'FontSize', 14);
        graph=legend(strcat('SOL ', num2str(SOL(ll))),'Location', 'NorthEastOutside');
        if kk == 1 
            title (graph,strcat('Plan') );
        end
        if kk == 2 
            title (graph,strcat('Do') );
        end
    end
end

%%Clear data%%
clear all;
clc;

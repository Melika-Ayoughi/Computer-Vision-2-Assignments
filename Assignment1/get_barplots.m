function [] = get_barplots()

figure

%Compare accuracies and time taken

%z = load(datafile)
%A1 = z.data(row number).column

% where row number is experiment and column is to get accuracy

colormap = colorcube;

%Accuracies for asmpling method 1
A1 = [[0.1,0.2,0.3]' [0.1,0.2,0.3]' [0.1,0.2,0.3]'];

%Accuracies for sampling method 2

A2 = [[0.1,0.2,0.3]' [0.1,0.2,0.3]' [0.1,0.2,0.3]'];

%Accuracies for sampling method 3

A3 = [[0.1,0.2,0.3]' [0.1,0.2,0.3]' [0.1,0.2,0.3]'];


subplot(1,3,1)

hBar=bar(A1,'grouped', 'FaceColor','flat');      % basic grouped bar plot, keep handle
% colormap(3);
hFg=gcf; hAx=gca;             % handles to current figure, axes
ylim([0 1])                % space out a little extra room
hAx.XTickLabel={'400';'1000';'4000'}; % label x axis

x=repmat([1:size(A1,1)].',1,size(A1,2));  % bar x nominals
xOff=bsxfun(@plus,x,[hBar.XOffset]); % bar midpoints x
hold all                             % keep axis limits, etc.

for i=1:length(hBar)
  hEB(i).Color = 'black';
  hBar(i).FaceColor = colormap(57 + 2*rem(i,4),:);
end
title('Dense Sampling')
ylabel('Mean Average Precision (MAP)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,2)

hBar=bar(A2,'grouped', 'FaceColor','flat');      % basic grouped bar plot, keep handle
% colormap(3);
hFg=gcf; hAx=gca;             % handles to current figure, axes
ylim([0 1])                % space out a little extra room
hAx.XTickLabel={'400';'1000';'4000'}; % label x axis

x=repmat([1:size(A2,1)].',1,size(A2,2));  % bar x nominals
xOff=bsxfun(@plus,x,[hBar.XOffset]); % bar midpoints x
hold all                             % keep axis limits, etc.

for i=1:length(hBar)
  hEB(i).Color = 'black';
  hBar(i).FaceColor = colormap(57 + 2*rem(i,4),:);
end

title('Keypoint Sampling')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,3)

hBar=bar(A3,'grouped', 'FaceColor','flat');      % basic grouped bar plot, keep handle
% colormap(3);
hFg=gcf; hAx=gca;             % handles to current figure, axes
ylim([0 1])                % space out a little extra room
hAx.XTickLabel={'400';'1000';'4000'}; % label x axis
% hAx.YColor=get(hFg,'color');  % hide y axis/labels, outline

x=repmat([1:size(A3,1)].',1,size(A3,2));  % bar x nominals
xOff=bsxfun(@plus,x,[hBar.XOffset]); % bar midpoints x


for i=1:length(hBar)
  hEB(i).Color = 'black';
  hBar(i).FaceColor = colormap(57 + 2*rem(i,4),:);
end

title('Keypoint Sampling')


hLg = legend(["RGB";"Grayscale";"Opponent"]);
% 
sgtitle('MAP for colour space vs. vocabulary size vs. sampling method')
% newPosition = [0.77 0.77 0.2 0.2];
% set(hLg,'Position', newPosition);

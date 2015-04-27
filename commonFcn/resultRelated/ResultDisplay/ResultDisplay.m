function varargout = ResultDisplay(varargin)
% miaRESULTDISPLAY M-file for ResultDisplay.fig
%      RESULTDISPLAY, by itself, creates a new RESULTDISPLAY or raises the existing
%      singleton*.
%
%      H = RESULTDISPLAY returns the handle to a new RESULTDISPLAY or the
%      handle to
%      the existing singleton*.
%
%      RESULTDISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTDISPLAY.M with the given input arguments.
%
%      RESULTDISPLAY('Property','Value',...) creates a new RESULTDISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResultDisplay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResultDisplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResultDisplay

% Last Modified by GUIDE v2.5 10-Nov-2013 17:19:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResultDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @ResultDisplay_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ResultDisplay is made visible.
function ResultDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ResultDisplay (see VARARGIN)

% Choose default command line output for ResultDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.OpenSelected_DoingFlag = 'ready';   % ��ͼ׼��ready
guidata(hObject,handles);

% OpenAll(handles) ;
% ColseAll(handles) ;
setFigurePosition(handles) ;
% UIWAIT makes ResultDisplay wait for user response (see UIRESUME)
%uiwait(handles.ResultDisplay);
% global ResultDisplayFirst
% if ResultDisplayFirst == 1
%      OpenAll(handles) ;
%      ColseAll() ;
%      ResultDisplayFirst = 0 ;        %��һ���Ȼ�������ͼƬ
% end


% OpenAll_Callback([],[],handles);       
% CloseAll_Callback;      %�����к��ٹر����У��Ӷ�����ͼ��


function setFigurePosition(handles)
% ����GUI����Ĵ�С��λ��
set(handles.ResultDisplay,'Position',[0 90 190 440]);%���ó�ʼλ�úʹ�С


%% handles ���ݴ�����ݱ���
%  Result,figureOutputPath,SelectedResult,OpenSelected_DoingFlag,FigureType
function OpenAll(handles)
%����:������ͼ��
%���������жϱ����Ƿ��Ѿ��򿪣���û���жϱ����Ƿ��Ѿ���ͼ��
Result = handles.Result;
figureOutputPath = handles.figureOutputPath;
n = length(Result) ;
%%%%%���ظ�����������ʱ��ͼ���Ѿ����ƺã�ֻ��򿪼��ɡ����Ϊ�˱�֤����Ѹ��£��ڷ���ǰ���������Result�ļ���
%%%%%�����ļ����ж�ͼ�δ�����񣬴�����򿪣�����������Ʋ�����
for i=1:n  
    %%%%����ͼ���������Ƿ������Ӧ��ͼ��
    h = findobj('Name',Result{i}.comment);%�������þ������������Ϊ��
    if isempty(h)   %ȷ��δ�򿪡��ж��Ƿ���Ҫ��ͼ
        path = [figureOutputPath,'\',Result{i}.project,'-',Result{i}.name,'.fig'];
        if exist(path,'file')  %�����ļ����жϣ���Ӧ��figͼ���Ѵ��ڣ�ֱ�Ӵ�            
            open(path);
        else        %�ж�Ϊ�����ڣ��Ȼ�ͼ���ٱ���
            DoPlotResult(Result,i,handles);
        end
    end
end

if isfield(handles,'ResultDisplay')
    figure(handles.ResultDisplay);      %������鿴���ƽ���������ǰ
end

function DoPlotResult(Result,index,handles)

isSubPlot = 1;

name = Result{index}.name ;     % ������
% �������Ϲ켣���ݶ�������
if strcmp(name,'track')
    % �켣������ݲ���������Result��ʽ
   PlotCombineTrack(Result,index,handles); 
else
    % ��������Result��ʽ
    if isSubPlot==1
        if strcmp(Result{index}.project,'contrast')
            PlotResult(Result,index,handles);
        else
            SubPlotResult(Result,index,handles);
        end
    else
        PlotResult(Result,index,handles);
    end
end



function PlotResult(Result,index,handles)
%���ܣ�����Result��Result{number}��ͼ��
%���� number ��������Ʊ�����Result�е��±�

figureOutputPath = handles.figureOutputPath ;
%% ���ƶ��������ķ���
% ��������������ж���/�У����д洢����
data = Result{index}.data ;     % ����������
if ~isempty(data)
    name = Result{index}.name ;     % ������
    comment = Result{index}.comment ;% ͼƬ�����Ľ���
    project = Result{index}.project; % ������
    project=ResetProjectName(project);
    frequency = Result{index}.frequency ;  % Ƶ��
    if isfield(Result{index},'subName')
        subName = Result{index}.subName ;
    else
        if min (size(data,1),size(data,2) )==3
            subName = {'x','y','z'};
        else
            subName = [];
        end
    end

    time = ( (1:length(data))-1 )/frequency;  % �д洢
    % ʹ time �� data �Ĵ洢��ʽһ�£������д洢,һ��һ��ʱ��
    if size(data,1)>size(data,2)    % dataΪ�д洢,һ��һ��ʱ��
        data = data';
    end
    h = figure('name',[project,'-',name]) ;
    dataNum = min(size(data,1),size(data,2));
    [lineStyles,colors,makers] = GenerateLineStyle(dataNum) ;
    hold on
    line_h=zeros(1,dataNum);
    for k=1:dataNum
        line_h(k)=plot(time,data(k,:),[lineStyles{k},makers{k}],'Color',colors{k},'LineWidth',2, 'MarkerSize',5); 
       %line_h(k)=plot(time,data(k,:),['-',makers{k}],'Color',colors{k},'LineWidth',1, 'MarkerSize',5); 
        %line_h(k)=plot(time,data(k,:),[lineStyles{k},makers{k}],'Color',colors{k},'LineWidth',1, 'MarkerSize',5); 
    end

    xlabel('ʱ��/S','fontsize',handles.titleFontSize);
    title(AddBias([project,'-',comment]),'fontsize',handles.titleFontSize);     %������˵��Ϊplot����
    ylabel(name,'fontsize',handles.titleFontSize);    %�Ա�����Ϊ����

    if ~isempty(subName) 
       legend(line_h,AddBias(subName),'fontsize',handles.titleFontSize); 
    end

    % ���ע������
    if isfield(Result{index},'text')
       textToAdd = Result{index} .text ;

       xTickLabel = get(gca,'XTickLabel');
       XLim = get(gca,'XLim');   
       dXLim = (XLim(2)-XLim(1))/50;% �ո�
       xTickLabel_End = str2double(xTickLabel(size(xTickLabel,1),:)) ;
       text_x_1 = str2double(xTickLabel(1,:))*XLim(2)/xTickLabel_End+dXLim ;   % ǰ4��cell����ʾλ��
       text_x_2 = str2double(xTickLabel(3,:))*XLim(2)/xTickLabel_End+2*dXLim;

       yTickLabel = get(gca,'YTickLabel');
       YLim = get(gca,'YLim');
       yTickLabel_toText = str2double(yTickLabel(2,:)) ;
       yTickLabel_Min = str2double(yTickLabel(1,:)) ;
       text_y = yTickLabel_toText*YLim(1)/yTickLabel_Min;

       for j=1:length(textToAdd)
           textToAdd{j} = AddBias(textToAdd{j});
       end
       % �� textToAdd �г���4��cellʱ���ֿ���ʾ
       if length(textToAdd)>4
           text(text_x_1,text_y,textToAdd(1:4));
           text(text_x_2,text_y,textToAdd(5:length(textToAdd)));
       else
           text(text_x_1,text_y,textToAdd);
       end

    end

    saveas(h,saveHand([figureOutputPath,'\',project,'-',name,'.fig']));   % �ԡ�������-����������Ϊ.fig��
    saveas(h,saveHand([figureOutputPath,'\',project,'-',name,'.emf']));
end


function strOut = saveHand( str )
% ������·���е� /ת���ɣ�
strOut = strrep(str, '/', '��');

function PlotCombineTrack(Result,index,handles)
figureOutputPath = handles.figureOutputPath ;
datai = Result{index}.data ;     % ����������
name = Result{index}.name ;     % ������
subName = Result{index}.subName ;     % ����
comment = Result{index}.comment ;% ͼƬ�����Ľ���
project = Result{index}.project; % ������

track_h = figure('name',[project,'-',name]) ;
hold on
[lineStyles,colors,makers] = GenerateLineStyle(length(datai)) ;
for k=1:length(datai)
   data = datai{k}; 
   plot(data(1,:),data(2,:),[lineStyles{k},makers{k}],'Color',colors{k},'LineWidth',2, 'MarkerSize',4);
end
legend(AddBias(subName),'fontsize',handles.titleFontSize)
xlabel('x����/m','fontsize',handles.titleFontSize);
ylabel('y����/m','fontsize',handles.titleFontSize);
title('track\_contrast','fontsize',handles.titleFontSize);     
saveas(track_h,saveHand([figureOutputPath,'\',project,'-',name,'.fig']));   % �ԡ�������-����������Ϊ.fig��
saveas(track_h,saveHand([figureOutputPath,'\',project,'-',name,'.emf']));

function new_project=ResetProjectName(old_project)
%% �������� project ����
new_project=old_project;
switch old_project
    case 'augZhijie_QT'
        new_project = '����һ';
    case 'VO'
        new_project='VNS';
    case 'contrast'
        new_project='�Ա�';
end

function SubPlotResult(Result,index,handles)
%���ܣ�����Result��Result{number}��ͼ��
%���� number ��������Ʊ�����Result�е��±�

figureOutputPath = handles.figureOutputPath ;
%% ���ƶ��������ķ���
% ��������������ж���/�У����д洢����
data = Result{index}.data ;     % ����������
if ~isempty(data)
    name = Result{index}.name ;     % ������
    comment = Result{index}.comment ;% ͼƬ�����Ľ���
    project = Result{index}.project; % ������
    frequency = Result{index}.frequency ;  % Ƶ��
    project=ResetProjectName(project);
    if isfield(Result{index},'subName')
        subName = Result{index}.subName ;
    else
        if min (size(data,1),size(data,2) )==3
            subName = {'x','y','z'};
        else
            subName = [];
        end
    end


    time = ( (1:length(data))-1 )/frequency;  % �д洢
    % ʹ time �� data �Ĵ洢��ʽһ�£������д洢,һ��һ��ʱ��
    if size(data,1)>size(data,2)    % dataΪ�д洢,һ��һ��ʱ��
        data = data';
    end
    h = figure('name',[project,'-',name]) ;
    dataNum = min(size(data,1),size(data,2));
    [lineStyles,colors,makers] = GenerateLineStyle(dataNum) ;
    % hold on
    line_h=zeros(1,dataNum);
    for k=1:dataNum
        % �ֱ��ͼ
        subplot(dataNum,1,k);
        line_h(k)=plot(time,data(k,:),[lineStyles{k},''],'Color',colors{k},'LineWidth',2, 'MarkerSize',4); 
       %line_h(k)=plot(time,data(k,:),['-',makers{k}],'Color',colors{k},'LineWidth',1, 'MarkerSize',5); 
        %line_h(k)=plot(time,data(k,:),[lineStyles{k},makers{k}],'Color',colors{k},'LineWidth',1, 'MarkerSize',5); 
        if ~isempty(subName)
            ylabel(subName{k},'fontsize',handles.titleFontSize);
        else
            ylabel(name,'fontsize',handles.titleFontSize);
        end
        if k==1
            title(AddBias([project,'-',comment]),'fontsize',handles.titleFontSize);     %������˵��Ϊplot����
        end
       % AddText(Result,index,k);
    end

    xlabel('ʱ��/S','fontsize',handles.titleFontSize);
    % 
    % % ���ע������
    % if isfield(Result{index},'text')
    %    textToAdd = Result{index} .text ;
    %    
    %    xTickLabel = get(gca,'XTickLabel');
    %    XLim = get(gca,'XLim');   
    %    dXLim = (XLim(2)-XLim(1))/50;% �ո�
    %    xTickLabel_End = str2double(xTickLabel(size(xTickLabel,1),:)) ;
    %    text_x_1 = str2double(xTickLabel(1,:))*XLim(2)/xTickLabel_End+dXLim ;   % ǰ4��cell����ʾλ��
    %    text_x_2 = str2double(xTickLabel(3,:))*XLim(2)/xTickLabel_End+2*dXLim;
    %    
    %    
    %    
    %    yTickLabel = get(gca,'YTickLabel');
    %    YLim = get(gca,'YLim');
    %    yTickLabel_toText = str2double(yTickLabel(2,:)) ;
    %    yTickLabel_Min = str2double(yTickLabel(1,:)) ;
    %    yTickLabel_Max = str2double(yTickLabel(length(yTickLabel),:)) ;
    %    text_y = yTickLabel_Min+(yTickLabel_Max-yTickLabel_Min)*0.2;
    %    %text_y = yTickLabel_toText*YLim(1)/yTickLabel_Min;
    % 
    %     disp('')
    %    disp(name)
    %    for i=1:length(textToAdd)
    %         disp(textToAdd{i});
    %    end
    %    
    %    for j=1:length(textToAdd)
    %        textToAdd{j} = AddBias(textToAdd{j});
    %    end
    %    text(text_x_1,text_y,textToAdd(2));
    %    % �� textToAdd �г���4��cellʱ���ֿ���ʾ
    %    if length(textToAdd)>4
    %        text(text_x_1,text_y,textToAdd(1:4));
    %        text(text_x_2,text_y,textToAdd(5:length(textToAdd)));
    %    else
    %        text(text_x_1,text_y,textToAdd);
    %    end

    % end

    saveas(h,saveHand([figureOutputPath,'\',project,'-',name,'.fig']));   % �ԡ�������-����������Ϊ.fig��
    saveas(h,saveHand([figureOutputPath,'\',project,'-',name,'.emf']));

    %% �����λ����ϣ����ƹ켣ͼ
    if strcmp(name,'position(m)') && ~strcmp(project,'contrast')
        track_h = figure('name',[project,'-',name]) ;
        plot(data(1,:),data(2,:),'LineWidth',2);
        xlabel('x����/m','fontsize',handles.titleFontSize);
        ylabel('y����/m','fontsize',handles.titleFontSize);
        title(AddBias([project,'-�켣']),'fontsize',handles.titleFontSize);     %������˵��Ϊplot����
        saveas(track_h,saveHand([figureOutputPath,'\',project,'-',name,'.fig']));   % �ԡ�������-����������Ϊ.fig��
        saveas(track_h,saveHand([figureOutputPath,'\',project,'-',name,'.emf']));
    end

end

function AddText(Result,index,k)
% ���ע������
if isfield(Result{index},'text')
   textToAdd = Result{index} .text ;
   
   xTickLabel = get(gca,'XTickLabel');
   XLim = get(gca,'XLim');   
   dXLim = (XLim(2)-XLim(1))/50;% �ո�
   xTickLabel_End = str2double(xTickLabel(size(xTickLabel,1),:)) ;
   text_x_1 = str2double(xTickLabel(1,:))*XLim(2)/xTickLabel_End+dXLim ;   % ǰ4��cell����ʾλ��
   text_x_2 = str2double(xTickLabel(3,:))*XLim(2)/xTickLabel_End+2*dXLim;
   
   
   
   yTickLabel = get(gca,'YTickLabel');
   YLim = get(gca,'YLim');
   dYLim = (YLim(2)-YLim(1))/10;% �ո�
   yTickLabel_End = str2double(yTickLabel(size(yTickLabel,1),:)) ;
   text_y = str2double(yTickLabel(1,:))*YLim(2)/yTickLabel_End+2*dYLim ; 
   
%    yTickLabel_toText = str2double(yTickLabel(2,:)) ;
%    yTickLabel_Min = str2double(yTickLabel(1,:)) ;
%    yTickLabel_Max = str2double(yTickLabel(size(yTickLabel,1),:)) ;
%    text_y = yTickLabel_Min+(yTickLabel_Max-yTickLabel_Min)*0.2;
   %text_y = yTickLabel_toText*YLim(1)/yTickLabel_Min;

%     disp('')
%    disp(name)
%    for i=1:length(textToAdd)
%         disp(textToAdd{i});
%    end
   
   for j=1:length(textToAdd)
       textToAdd{j} = AddBias(textToAdd{j});
   end
   text(text_x_1,text_y,textToAdd(1+k));
%    % �� textToAdd �г���4��cellʱ���ֿ���ʾ
%    if length(textToAdd)>4
%        text(text_x_1,text_y,textToAdd(1:4));
%        text(text_x_2,text_y,textToAdd(5:length(textToAdd)));
%    else
%        text(text_x_1,text_y,textToAdd);
%    end
   
end

function ColseAll(handles)
%���ܣ��ر�����ͼ��
Result = handles.Result ;
%�ر����ж���ͼ��
n = length(Result);
for i=1:n
    name = Result{i}.name ;     % ������
    project = Result{i}.project; % ������
    FigName = [project,'-',name];
    h = findobj('Name',FigName);
    if ~isempty(h)
        close(h);
    end
end
%�ر��������ͼ��

function OpenSelected(handles)
%���ܣ���ResultList�б�ѡ�еı���
%�����ѡ����Ǹ�������ͼ�����ڵ�ǰ
%%�ȼ���Ƿ��Ѿ��򿪣���ֹ�ظ��򿪡�δ��ʱ�ټ���ͼ���Ƿ���ڣ�����������ơ�����
% �б���˳���� Result  ��Ա���һ��
global   AxisRange
SelectedResultDisN = get(handles. ResultList,'Value') ;
ResultListNum = handles.ResultListNum  ;
SelectedResult = ResultListNum(SelectedResultDisN) ;

Result = handles.Result ;
for i=1:numel(SelectedResult)
    name = Result{SelectedResult(i)}.name ;     % ������
    project = Result{SelectedResult(i)}.project; % ������
    FigName = [project,'-',name];
    %%%%����ͼ���������Ƿ������Ӧ��ͼ��
    h = findobj('Name',FigName);%�������þ������������Ϊ��
    if isempty(h)   %ȷ�ϲ����ڡ��ж��Ƿ���Ҫ��ͼ
        %disp('δ��');
        path = [handles.figureOutputPath,'\',FigName,'.fig'];
        if exist(path,'file')  %�����ļ����жϣ���Ӧ��figͼ���Ѵ��ڣ�ֱ�Ӵ�
            %disp('���ڣ�ֱ�Ӵ�');
            try
                open(path);
            catch 
                disp('��ʧ��')
                DoPlotResult(Result,SelectedResult(i),handles);
            end
        else
            DoPlotResult(Result,SelectedResult(i),handles);
            %disp('�����ڣ�����');
        end
    else
        %disp('�Ѵ�');
        figure(h);      %���ڣ���������ǰ
    end
end
% AxisRange = axis;
% RefreshAxisRange(0,handles);

% --- Outputs from this function are returned to the command line.
function varargout = ResultDisplay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject,handles);


function CombineResult = GetCombineProjectResult(originalResult)
%% ����ԭʼͬһ�������Զ������������ɷ����������
% ���ɷ�����˵���ĵ�

% Ѱ������name��ͬ��project��ͬ������cell
% �ж�����name�����ж��ٸ����ϸ��
% �õ����е�name�б�
orNum = length(originalResult);
allName = cell(1,orNum) ;
difNameNum = 0;         %  ��ͬname�ĸ���
firstProjectIndex = zeros(1,orNum);     % Result��ͬһname�ĵ�һ�������±�
for i=1:orNum       % ���� difNameNum firstProjectIndex
    name = originalResult{i}.name ;
    if isNewName(name,allName)
        % Ϊ�� name
        difNameNum = difNameNum+1 ;
        firstProjectIndex(difNameNum) = i ;
        allName{difNameNum} = name ;
    end
end
allName = allName(1:difNameNum);
firstProjectIndex = firstProjectIndex(1:difNameNum);
combineLength = zeros(1,difNameNum);  % ����������ݵ���Ч����
combineFre = zeros(1,difNameNum);  % ����������ݵ�Ƶ��
for j=1:difNameNum
    name_j = originalResult{firstProjectIndex(j)}.name ;
    length_j = zeros(1,5);   % ����name��ͬ�ĵ�j���������ݳ���
    frequency_j = zeros(1,5);% ����name��ͬ�ĵ�j����������Ƶ��
    project_num = 1;
    length_j(1) = size(makeRow(originalResult{firstProjectIndex(j)}.data,3),2);
    frequency_j(1) = originalResult{firstProjectIndex(j)}.frequency;
    for k=firstProjectIndex(j)+1:orNum        
        if strcmp(name_j,originalResult{k}.name)
            project_num = project_num+1 ;
            length_j(project_num) = size(makeRow(originalResult{k}.data,3),2);
            frequency_j(project_num) = originalResult{k}.frequency;
        end
    end
    length_j = length_j(1:project_num);
    frequency_j = frequency_j(1:project_num);
    % �õ�������ݵ�ƽ�ʺͳ���
    [validLenth,combineK,combineLength(j),combineFre(j)] = GetValidLength(length_j,frequency_j);
    combineLength(j)=combineLength(j)-1;    % ��Ȼ�ݴ��ԱȽϲ�
end
combineResultNum = 0 ;  % �µ�ϸ�������ĸ���=name����*ÿ��name��Ӧ���ӱ���
CombineResult = cell(1,20);
% ���� name ����������Ҫ��ϵ�����
for j=1:difNameNum
    % ÿ��j�������µ�ϸ�������ĸ���Ϊ originalResult{firstProjectIndex(j)}.data ���ӱ�����
    firstData = originalResult{firstProjectIndex(j)}.data ;
    j_newCellNum = min( size(firstData,1),size(firstData,2) );
    name_j = originalResult{firstProjectIndex(j)}.name ;
    
    % �ж��˱����Ƿ���Ҫ���
    isNeedCombine = 0;
    for name_k=firstProjectIndex(j)+1:orNum
       if strcmp(originalResult{name_k}.name,name_j) 
           isNeedCombine = 1;
       end
    end
    if isNeedCombine == 1
        %% ������Ҫ�����������ͬ������ͬ���������Ҫ�������
        
        dataFlag = 'xyz result display format';
        frequency_j_first = originalResult{firstProjectIndex(j)}.frequency ;

        subName = originalResult{firstProjectIndex(j)}.subName ;
        comment_j = originalResult{firstProjectIndex(j)}.comment ;
        project_j = originalResult{firstProjectIndex(j)}.project ;
        % �����Ѿ�ȷ��j��Ӧ����ϸ�������³�Ա��dataFlag,frequency,name,project
        data_j = originalResult{firstProjectIndex(j)}.data ;
        data_j = makeRow(data_j) ;  % ʹΪ�д洢
        for j_sub=1:j_newCellNum
            % ��ѭ���н�����һ��ȷ������cell����
            if ~isempty(subName)
             %   name_j_sub = [name_j,'-',subName{j_sub}] ;      % ����ȷ�� name
                name_j_sub = subName{j_sub} ;
            else
                subName = [];
            end
            comment_j_sub = [comment_j,'-',subName{j_sub}]; % ����ȷ�� comment
            subName_j_sub = cell(1,5);  % ����δ֪��Ԥ��Ϊ5
            subName_j_sub{1} = project_j;
            
                        
            %%%%%%%%%%%%%%%%%%%%%% ************ %%%%%%%%%%%%%%
            toCombineData  = GetDataToComine(data_j(j_sub,:),frequency_j_first,combineFre(j));
            combineLength(j) = min(combineLength(j),length(toCombineData));
            data_j_sub = zeros(5,combineLength(j));
            data_j_sub(1,1:combineLength(j)) = toCombineData(1:combineLength(j)) ;  % ���ݺϲ���һ��
            %%%%%%%%%%%%%%%%%%%%% ************ %%%%%%%%%%%%%%%
            difProjectNum = 1;  % ��ͬ��project�ĸ���        
            % ��ȡdata��Ѱ������nameΪname_j��cell�����ϲ�������
            for k=firstProjectIndex(j)+1:orNum
                if strcmp(name_j,originalResult{k}.name)
                    difProjectNum = difProjectNum+1 ;
                    %%%%%%%%%%%%%%%%%%%%%%
                    % ����Ч�Լ�飺���ȡ�Ƶ��һ�µ�
                    %%%%%%%%%%%%%%%%%%%%%%
                    data_k = originalResult{k}.data ;
                    if ~isempty(data_k)
                        toCombineData  = GetDataToComine(data_k(j_sub,:),originalResult{k}.frequency,combineFre(j));
                        data_j_sub(difProjectNum,1:combineLength(j)) = toCombineData(1:combineLength(j)) ;  % ���ݺϲ���k��% ����ȷ�� data
                        subName_j_sub{difProjectNum} = originalResult{k}.project ;
                    end
                end
            end
            subName_j_sub = subName_j_sub(1:difProjectNum);     % ȥ����Ч
            data_j_sub = data_j_sub(1:difProjectNum,:);
            % ȷ��һ���µ�ϸ������
            aNewCombineResult.dataFlag = dataFlag ;
            aNewCombineResult.frequency = combineFre(j) ;
            aNewCombineResult.name = name_j_sub ;
            aNewCombineResult.comment = comment_j_sub ;
            aNewCombineResult.data = data_j_sub ;
            aNewCombineResult.project = 'contrast' ;
            aNewCombineResult.subName = subName_j_sub ;
            % ȷ����һ���µ�ϸ��������
            combineResultNum = combineResultNum+1 ;
            CombineResult{combineResultNum} = aNewCombineResult ; 
            
        end
    end
    
end
CombineResult = CombineResult(1:combineResultNum);
%% �����Ϲ켣���ݣ���ʽ���⣬������ͼ��
combineTrack.dataFlag = dataFlag ;
combineTrack.frequency = 1 ;    % ������
combineTrack.name = 'track' ;
combineTrack.comment = 'contrast_track';
combineTrack.project = 'contrast' ;

difProjectNum = 0;  % ��ͬ��project�ĸ���   
data_temp=cell(1);
subName_temp=cell(1);

for k=1:orNum
    if strcmp('position(m)',originalResult{k}.name)
        difProjectNum = difProjectNum+1 ;
        data_temp{difProjectNum} = originalResult{k}.data ;
        subName_temp{difProjectNum} = originalResult{k}.project ;
    end                
end        

combineTrack.data = data_temp;
combineTrack.subName = subName_temp;
combineResultNum = combineResultNum+1 ;
CombineResult{combineResultNum} = combineTrack ; 


function isNew = isNewName(name,allName)
%% allName �в����� name�򷵻�1
for i=1:length(allName)
   if strcmp(allName{i},name) 
      isNew = 0;
      return
   end
end
isNew = 1;

function new = makeRow(old,n)
% ʹ����Ϊ�д洢 ��һ��һ��ʱ�̣�����ʱ ����<����(ʱ����)
% ����nʱn��ʾ��������������֪��
new = old ;
if exist('n','var')
   momentNum = n;       % ��������
else
    momentNum = length(old);
end
if size(old,1)>momentNum
   new = old'; 
end

% --- Executes during object creation, after setting all properties.
function Open_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in Close.
function Close_Callback(hObject, eventdata, handles)
% hObject    handle to Close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%���ܣ��رձ�ѡ�е�ͼ��
%����������FigureHandle����رգ����ж��Ƿ��
%������һ�ַ����������ж�ͼ���Ƿ�򿪣�����ͼ�������Ҿ��
global Result   ResultNum   SelectedResult   FigureHandle   
n = length(SelectedResult) ;
for i=1:n
    VarOrder = SelectedResult(i)+ResultNum.time ;    %SelectedResult(i)+ResultNum.timeΪ��ѡ������Result�����еı��
    FigName = Result{VarOrder,3};
    h = findobj('Name',FigName);
    if ~isempty(h)
        close(h);
    end
    FigureHandle(VarOrder) = 0;     %�ر�ĳ��ͼ�κ�һ��Ҫ�ǵý�FigureHandle�����е���Ӧλ��0
end         

% --- Executes on button press in SupCombine.
function SupCombine_Callback(hObject, eventdata, handles)
% hObject    handle to SupCombine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CloseAll.
function CloseAll_Callback(~, ~,handles)
% hObject    handle to CloseAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ColseAll(handles) ;

% --- Executes on button press in SubCombine.
function SubCombine_Callback(hObject, eventdata, handles)
% hObject    handle to SubCombine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function isResult = isResultFormat(data)
% �ж� data �ǲ���Resultר�ø�ʽ
if iscell(data) && isfield(data{1},'dataFlag') && strcmp(data{1}.dataFlag,'xyz result display format')
    % ȷ��Ϊ��Ч��Result�ļ�
    isResult = 1 ;
else
    isResult = 0 ;
end

% --- Executes during object creation, after setting all properties.
function ResultDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResultDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global projectDataPath 

if isempty(projectDataPath)
    ResultPath = uigetdir([pwd,'\resultInput'],'ѡ������ƽ���ļ�');
    projectDataPath = pwd ;
else
    ResultPath = [projectDataPath,'\navResult'];    
end
%ResultPath = pwd;   % ��ִ���ļ�ʱ��ô��

if ~isdir(ResultPath)
   ResultPath = uigetdir(projectDataPath,'ѡ������ƽ���ļ�');
end

% disp('�������·��')
% display(ResultPath)
figureOutputPath = [ResultPath,'\figureOutput'] ;  % ��ͼ�������Ŀ¼
if isdir(figureOutputPath)
    button = questdlg('�Ƿ����ԭͼƬ','ͼƬ�洢�ļ�����','��','��','��') ;
    if strcmp(button,'��')
        delete([figureOutputPath,'\*']);     % ���������
    end
else
    mkdir(figureOutputPath);    % ����������
end
handles.figureOutputPath = figureOutputPath ;
guidata(hObject,handles);
% ��ȡ�ļ�������.mat�ļ�������һ�ж��Ƿ�Ϊresult��ʽ���ļ�������Ч���ݺϲ��� Result
allFillName = ls([ResultPath,'\*.mat']);
fileNum = size(allFillName,1);
validFileNum = fileNum;
Result = cell(1,20);    % ������δ֪����㶨���ȣ���ȷ�����ٶ���С
varNum = 0; % ��¼���д����Ƶı����ĸ���
for j=1:fileNum
   data = importdata([ResultPath,'\',allFillName(j,:)]); 
   if isResultFormat(data)  % ���ļ����ж�Ϊ��Ч�����ʽ�ļ�
       for k=1:length(data)
           varNum = varNum+1 ;
           Result{varNum} = data{k};    % �ϲ�
       end
   else
       validFileNum=validFileNum-1;
   end
end
Result = Result(1:varNum);
if(validFileNum>1)
    CombineResult = GetCombineProjectResult(Result) ;   % �õ������������
    assignin('base','CombineResult',CombineResult);
    Result = [Result,CombineResult];    % ��������Ͻ���ϲ��������Ƶı�����
end

handles.Result = Result ;   % ���� Result ��GUIData��

handles.figureOutputPath = figureOutputPath ;
guidata(hObject,handles);
% Result �д�ʱ�Ѿ��������д����Ƶı���
assignin('base','Result',Result);
save([handles.figureOutputPath,'\Result.mat'],'Result');
disp('Result �ļ���ȡ���������浽figureOutput �ͻ��������ռ�')

if exist([ResultPath,'\VOResult.mat'],'file')
    VOResult = importdata([ResultPath,'\VOResult.mat']);
    assignin('base','VOResult',VOResult);
end
if exist([ResultPath,'\VisualRT.mat'],'file')
    VisualRT = importdata([ResultPath,'\VisualRT.mat']);
    assignin('base','VisualRT',VisualRT);
end
if exist([ResultPath,'\trueTraceResult.mat'],'file')
    trueTraceResult = importdata([ResultPath,'\trueTraceResult.mat']);
    assignin('base','trueTraceResult',trueTraceResult);
end
if exist([ResultPath,'\simple_dRdT_check.mat'],'file')
    simple_dRdT_check = importdata([ResultPath,'\simple_dRdT_check.mat']);
    assignin('base','simple_dRdT_check',simple_dRdT_check);
end
if exist([ResultPath,'\realDriftResult.mat'],'file')
    realDriftResult = importdata([ResultPath,'\realDriftResult.mat']);
    assignin('base','realDriftResult',realDriftResult);
end
if exist([ResultPath,'\INS_VNS_Result_simple_dRdT.mat'],'file')
    INS_VNS_Result_simple_dRdT = importdata([ResultPath,'\INS_VNS_Result_simple_dRdT.mat']);
    assignin('base','INS_VNS_Result_simple_dRdT',INS_VNS_Result_simple_dRdT);
end
if exist([ResultPath,'\INS_VNS_Result_augment_dRdT.mat'],'file')
    INS_VNS_Result_augment_dRdT = importdata([ResultPath,'\INS_VNS_Result_augment_dRdT.mat']);
    assignin('base','INS_VNS_Result_augment_dRdT',INS_VNS_Result_augment_dRdT);
end
if exist([ResultPath,'\augment_dRdT_check.mat'],'file')
    augment_dRdT_check = importdata([ResultPath,'\augment_dRdT_check.mat']);
    assignin('base','augment_dRdT_check',augment_dRdT_check);
end

% --- Executes during object creation, after setting all properties.
function ResultList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResultList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% �����б�
Result = handles.Result ;
varNum = length(Result);
ResDis = cell(1,3);
ResultListNum = zeros(1,3) ;
ResDis_k = 0;
for j=1:varNum
    if ~isempty(Result{j}.data)
        ResDis_k = ResDis_k+1 ;
        ResDis{ResDis_k} = [Result{j}.project,'-',Result{j}.comment] ;
        ResultListNum(ResDis_k) = j ;
    end
end
set(hObject,'String',ResDis);
SelectedResult = 1;
set(hObject,'Value',SelectedResult);
handles.ResultListNum = ResultListNum ;
handles.titleFontSize = 15 ;
handles.SelectedResult = SelectedResult ;
guidata(hObject,handles);   % ���汻ѡ�����


% --- Executes on selection change in ResultList.
function ResultList_Callback(hObject, eventdata, handles)
% hObject    handle to ResultList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ResultList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ResultList
% ����ģʽ��ֱ������򿪣����ģʽ�²����һ���

FigureType = handles.FigureType ;
if ~strcmp(handles.OpenSelected_DoingFlag,'busy')
    handles.OpenSelected_DoingFlag = 'busy' ;       %����æ״̬��ִ�����������ǰ����Ӧ�µ����
    guidata(hObject,handles);
    if strcmp(FigureType,'alone')
        %ColseAll(handles) ;
        OpenSelected(handles) ;         %����ģʽ
    end
    figure(handles.ResultDisplay);      %������鿴���ƽ���������ǰ
    setFigurePosition(handles) ;
    handles.OpenSelected_DoingFlag = 'ready' ;    %�ָ�����״̬��������Ӧ�µ�����
    guidata(hObject,handles);
else
    %disp('wait last OpenSelected function finished')
end

% --- Executes on button press in OpenAll.
function OpenAll_Callback(~, ~, handles)
% hObject    handle to OpenAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 OpenAll(handles) ;

% --- Executes during object creation, after setting all properties.
function ResultListPane_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResultListPane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Title','����б�( ����� )')

function x_axis_Callback(hObject, eventdata, handles)
% hObject    handle to x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_axis as text
%        str2double(get(hObject,'String')) returns contents of x_axis as a double
%������������ʱ��ֱ���趨��ķ�Χ
%����һ������ʱ�����м�Ϊ���ģ����������ŷ�Χ
%�ӱ༭���е��ַ����ж�ȡ���֣�����֮�����κη�����Ԫ�ظ�������ո�,С������⣩
global AxisRange
xv = get(hObject,'String');

j=1;
temp=[];
%%%%%%%
%�����֣��������κγ��������ָ�������ʽ
n = length(xv);
for i=1:n
    if i<n
         if xv(i)>44 && xv(i)<58  %���ֻ�С����
            temp = [temp,xv(i)];
         else %�ո�
             if ~isempty(temp)
                temp = str2double(temp) ;
                xvdata(j) = temp;
                j=j+1;
                temp = [];
             end
         end
    else
        temp = [temp,xv(i)];
        temp = str2double(temp) ;
        xvdata(j) = temp;
    end
end
%%%%%%%
n = length(xvdata);
if n~=2 && n~=1
    errordlg('ʱ���᷶Χ��������');
    return;
end
if n==1     %����
    middle = (AxisRange(1) + AxisRange(2))/2 ;
    middle = fix(middle);
    xrange = AxisRange(2) - AxisRange(1) ;
    xrange = fix(xrange*xvdata) ;
    AxisRange(1) = middle - xrange/2;
    AxisRange(2) = middle + xrange/2;
    if AxisRange(1)<-60
        AxisRange(1) = -60;
        AxisRange(2) = AxisRange(1)+xrange ;
    end
    if AxisRange(2)>xlabelTime
        AxisRange(2)=xlabelTime+60;
        AxisRange(1) = AxisRange(2)-xrange ;
    end
end

Result = handles.Result ;
SelectedResultDisN = get(handles. ResultList,'Value') ;
ResultListNum = handles.ResultListNum  ;
SelectedResult = ResultListNum(SelectedResultDisN) ;
data = Result{SelectedResult(1)}.data ;
xlabelTime = ceil( length(data)/Result{SelectedResult(1)}.frequency );  %  ʱ���ܳ���

if n==2  %ֱ�����÷�Χ
    if xvdata(2)<xvdata(1)
        errordlg('X�᷶Χ���ô���ǰ���ӦС�ں���ġ�');
        return;
    end
    AxisRange(1) = xvdata(1);
    AxisRange(2) = xvdata(2);  
    if AxisRange(1)<0
        AxisRange(1) = 0;
    end
    if AxisRange(2)>xlabelTime
        AxisRange(2)=xlabelTime;
    end
end
RefreshAxisRange(1,handles);
        
function RefreshAxisRange(SourceNum,handles)
%���� AxisRange��ֵ���£�ͼ�Ρ��༭���϶�������һ��Ϊ������Դ������£�
%����SourceNum��ʾ������Դ��ͼ�Σ�0�����༭��1�����϶�����2��
global   AxisRange 
Result = handles.Result ;
SelectedResultDisN = get(handles. ResultList,'Value') ;
ResultListNum = handles.ResultListNum  ;
SelectedResult = ResultListNum(SelectedResultDisN) ;

data = Result{SelectedResult(1)}.data ;
xlabelTime = ceil( length(data)/Result{SelectedResult(1)}.frequency );  %  ʱ���ܳ���

if SourceNum~=0         %��Ϊ0ʱ�����ͼ��
    %ֻ�ı�ѡ�еĵ�һ��ͼ��
    FigName = [ Result{SelectedResult(1)}.project,'-',Result{SelectedResult(1)}.name ];
    h = findobj('Name',FigName);
    if isempty(h)
         DoPlotResult(Result,SelectedResult(1),handles);
    else
        figure(h);
    end
    axis(AxisRange);
end
%�ܸ��±༭��
xstr = [num2str(AxisRange(1)),' ',num2str(AxisRange(2))];
set(handles.x_axis,'String',xstr);
ystr = [num2str(AxisRange(3)),' ',num2str(AxisRange(4))];
set(handles.y_axis,'String',ystr);

if SourceNum~=2         %��Ϊ2ʱ������϶���
    xposition = (AxisRange(1)+AxisRange(2))/xlabelTime/2;
    if xposition>1
        xposition=1;
    end
    if xposition<0
        xposition=0;
    end
    set(handles.Xslider,'Value',xposition);
end

% --- Executes during object creation, after setting all properties.
function x_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_axis_Callback(hObject, eventdata, handles)
% hObject    handle to y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_axis as text
%        str2double(get(hObject,'String')) returns contents of y_axis as a double
%������������ʱ��ֱ���趨��ķ�Χ
%����һ������ʱ�����м�Ϊ���ģ����������ŷ�Χ
%�ӱ༭���е��ַ����ж�ȡ���֣�����֮�����κη�����Ԫ�ظ�������ո�,С������⣩
global AxisRange 
yv = get(hObject,'String');

j=1;
temp=[];
%%%%%%%
%�����֣��������κγ��������ָ�������ʽ
n = length(yv);
for i=1:n
    if i<n
         if yv(i)>44 && yv(i)<58  %���ֻ�С����
            temp = [temp,yv(i)];
         else %�ո�
             if ~isempty(temp)
                temp = str2double(temp) ;
                yvdata(j) = temp;
                j=j+1;
                temp = [];
             end
         end
    else
        temp = [temp,yv(i)];
        temp = str2double(temp) ;
        yvdata(j) = temp;
    end
end
%%%%%%%
n = length(yvdata);
if n~=2 && n~=1
    errordlg('Y�᷶Χ��������');
    return;
end
if n==1     %����
    middle = (AxisRange(3) + AxisRange(4))/2 ;
    middle = fix(middle);
    yrange = AxisRange(4) - AxisRange(3) ;
    yrange = fix(yrange*yvdata) ;
    AxisRange(3) = middle - yrange/2;
    AxisRange(4) = middle + yrange/2;
end

if n==2  %ֱ�����÷�Χ
    if yvdata(2)<yvdata(1)
        errordlg('Y�᷶Χ���ô���ǰ���ӦС�ں���ġ�');
        return;
    end
    AxisRange(3) = yvdata(1);
    AxisRange(4) = yvdata(2);  
end
RefreshAxisRange(1,handles);

% --- Executes during object creation, after setting all properties.
function y_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function Xslider_Callback(hObject, eventdata, handles)
% hObject    handle to Xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%��x�᷽�򣬱��ִ�С���������������ƶ�ͼ��
%��silder��ֵȷ���м�ֵ
global AxisRange

Result = handles.Result ;
SelectedResultDisN = get(handles. ResultList,'Value') ;
ResultListNum = handles.ResultListNum  ;
SelectedResult = ResultListNum(SelectedResultDisN) ;

data = Result{SelectedResult(1)}.data ;
xlabelTime = ceil( length(data)/Result{SelectedResult(1)}.frequency );  %  ʱ���ܳ���

position = get(hObject,'Value');
middle = xlabelTime * position ; %����м�ֵ
xrange = AxisRange(2)-AxisRange(1);
xmin = middle - xrange/2 ;
xmax = middle + xrange/2 ;
AxisRange(1) = xmin;
AxisRange(2) = xmax;
if AxisRange(1)<-60
    AxisRange(1) = -60 ;
    AxisRange(2) = AxisRange(1)+xrange ;
    if AxisRange(2)>xlabelTime
        AxisRange(2)=xlabelTime+100 ;
    end
end
if AxisRange(2)>xlabelTime
    AxisRange(2)=xlabelTime+60;
    AxisRange(1) = AxisRange(2)-xrange ;
    if AxisRange(1)<-60
        AxisRange(1)=-60;
    end
end

RefreshAxisRange(2,handles);

% --- Executes during object creation, after setting all properties.
function Xslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function uipanel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ResultList.
function ResultList_ButtonDownFcn(~, ~, handles)
% hObject    handle to ResultList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ����ģʽ��ֱ������򿪣����ģʽ�²����һ���
% global FigureType OpenSelectedHold_DoingFlag
% % OpenSelectedHold_DoingFlag���ڷ�ֹ�����ظ��һ�ʱ���ص��������Լ��жϳ���Ҫ��ִ���굱ǰ����Ӧ�µ��һ�
% FigureType = handles.FigureType ;
% if ~strcmp(OpenSelectedHold_DoingFlag,'busy')
%     OpenSelectedHold_DoingFlag = 'busy' ;       %����æ״̬��ִ�����������ǰ����Ӧ�µ��һ�
%     if strcmp(FigureType,'combine')
%         ColseAll() ;
%         PlotCombineFig(handles) ; %���ģʽ
%     end
%     figure(handles.ResultDisplay);      %������鿴���ƽ���������ǰ
%     setFigurePosition(handles) ;
%     OpenSelectedHold_DoingFlag = 'ready' ;    %�ָ�����״̬��������Ӧ�µ�����
% else
%     %disp('wait last OpenSelectedHold function finished')
% end

function PlotDiResult(Result)
%% �������ͼ��
% combineProject �ĸ�ʽ�ο�˵����
resultIndex = combineProject.resultIndex ;
subIndex = combineProject.subIndex ;
% �����������±��ʾ���������ݺϲ���һ��

function PlotCombineFig(handles)
% һ���ģʽ��ͼ
% �����Ƿ���ڣ�ֱ�����»���
%���ܣ�����Result�е�ͼ��
%���� number ��������Ʊ�����Result�е��±�
global Result  HoldNameList ResultNum OpenSelectedHold_DoingFlag


SelectedResultDisN = get(handles. ResultList,'Value') ;
ResultListNum = handles.ResultListNum  ;
SelectedResult = ResultListNum(SelectedResultDisN) ;

timeLength = length(Result{1,1}) ;  %ʱ�䳤��
dataNum = length(SelectedResult) ;  %��ϸ���

holdData = zeros(timeLength,dataNum) ;   %�д洢��һ��һ��ʱ��
holdTitle = cell(dataNum,1) ;
WholeExplain = '' ; %��Ͻ���
WholeName = '' ;
%������ݡ�˵���ͱ�����
for k=1:dataNum
    if k==1
        data_N = SelectedResult(k)+ResultNum.time ;
        holdData(:,k) = Result{data_N,k} ;
        holdTitle{k} = Result{data_N,3} ;   %����˵��
        WholeExplain = Result{data_N,3} ;
        WholeName = Result{data_N,2} ;
    else
      	data_N = SelectedResult(k)+ResultNum.time ;
        holdData(:,k) = Result{data_N,1} ;
        holdTitle{k} = Result{data_N,3} ;   %����˵��
        WholeExplain = [WholeExplain,'-',Result{data_N,3}] ;
        WholeName = [WholeName,'-',Result{data_N,2}] ;
    end
end

    figh = figure('Name',WholeExplain) ;    %��������е��±���Result���±���һ��  %������˵��Ϊfigure����
    ploth = plot(Result{1,1},holdData);        %Result{1}Ϊ����ʱ�䣬Result{number,1}��Ϊ�����Ƶı�������
    title(AddBias(WholeExplain),'fontsize',handles.titleFontSize);     %������˵��Ϊplot����
    legend(ploth,holdTitle,'fontsize',8) ;
    xlabel('ʱ��/S','fontsize',handles.titleFontSize);
    ylabel(WholeName,'fontsize',handles.titleFontSize);    %�Ա�����Ϊ����
    v =axis;
    v(3)=v(3)*0.95;
    if v(3)==0
        v(3)=-v(4)/50;
    end
    v(4)=v(4)*1.05;
    axis(v);        
    %%%%%%%%���棺ֻ���������±���
    if dataNum>1
        path = [pwd,'\result\figure\',WholeName,'.fig'];
        saveas(figh,path);
        path = [pwd,'\result\jpeg\',WholeName,'.jpg'];
        saveas(figh,path);
    end
% �����ͼ������¼��HoldNameList�����ڹر�ͼ��ʱ����ͼ��
num = length(HoldNameList) ;
HoldNameList{num+1} = WholeExplain ;



% --- Executes during object creation, after setting all properties.
function OpenAll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in HoldMode.
function HoldMode_Callback(hObject, ~, handles)
% hObject    handle to HoldMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HoldMode

FigureTypeNum = get(hObject,'Value') ;
if FigureTypeNum == 1    %���ģʽ
    handles.FigureType = 'combine';
    set(handles.ResultListPane,'Title','����б�(���ѡ��,�һ���)')
else    %����ģʽ
    handles.FigureType = 'alone';
    set(handles.ResultListPane,'Title','����б�( ����� )')
end
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function HoldMode_CreateFcn(hObject, ~, handles)
% hObject    handle to HoldMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.FigureType = 'alone'; % Ĭ�϶�����ͼģʽ
guidata(hObject,handles);
set(hObject,'Value',0)


% --- Executes on key press with focus on ResultList and none of its controls.
function ResultList_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ResultList (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
disp('')


% --- Executes on button press in refrash.
function refrash_Callback(hObject, eventdata, handles)
% hObject    handle to refrash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.ResultDisplay) ;
ResultDisplay ;


% --- Executes during object creation, after setting all properties.
function refrash_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refrash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function CloseAll_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to CloseAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ColseAll(handles) ;

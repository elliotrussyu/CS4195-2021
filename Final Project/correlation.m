% Mar. 23th 2021
% CS4195 Modeling and Data Analysis in Complex Networks
% Final Project
% Authors: 
%           Hanshu Yu 4907787,
%           Songlei Fang 5233038,
%           Ying Jin 5184657,
%           Xiaowei Duan 5337593,
%           Chang Ye 5219698.

% References:
% - Pappalardo et al., (2019) A public data set of spatio-temporal match events in soccer competitions, Nature Scientific Data 6:236, https://www.nature.com/articles/s41597-019-0247-7
% 
% - Pappalardo et al. (2019) PlayeRank: Data-driven Performance Evaluation and Player Ranking in Soccer via a Machine Learning Approach. ACM Transactions on Intellingent Systems and Technologies (TIST) 10, 5, Article 59 (September 2019), 27 pages. DOI: https://doi.org/10.1145/3343172

% Please use the latest version of MATLAB, using an older version could
% result in some unexpected errors.

tic
clear all
close all
clc
total_record_pass = [];
total_record_duel = [];
total_record_lose = [];
%% Add Path of Necessary Tools
% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));
displayflag = 0;
plotflag= 0;
%% Read Data
fileName1 = 'events_England.json'; % filename in JSON extension
str1 = fileread(fileName1); % dedicated for reading files as text
data1 = jsondecode(str1); % Using the jsondecode function to parse JSON from string
fileName2 = 'matches_England.json'; % filename in JSON extension
str2 = fileread(fileName2); % dedicated for reading files as text
data0 = jsondecode(str2); % Using the jsondecode function to parse JSON from string
fileNamep = 'players.json'; % filename in JSON extension
strp = fileread(fileNamep); % dedicated for reading files as text
playerdata = jsondecode(strp); % Using the jsondecode function to parse JSON from string
%% Data Pre-processing
for matc = 1:size(data0,1)
matchselect = matc;%This number should be from 1 to size(data0,1)

data2 = data1([data1.matchId] == data0(matchselect).wyId,:);

%Find 1 half finish time
in1 = strfind([data2.matchPeriod],'2H');
endtime1h = data2((in1-1)/2,:).eventSec;

in2 = strfind([data2.matchPeriod],'E1');
if isempty(in2) == 0
    endtime2h = data2((in2-1)/2,:).eventSec;
    in3 = strfind([data2.matchPeriod],'E2');
    endtime1e = data2((in3-1)/2,:).eventSec;
end
%Renumbering the players from the number 1
data = data2;
data = data([data.playerId]~=0,:);
players = sortrows(unique([data.playerId;data.teamId]','rows'),2,'ascend');
numberings = 1:size(players,1);
players_ref = [players,numberings'];
[lo,ii] = ismember([data.playerId],players_ref(:,1));
replace1 = players_ref(ii(lo),3);
teams = [sort(unique([data.teamId]),'ascend')',[1;2]];
[lo,ii] = ismember([data.teamId],teams(:,1));
replace2 = teams(ii(lo),2);
[lo,ii] = ismember(players_ref(:,2),teams(:,1));
players_ref(:,2) = teams(ii(lo),2);
for i = 1:length(replace1)
    data(i).playerId = replace1(i);
    data(i).teamId = replace2(i);
end
playernum = [length(find(players_ref(:,2) == 1)),length(find(players_ref(:,2) == 2))];

team1 = players_ref(players_ref(:,2)==1,3);
team2 = players_ref(players_ref(:,2)==2,3);

pos_team1 = player_pos(data,team1);
pos_team2 = player_pos(data,team2);

player_labels = cell(1,size(players_ref,1));
for i = 1:size(players_ref,1)
    player_labels{i} = playerdata([playerdata.wyId]==players_ref(i,1),:).shortName;
end
%% Initialization 
passgraph = [];
pass_state_ini = [0,0,0,0]; %Player1,Player2,timestamp,successful 1/fail 0
pass_flag = 0;
team_rec_temp = 0;
loseballgraph = [];

duelgraph = [];
duel_state_ini = [0,0,0]; %Player1,player2,timestamp
duel_flag = 0;

monitor = [];
%% (Spatial-)Temporal Network Construction
for i = 1:size(data,1)
    if i ~= 1
        monitor = [monitor;i, pass_flag,team_rec_temp, pass];
    else
        monitor = [1,0,0,0,0,0,0];
    end
    item = data(i);
    if isempty([item.tags]) == 0
        tags = [item.tags.id];
    else
        tags= 99999;
    end
%     In case of a duel,we save the state and move on to the next one,
%     because duels are supposed to always appear in pairs. Bu in fact 
%     there might be some mistakes in the dataset that some duels only 
%     appear independently, we consider such a line as an invalid line
%     of data.
%DUELS
    if item.eventId == 1 && duel_flag == 0
        duel = duel_state_ini;
        duel_flag = 1;
        duel(1) = item.playerId; %One of the players that participates in the duel
        
        if item.matchPeriod == '2H' %The timestamp of this current duel
            duel(3) = endtime1h+item.eventSec; 
        elseif item.matchPeriod == '1E'
            duel(3) = endtime1h+endtime2h+item.eventSec;
        elseif item.matchPeriod == '2E'
            duel(3) = endtime1h+endtime2h+endtime1e+item.eventSec;
        else
            duel(3) = item.eventSec;
        end
    
    elseif item.eventId == 1 && duel_flag == 1
        duel(2) = item.playerId;%One of the players that participates in the duel
        duelgraph = [duelgraph;duel];
        duel_flag = 0;
      
    elseif item.eventId ~= 1 && duel_flag == 1 %Bad duel pair check
        duel_flag = 0;
        duel = duel_state_ini;
    
    end
%PASSES    
    if item.eventId == 8
       
       
       
       if pass_flag == 0
           pass = pass_state_ini;
           pass(1) = item.playerId; %Pass initiator
           team_rec_temp = item.teamId; %Record the team of the first player
           
           if item.matchPeriod == '2H' %The timestamp of this current pass
               pass(3) = endtime1h+item.eventSec; 
           else
               pass(3) = item.eventSec;
           end

           if ~isempty(find(ismember(tags,1802), 1)) %Unsuccessful pass
               pass(4) = 0; %Indicate that the pass is not succcessful.
               pass_flag = 1;
           elseif ~isempty(find(ismember(tags,1801), 1)) %Successful pass?
               %We are not sure yet if the pass is actually successful, 
               %if it leads to a duel, his/hers teammate must win the 
               %duel for the pass to be marked as successful.
               pass_flag = 1; 
           end
       elseif pass_flag == 1 && pass(1)~= 0
           if item.teamId ~= team_rec_temp %Lose ball possession to the opponent team
              pass(2) = item.playerId;
              passgraph = [passgraph;pass];
              pass_flag = 0;
           end
           if item.teamId == team_rec_temp %Successful pass with same team receiver
              pass(2) = item.playerId;
              pass(4) = 1;
              passgraph = [passgraph;pass];
              pass_flag = 0;
           end
       end
       
    elseif item.eventId == 1 && pass_flag == 1 && i+1 <= size(data,1) %pass results in duel
        
        item2 = data(i+1);
        if isempty([item2.tags]) == 0
            tags2 = [item2.tags.id];
        else
            tags2 = 99999;
        end
        if item.eventId == item2.eventId
            if item.teamId == team_rec_temp && ~isempty(find(ismember(tags,701), 1)) %successful pass and successful duel
                pass(4) = 1;
                pass(2)= item.playerId;
                passgraph = [passgraph;pass];
                pass_flag=0;
            elseif item2.teamId == team_rec_temp && ~isempty(find(ismember(tags2,701), 1)) %successful pass and successful duel
                pass(4) = 1;
                pass(2)= item2.playerId;
                passgraph = [passgraph;pass];
                pass_flag=0;
            elseif item2.teamId ~= team_rec_temp && isempty(find(ismember(tags2,701), 1)) %Unsuccessful pass and successful duel
                pass(2)= item2.playerId;
                pass(4) = 0;
                passgraph = [passgraph;pass];
                pass_flag=0;
            elseif item.teamId ~= team_rec_temp && isempty(find(ismember(tags,701), 1)) %Unsuccessful pass and successful duel
                pass(2)= item.playerId;
                pass(4) = 0;
                passgraph = [passgraph;pass];
                pass_flag=0;
            end
        else
            pass_flag = 0; %Bad duel records
        end
    elseif item.eventId ~= 1 && item.eventId~= 8 && pass_flag == 1 && item.teamId == team_rec_temp %Pass lead to other activity, good pass
        pass(2) = item.playerId;
        pass(4) = 1;
        passgraph = [passgraph;pass];
        pass_flag = 0;
    elseif item.eventId ~= 1 && item.eventId~= 8 && pass_flag == 1 && item.teamId ~= team_rec_temp %Pass lead to other activity, bad pass
        pass(2)= item.playerId;
        pass(4) = 0;
        passgraph = [passgraph;pass];
        pass_flag=0;
    else
        pass_flag = 0;
        duel_flag = 0;
    end
end
%% Quality Guarantee
%Check bad data in the duel graph (duel between teammates)
chk = (duelgraph(:,1) <= playernum(1) & duelgraph(:,2)>playernum(1)) | (duelgraph(:,2) <= playernum(1) & duelgraph(:,1) > playernum(1));
duelgraph = duelgraph(chk,:);

chk2 = passgraph(:,1) ~= passgraph(:,2);
passgraph = passgraph(chk2,:);


%% Interpretation
graph_interpretation
if data0(matchselect).winner ~= 0
    if data0(matchselect).winner == teams(1,1)
        score1 = 3;
        score2 = 0;
    else
        score2 = 3;
        score1 = 0;
    end
else
    score1 = 1;
    score2 = 1;
end
%Data record
aaa = struct2cell(data0(matchselect).teamsData);
if aaa{1}.teamId == teams(1,1)
    goal1 = aaa{1}.score;
    goal2 = aaa{2}.score;
else
    goal2 = aaa{2}.score;
    goal1 = aaa{1}.score;
end
team1_record = [teams(1,1),data0(matchselect).wyId,score1,goal1,goal2...
                pp1,E_Dp1,Var_Dp1,stdp1,Rho_Dp1,C_Gp1,...
                avg_hopcountp1,network_diameterp1,lambda1p1,E_Sp1];
team2_record = [teams(2,1),data0(matchselect).wyId,score2,goal2,goal1...
                pp2,E_Dp2,Var_Dp2,stdp2,Rho_Dp2,C_Gp2,...
                avg_hopcountp2,network_diameterp2,lambda1p2,E_Sp2];
total_record_pass = [total_record_pass;team1_record;team2_record];
%team,match,
%w/d/l,goal,lose_goal
%link density, avg degree, deg variance, standard
%deviation, assortativity, clustering coeff, average hopcount, network
%diameter, algebraic connectivity.
total_record_duel = [total_record_duel;data0(matchselect).wyId,abs(goal1+goal2)...
                pd,E_Dd,Var_Dd,stdd,Rho_Dd,C_Gd,...
                avg_hopcountd,network_diameterd,lambda1d,E_Sd];
total_record_lose = [total_record_lose;data0(matchselect).wyId,abs(goal1+goal2)...
                    pl,E_Dl,Var_Dl,stdl,Rho_Dl,C_Gl,...
                    avg_hopcountl,network_diameterl,lambda1l,E_Sl];
%match,goal difference, 
%link density, avg degree, deg variance, standard
%deviation, assortativity, clustering coeff, average hopcount, network
%diameter, algebraic connectivity.
end
toc
corrcoef(total_record_pass(:,3:end))
corrcoef(total_record_duel(:,2:end))
corrcoef(total_record_lose(:,2:end))
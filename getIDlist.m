
%% load data
PGRS=readtable('PRSice_SCORES_AT_ALL_THRESHOLDS.txt');
%load xlsx data as a cell array with import
list = IDlistGenCogSubjectsS1;

%% find subjects that have both GWAS and imaging data
gwasID = cell2mat(list(:,3)); 
[GWAS_ID, GenCog_IND, PGRS_IND] = intersect(gwasID, PGRS.IID,'stable');

%% find indexes for daris ID
DARIS_ID= list(GenCog_IND,2);
IDlist = table(DARIS_ID, GWAS_ID,PGRS_IND); 

% change daris ID to numerical
f_getIdN = @(x)str2num(x(11:end));
IDlist.DARIS_ID = cellfun(f_getIdN,IDlist.DARIS_ID);

% get IDs for subjects that have both psy scores and imaging&gwas data
[DarisScores, DarisScoresind, DarisScoresGWASind] = intersect(PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.DARISID, IDlist.DARIS_ID);

% select psy scores for those subjects and keep gwas ID
% import psy data
SCZNeg = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.NegativeSchizotypalFactorScores(DarisScoresind);
SCZPos = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.PositiveSchizotypalFactorScores(DarisScoresind);
Pfact = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.PFactorScore(DarisScoresind);
Impuls = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.ImpuslivityFactorScore(DarisScoresind);
Instab = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.AfffectiveInstabilityFactorScores(DarisScoresind);

GWASPsyID = IDlist.GWAS_ID(DarisScoresGWASind); 
% create lists for all phenotypes
 % get ids for subjects that don't have psy data
noPsy = setdiff(PGRS.IID,GWASPsyID);
noPsyNaN = nan(length(noPsy),1);
noPsySubjects = horzcat(noPsy,noPsyNaN);

SCZnegList = horzcat(GWASPsyID, SCZNeg); SCZnegList = vertcat(SCZnegList,noPsySubjects); SCZnegList = sortrows(SCZnegList,1);
SCZposList = horzcat(GWASPsyID, SCZPos); SCZposList = vertcat(SCZposList,noPsySubjects); SCZposList = sortrows(SCZposList,1);
PfactList = horzcat(GWASPsyID, Pfact); PfactList = vertcat(PfactList,noPsySubjects); PfactList = sortrows(PfactList,1);
ImpulsList = horzcat(GWASPsyID, Impuls); ImpulsList = vertcat(ImpulsList,noPsySubjects); ImpulsList = sortrows(ImpulsList,1);
InstabList = horzcat(GWASPsyID, Instab); InstabList = vertcat(InstabList,noPsySubjects); InstabList = sortrows(InstabList,1);

% save all phenotypes in one file
MultiplePhenoList = table(SCZnegList(:,1),SCZnegList(:,2),SCZposList(:,2),PfactList(:,2),ImpulsList(:,2), InstabList(:,2)); 
MultiplePhenoList = sortrows(MultiplePhenoList,1);
MultiplePhenoList.Properties.VariableNames = {'ID' 'SCZneg' 'SCZpos' 'Pfact' 'Impuls' 'Instab'}; 
writetable(MultiplePhenoList,'multiplePheno.txt', 'Delimiter','\t')
% write lists into txt files separately
cd ('/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/7._GWAS2016PRSice/dataForPRSice')
dlmwrite('SCZnegPheno.txt',SCZnegList,'delimiter','\t','precision',7);
dlmwrite('SCZposPheno.txt',SCZposList,'delimiter','\t','precision',7);
dlmwrite('PfactPheno.txt',PfactList,'delimiter','\t','precision',7);
dlmwrite('ImpulsPheno.txt',ImpulsList,'delimiter','\t','precision',7);
dlmwrite('InstabPheno.txt',InstabList,'delimiter','\t','precision',7);

clear all; 

%% getting scores for ALL subjects with psy and gwas data (availability of
% imaging data isn't taken into account)
PGRS=readtable('PRSice_SCORES_AT_ALL_THRESHOLDS.txt');
k=1;
l=1;
p=1; 
% import a list of Belgrove IDs. (Psychopathology ...xls)
BellgroveID = unique(BellgroveID); 
BellgroveID = BellgroveID(BellgroveID>0); 
% import scores as table


for i=1:length(PGRS.IID);
    gwasid = num2str(PGRS.IID(i));
    L = length(gwasid);
    S = str2num(gwasid(1));
    S2 = str2num(gwasid(2));
    if L==6 && S==6
        if S2==2
            GWAS_IDsALL62(k) = str2num(gwasid(4:end));
            k=k+1;
        elseif S2==4
            GWAS_IDsALL64(l) = str2num(gwasid(4:end));
            l=l+1;
        elseif S2==1
            GWAS_IDsALL61(p) = str2num(gwasid(4:end));
            p=p+1;
        end
    end
end

GWAS_IDsALL61=GWAS_IDsALL61'; 
GWAS_IDsALL62=GWAS_IDsALL62';
GWAS_IDsALL64=GWAS_IDsALL64';

IDs610 = intersect(GWAS_IDsALL61,BellgroveID); 
IDs620 = intersect(GWAS_IDsALL62,BellgroveID); 
IDs640 = intersect(GWAS_IDsALL64,BellgroveID); 

% get inds for scores for those subjects
[A, indScores62] = intersect(PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.BellgroveID, IDs620); 
[~, indScores64] = intersect(PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.BellgroveID, IDs640); 
indScoressall = vertcat(indScores62,indScores64);

s620(1:length(IDs620),1) = 620000;
s640(1:length(IDs640),1) = 640000;

GWASS62IDs = s620+IDs620;
GWASS64IDs = s640+IDs640; 
GWASIDsall = vertcat(GWASS62IDs,GWASS64IDs);

SCZNeg = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.NegativeSchizotypalFactorScores(indScoressall);
SCZPos = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.PositiveSchizotypalFactorScores(indScoressall);
Pfact = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.PFactorScore(indScoressall);
Impuls = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.ImpuslivityFactorScore(indScoressall);
Instab = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.AfffectiveInstabilityFactorScores(indScoressall);

% get id for subjects woth no psy data
noPsy = setdiff(PGRS.IID,GWASIDsall);
noPsyNaN = nan(length(noPsy),1);
noPsySubjects = horzcat(noPsy,noPsyNaN);

SCZnegList = horzcat(GWASIDsall, SCZNeg); SCZnegList = vertcat(SCZnegList,noPsySubjects); SCZnegList = sortrows(SCZnegList,1);
SCZposList = horzcat(GWASIDsall, SCZPos); SCZposList = vertcat(SCZposList,noPsySubjects); SCZposList = sortrows(SCZposList,1);
PfactList = horzcat(GWASIDsall, Pfact); PfactList = vertcat(PfactList,noPsySubjects); PfactList = sortrows(PfactList,1);
ImpulsList = horzcat(GWASIDsall, Impuls); ImpulsList = vertcat(ImpulsList,noPsySubjects); ImpulsList = sortrows(ImpulsList,1);
InstabList = horzcat(GWASIDsall, Instab); InstabList = vertcat(InstabList,noPsySubjects); InstabList = sortrows(InstabList,1);

% save all phenotypes in one file
MultiplePhenoList = table(SCZnegList(:,1),SCZnegList(:,2),SCZposList(:,2),PfactList(:,2),ImpulsList(:,2), InstabList(:,2)); 
MultiplePhenoList = sortrows(MultiplePhenoList,1);
MultiplePhenoList.Properties.VariableNames = {'ID' 'SCZneg' 'SCZpos' 'Pfact' 'Impuls' 'Instab'}; 
writetable(MultiplePhenoList,'multiplePhenoALL.txt', 'Delimiter','\t')


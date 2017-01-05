
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


% getting scores for all subjects with psy and gwas data (availability of
% imaging data isn't taken into account)

% k=1; 
% for i=1:length(PGRS.IID);
%     gwasid = num2str(PGRS.IID(i)); 
%     if length(gwasid==6)
%     GWAS_IDsALL(k) = gwasid(4:end);
%     k=k+1; 
%     end
% end
% 
% GWAS_IDsALL = str2num(GWAS_IDsALL); 
% 
% [GWASall_ID, PGRSall_IND, GenCogall_IND] = intersect(GWAS_IDsALL, PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.BellgroveID,'stable');
% GWASPsyIDall = PGRS.IID(PGRSall_IND); 
% SCZNegall = PsychopathologyFactorScoreswithBellgroveIDsDARISIDs.NegativeSchizotypalFactorScores(GenCogall_IND);
% SCZnegListall = horzcat(GWASPsyIDall, SCZNegall);

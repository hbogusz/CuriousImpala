trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Opportunity> relatedOpps = [SELECT Id,Name FROM Opportunity
                     WHERE StageName = 'Closed Won'];
    List<Task> relatedTasks = new List<Task>();
    for(Opportunity opp : relatedOpps ){
    	Task newTask = new Task(Subject='Follow Up Test Task', WhatId= opp.Id); 
        relatedTasks.add(newTask);
    }
    insert relatedTasks;
}
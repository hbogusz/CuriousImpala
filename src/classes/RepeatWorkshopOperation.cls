/**
 * Created by hubert.bogusz on 16.05.2022.
 */

public with sharing class RepeatWorkshopOperation implements Schedulable{
    private List<Workshop__c> workshops;
    private integer attempt;
    private String action;
    public String repeatResponse { get; set; }
    private static final String jobName = 'Repeat workshop ';

    public RepeatWorkshopOperation(List<Workshop__c> workshops, String action) {
        this.workshops = workshops;
        this.action = action;
    }

    public void execute(SchedulableContext ctx) {
        System.enqueueJob(new QueueableWorkshopCallouts(action, workshops));
        System.abortJob(ctx.getTriggerId());
    }

    public static void schedule(String action, List<Workshop__c> workshops) {
        RepeatWorkshopOperation repeatWorkshopOperation = new RepeatWorkshopOperation(workshops, action);
        System.schedule(
                jobName + action,
                '0 0 0 ' + Date.today().addDays(1).day() + ' ' +  Date.today().month() + ' ? ',
                //Datetime.now().addMinutes(1).format('s m H d M') + ' ? ',
                repeatWorkshopOperation);
    }
}
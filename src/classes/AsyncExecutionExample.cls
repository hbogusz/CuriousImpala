/**
 * Created by hubert.bogusz on 01.04.2022.
 */

public  class AsyncExecutionExample implements  Queueable{
    public void execute(QueueableContext context){
        Account account = new Account(Name='Acme',Phone='(415) 555-1212');
        insert account;
    }

}
/*
Used to catch tasks created via email and add the 
Activity Type of 'E-Mail'. 
*/
trigger autoEmailTask on Task (before insert) {

    For(Task t : trigger.new){
        if(t.subject != null  && t.subject.startsWith('Email:')){
            t.Activity_Type__c = 'E-mail';
        }
    }
}
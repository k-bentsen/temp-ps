public class PermissionSetGrantInvocable
{
    public class GrantInfo
    {
        @InvocableVariable(required=TRUE) public Permission_Set_Grant__c grant;
        @InvocableVariable(required=TRUE) public String status;
    }

    @InvocableMethod(Label='GrantPermissionSet')
    public static void managePermSetGrant(List<GrantInfo> grantInfo)
    {
        System.enqueueJob(new PermissionSetGrantQueuable(grantInfo[0]));
    }

    private class PermissionSetGrantQueuable implements Queueable
    {
        private GrantInfo grant;

        public PermissionSetGrantQueuable(GrantInfo grant)
        {
            this.grant = grant;
        }

        public void execute(QueueableContext qc)
        {
            List<PermissionSetAssignment> existingPermSetAssgn = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :grant.grant.User__c AND PermissionSetId = :grant.grant.Permission_Set_Id__c];

            if(grant.status == 'Granted' && existingPermSetAssgn.isEmpty()) {
                insert new PermissionSetAssignment(AssigneeId = grant.grant.User__c, PermissionSetId = grant.grant.Permission_Set_Id__c);
            } else if(grant.status == 'Expired' && !existingPermSetAssgn.isEmpty()){
                delete existingPermSetAssgn;
            }
        }
    }
}

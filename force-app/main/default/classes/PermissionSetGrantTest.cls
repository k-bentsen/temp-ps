@isTest private with sharing class PermissionSetGrantTest
{
    static PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Name = 'TestPermissionSet'];
    static User u = [SELECT Id FROM User WHERE IsActive = TRUE AND Profile.UserLicense.Name = 'Salesforce' LIMIT 1];

    @isTest private static void grantPermissionSet()
    {
        Permission_Set_Grant__c psg = new Permission_Set_Grant__c(User__c = u.Id, Permission_Set_Id__c = permSet.Id);
        PermissionSetGrantInvocable.GrantInfo gi = new PermissionSetGrantInvocable.GrantInfo();
        gi.grant = psg;
        gi.status = 'Granted';
        Test.startTest();
            PermissionSetGrantInvocable.managePermSetGrant(new List<PermissionSetGrantInvocable.GrantInfo>{gi});
        Test.stopTest();

        List<PermissionSetAssignment> permSetAssigned = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :u.Id AND PermissionSetId = :permSet.Id];
        System.assertEquals(1, permSetAssigned.size());
    }

    @isTest private static void removePermissionSet()
    {
        Permission_Set_Grant__c psg = new Permission_Set_Grant__c(User__c = u.Id, Permission_Set_Id__c = permSet.Id);
        PermissionSetGrantInvocable.GrantInfo gi = new PermissionSetGrantInvocable.GrantInfo();
        gi.grant = psg;
        gi.status = 'Expired';
        Test.startTest();
            PermissionSetGrantInvocable.managePermSetGrant(new List<PermissionSetGrantInvocable.GrantInfo>{gi});
        Test.stopTest();

        List<PermissionSetAssignment> permSetRemoved = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :u.Id AND PermissionSetId = :permSet.Id];
        System.assertEquals(0, permSetRemoved.size());    
    }
}

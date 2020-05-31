public class PermissionSetGrantMgrController
{
    @AuraEnabled
    public static List<PSWrapper> getPermissionSets(Id userId)
    {
        List<PermissionSet> permSets = [SELECT Name, LicenseId, License.Name, Label FROM PermissionSet WHERE IsOwnedByProfile = FALSE ORDER BY Name ASC];
        Map<Id, PSWrapper> wrappersByPermSetId = new Map<Id, PSWrapper>();
        for(PermissionSet ps: permSets)
        {
            wrappersByPermSetId.put(ps.Id, new PSWrapper(ps));
        }
        if(String.isBlank(userId))
        {
            return wrappersByPermSetId.values();
        }
        else 
        {
            User u = [SELECT Profile.UserLicenseId FROM User WHERE Id = :userId];
            List<PermissionSetAssignment> existingPSA = [SELECT PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :userId];
            Set<Id> alreadyAssignedPSIds = new Set<Id>();
            for(PermissionSetAssignment psa: existingPSA)
            {
                alreadyAssignedPSIds.add(psa.PermissionSetId);
            }
            for(PermissionSet ps: permSets)
            {
                if(!String.isBlank(ps.LicenseId) && u.Profile.UserLicenseId != ps.LicenseId)
                {
                    PSWrapper psWrap = wrappersByPermSetId.get(ps.Id);
                    psWrap.disabled = 'true';
                    psWrap.displayText += ' - User does not match required License Type: ' + ps.License.Name;
                }
                else if(alreadyAssignedPSIds.contains(ps.Id))
                {
                    PSWrapper psWrap = wrappersByPermSetId.get(ps.Id);
                    psWrap.disabled = 'true';
                    psWrap.displayText += ' - already assigned to user';
                }
            }
            return wrappersByPermSetId.values();
        }
    }

    @AuraEnabled
    public static Permission_Set_Grant__c insertPermSetGrant(Id userId, Id permSetId, Decimal dur, String durUnit)
    {
        Permission_Set_Grant__c psg = new Permission_Set_Grant__c(User__c = userId, Permission_Set_Id__c = permSetId, Duration__c = dur, Duration_Unit__c = durUnit, Granted__c = TRUE);
        insert psg;
        return psg;
    }

    public class PSWrapper
    {
        @AuraEnabled public PermissionSet permSet;
        @AuraEnabled public String disabled;
        @AuraEnabled public String displayText;
        @AuraEnabled public String permSetId;

        public PSWrapper(PermissionSet permSet)
        {
            this.permSet = permSet;
            this.disabled = 'false';
            this.displayText = permSet.Label;
            this.permSetId = permSet.Id;
        }
    }
}
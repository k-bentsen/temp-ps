public class PermissionSetGrantMgrController
{
    @AuraEnabled
    public static List<PermissionSet> getPermissionSets()
    {
        return [SELECT Name, LicenseId, Label FROM PermissionSet WHERE IsOwnedByProfile = FALSE ORDER BY Name ASC];
    }
}
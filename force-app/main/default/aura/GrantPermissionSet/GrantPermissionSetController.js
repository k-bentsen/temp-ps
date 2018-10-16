({
    onInit : function(cmp, event, helper){
        var queryPS = cmp.get("c.getPermissionSets");
        queryPS.setCallback(this, function(resp){
            if(resp.getState() === "SUCCESS"){
                cmp.set("v.permSets", resp.getReturnValue());
            }
        });
        $A.enqueueAction(queryPS);
    },

    userUpdate : function(cmp, event, helper){
        var userVal = cmp.find("userId").get("v.value");
        console.log(userVal);
        console.log(userVal != "");
    },

    permSetListChange : function(cmp, event, helper){
        console.log(cmp.find("permSetId").get("v.value"));
    }
})
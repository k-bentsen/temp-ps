({
    onInit : function(cmp, event, helper){
        var queryPS = cmp.get("c.getPermissionSets");
        queryPS.setCallback(this, function(resp){
            helper.clearFields(cmp);
            helper.buttonToggle(cmp);
            if(resp.getState() === "SUCCESS"){
                cmp.set("v.permSets", resp.getReturnValue());
            }
        });
        $A.enqueueAction(queryPS);
    },

    userUpdate : function(cmp, event, helper){
        var userVal = cmp.find("userId").get("v.value");
        var queryPS = cmp.get("c.getPermissionSets");
        var currPsId = cmp.get("v.selectedPS");
        if(userVal != ""){
            queryPS.setParams({userId : userVal});
        } 
        
        queryPS.setCallback(this, function(resp){
            if(resp.getState() === "SUCCESS"){
                resp.getReturnValue().forEach(function(ps){
                    if(currPsId == ps.permSetId && ps.disabled == "true"){
                        cmp.set("v.selectedPS", "");
                    }
                });
                cmp.set("v.permSets", resp.getReturnValue());
                helper.buttonToggle(cmp);
            }
        });
        $A.enqueueAction(queryPS);
    },

    insertGrant : function(cmp, event, helper){
        var spinner = cmp.find("grantSpinner");
        $A.util.toggleClass(spinner, "slds-hide");

        var createGrant = cmp.get("c.insertPermSetGrant");
        createGrant.setParams({
            userId : cmp.find("userId").get("v.value"),
            permSetId : cmp.get("v.selectedPS"),
            dur : cmp.find("dur").get("v.value"),
            durUnit : cmp.find("durUnit").get("v.value")
        });
        createGrant.setCallback(this, function(resp){
            $A.util.toggleClass(spinner, "slds-hide");
            var toastEvent = $A.get("e.force:showToast");
            if(resp.getState() === "SUCCESS"){
                toastEvent.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": "Grant successful"
                });
                
                helper.clearFields(cmp);
                helper.buttonToggle(cmp);
            } else{
                toastEvent.setParams({
                    "type" : "error",
                    "title": "Error",
                    "message": resp.getError()
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(createGrant);
    },

    inputChange : function(cmp, event, helper){
        helper.buttonToggle(cmp);
    }
})
({
    buttonToggle : function(cmp) {
        var user = cmp.find("userId").get("v.value");
        var permSetId = cmp.find("permSetId").get("v.value");
        var dur = cmp.find("dur").get("v.value");
        var durUnit = cmp.find("durUnit").get("v.value");
        console.log("user id: " + user);
        console.log("SP id: " + permSetId);
        console.log("duration: " + dur);
        console.log("duration unit: " + durUnit);
        if(user == "" || permSetId == "" || dur == "" || durUnit == ""){
            cmp.set("v.btnDisabled", "true");
        } else{
            cmp.set("v.btnDisabled", "false");
        }
    },

    clearFields : function(cmp){
        cmp.find("userId").set("v.value", null);
        cmp.find("permSetId").set("v.value", "");
    }
})
({
    buttonToggle : function(cmp) {
        var user = cmp.find("userId").get("v.value");
        var permSetId = cmp.get("v.selectedPS");
        var dur = cmp.find("dur").get("v.value");
        var durUnit = cmp.find("durUnit").get("v.value");
        
        this.setMissingFields(cmp, user, permSetId, dur, durUnit);

        if(user == "" || user == null || permSetId == "" || dur == "" || durUnit == ""){
            cmp.set("v.btnDisabled", "true");
        } else{
            cmp.set("v.btnDisabled", "false");
        }
    },

    clearFields : function(cmp){
        cmp.find("userId").set("v.value", null);
        cmp.set("v.selectedPS", "");
    },

    setMissingFields : function(cmp, uId, psId, dur, durU){
        var mFlds = [];
        if(uId == "" || uId == null){
            mFlds.push("User");
        }
        if(psId == ""){
            mFlds.push("Permission Set");
        }
        if(dur == ""){
            mFlds.push("Duration");
        }
        if(durU == ""){
            mFlds.push("Duration Unit");
        }
        cmp.set("v.missingFlds", mFlds);
    }
})
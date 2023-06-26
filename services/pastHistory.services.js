const PastSearchModel=require('../model/pastHistory.model');

class PastSearchesService{
    static async postSearch(userEmail,resName,foodName){
        try {
            const data=new PastSearchModel({userEmail,resName,foodName});
            return await data.save();
        } catch (error) {
            throw error;
        }
    }
}

module.exports=PastSearchesService;
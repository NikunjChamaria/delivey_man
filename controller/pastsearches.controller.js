const PastSearchesService=require('../services/pastHistory.services');
const PastSearchModel=require('../model/pastHistory.model');

exports.postPast=async(req,res,next)=>{
    try {
        const{userEmail,resName,foodName,imageUrl}=req.body;
        const success= await PastSearchesService.postSearch(userEmail,resName,foodName,imageUrl);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.getPast=async(req,res,next)=>{
    try {
        const{userEmail}=req.body;
        const result=await PastSearchModel.find({'userEmail':userEmail},{});
        res.send(result);
    } catch (error) {
        
    }
}
const CartHistoryService=require('../services/carHistory.services');
const CartHistoryModel=require('../model/cartHistory.model');

exports.postData=async(req,res,next)=>{
    try {
        const {userEmail,restaurant,items,time,amount,price}=req.body;

        const success=CartHistoryService.postHistory(userEmail,restaurant,items,time,amount,price);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.getData=async(req,res,next)=>{
    try {
        const {userEmail}=req.body;

        const result=await CartHistoryModel.find({'userEmail':userEmail},{});
        res.send(result);
    } catch (error) {
        throw error;
    }
}

exports.getFav=async(req,res,next)=>{
    try {
        const {userEmail}=req.body;
        const result= await CartHistoryModel.find({'userEmail':userEmail,isFav:true});
        res.send(result);
    } catch (error) {
        throw error;
    }
}

exports.postFav=async(req,res,next)=>{
    try {
        const {userEmail,time,isFav}=req.body;
        const result=await CartHistoryModel.findOneAndUpdate({'userEmail':userEmail,'time':time},{'isFav':isFav});
        res.send({'status':"yo"});
    } catch (error) {
        throw error;
    }
}
const RestaurantService=require('../services/restaurant.service');
const RestaurantModel=require('../model/restaurant.model');

exports.postData=async(req,res,next)=>{
    try {
        const {resName,imageUrl,rating,dist,comments,averagePrice,foodType,location}=req.body;
        const success=await RestaurantService.postData(resName,imageUrl,rating,dist,comments,averagePrice,foodType,location);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.getData=async(req,res,next)=>{
    try {
        const result=await RestaurantModel.find();
        res.send(result);
    } catch (error) {
        throw error;
    }
}

exports.getData1=async(req,res,next)=>{
    try {
        const {foodType}=req.body;
        const result=await RestaurantModel.find({'foodType':foodType},{});
        res.send(result);
    } catch (error) {
        throw error;
    }
}

exports.getData2=async(req,res,next)=>{
    try {
        const {resName}=req.body;
        const result=await RestaurantModel.find({'resName':resName},{});
        res.send(result);
    } catch (error) {
        throw error;
    }
}
const RestaurantService=require('../services/restaurant.service');
const RestaurantModel=require('../model/restaurant.model');

exports.postData=async(req,res,next)=>{
    try {
        const {resName,rating,dist,comments,averagePrice,foodType,location,ownerEmail,businessEmail,address,lat,long}=req.body;
        const success=await RestaurantService.postData(resName,rating,dist,comments,averagePrice,foodType,location,ownerEmail,businessEmail,address,lat,long);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.getData=async(req,res,next)=>{
    try {
        const result=await RestaurantModel.find({},{_id:0,__v:0});
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

exports.getData3=async(req,res,next)=>{
    try {
        const {ownerEmail}=req.body;
        const result=await RestaurantModel.find({'ownerEmail':ownerEmail},{});
        res.send(result);
    } catch (error) {
        throw error;
    }
}

exports.search=async(req,res,next)=>{
    try {
        const {text}=req.body;
        const result=await RestaurantModel.find({'resName': new RegExp(text,'i')});
        res.send(result);
    } catch (error) {
        throw error;
    }
}
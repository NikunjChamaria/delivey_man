const RestaurantModel = require('../model/restaurant.model');
const FoodService=require('../services/food.service');
const FoodModel=require("../model/food.model");


exports.postData=async(req,res,next)=>{
    try {
        const {resName,name,price,rating,comments,imageUrl}=req.body;
        const restaurant=RestaurantModel.findOne({resName});
        
        
        
        const success=await FoodService.postFoodData(resName,name,price,rating,comments,imageUrl);
        res.status(200).json({status:true,token:"yo"});
    } catch (error) {
        throw error;
    }
}

exports.getData=async(req,res,next)=>{
    try {
        const {resName}=req.body;
        const resilt=await FoodModel.find({resName:resName},{});
        res.send(resilt);
    } catch (error) {
        throw error;
    }
}

exports.getData1=async(req,res,next)=>{
    try {
        const {resName,name}=req.body;
        const resilt=await FoodModel.find({resName:resName,name:name},{});
        res.send(resilt);
    } catch (error) {
        throw error;
    }
}

exports.search=async(req,res,next)=>{
    try {
        const {text}=req.body;
        const result=await FoodModel.find({'name': new RegExp(text,'i')});
        res.send(result);
    } catch (error) {
        throw error;
    }
}